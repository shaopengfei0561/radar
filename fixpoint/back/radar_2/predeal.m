function predeal(bg,kse)
global toprestore;
data=[];
[m,n]=size(bg);
for i=1:n
%% 坐标转换
   [data(1058*(i-1)+1:1058*i,1),data(1058*(i-1)+1:1058*i,2),data(1058*(i-1)+1:1058*i,3)]=rect_convert(bg(:,i),i);
%% 点云聚类
   [data(1058*(i-1)+1:1058*i,1),data(1058*(i-1)+1:1058*i,2),data(1058*(i-1)+1:1058*i,3)]=data_cluster(data(1058*(i-1)+1:1058*i,1),data(1058*(i-1)+1:1058*i,2),data(1058*(i-1)+1:1058*i,3));
end
%% 滤波
data=datafilter(data);
% data(:,2)=data(:,2)*0.634;
if max(data(:,2))>4500
   data(:,2)=data(:,2)*4500/max(data(:,2));
end
%% 保存原始数据
fname=strcat('oridata_',num2str(toprestore(kse)),'.txt');         %保存数据至相应库位号指定文件
fid=fopen(fname,'wt+');
fprintf(fid,'%f %f %f\n',data');
fclose(fid);
end       