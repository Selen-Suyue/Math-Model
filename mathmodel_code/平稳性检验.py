import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns
import warnings
warnings.filterwarnings('ignore')
plt.rcParams["font.sans-serif"]=["SimHei"] #设置字体
plt.rcParams["axes.unicode_minus"]=False #正常显示负号

original_data = pd.read_excel('时间测试.xlsx', index_col='销售日期')

from statsmodels.graphics.tsaplots import plot_acf, plot_pacf
from statsmodels.tsa.stattools import adfuller
from arch import arch_model

def test_constant_mean(data):
    # 计算移动平均
    rolmean = data.rolling(window=12).mean()

    # 进行ADF检验
    result = adfuller(data)

    print('ADF Statistic:', result[0])
    print('p-value:', result[1])
    print('Critical Values:')
    for key, value in result[4].items():
        print(f'{key}: {value}')

def test_stable_variance(data):
    # 计算条件方差
    model = arch_model(data)
    results = model.fit(disp='off')
    cond_variance = results.conditional_volatility

    # 进行ADF检验
    result = adfuller(data)

    print('ADF Statistic:', result[0])
    print('p-value:', result[1])
    print('Critical Values:')
    for key, value in result[4].items():
        print(f'{key}: {value}')

    # 绘制条件方差图形
    plt.figure(figsize=(16, 4))
    plt.plot(cond_variance, color='blue')
    plt.title('Conditional Variance')
    plt.show()

def test_time_dependent_covariance(data):
    # 计算差分后的数据
    diff_data = data.diff().dropna()

    # 进行ADF检验
    result = adfuller(diff_data)

    print('ADF Statistic:', result[0])
    print('p-value:', result[1])
    print('Critical Values:')
    for key, value in result[4].items():
        print(f'{key}: {value}')


def plot_data_properties(data, ts_plot_name="Time Series plot"):
    plt.figure(figsize=(16, 4))
    plt.plot(data)
    plt.title(ts_plot_name)
    plt.ylabel('Amount')
    plt.xlabel('Time')
    fig, axes = plt.subplots(1, 3, squeeze=False)
    fig.set_size_inches(16, 4)
    plot_acf(data, ax=axes[0, 0], lags=48);
    plot_pacf(data, ax=axes[0, 1], lags=48);
    sns.distplot(data, ax=axes[0, 2])
    axes[0, 2].set_title("Probability Distribution")
    plt.show()
plot_data_properties(original_data, '销售时间关系图')


