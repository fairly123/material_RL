# Material RL with PPO

这是一个使用PPO（Proximal Policy Optimization）算法来训练AI优化材料（透明吸波体）属性的项目。

## 环境要求

- Python 3.8+
- PyTorch
- Stable-Baselines3

## 安装

1. 克隆此仓库：

```bash
git clone https://github.com/your-username/material-rl.git
cd material-rl
```

2. 安装依赖项：

```bash
pip install -r requirements.txt
```

## 项目结构

```
material-RL/
├── requirements.txt        # 项目依赖
├── main.py                 # 主程序入口
├── train.py                # 训练脚本
├── play.py                 # 使用训练好的模型玩游戏
├── config.py               # 配置文件
├── models/                 # 模型定义
│   ├── __init__.py
│   ├── dqn_model.py              # DQN模型
│   └── ppo_model.py              # PPO模型
├── agents/                 # 智能体实现
│   ├── __init__.py
│   ├── base_agent.py       # 基础智能体类
│   ├── dqn_agent.py        # DQN智能体
│   └── ppo_agent.py        # PPO智能体
├── environment/            # 环境包装器
│   ├── CST.py
│   ├── mario_env.py        # 超级马里奥环境适配器
    └── material_env.py
├── utils/                  # 工具函数
│   ├── __init__.py
│   ├── replay_buffer.py    # 经验回放缓冲区
│   ├── wrappers.py         # 环境包装器
│   └── visualization.py    # 可视化工具
└── checkpoints/            # 模型保存目录
    └── README.md
```

## 使用方法

### 训练模型

运行以下命令开始训练：

```bash
# 使用DQN训练
python train.py --agent dqn --timesteps 1000000

# 使用PPO训练
python train.py --agent ppo --timesteps 1000000

# 从已有模型继续训练
python train.py --agent dqn --load-model checkpoints/best_dqn_model.pt
```

训练过程中的模型会每10000步保存一次，保存在`checkpoints`目录下。
训练日志可以在`logs`目录下找到，可以使用TensorBoard查看。

### 测试模型

训练完成后，可以运行以下命令来测试模型：

```bash
python main.py play --agent ppo --model checkpoints/best_ppo_model.pt --world 1-1 --no-record
```

可选参数：
- `--agent`: 选择算法 (`dqn` 或 `ppo`)
- `--model`: 模型文件路径
- `--world`: 选择游戏关卡
- `--episodes`: 游戏回合数
- `--max-steps`: 每回合最大步数
- `--no-render`: 不渲染游戏画面
- `--no-record`: 不录制视频
- `--fps`: 渲染和录制的帧率

## 可视化

训练过程中会自动生成日志和可视化数据，可以通过TensorBoard查看：

```bash
tensorboard --logdir logs
```

这将显示以下指标：
- 奖励曲线
- 游戏进度（玩家在关卡中的最远位置）
- 损失函数曲线
- 回合长度
- 模型评估结果

## 模型保存

模型在训练过程中会自动保存：
- 每隔一段时间保存一次模型（可在config.py中配置）
- 保存性能最好的模型
- 训练结束时保存最终模型

所有模型都保存在`checkpoints`目录下。

## 配置

可以通过修改`config.py`文件来调整各种参数，如：
- 环境参数（帧跳过、帧堆叠、奖励缩放等）
- DQN参数（学习率、探索率、批次大小等）
- PPO参数（学习率、GAE lambda、裁剪范围等）
- 可视化设置（是否使用TensorBoard、是否保存视频等）

## 自定义

您可以通过以下方式自定义项目：
- 在`models/`目录下添加新的神经网络结构
- 在`agents/`目录下实现新的强化学习算法
- 修改`environment/mario_env.py`中的奖励函数
- 在`utils/wrappers.py`中添加新的环境包装器

## 贡献

欢迎贡献代码、报告问题或提出改进建议！

## 许可证

本项目采用MIT许可证。详见LICENSE文件。


## 更新日志
2025.5.28更新内容
对代码进行了以下主要修改：
重新设计了动作空间（action_space）：
添加了action_type（0-3）来选择要修改的参数类型：
0：修改矩阵中的某个元素
1：修改r1参数
2：修改p参数
3：修改d参数
将矩阵位置的参数名从matrix改为更清晰的matrix_pos
将r1、p、d的连续值合并为一个param_value空间
改进了step()函数：
根据action_type来决定修改哪个参数
对于矩阵修改（action_type=0）：
使用matrix_pos和matrix_value来修改指定位置的值
对于参数修改（action_type=1,2,3）：
使用param_value来修改对应参数
使用np.clip确保参数值在有效范围内
添加了更多的信息到返回的info字典中
增加了参数验证和范围限制：
使用np.clip确保所有参数都在其有效范围内
为每种参数类型添加了专门的处理逻辑
这些修改确保了：
每次动作只能改变一个值（矩阵的一个元素或一个参数）
所有参数都保持在有效范围内
动作空间更加清晰和结构化
返回更多有用的信息供调试和监控使用
使用这个环境时，智能体需要：
首先选择要修改的参数类型（action_type）
如果修改矩阵，需要指定位置（matrix_pos）和新值（matrix_value）
如果修改参数（r1/p/d），需要提供新的参数值（param_value）
这样的设计使得强化学习算法可以更有效地学习如何优化材料结构和参数。




