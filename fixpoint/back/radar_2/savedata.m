function savedata(p,flag,sj)
global toprestore;
switch flag
    case 1
        fname=strcat('ytpntcloud_',num2str(toprestore(sj)),'.txt');
        p=floor(p);
    case 2
        fname=strcat('ytsurface_',num2str(toprestore(sj)),'.txt');
    case 3
        fname=strcat('ytpntcloud_',num2str(sj),'.txt');
        p=floor(p);
    otherwise;
end
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
end