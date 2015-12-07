function b = datafilter(data)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%算法参数配置%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
neithrd = 200;           %相邻点距离过滤阈值（单位：mm）
b=[];
m_data=[];
row=find(abs(data(:,1))+abs(data(:,2))+abs(data(:,3))>0);
m_data=data(row,:);
[r,l]=size(m_data);
for i=2:r-1
    d1=distance(m_data(i,:),m_data(i-1,:));
    d2=distance(m_data(i,:),m_data(i+1,:));
    if min(d1,d2)>neithrd                   %相邻点距离过滤阈值，超过该阈值则将该点滤除
       m_data(i,:)=0; 
    end
end
row=find(abs(m_data(:,1))+abs(m_data(:,2))+abs(m_data(:,3))>0);
b=m_data(row,:);
end