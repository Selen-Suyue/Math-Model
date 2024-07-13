import pandas as pd

data=pd.read_excel("花叶类.xlsx")
cof=pd.read_excel("coef花叶.xlsx")
score=0

#step1
for i in range(data.shape[0]):
    if data.iloc[i,1]>=data.iloc[i,2]:
        score+=data.iloc[i,2]
        data.iloc[i,1]-=data.iloc[i,2]
        data.iloc[i,2]=0
    elif data.iloc[i,1]<data.iloc[i,2]:
        score+=data.iloc[i,1]
        data.iloc[i,2]-=data.iloc[i,1]
        data.iloc[i, 1] = 0

#step2
for i in range(data.shape[0]):
    if data.iloc[i,2]!=0 :
        a=cof.iloc[1,:]
        for j in range(cof.shape[1]):
            max_index=cof.iloc[1,:].index(max(a))
            if data.iloc[max_index,1]>=data.iloc[i,2]:
                data.iloc[max_index,1]-=data.iloc[i,2]
                score+=cof.iloc[max_index,i]*data.iloc[i,2]
                data.iloc[i,2]=0
                break
            else :
                score += cof.iloc[max_index, i] * data.iloc[max_index, 1]
                data.iloc[i,2]-=data.iloc[max_index,i]
                data.iloc[max_index,i]=0
                a[max_index]=0
    if(data.iloc[i,2]==0):
        break
print(score)











