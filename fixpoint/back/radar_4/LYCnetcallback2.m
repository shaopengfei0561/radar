function LYCnetcallback2(obj,~)
% 根据SICK LD-LRS3601重写
global bufferlen;
global bgfrmnum2;
global bg_lidar2;
global bg2_lidar2;
global proflag2;
global lidar2frm;
global bufferdata3;
global bufferdata4;
global firstflag2;
global oridatadisplayflag;

if firstflag2 == -1
bufferdata3 = fread(obj,bufferlen,'uint8');
firstflag2 = firstflag2 + 1;
elseif firstflag2 == 0
bufferdata3 = fread(obj,bufferlen,'uint8');
laser_frame = [bufferdata3;bufferdata4];

%%%%%%%%%%%按ROD上传数据帧格式解析%%%%%%%%%%%%%%%
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
end
    bufferdata3 = bufferdata4; 
end

if oridatadisplayflag==1
   lidar2frm = reverse_datafusion;
end

if proflag2==1
% 开始采集数据
  bgfrmnum2=bgfrmnum2+1;
  bg_lidar2(:,bgfrmnum2) = reverse_datafusion;
  bg2_lidar2(:,bgfrmnum2) = reverse_datafusion;
end
  
        