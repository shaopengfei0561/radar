function LYCnetcallback1(obj,~)
% ����SICK LD-LRS3601��д
global bufferlen;
global bgfrmnum1;
global bg_lidar1;
global bg2_lidar1;
global bg_lidar2;
global bg2_lidar2;
global lidarstr1;
global angleData1;
global proflag1;
global proflag2;
global toprenum;
global handles1;
global lidar1;
global lidar2;
global flag_SFMODE;
global ldstat;
global oridatadisplayflag;
global firstflag1;
global bufferdata1;
global bufferdata2;
global lidarQuantity;

if firstflag1 == -1
bufferdata1 = fread(obj,bufferlen,'uint8');
firstflag1 = firstflag1 + 1;
elseif firstflag1 == 0
bufferdata2 = fread(obj,bufferlen,'uint8');
laser_frame = [bufferdata1;bufferdata2];

%%%%%%%%%%%��ROD�ϴ�����֡��ʽ����%%%%%%%%%%%%%%%
tempflag = find(laser_frame == 0);
if length(tempflag) >= 5
    m = 1;
    for i = 1:length(tempflag)-2
        if tempflag(i+1) - tempflag(i) == 1 && tempflag(i+2)-tempflag(i+1) > 1 && laser_frame(tempflag(i)+2) ~= 255
            start_flag = tempflag(i);
            m = i;
            break;
        end
    end
    for i = m:length(tempflag)-2
        if tempflag(i+1) - tempflag(i) == 1 && tempflag(i+2)-tempflag(i+1) == 1
            stop_flag = tempflag(i);
            break;
        end
    end
    frame_data = laser_frame(start_flag+19:stop_flag-2);

    j = 1;
    k = 1;
    for i = 1:length(frame_data)
        if j == 1
            partH = frame_data(i);
            j = 0;
        elseif j == 0
            partL = bitand(uint8(frame_data(i)),uint8(254));
            deal_data(k) = double(partH)*(2^8) + double(partL);
            if deal_data(k) == 0
                j = 2;
            else
                j = 1;
            end
            k = k+1;
        elseif j == 2
            j = 1;
        end
    end

    for i = 1:length(deal_data)                                        
        reverse_data(i) = deal_data(length(deal_data) - i + 1);                            
    end       
    reverse_datafusion=reverse_data;
    pointNum=529;
end
    bufferdata1 = bufferdata2; 
end
% ��ʾԭʼ����
if oridatadisplayflag==1
    oridataDisplay(reverse_datafusion,pointNum);
end
% ��ʼ�ɼ�����
if proflag1==1
  bgfrmnum1=bgfrmnum1+1;
  bg_lidar1(:,bgfrmnum1) = reverse_datafusion;
  bg2_lidar1(:,bgfrmnum1) = reverse_datafusion;
end
%% ��ʼ���ݴ���
tempflag = 1;
if lidarQuantity == 2
    tempflag = proflag1+ proflag2 - 4;
else
    tempflag = proflag1 - 2;
end

if tempflag == 0 
  fclose(lidar1);
  if lidarQuantity == 2
	fclose(lidar2);
  end
  ldstat=0;
  disp('��ʼ���ݴ���......');
  fname='��ʼ���ݴ���';
  set(handles1.statetext,'String',fname);
  for sj=1:toprenum
  disp('����Ԥ����......');
  fname='����Ԥ����';
  set(handles1.statetext,'String',fname);
  if lidarQuantity == 2
    temp=min(bgfrmnum1,bgfrmnum2);
	predeal([bg_lidar1(:,1:temp);bg_lidar2(:,1:temp)],sj,pointNum,[bg2_lidar1(:,1:temp);bg2_lidar2(:,1:temp)]);
  else
    predeal(bg_lidar1,sj,pointNum,bg2_lidar1);
  end
  end         
  %�����ؽ�
  disp('�����ؽ�......');
  fname='�����ؽ�';
  set(handles1.statetext,'String',fname);
  dianyunalg(sj);                                                     % �������ݴ�����                                                           
  % �ָ�����
  proflag1=0;
  bg_lidar1=[];
  bg_lidar2=[];
  proflag2=0;
  flag_SFMODE=0;
end        

  
        