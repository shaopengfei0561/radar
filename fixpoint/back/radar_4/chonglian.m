function chonglian()
global ys;
global handles1;
try
   disp('连接调度服务......');
   fname='连接调度服务......';
   set(handles1.statetext,'String',fname);
   pause(1);
   fclose(ys);
   fopen(ys);
   disp('调度服务连接成功');
   fname='调度服务连接成功';
   set(handles1.statetext,'String',fname);
catch
   disp('连接调度服务失败');
   fname='连接调度服务失败';
   set(handles1.statetext,'String',fname);
end
end