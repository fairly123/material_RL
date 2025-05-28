"""
配置文件，包含训练和模型的各种参数设置
"""
import torch

# 通用配置
DEVICE = "cuda"  # 或 "cpu"
ENV_NAME = "SuperMarioBros"
WORLD_STAGE = "1-1"  # 游戏关卡，格式为"世界-关卡"
RENDER_MODE = "rgb_array"  # 渲染模式，训练时通常为rgb_array

# 环境预处理配置
FRAME_SKIP = 4      # 跳帧数量，每n帧执行一次动作
FRAME_STACK = 4     # 堆叠帧数量，将连续n帧作为状态输入
REWARD_SCALE = 0.1  # 奖励缩放
MAX_EPISODE_STEPS = 1000000  # 单轮游戏最大步数
RESIZE_SHAPE = (84, 84)  # 图像调整大小

# 训练配置
TOTAL_TIMESTEPS = 1000000  # 总训练步数
SAVE_INTERVAL = 10000      # 保存模型间隔
LOG_INTERVAL = 1           # 日志打印间隔
EVAL_INTERVAL = 5000       # 评估间隔
EVAL_EPISODES = 5          # 评估回合数
SEED = 42                  # 随机种子

# 材料环境配置
MATERIAL_CONFIG = {
    "matrix_size": 5,          # 矩阵大小
    "r1_range": (10, 100),     # ITO面电阻值范围 (Ω/sq)
    "p_range": (100, 500),     # 单元周期边长范围 (nm)
    "d_range": (50, 200),      # 中间介质层厚度范围 (nm)
    "freq_range": (0.1, 10),   # 频率范围 (THz)
    "reward_weights": {
        "transmission": 1.0,
        "reflection": -0.5,
        "absorption": 0.8
    },
    "cst_path": r"C:\Program Files\CST Studio Suite 2022",  # CST软件路径
    "project_template": r"template.cst"  # CST项目模板路径
}

# DQN配置
DQN_CONFIG = {
    "learning_rate": 1e-4,
    "batch_size": 64,
    "gamma": 0.99,
    "epsilon_start": 1.0,
    "epsilon_end": 0.01,
    "epsilon_decay": 50000,
    "target_update": 1000,
    "buffer_size": 100000,
    "hidden_size": 256,
    "double_dqn": True
}

# PPO配置
PPO_CONFIG = {
    "learning_rate": 3e-4,
    "n_steps": 2048,
    "batch_size": 64,
    "n_epochs": 10,
    "gamma": 0.99,
    "gae_lambda": 0.95,
    "clip_range": 0.2,
    "clip_range_vf": None,
    "ent_coef": 0.0,
    "vf_coef": 0.5,
    "max_grad_norm": 0.5,
    "hidden_size": 256
}

# 可视化配置
VISUALIZATION_CONFIG = {
    "log_dir": "logs",
    "exp_name": "material_optimization",
    "save_video": False,
    "video_interval": 10
}

# 检查点配置
CHECKPOINT_DIR = "checkpoints"
