# 这个项目是用强化学习中的PPO/DQN算法实现对材料的结构和参数优化。models文件夹下是DQN网络模型和PPO网络模型，agents文件夹下是智能体。在environment文件夹下，当前文件实现材料优化环境适配器，定义了材料的结构和参数。材料的输入特征包含一个5*5的数值为0/1的矩阵，以及r1，p，d等几何结构参数。函数_run_cst_simulation()中连接了CST仿真软件，将当前材料状态传输给CST软件，运行仿真，根据S参数返回了一个结果。现在我需要你帮我完善这个文件，特别是step()函数，我希望action可以指导输入特征中矩阵每个位置的数值0/1的变化，或是使得r1，p，d等参数在范围内变化，每次action只改变一个值。

"""材料优化环境适配器"""
import numpy as np
import gym
from gym import spaces
import subprocess
import os
import pandas as pd
import CST

class MaterialEnv(gym.Env):
    """
    材料优化环境，用于优化材料结构和参数
    """
    def __init__(
        self,
        matrix_size=5,
        r1_range=(10, 100),    # ITO面电阻值范围 (Ω/sq)
        p_range=(100, 500),    # 单元周期边长范围 (nm)
        d_range=(50, 200),     # 中间介质层厚度范围 (nm)
        cst_path=None,         # CST软件路径
        project_template=None, # CST项目模板路径
        freq_range=(0.1, 10),  # 频率范围 (THz)
        reward_weights={
            'transmission': 1.0,
            'reflection': -0.5,
            'absorption': 0.8
        }
    ):
        super(MaterialEnv, self).__init__()
        
        # 定义观察空间
        self.observation_space = spaces.Dict({
            'matrix': spaces.Box(low=0, high=1, shape=(matrix_size, matrix_size), dtype=np.int32),
            'r1': spaces.Box(low=r1_range[0], high=r1_range[1], shape=(1,), dtype=np.float32),
            'p': spaces.Box(low=p_range[0], high=p_range[1], shape=(1,), dtype=np.float32),
            'd': spaces.Box(low=d_range[0], high=d_range[1], shape=(1,), dtype=np.float32)
        })
        
        # 定义动作空间
        # action_type: 0表示修改矩阵，1表示修改r1，2表示修改p，3表示修改d
        self.action_space = spaces.Dict({
            'action_type': spaces.Discrete(4),  # 选择要修改的参数类型
            'matrix_pos': spaces.Discrete(matrix_size * matrix_size),  # 矩阵元素的位置
            'matrix_value': spaces.Discrete(2),  # 0或1
            'param_value': spaces.Box(  # 用于r1/p/d的连续值
                low=np.array([min(r1_range[0], p_range[0], d_range[0])]),
                high=np.array([max(r1_range[1], p_range[1], d_range[1])]),
                shape=(1,),
                dtype=np.float32
            )
        })
        
        # 环境参数
        self.matrix_size = matrix_size
        self.r1_range = r1_range
        self.p_range = p_range
        self.d_range = d_range
        self.cst_path = cst_path
        self.project_template = project_template
        self.freq_range = freq_range
        self.reward_weights = reward_weights
        
        # 当前状态
        self.current_state = None
        self.step_count = 0
        self.max_steps = 100
        
    def reset(self):
        """
        重置环境到初始状态
        """
        self.current_state = {
            'matrix': np.zeros((self.matrix_size, self.matrix_size), dtype=np.int32),
            'r1': np.array([np.mean(self.r1_range)]),
            'p': np.array([np.mean(self.p_range)]),
            'd': np.array([np.mean(self.d_range)])
        }
        self.step_count = 0
        return self.current_state
    
    def step(self, action):
        """
        执行一步优化
        
        Args:
            action: 包含action_type、matrix_pos、matrix_value和param_value的字典
            
        Returns:
            next_state: 下一个状态
            reward: 奖励值
            done: 是否结束
            info: 额外信息
        """
        # 根据action_type决定要修改哪个参数
        action_type = action['action_type']
        
        if action_type == 0:  # 修改矩阵
            matrix_pos = action['matrix_pos']
            i, j = matrix_pos // self.matrix_size, matrix_pos % self.matrix_size
            self.current_state['matrix'][i, j] = action['matrix_value']
        elif action_type == 1:  # 修改r1
            # 确保参数值在有效范围内
            param_value = np.clip(action['param_value'], self.r1_range[0], self.r1_range[1])
            self.current_state['r1'] = np.array([param_value])
        elif action_type == 2:  # 修改p
            param_value = np.clip(action['param_value'], self.p_range[0], self.p_range[1])
            self.current_state['p'] = np.array([param_value])
        else:  # 修改d
            param_value = np.clip(action['param_value'], self.d_range[0], self.d_range[1])
            self.current_state['d'] = np.array([param_value])
        
        # 运行CST仿真
        s_params = self._run_cst_simulation()
        
        # 计算奖励
        reward = self._calculate_reward(s_params)
        
        # 检查是否结束
        self.step_count += 1
        done = self.step_count >= self.max_steps
        
        # 返回额外信息
        info = {
            'action_type': action_type,
            'step_count': self.step_count,
            's_params': s_params
        }
        
        return self.current_state, reward, done, info
    
    def _run_cst_simulation(self):
        """
        运行CST仿真并获取S参数
        """
        # 实现与CST软件的接口
        # 1. 根据当前状态生成CST模型
        # 2. 运行仿真
        # 3. 获取S参数结果
        # 这部分需要根据实际的CST软件API来实现
        absorber = CST.CST_script()
        current_matrix = self.current_state['matrix']
        r1 = self.current_state['r1']
        p = self.current_state['p']
        d = self.current_state['d']
        inter = absorber.material_init(current_matrix, r1, p, d)
        return inter
    
    def _calculate_reward(self, s_params):
        """
        根据S参数计算奖励值
        
        Args:
            s_params: CST仿真返回的吸收区间数据
            
        Returns:
            reward: 奖励值
        """
        # 吸收区间越大越好
        absorption_interval = s_params
        
        # 基础奖励：吸收区间大小
        base_reward = absorption_interval
        
        # 额外奖励：如果吸收区间超过某个阈值
        threshold = 0.5  # 可以根据实际需求调整
        bonus = 2.0 if absorption_interval > threshold else 0.0
        
        # 惩罚：如果吸收区间太小
        penalty = -1.0 if absorption_interval < 0.1 else 0.0
        
        # 总奖励
        reward = base_reward + bonus + penalty
        
        return reward
    
    def render(self):
        """
        渲染当前状态（可选）
        """
        pass
    
    def close(self):
        """
        关闭环境
        """
        pass