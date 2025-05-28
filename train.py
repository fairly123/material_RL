"""
训练脚本，用于训练智能体优化材料结构和参数
"""
import os
import argparse
import time
import numpy as np
import torch
import random
from tqdm import tqdm
import gymnasium as gym
from datetime import datetime

from config import (
    DEVICE, TOTAL_TIMESTEPS, SAVE_INTERVAL, LOG_INTERVAL, EVAL_INTERVAL, 
    EVAL_EPISODES, SEED, DQN_CONFIG, PPO_CONFIG, VISUALIZATION_CONFIG,
    CHECKPOINT_DIR, MATERIAL_CONFIG
)
from environment.material_env import MaterialEnv
from agents.dqn_agent import DQNAgent
from agents.ppo_agent import PPOAgent
from utils.visualization import Visualizer


def set_seed(seed=SEED):
    """
    设置随机种子
    
    Args:
        seed: 随机种子
    """
    random.seed(seed)
    np.random.seed(seed)
    torch.manual_seed(seed)
    if torch.cuda.is_available():
        torch.cuda.manual_seed(seed)
        torch.cuda.manual_seed_all(seed)
        torch.backends.cudnn.deterministic = True
        torch.backends.cudnn.benchmark = False


def create_agent(agent_type, env, device):
    """
    创建智能体
    
    Args:
        agent_type: 智能体类型 ('dqn' 或 'ppo')
        env: 环境实例
        device: 计算设备
    
    Returns:
        agent: 智能体实例
    """
    # 获取观察空间和动作空间的维度
    obs_shape = {
        'matrix': env.observation_space['matrix'].shape,
        'r1': env.observation_space['r1'].shape,
        'p': env.observation_space['p'].shape,
        'd': env.observation_space['d'].shape
    }
    action_space = env.action_space
    
    if agent_type == 'dqn':
        return DQNAgent(obs_shape, action_space, device, DQN_CONFIG)
    elif agent_type == 'ppo':
        return PPOAgent(obs_shape, action_space, device, PPO_CONFIG)
    else:
        raise ValueError(f"Unknown agent type: {agent_type}")


def evaluate_agent(agent, env, n_episodes=EVAL_EPISODES):
    """
    评估智能体性能
    
    Args:
        agent: 智能体实例
        env: 环境实例
        n_episodes: 评估回合数
    
    Returns:
        eval_info: 评估信息
    """
    total_rewards = []
    total_lengths = []
    best_absorption_intervals = []
    
    for episode in range(n_episodes):
        state = env.reset()
        episode_reward = 0
        episode_length = 0
        best_absorption_interval = 0
        done = False
        
        while not done:
            action = agent.select_action(state, evaluate=True)
            next_state, reward, done, info = env.step(action)
            
            episode_reward += reward
            episode_length += 1
            if 's_params' in info:
                best_absorption_interval = max(best_absorption_interval, info['s_params'])
                
            state = next_state
            
        total_rewards.append(episode_reward)
        total_lengths.append(episode_length)
        best_absorption_intervals.append(best_absorption_interval)
    
    eval_info = {
        "mean_reward": np.mean(total_rewards),
        "std_reward": np.std(total_rewards),
        "mean_length": np.mean(total_lengths),
        "mean_absorption_interval": np.mean(best_absorption_intervals),
        "max_absorption_interval": np.max(best_absorption_intervals)
    }
    
    return eval_info


