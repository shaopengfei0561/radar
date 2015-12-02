function send_meadata(storedata,mode)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%�������ӣ�����ƽ̨���������Ͳ������
global ys;
global hObject1 handles1;
global toprenum;
global storeconfig;
global deviceID;
global runstat;
mes_frame(1:4)=uint8(hex2dec('df'));                                       %֡ͷ
switch mode
    %���Ͳ�������
    case 1                                                                                                                                                      
        mes_frame(5)=2;                                                    %��Ϣ�����ֶ�
        mes_frame(6)=23*toprenum+11;                                        %֡�������ֽڣ�
        mes_frame(7)=0;                                                    %֡�������ֽڣ�
        mes_frame(8)=toprenum;                                             %ɨ���λ����
        for i=1:toprenum
            mes_frame(9+23*(i-1))=mod(storedata(i).storeid,2^8);            %���
            mes_frame(10+23*(i-1))=floor(storedata(i).storeid/2^8);         %���
            mes_frame(11+23*(i-1))=storedata(i).seq;                        %��λ��
            mes_frame(12+23*(i-1))=mod(storedata(i).vol,2^8);               %��λ����������
            mes_frame(13+23*(i-1))=floor(mod(storedata(i).vol,2^16)/2^8);   %��λ����������
            mes_frame(14+23*(i-1))=floor(mod(storedata(i).vol,2^24)/2^16);  %��λ����������
            mes_frame(15+23*(i-1))=floor(storedata(i).vol/2^24);            %��λ����������
            
            year = str2num(storedata(i).filenam1(1:4));
            mes_frame(16+23*(i-1))=mod(year,2^8);                     %��λɨ��ͼƬ�ļ���
            mes_frame(17+23*(i-1))=floor(year/2^8);                   %��λɨ��ͼƬ�ļ���
            mes_frame(18+23*(i-1))=str2num(storedata(i).filenam1(5:6));                              %��λɨ��ͼƬ�ļ���
            mes_frame(19+23*(i-1))=str2num(storedata(i).filenam1(7:8));                              %��λɨ��ͼƬ�ļ���
            mes_frame(20+23*(i-1))=str2num(storedata(i).filenam1(9:10));                              %��λɨ��ͼƬ�ļ���
            mes_frame(21+23*(i-1))=str2num(storedata(i).filenam1(11:12));                              %��λɨ��ͼƬ�ļ���
            mes_frame(22+23*(i-1))=str2num(storedata(i).filenam1(13:14));                              %��λɨ��ͼƬ�ļ���
            mes_frame(23+23*(i-1))=str2num(storedata(i).filenam1(15:16));                   %��λɨ��ͼƬ�ļ���
            
            mes_frame(24+23*(i-1))=mod(year,2^8);                     %��λɨ��ͼƬ�ļ���
            mes_frame(25+23*(i-1))=floor(year/2^8);                   %��λɨ��ͼƬ�ļ���
            mes_frame(26+23*(i-1))=str2num(storedata(i).filenam2(5:6));                              %��λɨ��ͼƬ�ļ���
            mes_frame(27+23*(i-1))=str2num(storedata(i).filenam2(7:8));                              %��λɨ��ͼƬ�ļ���
            mes_frame(28+23*(i-1))=str2num(storedata(i).filenam2(9:10));                              %��λɨ��ͼƬ�ļ���
            mes_frame(29+23*(i-1))=str2num(storedata(i).filenam2(11:12));                              %��λɨ��ͼƬ�ļ���
            mes_frame(30+23*(i-1))=str2num(storedata(i).filenam2(13:14));                              %��λɨ��ͼƬ�ļ���
            mes_frame(31+23*(i-1))=str2num(storedata(i).filenam2(15:16));                   %��λɨ��ͼƬ�ļ���  
        end
        mes_frame(23*toprenum+9)=mod(deviceID,2^8);                         %�豸ID�����ֽڣ�
        mes_frame(23*toprenum+10)=floor(deviceID/2^8);                      %�豸ID�����ֽڣ�
        mes_frame(23*toprenum+11)=crc(mes_frame(1:(23*toprenum+10)));       %У��λ
        
    case 2                                                                  %����ƽ̨�������˷���ɨ���λ��Ϣ
        mes_frame(5)=3;                                                     %��Ϣ�����ֶ�                                                     
        mes_frame(6)=13;                                                    %��֡�������ֽڣ�
        mes_frame(7)=0;                                                     %��֡�������ֽڣ�
        mes_frame(8)=mod(storeconfig(1,1),2^8);                             %��ţ����ֽڣ�
        mes_frame(9)=floor(storeconfig(1,1)/2^8);                           %��ţ����ֽڣ�
        mes_frame(10)=storeconfig(1,2);                                     %��λ��
        mes_frame(11)=mod(deviceID,2^8);                                    %�豸ID�����ֽڣ�
        mes_frame(12)=floor(deviceID/2^8);                                  %�豸ID�����ֽڣ�
        mes_frame(13)=crc(mes_frame(1:12));                                 %У��λ
        
    case 3                                                                  %����������
        mes_frame(5)=4;                                                     %��Ϣ�����ֶ�                                                     
        mes_frame(6)=11;                                                    %��֡�������ֽڣ�
        mes_frame(7)=0;                                                     %��֡�������ֽڣ�
        mes_frame(8)=runstat;                                               %æ�б�־λ��0���У�1��æ��
        mes_frame(9)=mod(deviceID,2^8);                                     %�豸ID�����ֽڣ�
        mes_frame(10)=floor(deviceID/2^8);                                  %�豸ID�����ֽڣ�
        mes_frame(11)=crc(mes_frame(1:10));                                 %У��λ  
    otherwise 
end
% ��������
fwrite(ys,mes_frame,'uint8');