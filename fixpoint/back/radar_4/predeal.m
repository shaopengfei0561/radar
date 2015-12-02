function predeal(bg,sj,pointNum,bg2)
global deviceID;
global storeconfig;
global lidarQuantity;

data=[];
[m,n]=size(bg);
[m1,n1]=size(bg2);

if lidarQuantity == 2
	temp_pointNum = pointNum*2;
else
    temp_pointNum = pointNum;
end

for i=1:n
%% 坐标转换
   [data(temp_pointNum*(i-1)+1:temp_pointNum*i,1),data(temp_pointNum*(i-1)+1:temp_pointNum*i,2),data(temp_pointNum*(i-1)+1:temp_pointNum*i,3)]=rect_convert(bg(:,i),i,sj,pointNum);
%% 点云聚类
%    [data(temp_pointNum*(i-1)+1:temp_pointNum*i,1),data(temp_pointNum*(i-1)+1:temp_pointNum*i,2),data(temp_pointNum*(i-1)+1:temp_pointNum*i,3)]=data_cluster(data(temp_pointNum*(i-1)+1:temp_pointNum*i,1),data(temp_pointNum*(i-1)+1:temp_pointNum*i,2),data(temp_pointNum*(i-1)+1:temp_pointNum*i,3),pointNum);
%% 存入能量值    
%    data(temp_pointNum*(i-1)+1:temp_pointNum*i,4)=bg2(:,i);
end
%% 滤波
data=datafilter(data);
%% 保存原始数据
fname=strcat('oridata_','z',num2str(deviceID),'z',num2str(storeconfig(sj,2)),'.txt');         %保存数据至相应库位号指定文件
fid=fopen(fname,'wt+');
fprintf(fid,'%f %f %f\n',data');
fclose(fid);
end       