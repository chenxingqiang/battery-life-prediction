% setup.m
% 初始化锂离子电池寿命预测项目的环境

% 清除工作空间和命令窗口
clear;
clc;
close all;

% 获取当前脚本的路径
script_path = fileparts(mfilename('fullpath'));

% 添加项目文件夹到 MATLAB 路径
addpath(genpath(fullfile(script_path, 'src')));
addpath(genpath(fullfile(script_path, 'data')));
addpath(genpath(fullfile(script_path, 'results')));

% 检查必要的工具箱
required_toolboxes = {'Statistics and Machine Learning Toolbox', ...
                      'Signal Processing Toolbox', ...
                      'Wavelet Toolbox', ...
                      'Deep Learning Toolbox'};
                  
missing_toolboxes = check_toolboxes(required_toolboxes);

if ~isempty(missing_toolboxes)
    warning('以下工具箱缺失，可能会影响某些功能：');
    disp(missing_toolboxes);
else
    disp('所有必要的工具箱都已安装。');
end

% 设置全局变量
global DATA_DIR RESULTS_DIR;
DATA_DIR = fullfile(script_path, 'data');
RESULTS_DIR = fullfile(script_path, 'results');

% 创建结果目录（如果不存在）
if ~exist(RESULTS_DIR, 'dir')
    mkdir(RESULTS_DIR);
end

% 检查数据文件是否存在
data_files = {'B0005.mat', 'B0006.mat', 'B0007.mat', 'B0018.mat'};
missing_files = check_data_files(data_files, DATA_DIR);

if ~isempty(missing_files)
    warning('以下数据文件缺失：');
    disp(missing_files);
    error('请确保所有必要的数据文件都在 data 目录中。');
else
    disp('所有必要的数据文件都已找到。');
end

disp('环境设置完成。您现在可以运行 main.m 来开始分析。');

% 辅助函数
function missing_toolboxes = check_toolboxes(required_toolboxes)
    installed_toolboxes = ver;
    installed_toolbox_names = {installed_toolboxes.Name};
    missing_toolboxes = setdiff(required_toolboxes, installed_toolbox_names);
end

function missing_files = check_data_files(data_files, data_dir)
    missing_files = {};
    for i = 1:length(data_files)
        if ~exist(fullfile(data_dir, data_files{i}), 'file')
            missing_files{end+1} = data_files{i};
        end
    end
end