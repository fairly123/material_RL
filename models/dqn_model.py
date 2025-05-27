"""
DQN网络模型
"""
import torch
import torch.nn as nn
import torch.nn.functional as F
import numpy as np


class DQN(nn.Module):
    """
    深度Q网络，使用多头输出处理不同类型的动作
    """
    def __init__(self, input_shape, matrix_size):
        """
        初始化DQN网络
        
        Args:
            input_shape: 输入状态形状 (C, H, W)
            matrix_size: 矩阵大小
        """
        super(DQN, self).__init__()
        
        self.conv = nn.Sequential(
            nn.Conv2d(input_shape[0], 32, kernel_size=3, stride=1),
            nn.ReLU(),
            nn.Conv2d(32, 64, kernel_size=3, stride=1),
            nn.ReLU(),
            nn.Conv2d(64, 64, kernel_size=3, stride=1),
            nn.ReLU()
        )
        
        conv_out_size = self._get_conv_output(input_shape)
        
        # 共享特征层
        self.shared = nn.Sequential(
            nn.Linear(conv_out_size, 512),
            nn.ReLU()
        )
        
        # 动作类型Q值
        self.action_type_head = nn.Linear(512, 4)
        
        # 矩阵位置Q值
        self.matrix_pos_head = nn.Linear(512, matrix_size * matrix_size)
        
        # 矩阵值Q值
        self.matrix_value_head = nn.Linear(512, 2)
        
        # 连续参数Q值（离散化为多个区间）
        self.param_head = nn.Linear(512, 10)  # 将连续参数空间离散化为10个区间
        
        self.matrix_size = matrix_size
        
    def _get_conv_output(self, shape):
        """
        计算卷积层输出大小
        """
        o = self.conv(torch.zeros(1, *shape))
        return int(np.prod(o.size()))
        
    def forward(self, x):
        """
        前向传播，返回各个动作分量的Q值
        """
        conv_out = self.conv(x).view(x.size()[0], -1)
        features = self.shared(conv_out)
        
        return {
            'action_type': self.action_type_head(features),
            'matrix_pos': self.matrix_pos_head(features),
            'matrix_value': self.matrix_value_head(features),
            'param': self.param_head(features)
        }


class DuelingDQN(nn.Module):
    """
    Dueling DQN网络，使用多头输出处理不同类型的动作
    """
    def __init__(self, input_shape, matrix_size):
        """
        初始化Dueling DQN网络
        
        Args:
            input_shape: 输入状态形状 (C, H, W)
            matrix_size: 矩阵大小
        """
        super(DuelingDQN, self).__init__()
        
        self.conv = nn.Sequential(
            nn.Conv2d(input_shape[0], 32, kernel_size=3, stride=1),
            nn.ReLU(),
            nn.Conv2d(32, 64, kernel_size=3, stride=1),
            nn.ReLU(),
            nn.Conv2d(64, 64, kernel_size=3, stride=1),
            nn.ReLU()
        )
        
        conv_out_size = self._get_conv_output(input_shape)
        
        # 共享特征层
        self.shared = nn.Sequential(
            nn.Linear(conv_out_size, 512),
            nn.ReLU()
        )
        
        # 价值流
        self.value_stream = nn.Sequential(
            nn.Linear(512, 256),
            nn.ReLU(),
            nn.Linear(256, 1)
        )
        
        # 各个动作分量的优势流
        self.advantage_streams = nn.ModuleDict({
            'action_type': nn.Sequential(
                nn.Linear(512, 256),
                nn.ReLU(),
                nn.Linear(256, 4)
            ),
            'matrix_pos': nn.Sequential(
                nn.Linear(512, 256),
                nn.ReLU(),
                nn.Linear(256, matrix_size * matrix_size)
            ),
            'matrix_value': nn.Sequential(
                nn.Linear(512, 256),
                nn.ReLU(),
                nn.Linear(256, 2)
            ),
            'param': nn.Sequential(
                nn.Linear(512, 256),
                nn.ReLU(),
                nn.Linear(256, 10)  # 离散化为10个区间
            )
        })
        
        self.matrix_size = matrix_size
        
    def _get_conv_output(self, shape):
        """
        计算卷积层输出大小
        """
        o = self.conv(torch.zeros(1, *shape))
        return int(np.prod(o.size()))
        
    def forward(self, x):
        """
        前向传播，返回各个动作分量的Q值
        """
        conv_out = self.conv(x).view(x.size()[0], -1)
        features = self.shared(conv_out)
        
        # 计算状态价值
        value = self.value_stream(features)
        
        # 计算各个动作分量的优势
        q_values = {}
        for action_type, advantage_stream in self.advantage_streams.items():
            advantage = advantage_stream(features)
            # 使用Dueling DQN的计算方式
            q_values[action_type] = value + advantage - advantage.mean(dim=1, keepdim=True)
            
        return q_values