对PPO和DQN模型都进行了修改，以适应新的动作空间结构。主要的改动包括：
PPO模型的改动：
将单一的策略网络拆分为多个子网络：
action_type_policy：选择动作类型（4种）
matrix_pos_policy：选择矩阵位置（matrix_size * matrix_size）
matrix_value_policy：选择矩阵值（0或1）
param_policy：生成连续参数值（使用正态分布）
修改了forward()、evaluate()和act()方法以处理复合动作空间
使用了混合分布（离散分布和连续分布）来处理不同类型的动作
DQN模型的改动：
将单一的Q网络拆分为多个头：
action_type_head：动作类型的Q值
matrix_pos_head：矩阵位置的Q值
matrix_value_head：矩阵值的Q值
param_head：连续参数的Q值（离散化为10个区间）
对于Dueling DQN，每个动作分量都有自己的优势流
使用共享特征提取器来提高效率
主要的设计考虑：
模块化设计：
每个动作分量都有独立的网络分支
使用共享特征提取器减少参数数量
连续动作处理：
PPO：使用正态分布来处理连续参数
DQN：将连续参数空间离散化为10个区间
架构优化：
减小了卷积核大小和步长，以更好地处理5x5的输入矩阵
调整了网络层的大小以平衡性能和复杂度
输出格式：
两个模型都返回字典形式的输出，包含所有动作分量
保持了与环境动作空间的一致性
使用这些修改后的模型，智能体可以：
先选择要修改的参数类型（矩阵元素或几何参数）
根据选择的类型执行相应的动作（修改矩阵位置和值，或调整连续参数）
每次只修改一个值，符合环境的要求
这些改动使得模型能够更好地适应新的动作空间结构，同时保持了学习的效率。


对PPO智能体和DQN智能体的修改。主要的改动包括：
PPO智能体的改动：
修改了初始化参数，使用matrix_size替代原来的action_space
更新了PPOMemory类以支持复合动作空间
修改了动作的存储和批处理方式，现在使用字典存储不同类型的动作
更新了evaluate和act方法以处理新的动作结构
调整了损失计算方式，考虑了所有动作分量
DQN智能体的改动：
修改了初始化参数，使用matrix_size替代原来的action_space
更新了动作选择逻辑，分别处理每个动作分量
修改了随机探索策略，为每个动作分量生成随机值
更新了Q值计算方式，分别计算每个动作分量的Q值
实现了分层的Double DQN机制
调整了损失计算，现在是所有动作分量损失的总和
主要的设计考虑：
动作空间处理：
将动作空间分解为四个部分：action_type、matrix_pos、matrix_value和param
每个部分都有独立的Q值或策略输出
保持了动作空间的结构化特性
探索策略：
PPO：使用多个概率分布来采样不同类型的动作
DQN：为每个动作分量独立实现epsilon-greedy策略
学习机制：
PPO：分别计算每个动作分量的策略损失和价值损失
DQN：分别计算每个动作分量的Q值损失，并求和作为总损失
经验存储：
使用字典结构存储复合动作
保持了原有的回放缓冲区机制
网络结构适配：
与新的模型结构完全对接
保持了原有的优化器和学习率设置
这些修改使得智能体能够：
正确处理新的动作空间结构
为每个动作分量提供合适的探索策略
有效学习不同类型的动作决策
保持原有的训练稳定性
使用这些修改后的智能体，系统应该能够更好地学习材料优化任务，同时保持了算法的核心优势。

## 2025.5.29更新内容

对train.py文件进行了修改，主要变更包括：
1.将环境从Mario游戏改为材料优化环境
2.修改了观察空间和动作空间的处理方式，以适应材料环境的特殊结构
3.更新了评估指标，从游戏相关的指标改为材料优化相关的指标（如吸收区间）
4.简化了训练流程，移除了不必要的视频录制等功能
5.更新了命令行参数，移除了游戏相关的参数，保留了必要的训练参数

环境适配器（material_env.py）：
1.观察空间和动作空间定义合理
2.需要完善_calculate_reward函数，根据S参数计算奖励值
3.CST仿真接口已经实现，但需要设置正确的CST软件路径和项目模板路径

CST接口（CST.py）：
1.已经实现了基本的CST仿真功能
2.需要确保CST软件路径正确配置
3.建议添加错误处理机制，以应对仿真失败的情况

训练流程：
1.DQN和PPO算法的训练流程已经适配材料优化任务
2.评估指标已更新为材料性能相关的指标
3.保存了最佳模型和定期检查点