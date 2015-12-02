function send_meadata(storedata,mode)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%按需连接，向云平台服务器发送测量结果
global t5;
disp('连接云平台服务器......');
fopen(t5);                                                                 %连接云平台服务器
disp('云平台服务器连接已成功......');
global toprenum;
mes_frame(1:4)=uint8(hex2dec('df'));                                       %帧头
switch mode
    %发送测量数据
    case 1                                                                                                                                                      
        mes_frame(5)=2;                                                    %消息类型字段
        mes_frame(6)=7*toprenum+9;                                         %帧长（低字节）
        mes_frame(7)=0;                                                    %帧长（高字节）
        mes_frame(8)=toprenum;                                             %扫描库位数量
        for i=1:toprenum
            mes_frame(9+7*(i-1))=storedata(i).seq;                         %库位号
            mes_frame(10+7*(i-1))=mod(storedata(i).vol,2^8);               %库位体积测量结果
            mes_frame(11+7*(i-1))=floor(mod(storedata(i).vol,2^16)/2^8);   %库位体积测量结果
            mes_frame(12+7*(i-1))=floor(mod(storedata(i).vol,2^24)/2^16);  %库位体积测量结果
            mes_frame(13+7*(i-1))=floor(storedata(i).vol/2^24);            %库位体积测量结果
            mes_frame(14+7*(i-1))=storedata(i).filenam1;                   %库位扫描图片文件名
            mes_frame(15+7*(i-1))=storedata(i).filenam2;                   %库位扫描图片文件名
        end
        mes_frame(7*toprenum+9)=crc(mes_frame(1:(7*toprenum+8)));          %校验位
    case 2
        mes_frame=storedata;                                               %向云平台服务器端发送扫描库位消息
    otherwise 
end
% 发送数据
disp('向云平台服务器发送通知消息......');
fwrite(t5,mes_frame,'uint8');
fclose(t5);%断开云平台服务器
disp('断开与云平台服务器的连接......');