function vcfrmpara(data)
%% ����VC�״����ݲɼ�������͵�����֡
global toprestore;
global toprenum;
global ListenTimer;
global f;
global hObject1 handles1;
% modified by YZJ start...
global showType;
global paravalue;
% modified by YZJ end...
switch data(5)
    case 1
          disp('VC��ȷ���յ�ɨ���λ����......');
          
    case 2                                                                 % VC�����������Ŀ�ʼ�㷨������������֡                                                                
          send_data(data,4);                                               % ��VC����������Ӧ��
          disp('�յ�VC�����������Ŀ�ʼ�㷨������������֡......');
          stop(ListenTimer);          
          for sj=1:toprenum
              %���տ�λ��������Ӧ����
              fname=strcat(num2str(toprestore(sj)),'.txt');
              ftpget(fname,f);
          end 
          disp('�����������......');
          % �����ؽ�
          % modified by YZJ start...
          if(~showType)
            dianyunalg();                                                  % �������ݴ�����
          else
            dianyunalg2(); 
          end
          % modified by YZJ end...                                         % �������ݴ�����                                                         
          % �ָ�����
          toprestore=[];
          toprenum=0;
          start(ListenTimer);
     
    case 3                                                                 
          disp('�ѽ��յ�VC������������ɨ���λ��Ϣ......');                  %VC������������ɨ���λ��Ϣ
          send_meadata(data,2)                                             %����ƽ̨����ɨ���λ��Ϣ
          disp('����ƽ̨����ɨ���λ��Ϣ......');
    otherwise       
end
end