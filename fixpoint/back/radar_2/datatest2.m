file='oridata2_1.txt';
t=load(file);
p=[t,t(:,1),t(:,2)];
row=find(abs(p(:,1))+abs(p(:,2))+abs(p(:,3))>0);
p=p(row,:);
fname=strcat('1','.txt');
fid=fopen(fname,'wt+');%写入文件路径
[m,n]=size(p); %获取矩阵的大小，p为要输出的矩阵
for i=1:1:m
    for j=1:1:n
        if j==n %如果一行的个数达到n个则换行，否则空格
            fprintf(fid,'%d\n',p(i,j)); 
        else
            fprintf(fid,'%d\t',p(i,j));
        end
    end
end
fclose(fid); %关闭文件