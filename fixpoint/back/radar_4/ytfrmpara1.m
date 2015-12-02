function ytfrmpara1(data)
global YThdeg1;
global YTvdeg1;
global handles1;
global scanstat1;
global proflag1;
global yt1;
global lidar1cnt;
global paravalue;
global startangle1;
global endangle1;
global flag_SFMODE;

YTResolution = str2num(paravalue.yt.ytresolution);
switch data(4)
    % ��ȡ��̨״̬
    case 89
        YThdeg1=data(5)*256+data(6);                                        %ˮƽ�Ƕ�λ��
        fname=strcat(num2str(YThdeg1/YTResolution));
        set(handles1.text9,'String',fname);
        YTStartPos = str2num(paravalue.yt.ytstartpos)*YTResolution;
        if flag_SFMODE==1
           YTStartPos=0; 
        end
        if YThdeg1<=(360*YTResolution) && YThdeg1>=(350*YTResolution)
            temp = YTStartPos+(360*YTResolution)-YThdeg1;
        else
            temp = abs(YTStartPos-YThdeg1);
        end
        if scanstat1==1 && temp<50                                          %ɨ��״̬��ˮƽ��Ϊ0ʱ����ɨ�� 
            startangle1=YThdeg1;
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
            
            storedata=0;
            if flag_SFMODE~=1
                send_meadata(storedata,2);
                fname='����ƽ̨���Ϳ�ʼɨ���λ��Ϣ';
                set(handles1.statetext,'String',fname);
                set(handles1.statetext2,'String',fname);
                disp('����ƽ̨���Ϳ�ʼɨ���λ��Ϣ');
            end
            fwrite(yt1,data,'uint8'); 
            proflag1=1;
            fname='�豸1�ѵ���ɨ����㣬��ʼ���ݲɼ�';
            set(handles1.statetext,'String',fname);
            disp('�豸1�ѵ���ɨ����㣬��ʼ���ݲɼ�');
            scanstat1=2;
        end
        YTEndPos = str2num(paravalue.yt.ytendpos)*YTResolution;
        if flag_SFMODE==1
           str3=get(handles1.scanend,'string');
           YTEndPos=str2num(str3)*YTResolution;
        end
        if scanstat1==2&&abs(YTEndPos-YThdeg1)<50                                         %����ɨ���յ�
            proflag1=2;
            endangle1=YThdeg1;
            fname='�豸1�ѵ���ɨ���յ㣬ֹͣ���ݲɼ�,������ָֹ̨ͣ��';
            set(handles1.statetext,'String',fname);
            disp('�豸1�ѵ���ɨ���յ㣬ֹͣ���ݲɼ���������ָֹ̨ͣ��');
            data=[255,1,0,0,0,0,1];
            fwrite(yt1,data,'uint8');
            scanstat1=0;
            lidar1cnt=0;
        end
    % ��ȡ���洢��λλ��
    case 91
        YTvdeg1=data(5)*256+data(6);                                        %��ֱ�Ƕ�λ��
        if YTvdeg1>=(600*YTResolution)
             YTvdeg1=dec2hex(YTvdeg1);
             YTvdeg1=hex2decWithSign(YTvdeg1, 4);
        end
        fname=strcat(num2str(YTvdeg1/YTResolution));
        set(handles1.text10,'String',fname);
    otherwise       
end
end