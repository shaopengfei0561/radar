function railconfig(data)
global t3;
mes_frame(1:4)=uint8(hex2dec('df'));                                       %֡ͷ
mes_frame(5)=3;                                                            %��Ϣ�����ֶ�
mes_frame(6)=20;                                                           %֡�������ֽڣ�
mes_frame(7)=0;                                                            %֡�������ֽڣ�

mes_frame(8)=mod(data(1),2^8);                                             %1�ŵ�������λ��
mes_frame(9)=floor(mod(data(1),2^16)/2^8);
mes_frame(10)=floor(mod(data(1),2^24)/2^16);
mes_frame(11)=floor(data(1)/2^24);
mes_frame(12)=data(2);                                                     %1�ŵ���ʵʱ�˶��ٶȣ�cm/s��
mes_frame(13)=data(3);                                                     %1�ŵ�������Ԥ��λ

mes_frame(14)=mod(data(4),2^8);                                            %2�ŵ�������λ��
mes_frame(15)=floor(mod(data(4),2^16)/2^8);
mes_frame(16)=floor(mod(data(4),2^24)/2^16);
mes_frame(17)=floor(data(4)/2^24);
mes_frame(18)=data(5);                                                     %2�ŵ���ʵʱ�˶��ٶȣ�cm/s��
mes_frame(19)=data(6);                                                     %2�ŵ�������Ԥ��λ

mes_frame(20)=crc(mes_frame(1:19));                                        %У��λ
% ��������
fwrite(t3,mes_frame,'uint8');