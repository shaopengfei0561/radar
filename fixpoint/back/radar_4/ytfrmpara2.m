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
    % 获取云台状态
    case 89
        YThdeg2=data(5)*256+data(6);                                        %水平角度位置
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
        if scanstat2==1 && temp<50                                          %到达扫描起点
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
            fname='设备2已到达扫描起点，开始数据采集';
            set(handles1.statetext2,'String',fname);
            disp('设备2已到达扫描起点，开始数据采集');
            scanstat2=2;
        end
        YTEndPos = str2num(paravalue.yt.ytendpos)*YTResolution;  
        if flag_SFMODE==1
           str3=get(handles1.scanend,'string');
           YTEndPos=str2num(str3)*YTResolution;
        end
           
        if scanstat2==2&&abs(YTEndPos-YThdeg2)<50                           %到达扫描终点
            proflag2 = 2;
            endangle2 = YThdeg2;
            fname = '设备2已到达扫描终点，停止数据采集,发送云台停止指令';
            set(handles1.statetext2,'String',fname);
            disp('设备2已到达扫描终点，停止数据采集，发送云台停止指令');
            data = [255,1,0,0,0,0,1];
            fwrite(yt2,data,'uint8');
            scanstat2 = 0;
            lidar2cnt = 0;
        end
    % 获取并存储仓位位置
    case 91
        YTvdeg2 = data(5)*256+data(6);                                        %垂直角度位置
        if YTvdeg2>= (600*YTResolution)
             YTvdeg2 = dec2hex(YTvdeg2);
             YTvdeg2 = hex2decWithSign(YTvdeg2, 4);
        end
        fname=strcat(num2str(YTvdeg2/YTResolution));
        set(handles1.text42,'String',fname);
    otherwise       
end
end