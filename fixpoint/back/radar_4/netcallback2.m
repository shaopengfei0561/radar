function netcallback2(obj,~)
% 根据SICK LD-LRS3601重写
global bufferlen;
global bgfrmnum2;
global bg_lidar2;
global bg2_lidar2;
global lidarstr2;
global angleData2;
global proflag2;
global lidar2frm;
global oridatadisplayflag;

curstr = fread(obj,bufferlen,'uint8');
% [str, count, msg] = fgets(obj);
lidarstr2 = [lidarstr2; curstr];

if(sum(lidarstr2(1:4))==8) % 2*4
%   disp('OK!');
  if(lidarstr2(10)==hex2dec('45'))
%     disp('sEA!');
    curLen = lidarstr2(5)*2^24+lidarstr2(6)*2^16+lidarstr2(7)*2^8+lidarstr2(8);
    lidarstr2 = lidarstr2(8+curLen+1+1:end,:);
    return;
  end
else
  disp('ERROR2!');
  return;
end

%%%%%%%%%%%按LD LRS3601上传数据帧格式解析%%%%%%%%%%%%%%%
% 提取一帧
curLen = lidarstr2(5)*2^24+lidarstr2(6)*2^16+lidarstr2(7)*2^8+lidarstr2(8);
curData = lidarstr2(1:8+curLen+1,:);
lidarstr2 = lidarstr2(8+curLen+1+1:end,:);
% Cola B协议解析
measuredData = parseDataColaB2( curData );
angleData2 = measuredData(:,1);
reverse_datafusion = measuredData(:,2);
reverse_datafusion2 = measuredData(:,3);

if oridatadisplayflag==1
   lidar2frm = reverse_datafusion;
end

if proflag2==1
% 开始采集数据
  bgfrmnum2=bgfrmnum2+1;
  bg_lidar2(:,bgfrmnum2) = reverse_datafusion;
  bg2_lidar2(:,bgfrmnum2) = reverse_datafusion2;
end
  
        