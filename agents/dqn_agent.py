"""
DQN智能体
"""
import torch
import torch.nn as nn
import torch.optim as optim
import numpy as np
import random
import os
from datetime import datetime

from models.dqn_model import DQN, DuelingDQN
from utils.replay_buffer import ReplayBuffer, PrioritizedReplayBuffer


class DQNAgent:
    """
    DQN智能体
    """
    def __init__(self, state_shape, matrix_size, device, config):
        """
        初始化DQN智能体
        
        Args:
            state_shape: 状态空间形状
            matrix_size: 矩阵大小
            device: 计算设备
            config: 配置参数
        """
        self.device = device
        self.matrix_size = matrix_size
        self.config = config
        
        # 创建网络
        if config["dueling_dqn"]:
            self.policy_net = DuelingDQN(state_shape, matrix_size).to(device)
            self.target_net = DuelingDQN(state_shape, matrix_size).to(device)
        else:
            self.policy_net = DQN(state_shape, matrix_size).to(device)
            self.target_net = DQN(state_shape, matrix_size).to(device)
            
        # 复制参数到目标网络
        self.target_net.load_state_dict(self.policy_net.state_dict())
        self.target_net.eval()
        
        # 创建优化器
        self.optimizer = optim.Adam(
            self.policy_net.parameters(), 
            lr=config["learning_rate"]
        )
        
        # 创建经验回放缓冲区
        self.buffer = ReplayBuffer(config["buffer_size"], device)
        
        # 探索参数
        self.epsilon = config["epsilon_start"]
        self.epsilon_end = config["epsilon_end"]
        self.epsilon_decay = config["epsilon_decay"]
        
        # 其他参数
        self.gamma = config["gamma"]
        self.batch_size = config["batch_size"]
        self.target_update = config["target_update_interval"]
        self.learning_starts = config["learning_starts"]
        self.double_dqn = config["double_dqn"]
        
        # 训练计数器
        self.step_counter = 0
        self.update_counter = 0
        self.episode_counter = 0
        
        # 日志
        self.training_info = {
            "losses": [],
            "q_values": [],
            "epsilons": []
        }
        
    def select_action(self, state, evaluate=False):
        """
        选择动作，使用epsilon-greedy策略
        """
        if evaluate:
            with torch.no_grad():
                state = torch.FloatTensor(state).unsqueeze(0).to(self.device)
                q_values = self.policy_net(state)
                
                # 分别选择每个动作分量
                action = {
                    'action_type': q_values['action_type'].max(1)[1].item(),
                    'matrix_pos': q_values['matrix_pos'].max(1)[1].item(),
                    'matrix_value': q_values['matrix_value'].max(1)[1].item(),
                    'param': q_values['param'].max(1)[1].item()
                }
                return action
                
        # 计算当前探索率
        self.epsilon = self.epsilon_end + (self.epsilon - self.epsilon_end) * \
                       np.exp(-1. * self.step_counter / self.epsilon_decay)
                       
        # 随机探索
        if random.random() < self.epsilon:
            return {
                'action_type': random.randint(0, 3),
                'matrix_pos': random.randint(0, self.matrix_size * self.matrix_size - 1),
                'matrix_value': random.randint(0, 1),
                'param': random.randint(0, 9)  # 10个离散区间
            }
            
        # 贪婪选择
        with torch.no_grad():
            state = torch.FloatTensor(state).unsqueeze(0).to(self.device)
            q_values = self.policy_net(state)
            
            action = {
                'action_type': q_values['action_type'].max(1)[1].item(),
                'matrix_pos': q_values['matrix_pos'].max(1)[1].item(),
                'matrix_value': q_values['matrix_value'].max(1)[1].item(),
                'param': q_values['param'].max(1)[1].item()
            }
            
            # 记录最大Q值
            max_q = max(q_value.max().item() for q_value in q_values.values())
            self.training_info["q_values"].append(max_q)
            self.training_info["epsilons"].append(self.epsilon)
            
            return action
            
    def store_transition(self, state, action, next_state, reward, done):
        """
        存储经验到回放缓冲区
        """
        self.buffer.push(state, action, next_state, reward, done)
        self.step_counter += 1
        
    def optimize_model(self):
        """
        优化模型
        """
        if len(self.buffer) < self.batch_size or self.step_counter < self.learning_starts:
            return None
            
        # 从缓冲区中采样
        state, action, next_state, reward, done = self.buffer.sample(self.batch_size)
        
        # 计算当前Q值
        current_q_values = self.policy_net(state)
        
        # 分别获取每个动作分量的Q值
        current_q = {
            'action_type': current_q_values['action_type'].gather(1, action['action_type'].unsqueeze(1)).squeeze(1),
            'matrix_pos': current_q_values['matrix_pos'].gather(1, action['matrix_pos'].unsqueeze(1)).squeeze(1),
            'matrix_value': current_q_values['matrix_value'].gather(1, action['matrix_value'].unsqueeze(1)).squeeze(1),
            'param': current_q_values['param'].gather(1, action['param'].unsqueeze(1)).squeeze(1)
        }
        
        # 计算目标Q值
        with torch.no_grad():
            if self.double_dqn:
                # Double DQN
                next_q_values = self.policy_net(next_state)
                next_actions = {
                    k: v.max(1)[1].unsqueeze(1)
                    for k, v in next_q_values.items()
                }
                target_q_values = self.target_net(next_state)
                next_q = {
                    k: target_q_values[k].gather(1, next_actions[k]).squeeze(1)
                    for k in next_actions.keys()
                }
            else:
                # 标准DQN
                next_q_values = self.target_net(next_state)
                next_q = {
                    k: v.max(1)[0]
                    for k, v in next_q_values.items()
                }
            
            # 计算每个动作分量的目标值
            targets = {}
            for key in next_q:
                targets[key] = reward + (1 - done) * self.gamma * next_q[key]
        
        # 计算总损失（所有动作分量的损失之和）
        loss = sum(
            nn.functional.smooth_l1_loss(current_q[key], targets[key])
            for key in current_q
        )
        
        # 优化
        self.optimizer.zero_grad()
        loss.backward()
        # 梯度裁剪
        for param in self.policy_net.parameters():
            param.grad.data.clamp_(-1, 1)
        self.optimizer.step()
        
        # 记录损失
        self.training_info["losses"].append(loss.item())
        
        # 更新目标网络
        self.update_counter += 1
        if self.update_counter % self.target_update == 0:
            self.target_net.load_state_dict(self.policy_net.state_dict())
            
        return loss.item()
        
    def save_model(self, path):
        """
        保存模型
        """
        if not os.path.exists(os.path.dirname(path)):
            os.makedirs(os.path.dirname(path))
            
        torch.save({
            'policy_net': self.policy_net.state_dict(),
            'target_net': self.target_net.state_dict(),
            'optimizer': self.optimizer.state_dict(),
            'step_counter': self.step_counter,
            'update_counter': self.update_counter,
            'episode_counter': self.episode_counter,
            'epsilon': self.epsilon,
            'config': self.config
        }, path)
        
    def load_model(self, path):
        """
        加载模型
        """
        checkpoint = torch.load(path)
        
        self.policy_net.load_state_dict(checkpoint['policy_net'])
        self.target_net.load_state_dict(checkpoint['target_net'])
        self.optimizer.load_state_dict(checkpoint['optimizer'])
        self.step_counter = checkpoint['step_counter']
        self.update_counter = checkpoint['update_counter']
        self.episode_counter = checkpoint['episode_counter']
        self.epsilon = checkpoint['epsilon']
        
        # 确保目标网络处于评估模式
        self.target_net.eval()
