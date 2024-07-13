%%多目标粒子群优化算法(MOPSO)
clear;clc
result1=zeros(1,33);%定价确定
result2=zeros(1,33);%补货量预测
%%初始化种群
N=1000; 
d=66; 
ger=20; 
xlow=[0.40 0.51 0.91 0.70 2.73 1.02 0.77 0.69 0.64 0.72 0.63 1.67 1.78 4.09 2.35 2.40 2.60 3.85 0.81 0.88 1.48 1.35 0.64 0.49 0.32 0.60 3.39 0.56 2.85 3.34 0.73 0.31 0.42 8.92 13.24 3.79	5.89 0.92 10.29	4.47 6.38 4.84 32.14 21.14 6.86	12.5 3.52 5.94 2.94 1.7	3.95 10.86	2.61 4.19 6.78 14.17 21.29 11.14 11.14 1.02	6.86 2 4.59 9.86 16 8.71];
xhigh=[4.77 4.71 10.00 6.76 17.50 8.22 6.61 5.98 6.50 5.58 5.20 6.88 15.43 16.04 17.87 16.49 17.50 26.14 7.50 7.50 15.00 14.25 6.50 7.21 3.23 6.17 23.88 5.90 23.48 30.00 6.28 2.35 3.43 17.85 26.49 7.59 11.77 1.85 20.57 8.94 12.76 9.69 64.29 42.29 13.71 25.01 7.03 13.89 8.89 5.40 11.90 21.72 5.22 8.39 13.55 28.35 42.57 22.29 22.29 2.03 13.71 4 9.17 19.7 32 17.4];
vlow=[-0.5,-5];
vhigh=[0.5,5];
w=0.5; 
c1=0.6;
c2=0.6; 
%%初始化种群位置
for i = 1:N
    for j=1:d
     x(i,j)=xlow(1, j)+(xhigh(1,j)-xlow(1,j))*unifrnd(0,1);
    end
end
%%初始化种群速度
for i = 1:N
    for j=1:d/2
     v(i,j)=vlow(1, 1)+(vhigh(1,1)-vlow(1,1))*unifrnd(0,1);
    end
end
for i = 1:N
    for j=d/2+1:d
     v(i,j)=vlow(1, 2)+(vhigh(1,2)-vlow(1,2))*unifrnd(0,1);
    end
end
xm=x;%每个个体的历史最佳位置
ym=zeros(1, d);%种群的历史最佳位置
fxm=zeros(N, 2);%每个个体的历史最佳适应度
fym=[-inf,-inf];%种群历史最佳适应度（寻max则初始化为-inf，寻min则初始化为inf）
%%群体更新
record=zeros(ger,2);%记录器(记录每次迭代的群体最佳适应度)
for iter=1:ger
fx=zeros(N,2);
%%个体当前适应度
for i=1:N
  fx(i,1)=object1(x(i,:)); 
  fx(i,2)=object2(x(i,[34:66]));
end
%%更新个体历史最佳适应度和个体历史最佳位置
for i=1:N
  if fxm(i,1)<fx(i,1)&&fxm(i,2)<fx(i,2)
  fxm=fx;%更新个体历史最佳适应度
  xm(i,:)=x(i,:);%更新个体历史最佳位置
  else
  r=unifrnd(0,1);
  if r<0.5
  xm(i,:)=x(i,:);%更新个体历史最佳位置
  else
  xm(i,:)=xm(i,:);%更新个体历史最佳位置
  end
  end
end
%%更新群体历史最佳适应度和群体历史最佳位置
for i=1:N
  if fym(1,1)<fxm(i,1)&&fym(1,2)<fxm(i,2)
  fym=fxm(i,:);% 更新群体历史最佳适应度
  ym=xm(i,:);% 更新群体历史最佳位置
  end
end
%%更新速度
v=v*w+c1*rand*(xm-x)+c2*rand*(repmat(ym, N, 1)-x);
%%边界速度处理
new_v=zeros(N,d);
for  i=1:d/2
     vi=v(:,i);
     vi(vi>vhigh(1,1))=vhigh(1,1);
     vi(vi<vlow(1,1))=vlow(1,1);
     new_v(:,i)=vi;
end
for  i=d/2+1:d
     vi=v(:,i);
     vi(vi>vhigh(1,2))=vhigh(1,2);
     vi(vi<vlow(1,2))=vlow(1,2);
     new_v(:,i)=vi;
end
v=new_v;
%更新位置
x=x+v; 
%边界位置处理
new_x=zeros(N,d);
for i=1:d/2
    xi=x(:,i);
    xi(xi>xhigh(1,1))=xhigh(1,1);
    xi(xi<xlow(1,1))=xlow(1,1);
    new_x(:,i)=xi;   
end
for i=d/2+1:d
    xi=x(:,i);
    xi(xi>xhigh(1,2))=xhigh(1,2);
    xi(xi<xlow(1,2))=xlow(1,2);
    new_x(:,i)=xi;   
end
x=new_x;
record(iter,:)=fym;%最佳适应度记录
end
%导入结果
result1=ym(1,[1 :33]);
result2=ym(1,[34 :66]);