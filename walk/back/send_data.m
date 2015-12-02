function send_data(data,mode)
global t4;                                                                 %VC雷达数据采集服务器
global t3;                                                                 %云平台客户端
mes_frame(1:4)=uint8(hex2dec('df'));                                       %帧头
switch mode
    case 1 
        mes_frame=[data,239,239,239,239];
        % 发送数据
        fwrite(t4,mes_frame,'uint8');                                      %向雷达VC采集服务器转发开始采集雷达数据命令
        
    case 2
        mes_frame(5)=1;                                                    %消息类型字段
        mes_frame(6)=9;                                                    %帧长（低字节）
        mes_frame(7)=0;                                                    %帧长（高字节）
        mes_frame(8)=1;                                                    %开始采集数据指令配置成功
        mes_frame(9)=crc(mes_frame(1:8));                                  %校验位
        % 发送数据
        fwrite(t3,mes_frame,'uint8');                                      %向云平台客户端发送应答消息
        
    case 3
        mes_frame(5)=1;                                                    %消息类型字段
        mes_frame(6)=9;                                                    %帧长（低字节）
        mes_frame(7)=0;                                                    %帧长（高字节）
        mes_frame(8)=3;                                                    %开始采集数据指令配置成功
        mes_frame(9)=crc(mes_frame(1:8));                                  %校验位
        % 发送数据
        fwrite(t3,mes_frame,'uint8');                                      %向云平台客户端发送系统忙消息
        
    case 4                                                                 %向VC服务器发送应答消息
        mes_frame(5)=2;                                                    %消息类型字段
        mes_frame(6)=9;                                                    %帧长（低字节）
        mes_frame(7)=0;                                                    %帧长（高字节）
        mes_frame(8)=1;                                                    %开始算法处理指令配置成功
        mes_frame(9)=crc(mes_frame(1:8));                                  %校验位
        mes_frame(10)=239;
        mes_frame(11)=239;
        mes_frame(12)=239;
        mes_frame(13)=239;
        % 发送数据
        fwrite(t4,mes_frame,'uint8');     
    otherwise 
end
