import statsmodels.api as sm
import pandas as pd
lst=[]
data=pd.read_excel('月度.xls')
for i in range(1,252):
    y=data.iloc[:,i]
    mod = sm.tsa.statespace.SARIMAX(y,
                        order=(1, 1, 1),
                        seasonal_order=(1, 1, 1, 12),
                        enforce_stationarity=False,
                        enforce_invertibility=False)

    results = mod.fit()
    params = results.params
    weight = params[['ar.L1', 'ma.L1', 'ar.S.L12', 'ma.S.L12']]
    lst.append(weight)
lst=pd.DataFrame(lst)
lst.to_excel('coef.xlsx')



