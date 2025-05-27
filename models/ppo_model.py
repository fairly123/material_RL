"""
PPO网络模型
"""
import torch
import torch.nn as nn
import torch.nn.functional as F
import numpy as np
from torch.distributions import Categorical, Normal


class PPONetwork(nn.Module):
    """
    PPO网络，包含共享的特征提取器、多个策略网络和价值网络
    """
    def __init__(self, input_shape, matrix_size):
        """
        初始化PPO网络
        
        Args:
            input_shape: 输入状态形状 (C, H, W)
            matrix_size: 矩阵大小
        """
        super(PPONetwork, self).__init__()
        
        # 共享特征提取器
        self.features = nn.Sequential(
            nn.Conv2d(input_shape[0], 32, kernel_size=3, stride=1),
            nn.ReLU(),
            nn.Conv2d(32, 64, kernel_size=3, stride=1),
            nn.ReLU(),
            nn.Conv2d(64, 64, kernel_size=3, stride=1),
            nn.ReLU()
        )
        
        conv_out_size = self._get_conv_output(input_shape)
        
        # 动作类型策略网络
        self.action_type_policy = nn.Sequential(
            nn.Linear(conv_out_size, 256),
            nn.ReLU(),
            nn.Linear(256, 4)  # 4种动作类型
        )
        
        # 矩阵位置策略网络
        self.matrix_pos_policy = nn.Sequential(
            nn.Linear(conv_out_size, 256),
            nn.ReLU(),
            nn.Linear(256, matrix_size * matrix_size)
        )
        
        # 矩阵值策略网络
        self.matrix_value_policy = nn.Sequential(
            nn.Linear(conv_out_size, 256),
            nn.ReLU(),
            nn.Linear(256, 2)  # 0或1
        )
        
        # 连续参数策略网络（输出均值和标准差）
        self.param_policy = nn.Sequential(
            nn.Linear(conv_out_size, 256),
            nn.ReLU(),
            nn.Linear(256, 2)  # 均值和标准差
        )
        
        # 价值网络（评论家）
        self.value = nn.Sequential(
            nn.Linear(conv_out_size, 256),
            nn.ReLU(),
            nn.Linear(256, 1)
        )
        
        self.matrix_size = matrix_size
        
    def _get_conv_output(self, shape):
        """
        计算卷积层输出大小
        """
        o = self.features(torch.zeros(1, *shape))
        return int(np.prod(o.size()))
        
    def forward(self, x):
        """
        前向传播，返回所有动作分量的概率分布和状态价值
        """
        features = self.features(x)
        features = features.view(x.size(0), -1)
        
        # 计算各个动作分量的概率
        action_type_probs = F.softmax(self.action_type_policy(features), dim=1)
        matrix_pos_probs = F.softmax(self.matrix_pos_policy(features), dim=1)
        matrix_value_probs = F.softmax(self.matrix_value_policy(features), dim=1)
        
        # 连续参数策略
        param_mean, param_log_std = torch.chunk(self.param_policy(features), 2, dim=1)
        param_std = torch.exp(param_log_std)
        
        # 计算状态价值
        state_value = self.value(features)
        
        return (action_type_probs, matrix_pos_probs, matrix_value_probs, 
                param_mean, param_std, state_value)
        
    def evaluate(self, x, action):
        """
        评估给定状态和动作，返回所有动作分量的对数概率、熵和状态价值
        """
        (action_type_probs, matrix_pos_probs, matrix_value_probs,
         param_mean, param_std, state_value) = self.forward(x)
        
        # 创建各个分量的分布
        action_type_dist = Categorical(action_type_probs)
        matrix_pos_dist = Categorical(matrix_pos_probs)
        matrix_value_dist = Categorical(matrix_value_probs)
        param_dist = Normal(param_mean, param_std)
        
        # 分解动作
        action_type = action['action_type']
        matrix_pos = action['matrix_pos']
        matrix_value = action['matrix_value']
        param_value = action['param_value']
        
        # 计算对数概率
        action_type_log_prob = action_type_dist.log_prob(action_type)
        matrix_pos_log_prob = matrix_pos_dist.log_prob(matrix_pos)
        matrix_value_log_prob = matrix_value_dist.log_prob(matrix_value)
        param_log_prob = param_dist.log_prob(param_value)
        
        # 计算熵
        entropy = (action_type_dist.entropy() + matrix_pos_dist.entropy() +
                  matrix_value_dist.entropy() + param_dist.entropy())
        
        # 组合所有对数概率
        total_log_prob = (action_type_log_prob + matrix_pos_log_prob +
                         matrix_value_log_prob + param_log_prob)
        
        return total_log_prob, state_value, entropy
        
    def act(self, x, deterministic=False):
        """
        根据给定状态选择动作，可选择确定性或随机性策略
        """
        with torch.no_grad():
            (action_type_probs, matrix_pos_probs, matrix_value_probs,
             param_mean, param_std, state_value) = self.forward(x)
            
            if deterministic:
                # 确定性策略：选择概率最高的动作
                action_type = torch.argmax(action_type_probs, dim=1)
                matrix_pos = torch.argmax(matrix_pos_probs, dim=1)
                matrix_value = torch.argmax(matrix_value_probs, dim=1)
                param_value = param_mean
            else:
                # 随机性策略：根据概率采样动作
                action_type_dist = Categorical(action_type_probs)
                matrix_pos_dist = Categorical(matrix_pos_probs)
                matrix_value_dist = Categorical(matrix_value_probs)
                param_dist = Normal(param_mean, param_std)
                
                action_type = action_type_dist.sample()
                matrix_pos = matrix_pos_dist.sample()
                matrix_value = matrix_value_dist.sample()
                param_value = param_dist.sample()
            
            # 构建完整的动作字典
            action = {
                'action_type': action_type,
                'matrix_pos': matrix_pos,
                'matrix_value': matrix_value,
                'param_value': param_value
            }
            
            # 计算总的对数概率
            log_prob = self.evaluate(x, action)[0]
            
            return action, log_prob, state_value
