NET.addAssembly('E:\��Ѻ���ڵ���sickmatlab\1.0.0.150921_yt\UFileEX.dll');    %ָ��dll�ļ���·�� 
import UFileEX.*;                                                           %����dll 
key = 'test/a.jpg';                                                         %�ƶ�key            
upLoadfileDir = 'E:\workspace\cccc.jpg';                                    %�ϴ��ļ�·��            
downLoadfileDir = 'C:\eeee\1234.jpg';                                       %�����ļ�����·��
output=UFile.Instance;                                                      %����ʵ���� 
b1=output.UploadFile(key,upLoadfileDir);                                    %�ϴ��ļ�
b2=output.DownLoadFile(downLoadfileDir, key);                               %�����ļ�
b3=output.DeleteFile(key);                                                  %ɾ���ļ�
