function connectvc()
global t4;
try 
    pause(3);
    fopen(t4);
catch err
    disp('VC����������ʧ�ܣ�3s��������......');
    connectvc();
end
end