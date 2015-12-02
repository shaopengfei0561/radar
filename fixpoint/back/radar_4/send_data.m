function send_data(data,mode)
global ys;                                                                 %云平台客户端
global deviceID;
mes_frame(1:4)=uint8(hex2dec('df'));                                       %帧头
switch mode
    case 2
        mes_frame(5)=1;                                                    %消息类型字段
        mes_frame(6)=11;                                                    %帧长（低字节）
        mes_frame(7)=0;                                                    %帧长（高字节）
        mes_frame(8)=1;                                                    %开始采集数据指令配置成功
        mes_frame(9)=mod(deviceID,2^8);                                    %设备ID（低字节）
        mes_frame(10)=floor(deviceID/2^8);                                 %设备ID（高字节）
        mes_frame(11)=crc(mes_frame(1:10));                                %校验位
        % 发送数据
        fwrite(ys,mes_frame,'uint8');                                      %向云平台客户端发送应答消息
    case 3
        mes_frame(5)=1;                                                    %消息类型字段
        mes_frame(6)=9;                                                    %帧长（低字节）
        mes_frame(7)=0;                                                    %帧长（高字节）
        mes_frame(8)=3;                                                    %开始采集数据指令配置成功
        mes_frame(9)=mod(deviceID,2^8);                                    %设备ID（低字节）
        mes_frame(10)=floor(deviceID/2^8);                                 %设备ID（高字节）
        mes_frame(11)=crc(mes_frame(1:10));                                %校验位
        % 发送数据
        fwrite(ys,mes_frame,'uint8');                                      %向云平台客户端发送系统忙消息
    otherwise 
end
