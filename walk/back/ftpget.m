function ftpget(fname,f)
try 
    disp('连接ftp下载相应库位数据......');
    mget(f,fname);
    disp('下载成功，关闭FTP......');
    close(f);
catch  err
    disp('FTP下载失败，10s后尝试重新下载......');
    close(f);
    delete(fname);
    pause(10);
    ftpget(fname,f);
end