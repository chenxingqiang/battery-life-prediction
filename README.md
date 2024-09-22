# 锂离子电池寿命预测及影响分析

这个项目旨在分析锂离子电池的寿命预测和影响因素,使用 NASA 的 B0005、B0006、B0007 和 B0018 数据集。

## 项目结构

- src/: 源代码目录
  - main.m: 主脚本
  - preprocess_data.m: 数据预处理函数
  - analyze_capacity_regeneration.m: 容量再生现象分析函数
  - analyze_temperature_impact.m: 温度影响分析函数
  - predict_capacity.m: 容量预测函数
  - visualize_results.m: 结果可视化函数
  - save_results.m: 结果保存函数
  - helper_functions.m: 辅助函数集合
- data/: 数据目录 (将自动下载数据集)
- results/: 结果保存目录

## 使用方法

1. 确保您的 MATLAB 环境已经设置好。
2. 打开 MATLAB,将工作目录设置为项目的 src/ 文件夹。
3. 在 MATLAB 命令窗口中运行 main 脚本:

   

4. 脚本将自动下载数据、进行分析,并在 results/ 目录中保存结果。

## 注意事项

- 请确保您有足够的磁盘空间来存储数据集和结果。
- 分析过程可能需要一些时间,请耐心等待。
- 如果遇到任何问题,请检查 MATLAB 的错误信息并相应调整代码。

