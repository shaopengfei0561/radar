file='oridata2_1.txt';
t=load(file);
p=[t,t(:,1),t(:,2)];
row=find(abs(p(:,1))+abs(p(:,2))+abs(p(:,3))>0);
p=p(row,:);
fname=strcat('1','.txt');
fid=fopen(fname,'wt+');%д���ļ�·��
[m,n]=size(p); %��ȡ����Ĵ�С��pΪҪ����ľ���
for i=1:1:m
    for j=1:1:n
        if j==n %���һ�еĸ����ﵽn�����У�����ո�
            fprintf(fid,'%d\n',p(i,j)); 
        else
            fprintf(fid,'%d\t',p(i,j));
        end
    end
end
fclose(fid); %�ر��ļ