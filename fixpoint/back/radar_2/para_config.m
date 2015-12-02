%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
%     激光雷达实时仿真程序，针对日本HOKUYO URG协议解析数据
%         serial_com.m是整个程序的主函数,负责变量的申明与初始化操作，同时打开串口接收数据；
%         instrcallback.m是串口中断函数，解析原始数据帧；
%         LS_main.m是算法的主函数，包括数据的存储、处理与显示；
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   
function para_config()
%%      全局变量申明
global dataframequeue; % 原始数据帧队列结构体
global algorithmconfiginfo; % 阈值配置结构体
global dijizhen;
global LeastFrameNumber;  % 建立地图最少需要的数据帧数
global ExceptionFlag; % 异常标志位
global Timer; % 重新建立地图周期
global framelength; % 解析后数据帧长度
global scanrange; % 扫描角度范围
global angleresolution; % 角度分辨率
global QueueLength; % 原始数据和报警结果的存储队列长度
global frameTotalNumber; % 数据帧的数量，用于表示时间
global originallength; % 硬件上传原始数据的长度
global server1laserdata;
global server2laserdata; % 串口中断程序中数据缓存空间
global firstflag; % 串口中断程序中用于标识是否是第一帧数据
global maxLimit; % 最大有效检测距离
global startangle; % 扫描起始角度
global featurebufferlen; % 保存特征队列长度
global objNumber; % 目标数量
global objID; % 目标标号
global netcall;
global ge;
global framedatanum;
global backgroundflag;
global maxno;
global w;
global nn;
global bianliang;
global minpointnum;
global minwidth;
global minthreshold;
global fusiondistance;
global spacefusiondistance;
global speedlimit;
global shootinteval;
global pastclock;
global tick;
global mstep;
global bg;
global frmstate;
global frmflag;
global frmsqen;
global frmstart;
global fredata;
global frmlength;
global railone;
global railtwo;
global proflag;
global startpos;
global endpos;
global railspeed;
global storenam;
global bgfrmnum;
global toprestore;
global toprenum;
global railcofigsuc;        %导轨配置成功应答标志
global starttimes;
global sstep;
global lidar1cnt;
global lidar2cnt;
global runstat;
%%      硬件参数
startangle = 0;
scanrange = 190.08/360*2*pi; % 扫描角度范围
angleresolution = 0.36/360*2*pi; % 角度分辨率
maxLimit = 20000; % 最大有效检测距离
framelength = scanrange/angleresolution; % 解析后数据帧长度
originallength = framelength*3 + 26 + ceil(framelength*3/64)*2 + 1; % 硬件上传原始数据的长度
ge=1;
%%      算法参数
algorithmconfiginfo.bkgrdOffset = 500;
algorithmconfiginfo.adjacentJump = 1000;
algorithmconfiginfo.objWidthThreshold = 100;
algorithmconfiginfo.bldmapPeriod = 10000;
algorithmconfiginfo.stride = 500;
w=1;
nn=1;
maxno=100;%目标数限制
mstep=0;
minpointnum=5;%目标线段最少需要的点数；
minwidth=1000;%目标分段宽度，当相邻点间距大于该距离时分为两段；
minthreshold=500;%提取前景最小的背景偏移量；
fusiondistance=400;%融合距离 帧内融合间距
spacefusiondistance=500;%帧间融合距离
speedlimit=40;

%%      应用参数
LeastFrameNumber = 10; % 建立地图最少需要的帧数量 
QueueLength = 30;      % 原始数据存储队列的长度
framedatanum=529*2;
backgroundflag=0;
shootinteval=30;

pastclock=clock;
tick=0;
bianliang=0;
%%      变量初始化
netcall=0;
ExceptionFlag = 1;
Timer = algorithmconfiginfo.bldmapPeriod;
dataframequeue.curFrameNum = 1;
frameTotalNumber = 0;
firstflag = -1;
featurebufferlen = 0;
objNumber = 0;
objID = 0;
dijizhen=1;
server1laserdata=zeros(1,535);
server2laserdata=zeros(1,535);
bg=[];
% 通信参数初始化
%参数初始化
frmflag=0;
frmsqen=0;
frmstart=0;
frmlength=0;
fredata=[];
railone.speed=0;
railone.position=0;
railtwo.speed=0;
railtwo.position=0;
proflag=0;
startpos=0;
endpos=0;
railspeed=0;
storenam=zeros(1,8);
bgfrmnum=0;
toprestore=[];
toprenum=0;
frmstate=0;
railcofigsuc=0;
starttimes=0;
sstep=0;
lidar1cnt=0;
lidar2cnt=0;
runstat=0;