function vcfrmpara(data)
%% ����VC�״����ݲɼ�������͵�����֡
global toprestore;
global toprenum;
global ListenTimer;
global f;
% modified by YZJ start...
global showType;
global paravalue;
% modified by YZJ end...
switch data(5)
    case 1
          disp('VC��ȷ���յ�ɨ���λ����......');
          
    case 2                                                                 % VC�����������Ŀ�ʼ�㷨������������֡                                                                
          send_data(data,4);                                               % ��VC���������Ϳ�ʼ�㷨��������Ӧ��
          disp('�յ�VC�����������Ŀ�ʼ�㷨������������֡......');
          stop(ListenTimer);          
          for sj=1:toprenum
              %���տ�λ��������Ӧ����
              fname=strcat('yt',num2str(toprestore(sj)),'.txt');
              try 
                    mget(f,fname);
              catch  err
                    disp('FTP����ʧ�ܣ���������......');
                    str1 = num2str(paravalue.ftp.ftpip);
                    str2 = num2str(paravalue.ftp.ftpuser);
                    str3 = num2str(paravalue.ftp.ftppw);
                    str4 = num2str(paravalue.ftp.ftpport);
                    str=strcat(str1,':',str4);
                    f=ftp(str,str2,str3);
                    disp('FTP�����ѳɹ�......');
                    pasv(f);
                    delete('yt*.txt');
                    mget(f,fname);
              end
          end         
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
     
    case 3                                                                 %VC������������ɨ���λ��Ϣ
          send_meadata(data,2)                                             %����ƽ̨����ɨ���λ��Ϣ
          disp('����ƽ̨����ɨ���λ��Ϣ......');
    otherwise       
end
end