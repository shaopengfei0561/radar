function ftpget(fname,f)
try 
    disp('����ftp������Ӧ��λ����......');
    mget(f,fname);
    disp('���سɹ����ر�FTP......');
    close(f);
catch  err
    disp('FTP����ʧ�ܣ�10s������������......');
    close(f);
    delete(fname);
    pause(10);
    ftpget(fname,f);
end