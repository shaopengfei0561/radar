function chonglian()
global ys;
global handles1;
try
   disp('���ӵ��ȷ���......');
   fname='���ӵ��ȷ���......';
   set(handles1.statetext,'String',fname);
   pause(1);
   fclose(ys);
   fopen(ys);
   disp('���ȷ������ӳɹ�');
   fname='���ȷ������ӳɹ�';
   set(handles1.statetext,'String',fname);
catch
   disp('���ӵ��ȷ���ʧ��');
   fname='���ӵ��ȷ���ʧ��';
   set(handles1.statetext,'String',fname);
end
end