def train_dqn(agent, env, timesteps, visualizer=None):
    """
    训练DQN智能体
    
    Args:
        agent: DQN智能体
        env: 环境实例
        timesteps: 总训练步数
        visualizer: 可视化器
    """
    global_step = agent.step_counter
    episode = agent.episode_counter
    best_reward = -float('inf')
    
    pbar = tqdm(total=timesteps)
    pbar.update(global_step)
    
    while global_step < timesteps:
        state = env.reset()
        episode_reward = 0
        episode_length = 0
        best_absorption_interval = 0
        
        done = False
        while not done:
            action = agent.select_action(state)
            next_state, reward, done, info = env.step(action)
            
            agent.store_transition(state, action, next_state, reward, done)
            loss = agent.optimize_model()
            
            episode_reward += reward
            episode_length += 1
            global_step += 1
            if 's_params' in info:
                best_absorption_interval = max(best_absorption_interval, info['s_params'])
                
            if loss is not None and visualizer is not None:
                visualizer.log_train(global_step, {"loss": loss})
                
            if global_step % EVAL_INTERVAL == 0:
                eval_info = evaluate_agent(agent, env)
                
                print(f"\nEvaluation at step {global_step}:")
                print(f"  Mean reward: {eval_info['mean_reward']:.2f}")
                print(f"  Mean absorption interval: {eval_info['mean_absorption_interval']:.2f}")
                print(f"  Max absorption interval: {eval_info['max_absorption_interval']:.2f}")
                
                if visualizer is not None:
                    visualizer.log_step(global_step, {
                        "eval_reward": eval_info['mean_reward'],
                        "eval_absorption_interval": eval_info['mean_absorption_interval'],
                        "eval_max_absorption_interval": eval_info['max_absorption_interval']
                    })
                
                if eval_info['mean_reward'] > best_reward:
                    best_reward = eval_info['mean_reward']
                    agent.save_model(os.path.join(CHECKPOINT_DIR, "best_dqn_model.pt"))
                    print(f"  New best model with reward: {best_reward:.2f}")
                    
            if global_step % SAVE_INTERVAL == 0:
                agent.save_model(os.path.join(CHECKPOINT_DIR, f"dqn_model_step_{global_step}.pt"))
                
            pbar.update(1)
            
            if global_step >= timesteps:
                break
                
            state = next_state
        
        episode += 1
        agent.episode_counter = episode
        
        episode_info = {
            "episode_reward": episode_reward,
            "episode_length": episode_length,
            "best_absorption_interval": best_absorption_interval,
            "epsilon": agent.epsilon
        }
        
        if episode % LOG_INTERVAL == 0:
            print(f"\nEpisode {episode}:")
            print(f"  Reward: {episode_reward:.2f}")
            print(f"  Best absorption interval: {best_absorption_interval:.2f}")
            print(f"  Epsilon: {agent.epsilon:.4f}")
            
        if visualizer is not None:
            visualizer.log_episode(episode, episode_info)
                
    agent.save_model(os.path.join(CHECKPOINT_DIR, "final_dqn_model.pt"))
    pbar.close()


def train_ppo(agent, env, timesteps, visualizer=None):
    """
    训练PPO智能体
    
    Args:
        agent: PPO智能体
        env: 环境实例
        timesteps: 总训练步数
        visualizer: 可视化器
    """
    global_step = agent.step_counter
    episode = agent.episode_counter
    best_reward = -float('inf')
    
    pbar = tqdm(total=timesteps)
    pbar.update(global_step)
    
    n_steps = PPO_CONFIG["n_steps"]
    
    while global_step < timesteps:
        state = env.reset()
        episode_reward = 0
        episode_length = 0
        best_absorption_interval = 0
        
        done = False
        step_count = 0
        
        while not done:
            action, log_prob, value = agent.select_action(state)
            next_state, reward, done, info = env.step(action)
            
            agent.store_transition(state, action, log_prob, value, reward, done)
            
            episode_reward += reward
            episode_length += 1
            global_step += 1
            step_count += 1
            if 's_params' in info:
                best_absorption_interval = max(best_absorption_interval, info['s_params'])
                
            if step_count % n_steps == 0 or done:
                loss_info = agent.learn()
                if visualizer is not None:
                    visualizer.log_train(global_step, loss_info)
                    
            if global_step % EVAL_INTERVAL == 0:
                eval_info = evaluate_agent(agent, env)
                
                print(f"\nEvaluation at step {global_step}:")
                print(f"  Mean reward: {eval_info['mean_reward']:.2f}")
                print(f"  Mean absorption interval: {eval_info['mean_absorption_interval']:.2f}")
                print(f"  Max absorption interval: {eval_info['max_absorption_interval']:.2f}")
                
                if visualizer is not None:
                    visualizer.log_step(global_step, {
                        "eval_reward": eval_info['mean_reward'],
                        "eval_absorption_interval": eval_info['mean_absorption_interval'],
                        "eval_max_absorption_interval": eval_info['max_absorption_interval']
                    })
                
                if eval_info['mean_reward'] > best_reward:
                    best_reward = eval_info['mean_reward']
                    agent.save_model(os.path.join(CHECKPOINT_DIR, "best_ppo_model.pt"))
                    print(f"  New best model with reward: {best_reward:.2f}")
                    
            if global_step % SAVE_INTERVAL == 0:
                agent.save_model(os.path.join(CHECKPOINT_DIR, f"ppo_model_step_{global_step}.pt"))
                
            pbar.update(1)
            
            if global_step >= timesteps:
                break
                
            state = next_state
        
        episode += 1
        agent.episode_counter = episode
        
        episode_info = {
            "episode_reward": episode_reward,
            "episode_length": episode_length,
            "best_absorption_interval": best_absorption_interval
        }
        
        if episode % LOG_INTERVAL == 0:
            print(f"\nEpisode {episode}:")
            print(f"  Reward: {episode_reward:.2f}")
            print(f"  Best absorption interval: {best_absorption_interval:.2f}")
            
        if visualizer is not None:
            visualizer.log_episode(episode, episode_info)
                
    agent.save_model(os.path.join(CHECKPOINT_DIR, "final_ppo_model.pt"))
    pbar.close()


