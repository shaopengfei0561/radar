function predeal(bg,kse)
global toprestore;
data=[];
[m,n]=size(bg);
for i=1:n
%% ����ת��
   [data(1058*(i-1)+1:1058*i,1),data(1058*(i-1)+1:1058*i,2),data(1058*(i-1)+1:1058*i,3)]=rect_convert(bg(:,i),i);
%% ���ƾ���
   [data(1058*(i-1)+1:1058*i,1),data(1058*(i-1)+1:1058*i,2),data(1058*(i-1)+1:1058*i,3)]=data_cluster(data(1058*(i-1)+1:1058*i,1),data(1058*(i-1)+1:1058*i,2),data(1058*(i-1)+1:1058*i,3));
end
%% �˲�
data=datafilter(data);
% data(:,2)=data(:,2)*0.634;
if max(data(:,2))>4500
   data(:,2)=data(:,2)*4500/max(data(:,2));
end
%% ����ԭʼ����
fname=strcat('oridata_',num2str(toprestore(kse)),'.txt');         %������������Ӧ��λ��ָ���ļ�
fid=fopen(fname,'wt+');
fprintf(fid,'%f %f %f\n',data');
fclose(fid);
end       