function send_meadata(storedata,mode)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%�������ӣ�����ƽ̨���������Ͳ������
global t5;
disp('������ƽ̨������......');
fopen(t5);                                                                 %������ƽ̨������
disp('��ƽ̨�����������ѳɹ�......');
global toprenum;
mes_frame(1:4)=uint8(hex2dec('df'));                                       %֡ͷ
switch mode
    %���Ͳ�������
    case 1                                                                                                                                                      
        mes_frame(5)=2;                                                    %��Ϣ�����ֶ�
        mes_frame(6)=7*toprenum+9;                                         %֡�������ֽڣ�
        mes_frame(7)=0;                                                    %֡�������ֽڣ�
        mes_frame(8)=toprenum;                                             %ɨ���λ����
        for i=1:toprenum
            mes_frame(9+7*(i-1))=storedata(i).seq;                         %��λ��
            mes_frame(10+7*(i-1))=mod(storedata(i).vol,2^8);               %��λ����������
            mes_frame(11+7*(i-1))=floor(mod(storedata(i).vol,2^16)/2^8);   %��λ����������
            mes_frame(12+7*(i-1))=floor(mod(storedata(i).vol,2^24)/2^16);  %��λ����������
            mes_frame(13+7*(i-1))=floor(storedata(i).vol/2^24);            %��λ����������
            mes_frame(14+7*(i-1))=storedata(i).filenam1;                   %��λɨ��ͼƬ�ļ���
            mes_frame(15+7*(i-1))=storedata(i).filenam2;                   %��λɨ��ͼƬ�ļ���
        end
        mes_frame(7*toprenum+9)=crc(mes_frame(1:(7*toprenum+8)));          %У��λ
    case 2
        mes_frame=storedata;                                               %����ƽ̨�������˷���ɨ���λ��Ϣ
    otherwise 
end
% ��������
disp('����ƽ̨����������֪ͨ��Ϣ......');
fwrite(t5,mes_frame,'uint8');
fclose(t5);%�Ͽ���ƽ̨������
disp('�Ͽ�����ƽ̨������������......');