%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
%     �����״�ʵʱ�����������ձ�HOKUYO URGЭ���������
%         serial_com.m�����������������,����������������ʼ��������ͬʱ�򿪴��ڽ������ݣ�
%         instrcallback.m�Ǵ����жϺ���������ԭʼ����֡��
%         LS_main.m���㷨�����������������ݵĴ洢����������ʾ��
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   
function para_config()
%%      ȫ�ֱ�������
global dataframequeue; % ԭʼ����֡���нṹ��
global algorithmconfiginfo; % ��ֵ���ýṹ��
global dijizhen;
global LeastFrameNumber;  % ������ͼ������Ҫ������֡��
global ExceptionFlag; % �쳣��־λ
global Timer; % ���½�����ͼ����
global framelength; % ����������֡����
global scanrange; % ɨ��Ƕȷ�Χ
global angleresolution; % �Ƕȷֱ���
global QueueLength; % ԭʼ���ݺͱ�������Ĵ洢���г���
global frameTotalNumber; % ����֡�����������ڱ�ʾʱ��
global originallength; % Ӳ���ϴ�ԭʼ���ݵĳ���
global server1laserdata;
global server2laserdata; % �����жϳ��������ݻ���ռ�
global firstflag1;  % ���ڱ�ʶlidar1�Ƿ��ǵ�һ֡����
global firstflag2;  % ���ڱ�ʶlidar2�Ƿ��ǵ�һ֡����
global maxLimit; % �����Ч������
global startangle; % ɨ����ʼ�Ƕ�
global featurebufferlen; % �����������г���
global objNumber; % Ŀ������
global objID; % Ŀ����
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
global frmstate1;
global frmflag;
global frmsqen;
global frmstart;
global fredata;
global frmlength;
global railone;
global railtwo;
global proflag1;
global proflag2;
global startpos;
global endpos;
global railspeed;
global storenam;
global bgfrmnum1;
global bgfrmnum2;
global toprestore;
global toprenum;
global railcofigsuc;        %�������óɹ�Ӧ���־
global starttimes;
global sstep;
global lidar1cnt;
global lidar2cnt;
global ytstat;
global ldstat;
global scanstat1;
global scanstat2;
global runstat;
global frmstate2;
global frmstate;
global lidarcnt;
global bg_lidar1;
global bg_lidar2;
global bg2_lidar1;
global bg2_lidar2;
global flag_SFMODE;
global oridatadisplayflag;
global stopflag;
%%      Ӳ������
startangle = 0;
scanrange = 190.08/360*2*pi; % ɨ��Ƕȷ�Χ
angleresolution = 0.36/360*2*pi; % �Ƕȷֱ���
maxLimit = 20000; % �����Ч������
framelength = scanrange/angleresolution; % ����������֡����
originallength = framelength*3 + 26 + ceil(framelength*3/64)*2 + 1; % Ӳ���ϴ�ԭʼ���ݵĳ���
ge=1;
%%      �㷨����
algorithmconfiginfo.bkgrdOffset = 500;
algorithmconfiginfo.adjacentJump = 1000;
algorithmconfiginfo.objWidthThreshold = 100;
algorithmconfiginfo.bldmapPeriod = 10000;
algorithmconfiginfo.stride = 500;
w=1;
nn=1;
maxno=100;%Ŀ��������
mstep=0;
minpointnum=5;%Ŀ���߶�������Ҫ�ĵ�����
minwidth=1000;%Ŀ��ֶο�ȣ������ڵ�����ڸþ���ʱ��Ϊ���Σ�
minthreshold=500;%��ȡǰ����С�ı���ƫ������
fusiondistance=400;%�ںϾ��� ֡���ںϼ��
spacefusiondistance=500;%֡���ںϾ���
speedlimit=40;

%%      Ӧ�ò���
LeastFrameNumber = 10; % ������ͼ������Ҫ��֡���� 
QueueLength = 30;      % ԭʼ���ݴ洢���еĳ���
framedatanum=529*2;
backgroundflag=0;
shootinteval=30;

pastclock=clock;
tick=0;
bianliang=0;
%%      ������ʼ��
netcall=0;
ExceptionFlag = 1;
Timer = algorithmconfiginfo.bldmapPeriod;
dataframequeue.curFrameNum = 1;
frameTotalNumber = 0;
firstflag1 = -1;
firstflag2 = -1;
featurebufferlen = 0;
objNumber = 0;
objID = 0;
dijizhen=1;
server1laserdata=zeros(1,535);
server2laserdata=zeros(1,535);
bg_lidar1=[];
bg_lidar2=[];
bg2_lidar1=[];
bg2_lidar2=[];
% ͨ�Ų�����ʼ��
%������ʼ��
frmflag=0;
frmsqen=0;
frmstart=0;
frmlength=0;
fredata=[];
railone.speed=0;
railone.position=0;
railtwo.speed=0;
railtwo.position=0;
proflag1=0;
proflag2=0;
startpos=0;
endpos=0;
railspeed=0;
bgfrmnum1=0;
bgfrmnum2=0;
storenam=zeros(1,8);
toprestore=[];
toprenum=0;
frmstate1=0;
frmstate2=0;
railcofigsuc=0;
starttimes=0;
sstep=0;
lidar1cnt=0;
lidar2cnt=0;
ytstat=0;
ldstat=0;
scanstat1=0;
scanstat2=0;
runstat=0;
frmstate=0;
lidarcnt=0;
flag_SFMODE=0;
oridatadisplayflag=0;
stopflag=0;