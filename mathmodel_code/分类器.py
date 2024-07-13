from sklearn.svm import SVC
from sklearn.discriminant_analysis import LinearDiscriminantAnalysis
from sklearn.tree import DecisionTreeClassifier
from sklearn.ensemble import VotingClassifier
import pandas as pd

# 创建分类器
svm = SVC(kernel='linear', probability=True)
lda = LinearDiscriminantAnalysis()
dt = DecisionTreeClassifier()

# 创建投票器模型
voting_model = VotingClassifier(estimators=[('svm', svm), ('lda', lda), ('dt', dt)],
                                weights=[0.5, 0.3, 0.2], voting='soft')

data=pd.read_excel('a.xlsx')

X_train=data.iloc[:200,0]
y_train=data.iloc[:200,1]
X_test=data.iloc[200:,0]
voting_model.fit(X_train, y_train)

# 使用模型预测新数据的标签
predictions = voting_model.predict(X_test)





