function connectvc()
global t4;
try 
    pause(3);
    fopen(t4);
catch err
    disp('VC服务器连接失败，3s后尝试重连......');
    connectvc();
end
end