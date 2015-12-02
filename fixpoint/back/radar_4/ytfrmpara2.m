function ytfrmpara2(data)
global YThdeg2;
global YTvdeg2;
global hObject1 handles1;
global scanstat2;
global proflag2;
global yt2;
global lidar2cnt;
global startangle2;
global endangle2;
global paravalue;
global flag_SFMODE;
YTResolution = str2num(paravalue.yt.ytresolution);
switch data(4)
    % ��ȡ��̨״̬
    case 89
        YThdeg2=data(5)*256+data(6);                                        %ˮƽ�Ƕ�λ��
        fname=strcat(num2str(YThdeg2/YTResolution));
        set(handles1.text41,'String',fname);
        YTStartPos = str2num(paravalue.yt.ytstartpos)*YTResolution;
        if flag_SFMODE==1
           YTStartPos=0; 
        end
        
        if YThdeg2<=(360*YTResolution) && YThdeg2>=(350*YTResolution)
            temp = YTStartPos+(360*YTResolution)-YThdeg2;
        else
            temp = abs(YTStartPos-YThdeg2);
        end
        if scanstat2==1 && temp<50                                          %����ɨ�����
            startangle2=YThdeg2;
            if flag_SFMODE==1
                str3 = get(handles1.degspd,'string');
                degspd=str2num(str3);
            else
                degspd = str2num(paravalue.yt.ytspeed);
            end    
            if(degspd>63)
                degspd=63;
            end
            data(1)=255;
            data(2)=1;
            data(3)=0;
            data(4)=2;
            data(5)=degspd;
            data(6)=0;
            crcb=sum(data(2:6));
            if(crcb>255)
               crcb=mod(crcb,256);
            end
            data(7)=crcb;
            
            fwrite(yt2,data,'uint8'); 
            proflag2=1;
            fname='�豸2�ѵ���ɨ����㣬��ʼ���ݲɼ�';
            set(handles1.statetext2,'String',fname);
            disp('�豸2�ѵ���ɨ����㣬��ʼ���ݲɼ�');
            scanstat2=2;
        end
        YTEndPos = str2num(paravalue.yt.ytendpos)*YTResolution;  
        if flag_SFMODE==1
           str3=get(handles1.scanend,'string');
           YTEndPos=str2num(str3)*YTResolution;
        end
           
        if scanstat2==2&&abs(YTEndPos-YThdeg2)<50                           %����ɨ���յ�
            proflag2 = 2;
            endangle2 = YThdeg2;
            fname = '�豸2�ѵ���ɨ���յ㣬ֹͣ���ݲɼ�,������ָֹ̨ͣ��';
            set(handles1.statetext2,'String',fname);
            disp('�豸2�ѵ���ɨ���յ㣬ֹͣ���ݲɼ���������ָֹ̨ͣ��');
            data = [255,1,0,0,0,0,1];
            fwrite(yt2,data,'uint8');
            scanstat2 = 0;
            lidar2cnt = 0;
        end
    % ��ȡ���洢��λλ��
    case 91
        YTvdeg2 = data(5)*256+data(6);                                        %��ֱ�Ƕ�λ��
        if YTvdeg2>= (600*YTResolution)
             YTvdeg2 = dec2hex(YTvdeg2);
             YTvdeg2 = hex2decWithSign(YTvdeg2, 4);
        end
        fname=strcat(num2str(YTvdeg2/YTResolution));
        set(handles1.text42,'String',fname);
    otherwise       
end
end