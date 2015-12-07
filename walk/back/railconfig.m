function railconfig(data)
global t3;
mes_frame(1:4)=uint8(hex2dec('df'));                                       %帧头
mes_frame(5)=3;                                                            %消息类型字段
mes_frame(6)=20;                                                           %帧长（低字节）
mes_frame(7)=0;                                                            %帧长（高字节）

mes_frame(8)=mod(data(1),2^8);                                             %1号导轨所处位置
mes_frame(9)=floor(mod(data(1),2^16)/2^8);
mes_frame(10)=floor(mod(data(1),2^24)/2^16);
mes_frame(11)=floor(data(1)/2^24);
mes_frame(12)=data(2);                                                     %1号导轨实时运动速度（cm/s）
mes_frame(13)=data(3);                                                     %1号导轨所处预置位

mes_frame(14)=mod(data(4),2^8);                                            %2号导轨所处位置
mes_frame(15)=floor(mod(data(4),2^16)/2^8);
mes_frame(16)=floor(mod(data(4),2^24)/2^16);
mes_frame(17)=floor(data(4)/2^24);
mes_frame(18)=data(5);                                                     %2号导轨实时运动速度（cm/s）
mes_frame(19)=data(6);                                                     %2号导轨所处预置位

mes_frame(20)=crc(mes_frame(1:19));                                        %校验位
% 发送数据
fwrite(t3,mes_frame,'uint8');