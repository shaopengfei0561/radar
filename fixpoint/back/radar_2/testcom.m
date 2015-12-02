global t4;
t4 = tcpip('10.13.20.59',7008);
try 
    fopen(t4);
catch err
    disp('VC服务器连接失败，3s后尝试重连......');
    connectvc();
end
disp('VC服务器连接成功......');