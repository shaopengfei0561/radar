function flag = netstate(port)
fname=strcat('-n -p tcp |find ":',num2str(port),'"');
data=netstat(fname);
[r,l]=size(data);
flag=1;
for i=1:l
    if data(i)=='E'&&data(i+1)=='S'
        flag=2;
    end
end
end