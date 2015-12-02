function count = MyCompress(A,dis)
kk=0;%设置进度条的初始值
a=A;%获取当前矩阵a的值；
count=[];%存储变量count赋值为【】，每次压缩后不保留压缩前的数值
m=max(a);%求出a中每列的最大值，m是1*3的数轴向量
n=min(a);%求出a中每列的最xiao值，n是1*3的数轴向量
xj=m(1)-n(1);%求出x的范围
yj=m(2)-n(2);%求出y的范围
%zj=m(3)-n(3);%求出z的范围以便三维格网划分
xx=0:dis:xj;%生成分割数组
yy=0:dis:yj;%生成分割数组
%zz=0:dis:zj;%生成分割数组
steps=length(xx)*length(yy);%进度条总长度，这里等于每个循环的叠成
step=steps/100;%进度条默认百分比基数数100，准换为100比 方便输出进度百分比
hwait=waitbar(0,'qingshaodeng<<<<<');%进度条初始显示
for ji=1:length(xx)%0:dis:floor(xj)%划分立体格网；
   for ii=1:length(yy)%0:dis:floor(yj)
    %for iii=1:length(zz)%0:dis:floor(zj)
        %找出划分后的三维格网中的点，点号保存在p中,p是点的点好，也就是原始数据中序号，第几列所组成的一个列向量
        p=find(n(1)+xx(ji)<=a(:,1)&a(:,1)<=n(1)+xx(ji)+dis&n(2)+yy(ii)<=a(:,2)&a(:,2)<=n(2)+yy(ii)+dis);  
        kk=kk+1;%进度条的设置，每次循环叠加 每次循环更新进度条
        if steps-kk<=200;%当进度小雨200时  提示即将完成
          waitbar(kk/steps,hwait,'即将完成，间距越小循环越多越熬时间');
          pause(0.05);%每次停留0.05秒更新进度条
        else
        perstr=fix(kk/step);%进度百分比设置
        str=['正在压缩，大概需要几分钟，已完成',num2str(perstr),'%'];
        waitbar(kk/steps,hwait,str);%显示进度变化
        pause(0.05);
        end
        if isempty(p)==1%判断p是不是空矩阵，即选择方格内有没有点 如果没有下一个方格寻找 节省时间
          continue;%跳出循环 下次迭代
        else
          avrx=mean(a(p,1));%求出所选窗口中点云数据的平均值
          avry=mean(a(p,2));%求出所选窗口中点云数据的平均值
          avrz=mean(a(p,3));%求出所选窗口中点云数据的平均值
          avr=[avrx avry avrz];%对每一列求得的结果组合成数组avr
          count=[count;avr];%将每次循环得到的平均值保存在矩阵count中；
        end
   end
end
close(hwait);
msgbox('压缩处理完毕');
end