def main():
    # 解析命令行参数
    parser = argparse.ArgumentParser(description="Train an agent to optimize material structure")
    parser.add_argument("--agent", type=str, default="dqn", choices=["dqn", "ppo"], help="Agent type (dqn or ppo)")
    parser.add_argument("--timesteps", type=int, default=TOTAL_TIMESTEPS, help="Total timesteps for training")
    parser.add_argument("--seed", type=int, default=SEED, help="Random seed")
    parser.add_argument("--load-model", type=str, default=None, help="Load model from path")
    args = parser.parse_args()
    
    # 设置随机种子
    set_seed(args.seed)
    
    # 设置设备
    device = torch.device("cuda" if torch.cuda.is_available() else "cpu")
    print(f"Using device: {device}")
    
    # 创建环境
    env = MaterialEnv(
        matrix_size=MATERIAL_CONFIG["matrix_size"],
        r1_range=MATERIAL_CONFIG["r1_range"],
        p_range=MATERIAL_CONFIG["p_range"],
        d_range=MATERIAL_CONFIG["d_range"],
        cst_path=MATERIAL_CONFIG["cst_path"],
        project_template=MATERIAL_CONFIG["project_template"],
        freq_range=MATERIAL_CONFIG["freq_range"],
        reward_weights=MATERIAL_CONFIG["reward_weights"]
    )
    
    # 创建智能体
    agent = create_agent(args.agent, env, device)
    
    # 加载模型（如果指定）
    if args.load_model is not None:
        print(f"Loading model from: {args.load_model}")
        agent.load_model(args.load_model)
    
    # 创建可视化器
    timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
    log_dir = os.path.join(VISUALIZATION_CONFIG["log_dir"], f"{args.agent}_{timestamp}")
    visualizer = Visualizer(VISUALIZATION_CONFIG, log_dir=log_dir)
    
    # 打印训练配置
    print("\nTraining configuration:")
    print(f"  Agent type: {args.agent}")
    print(f"  Total timesteps: {args.timesteps}")
    print(f"  Seed: {args.seed}")
    print("\nMaterial configuration:")
    print(f"  Matrix size: {MATERIAL_CONFIG['matrix_size']}x{MATERIAL_CONFIG['matrix_size']}")
    print(f"  R1 range: {MATERIAL_CONFIG['r1_range']}")
    print(f"  P range: {MATERIAL_CONFIG['p_range']}")
    print(f"  D range: {MATERIAL_CONFIG['d_range']}")
    print(f"  Frequency range: {MATERIAL_CONFIG['freq_range']} THz")
    
    # 开始训练
    print(f"\nStarting training with {args.agent.upper()} agent...")
    
    try:
        if args.agent == "dqn":
            train_dqn(agent, env, args.timesteps, visualizer)
        elif args.agent == "ppo":
            train_ppo(agent, env, args.timesteps, visualizer)
    except KeyboardInterrupt:
        print("\nTraining interrupted by user")
    finally:
        env.close()
        visualizer.close()
        
    print("\nTraining completed!")
    

if __name__ == "__main__":
    main()