clear all;
a=load('oridata_z1z11.txt');
row=find(abs(a(:,1))+abs(a(:,2))+abs(a(:,3))>0);
a=a(row,:);
b(:,1)=a(:,1);
b(:,2)=a(:,2);
b(:,3)=-a(:,3);
b(:,4)=a(:,2);
fname=strcat('oridata_1','.txt');
fid=fopen(fname,'wt+');
b=floor(b);
fprintf(fid,'%f %f %f %f\n',b');