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
global firstflag; % �����жϳ��������ڱ�ʶ�Ƿ��ǵ�һ֡����
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
global railcofigsuc;        %�������óɹ�Ӧ���־
global starttimes;
global sstep;
global lidar1cnt;
global lidar2cnt;
global runstat;
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
firstflag = -1;
featurebufferlen = 0;
objNumber = 0;
objID = 0;
dijizhen=1;
server1laserdata=zeros(1,535);
server2laserdata=zeros(1,535);
bg=[];
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