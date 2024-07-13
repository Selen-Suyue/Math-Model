 %人群搜索算法（SOA）优化的基于非线性规划的各蔬菜品类未来一周的日补货总量和定价策略决策模型
 clear;clc
 result1=zeros(7,6);
 result2=zeros(7,6);
 %%初始化种群
 N = 1000; 
 d = 84; 
 ger = 20; 
 xlimit = [3,10;3.3,12;12.1,15;3,12;3.5,15;3.3,12;195,215;25,35;25,40;18,25;115,135;85,105]; 
 umax=0.95;%最大隶属度值
 umin=0.011;%最小隶属度值
 wmax=0.9;%权重最大值
 wmin=0.1;%权重最小值

 %%初始化种群位置
 for i = 1:N
     for j=1:d/2
     if mod(j,6)~=0
     x(i,j) = xlimit(mod(j,6), 1) + (xlimit(mod(j,6), 2)-xlimit(mod(j,6), 1))*unifrnd(0, 1);
     elseif mod(j,6)==0
     x(i,j) = xlimit(6, 1) + (xlimit(6, 2)-xlimit(6, 1))*unifrnd(0, 1);
     end
     end
 end
 for i = 1:N
     for j=d/2+1:d
     if mod(j,6)~=0
     x(i,j) = xlimit(mod(j,6)+6, 1) + (xlimit(mod(j,6)+6, 2)-xlimit(mod(j,6)+6, 1))*unifrnd(0, 1);
     elseif mod(j,6)==0
     x(i,j) = xlimit(12, 1) + (xlimit(12, 2)-xlimit(12, 1))*unifrnd(0, 1);
     end
     end
 end
 xm = x; % 每个个体的历史最佳位置
 ym = zeros(1, d); % 种群的历史最佳位置
 fxm = zeros(N, 1); % 每个个体的历史最佳适应度
 fym = -inf; % 种群历史最佳适应度（寻max则初始化为-inf，寻min则初始化为inf）

 %%寻找最优个体
 fx = zeros(N, 1);
 for i = 1:N
 fx(i) = object(x(i,:)); % 个体当前适应度
 end
 %更新个体历史最佳适应度和个体历史最佳位置
 for i = 1:N
 if fxm(i) < fx(i)
 fxm(i) = fx(i); % 更新个体历史最佳适应度
 xm(i,:) = x(i,:); % 更新个体历史最佳位置
 end
 end
 %更新群体历史最佳适应度和群体历史最佳位置
 if fym < max(fxm) 
 [fym, nmax] = max(fxm); % 更新群体历史最佳适应度
 ym = xm(nmax, :); % 更新群体历史最佳位置
 end

 
 %%迭代寻优
 record = zeros(ger, 1); % 记录器(记录每次迭代的群体最佳适应度)
 Di=0*rand(N,d);
 Di(1,:)=1;
 L=0*rand(N,d);
 Diego=0*rand(N,d);
 Dialt=0*rand(N,d);
 Dipro=0*rand(N,d);
 for iter = 1:ger
 for i=1:N
 w=wmax-iter*(wmax-wmin)/ger;
 Diego(i,:)=sign(xm(i,:)- x(i,:));%确定利己方向
 Dialt(i,:)=sign(ym - x(i,:));%确定利他方向
 if object(xm(i,:))>=object(x(i,:))
   Dipro(i,:)=-Di(i,:);
 else
   Dipro(i,:)=Di(i,:);
 end
 Di(i,:)=sign(w* Dipro(i,:)+rand*Diego(i,:)+rand*Dialt(i,:));%确定经验梯度方向
 [Orderfitnessgbest, Indexfitnessgbest]=sort(fxm,'descend');
 u=umax-(N-Indexfitnessgbest(i))*(umax-umin)/(N-1);
 U=u+(1-u)*rand;
 H(iter)=(ger-iter)/ger;%选代过程中权重的变化
 C(i,:)=H(iter)*abs(ym-5*rands(1,d));%确定高斯函数的参数
 T=sqrt(-log(U));%确定搜索步长的大小
 v(i,:)=C(i,:)*T;
 v(1,find(v(1,:)>3*max(C(i,:))))=3*max(C(i,:));
 v(i,find(v(i,:)<0))=0;
 %更新位置
 x(i,:) = x(i,:) + Di(i,:).*v(i,:); 
 % 边界位置处理
 new_x = zeros(N, d);
 for i = 1:d/2
     xi = x(:,i);
     if mod(i,6)~=0
     xi(xi > xlimit(mod(i,6),2)) = xlimit(mod(i,6),2);
     xi(xi < xlimit(mod(i,6),1)) = xlimit(mod(i,6),1);
     new_x(:,i) = xi;
     elseif mod(i,6)==0
     xi(xi > xlimit(6,2)) = xlimit(6,2);
     xi(xi < xlimit(6,1)) = xlimit(6,1);
     new_x(:,i) = xi;
     end
 end
 for i = d/2+1:d
     xi =x(:,i);
     if mod(i,6)~=0
     xi(xi > xlimit(mod(i,6)+6,2)) = xlimit(mod(i,6)+6,2);
     xi(xi < xlimit(mod(i,6)+6,1)) = xlimit(mod(i,6)+6,1);
     new_x(:,i) = xi;
     elseif mod(i,6)==0
     xi(xi > xlimit(12,2)) = xlimit(12,2);
     xi(xi < xlimit(12,1)) = xlimit(12,1);
     new_x(:,i) = xi;
     end
 end
 x = new_x;
 end
 record(iter) = fym; % 最佳适应度记录
 end

 %%导入结果
 for i=1:7
   for j=1:6
   result1(i,j)=ym(1,6*(i-1)+j);
   end
 end
  for i=1:7
   for j=1:6
   result2(i,j)=ym(1,42+6*(i-1)+j);
   end
 end