function netcallback1(obj,~)
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
global lidarcnt;
global angleData2;
global flag_SFMODE;
global ldstat;
global oridatadisplayflag;
global lidarQuantity;
global bgfrmnum2;
global startangle2;
global endangle2;
global startangle1;
global endangle1;

% lidarcnt = lidarcnt+1
curstr = fread(obj,bufferlen,'uint8');
% [str, count, msg] = fgets(obj);
lidarstr1 = [lidarstr1; curstr];

if (sum(lidarstr1(1:4))==8) % 2*4
%   disp('OK!');
  if(lidarstr1(10)==hex2dec('45'))
%   disp('sEA!');
    curLen = lidarstr1(5)*2^24+lidarstr1(6)*2^16+lidarstr1(7)*2^8+lidarstr1(8);
    lidarstr1 = lidarstr1(8+curLen+1+1:end,:);
    return;
  end
else
  disp('ERROR1!');
  return;
end

%%%%%%%%%%%��LD LRS3601�ϴ�����֡��ʽ����%%%%%%%%%%%%%%%
% ��ȡһ֡
curLen = lidarstr1(5)*2^24+lidarstr1(6)*2^16+lidarstr1(7)*2^8+lidarstr1(8);
curData = lidarstr1(1:8+curLen+1,:);
lidarstr1 = lidarstr1(8+curLen+1+1:end,:);
% Cola BЭ�����
[measuredData ,pointNum]= parseDataColaB2( curData );
angleData1 = measuredData(:,1);
reverse_datafusion  = measuredData(:,2);
reverse_datafusion2 = measuredData(:,3);
if oridatadisplayflag==1
    oridataDisplay(reverse_datafusion,pointNum);
end
% ��ʼ�ɼ�����
if proflag1==1
  bgfrmnum1=bgfrmnum1+1;
  bg_lidar1(:,bgfrmnum1) = reverse_datafusion;
  bg2_lidar1(:,bgfrmnum1) = reverse_datafusion2;
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
  set(handles1.statetext2,'String',fname);
  for sj=1:toprenum
  disp('����Ԥ����......');
  fname='����Ԥ����';
  set(handles1.statetext,'String',fname);
  set(handles1.statetext2,'String',fname);
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
  set(handles1.statetext2,'String',fname);
  dianyunalg(sj);                                                     % �������ݴ�����                                                           
  % �ָ�����
  proflag1=0;
  bg_lidar1=[];
  bg_lidar2=[];
  angleData1=[];
  angleData2=[];
  bgfrmnum1 = 0;
  bgfrmnum2 = 0;
  startangle1 = 0;
  startangle2 = 0;
  endangle1 = 0;
  endangle2 = 0;
  proflag2=0;
  flag_SFMODE=0;
end        

  
        