function send_meadata(storedata,mode)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%按需连接，向云平台服务器发送测量结果
global ys;
global hObject1 handles1;
global toprenum;
global storeconfig;
global deviceID;
global runstat;
mes_frame(1:4)=uint8(hex2dec('df'));                                       %帧头
switch mode
    %发送测量数据
    case 1                                                                                                                                                      
        mes_frame(5)=2;                                                    %消息类型字段
        mes_frame(6)=23*toprenum+11;                                        %帧长（低字节）
        mes_frame(7)=0;                                                    %帧长（高字节）
        mes_frame(8)=toprenum;                                             %扫描库位数量
        for i=1:toprenum
            mes_frame(9+23*(i-1))=mod(storedata(i).storeid,2^8);            %库号
            mes_frame(10+23*(i-1))=floor(storedata(i).storeid/2^8);         %库号
            mes_frame(11+23*(i-1))=storedata(i).seq;                        %库位号
            mes_frame(12+23*(i-1))=mod(storedata(i).vol,2^8);               %库位体积测量结果
            mes_frame(13+23*(i-1))=floor(mod(storedata(i).vol,2^16)/2^8);   %库位体积测量结果
            mes_frame(14+23*(i-1))=floor(mod(storedata(i).vol,2^24)/2^16);  %库位体积测量结果
            mes_frame(15+23*(i-1))=floor(storedata(i).vol/2^24);            %库位体积测量结果
            
            year = str2num(storedata(i).filenam1(1:4));
            mes_frame(16+23*(i-1))=mod(year,2^8);                     %库位扫描图片文件名
            mes_frame(17+23*(i-1))=floor(year/2^8);                   %库位扫描图片文件名
            mes_frame(18+23*(i-1))=str2num(storedata(i).filenam1(5:6));                              %库位扫描图片文件名
            mes_frame(19+23*(i-1))=str2num(storedata(i).filenam1(7:8));                              %库位扫描图片文件名
            mes_frame(20+23*(i-1))=str2num(storedata(i).filenam1(9:10));                              %库位扫描图片文件名
            mes_frame(21+23*(i-1))=str2num(storedata(i).filenam1(11:12));                              %库位扫描图片文件名
            mes_frame(22+23*(i-1))=str2num(storedata(i).filenam1(13:14));                              %库位扫描图片文件名
            mes_frame(23+23*(i-1))=str2num(storedata(i).filenam1(15:16));                   %库位扫描图片文件名
            
            mes_frame(24+23*(i-1))=mod(year,2^8);                     %库位扫描图片文件名
            mes_frame(25+23*(i-1))=floor(year/2^8);                   %库位扫描图片文件名
            mes_frame(26+23*(i-1))=str2num(storedata(i).filenam2(5:6));                              %库位扫描图片文件名
            mes_frame(27+23*(i-1))=str2num(storedata(i).filenam2(7:8));                              %库位扫描图片文件名
            mes_frame(28+23*(i-1))=str2num(storedata(i).filenam2(9:10));                              %库位扫描图片文件名
            mes_frame(29+23*(i-1))=str2num(storedata(i).filenam2(11:12));                              %库位扫描图片文件名
            mes_frame(30+23*(i-1))=str2num(storedata(i).filenam2(13:14));                              %库位扫描图片文件名
            mes_frame(31+23*(i-1))=str2num(storedata(i).filenam2(15:16));                   %库位扫描图片文件名  
        end
        mes_frame(23*toprenum+9)=mod(deviceID,2^8);                         %设备ID（低字节）
        mes_frame(23*toprenum+10)=floor(deviceID/2^8);                      %设备ID（高字节）
        mes_frame(23*toprenum+11)=crc(mes_frame(1:(23*toprenum+10)));       %校验位
        
    case 2                                                                  %向云平台服务器端发送扫描库位消息
        mes_frame(5)=3;                                                     %消息类型字段                                                     
        mes_frame(6)=13;                                                    %总帧长（低字节）
        mes_frame(7)=0;                                                     %总帧长（高字节）
        mes_frame(8)=mod(storeconfig(1,1),2^8);                             %库号（低字节）
        mes_frame(9)=floor(storeconfig(1,1)/2^8);                           %库号（高字节）
        mes_frame(10)=storeconfig(1,2);                                     %库位号
        mes_frame(11)=mod(deviceID,2^8);                                    %设备ID（低字节）
        mes_frame(12)=floor(deviceID/2^8);                                  %设备ID（高字节）
        mes_frame(13)=crc(mes_frame(1:12));                                 %校验位
        
    case 3                                                                  %发送心跳包
        mes_frame(5)=4;                                                     %消息类型字段                                                     
        mes_frame(6)=11;                                                    %总帧长（低字节）
        mes_frame(7)=0;                                                     %总帧长（高字节）
        mes_frame(8)=runstat;                                               %忙闲标志位（0：闲，1：忙）
        mes_frame(9)=mod(deviceID,2^8);                                     %设备ID（低字节）
        mes_frame(10)=floor(deviceID/2^8);                                  %设备ID（高字节）
        mes_frame(11)=crc(mes_frame(1:10));                                 %校验位  
    otherwise 
end
% 发送数据
fwrite(ys,mes_frame,'uint8');