global t4;
t4 = tcpip('10.13.20.59',7008);
try 
    fopen(t4);
catch err
    disp('VC����������ʧ�ܣ�3s��������......');
    connectvc();
end
disp('VC���������ӳɹ�......');