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
%% ����ת��
   [data(temp_pointNum*(i-1)+1:temp_pointNum*i,1),data(temp_pointNum*(i-1)+1:temp_pointNum*i,2),data(temp_pointNum*(i-1)+1:temp_pointNum*i,3)]=rect_convert(bg(:,i),i,sj,pointNum);
%% ���ƾ���
%    [data(temp_pointNum*(i-1)+1:temp_pointNum*i,1),data(temp_pointNum*(i-1)+1:temp_pointNum*i,2),data(temp_pointNum*(i-1)+1:temp_pointNum*i,3)]=data_cluster(data(temp_pointNum*(i-1)+1:temp_pointNum*i,1),data(temp_pointNum*(i-1)+1:temp_pointNum*i,2),data(temp_pointNum*(i-1)+1:temp_pointNum*i,3),pointNum);
%% ��������ֵ    
%    data(temp_pointNum*(i-1)+1:temp_pointNum*i,4)=bg2(:,i);
end
%% �˲�
data=datafilter(data);
%% ����ԭʼ����
fname=strcat('oridata_','z',num2str(deviceID),'z',num2str(storeconfig(sj,2)),'.txt');         %������������Ӧ��λ��ָ���ļ�
fid=fopen(fname,'wt+');
fprintf(fid,'%f %f %f\n',data');
fclose(fid);
end       