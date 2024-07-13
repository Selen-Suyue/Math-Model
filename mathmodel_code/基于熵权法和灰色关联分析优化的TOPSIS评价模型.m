%%基于熵权法和灰色关联分析优化的TOPSIS评价模型
clear;clc
%%第一步:读取数据
X=xlsread('指标.xls','B2:E50');
[n,m] = size(X);
disp(['共有' num2str(n) '个评价对象, ' num2str(m) '个评价指标']) 

%%第二步:对正向化后的矩阵进行标准化
for i = 1:n
   for j = 1:m
      Z(i,j) = [X(i,j) - min(X(:,j))] / [max(X(:,j)) - min(X(:,j))];
   end
end
disp('标准化矩阵 Z = ')
disp(Z)

%%第三步:熵权法权重计算
Z=Z+0.0001;
weight=Entropy_Method(Z);
disp('熵权法确定的权重为：')
disp(weight)

%%第四步:评价指标加权后的规范化结果计算
G=Z.*weight;
disp('评价指标加权后的规范化结果计算为：')
disp(G)

%%第五步：评价方案的理想解欧氏距离
l_P = sum([(weight.*(G - repmat(max(G),n,1))).^ 2 ],2) .^ 0.5; % l+ 与最大值的距离向量
l_M = sum([(weight.*(G - repmat(min(G),n,1))).^ 2 ],2) .^ 0.5; % l- 与最小值的距离向量

%%第六步：评价方案与理想解之间灰色关联矩阵计算
t = abs(repmat(max(G),n,1)-G);
mmin = min(min(t));%计算最小差
mmax = max(max(t));%计算最大差
P = 0.5;%分辨系数
r_P0 = (mmin + P * mmax)./(t + P * mmax);%计算灰色关联分析

t =abs(repmat(min(G),n,1)-G+0.0001);
mmin = min(min(t));%计算最小差
mmax = max(max(t));%计算最大差
P = 0.5;%分辨系数
r_M0 = (mmin + P * mmax)./(t + P * mmax);%计算灰色关联分析

%%第七步：计算评价方案与理想解之间的关联程度
r_P=sum(r_P0,2)/m;
r_M=sum(r_M0,2)/m;

%%第八步：对计算结果进行无量纲化操处理
L_P=l_P/max(l_P);
L_M=l_M/max(l_M);
R_P=r_P/max(r_P);
R_M=r_M/max(r_M);


%%第九步：计算评价方案与理想方案的接近度
s_p=0.5*L_P+0.5*R_M;
s_m=0.5*L_M+0.5*R_P;
C=s_p./(s_p+s_m);
C = [max(C) - C] / [max(C) - min(C)];
disp('计算评价方案与理想方案的接近度为：')
disp(C)