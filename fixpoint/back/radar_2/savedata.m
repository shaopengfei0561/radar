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
end