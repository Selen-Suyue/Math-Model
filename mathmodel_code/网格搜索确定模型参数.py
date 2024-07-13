import itertools
import warnings
from statsmodels.tsa.statespace.sarimax import SARIMAX
import pandas as pd

def find_best_sarima_model(data):
    best_aic = float("inf")
    best_order = None
    best_seasonal_order = None

    # 忽略警告信息
    warnings.filterwarnings("ignore")

    # 遍历参数组合
    for order in itertools.product(range(0, 1), range(0, 1), range(0, 1)):
        for seasonal_order in itertools.product(range(0, 1), range(0, 1), range(0, 1), range(0, 1)):
            try:

                model = SARIMAX(data, order=order, seasonal_order=seasonal_order)
                results = model.fit(disp=False)


                aic = results.aic

                # 更新最佳模型参数
                if aic < best_aic:
                    best_aic = aic
                    best_order = order
                    best_seasonal_order = seasonal_order
            except:
                continue

    print("Best SARIMA Model (AIC={}): SARIMA{}x{}".format(best_aic, best_order, best_seasonal_order))
data=pd.read_excel('月度.xlsx')
find_best_sarima_model(data)




