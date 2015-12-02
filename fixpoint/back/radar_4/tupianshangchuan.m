NET.addAssembly('E:\仓押三期单机sickmatlab\1.0.0.150921_yt\UFileEX.dll');    %指明dll文件的路径 
import UFileEX.*;                                                           %引用dll 
key = 'test/a.jpg';                                                         %云端key            
upLoadfileDir = 'E:\workspace\cccc.jpg';                                    %上传文件路径            
downLoadfileDir = 'C:\eeee\1234.jpg';                                       %下载文件保存路径
output=UFile.Instance;                                                      %将类实例化 
b1=output.UploadFile(key,upLoadfileDir);                                    %上传文件
b2=output.DownLoadFile(downLoadfileDir, key);                               %下载文件
b3=output.DeleteFile(key);                                                  %删除文件
