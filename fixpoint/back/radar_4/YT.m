function varargout = YT(varargin)
% YT MATLAB code for YT.fig
%      YT, by itself, creates a new YT or raises the existing
%      singleton*.
%
%      H = YT returns the handle to a new YT or the handle to
%      the existing singleton*.
%
%      YT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in YT.M with the given input arguments.
%
%      YT('Property','Value',...) creates a new YT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before YT_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to YT_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help YT

% Last Modified by GUIDE v2.5 08-Oct-2015 14:06:31

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @YT_OpeningFcn, ...
                   'gui_OutputFcn',  @YT_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before YT is made visible.
function YT_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to YT (see VARARGIN)

% Choose default command line output for YT
global hObject1 handles1;
global showEnable showType;
global startflag;
global paravalue;
global deviceID;
global deviceType;
global lidarQuantity;

h = handles.figure1; %返回其句柄
newIcon = javax.swing.ImageIcon('wsn.jpg');
figFrame = get(h,'JavaFrame'); %取得Figure的JavaFrame。
figFrame.setFigureIcon(newIcon); %修改图标

showEnable = 0;
showType = 0;
handles.output = hObject;
hObject1=hObject;
handles1=handles;
% Update handles structure
guidata(hObject, handles);
ttt = keyGet('key.yu');
flag = iniDecrypt('Config.yu',ttt);
paravalue= ini2struct('Config.ini');
delete('Config.ini');
deviceID = str2num(paravalue.systeminfor.deviceid);
deviceType = str2num(paravalue.systeminfor.devicetype);
lidarQuantity = str2num(paravalue.systeminfor.lidarquantity);

para_config();
startflag=0;
clc;
diary('c:\web\resources\testlog3.txt');
diary on;
datestr(now,31);
% UIWAIT makes YT wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = YT_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

function hdegval_Callback(hObject, eventdata, handles)
% hObject    handle to hdegval (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of hdegval as text
%        str2double(get(hObject,'String')) returns contents of hdegval as a double


% --- Executes during object creation, after setting all properties.
function hdegval_CreateFcn(hObject, eventdata, handles)
% hObject    handle to hdegval (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function vdegval_Callback(hObject, eventdata, handles)
% hObject    handle to vdegval (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of vdegval as text
%        str2double(get(hObject,'String')) returns contents of vdegval as a double


% --- Executes during object creation, after setting all properties.
function vdegval_CreateFcn(hObject, eventdata, handles)
% hObject    handle to vdegval (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function degspd_Callback(hObject, eventdata, handles)
% hObject    handle to degspd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of degspd as text
%        str2double(get(hObject,'String')) returns contents of degspd as a double


% --- Executes during object creation, after setting all properties.
function degspd_CreateFcn(hObject, eventdata, handles)
% hObject    handle to degspd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ipval1_Callback(hObject, eventdata, handles)
% hObject    handle to ipval1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ipval1 as text
%        str2double(get(hObject,'String')) returns contents of ipval1 as a double


% --- Executes during object creation, after setting all properties.
function ipval1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ipval1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ipval2_Callback(hObject, eventdata, handles)
% hObject    handle to ipval2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ipval2 as text
%        str2double(get(hObject,'String')) returns contents of ipval2 as a double


% --- Executes during object creation, after setting all properties.
function ipval2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ipval2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object deletion, before destroying properties.
function figure1_DeleteFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global yt1;
global yt2;
global ytstat;
global ldstat;
global lidar1;
global lidar2;
global runstat;
global lidarQuantity;

if ytstat==1
data=[255,1,0,0,0,0,1];
fwrite(yt1,data,'uint8');
if lidarQuantity == 2
    fwrite(yt2,data,'uint8');
end
fclose(yt1);
delete(yt1);
clear yt1;
if lidarQuantity == 2
    fclose(yt2);
    delete(yt2);
    clear yt2;
end
disp('云台关闭并已释放');
ytstat=0;
end

if ldstat==1
fclose(lidar1);
disp('关闭雷达1......');
delete(lidar1);
clear lidar1;

if lidarQuantity == 2
    fclose(lidar2);
    disp('关闭雷达2......');
    delete(lidar2);
    clear lidar2;
end

ldstat=0;
runstat=0;
end


function scanend_Callback(hObject, eventdata, handles)
% hObject    handle to scanend (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of scanend as text
%        str2double(get(hObject,'String')) returns contents of scanend as a double


% --- Executes during object creation, after setting all properties.
function scanend_CreateFcn(hObject, eventdata, handles)
% hObject    handle to scanend (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit13_Callback(hObject, eventdata, handles)
% hObject    handle to edit13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit13 as text
%        str2double(get(hObject,'String')) returns contents of edit13 as a double


% --- Executes during object creation, after setting all properties.
function edit13_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit14_Callback(hObject, eventdata, handles)
% hObject    handle to edit14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit14 as text
%        str2double(get(hObject,'String')) returns contents of edit14 as a double


% --- Executes during object creation, after setting all properties.
function edit14_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit15_Callback(hObject, eventdata, handles)
% hObject    handle to edit15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit15 as text
%        str2double(get(hObject,'String')) returns contents of edit15 as a double


% --- Executes during object creation, after setting all properties.
function edit15_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit16_Callback(hObject, eventdata, handles)
% hObject    handle to edit16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit16 as text
%        str2double(get(hObject,'String')) returns contents of edit16 as a double


% --- Executes during object creation, after setting all properties.
function edit16_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit17_Callback(hObject, eventdata, handles)
% hObject    handle to edit17 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit17 as text
%        str2double(get(hObject,'String')) returns contents of edit17 as a double


% --- Executes during object creation, after setting all properties.
function edit17_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit17 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton22.
function pushbutton22_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton22 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global yt1;
global yt2;
global lidar1;
global lidar2;
global ys;
global ListenTimer;
global startflag;
global stopflag;
global paravalue;
global yt_interface;
global ytstat;
global ldstat;
global bufferlen;
global lidarstr1;
global lidarstr2;
global handles1;
global deviceID;
global deviceType;
global lidarQuantity;

ttt = keyGet('key.yu');
flag = iniDecrypt('Config.yu',ttt);
paravalue= ini2struct('Config.ini');
delete('Config.ini');
deviceID = str2num(paravalue.systeminfor.deviceid);
deviceType = str2num(paravalue.systeminfor.devicetype);
lidarQuantity = str2num(paravalue.systeminfor.lidarquantity);

handles1=handles;

temp=isempty(startflag);
if startflag==0||temp==1
startflag=1;
stopflag=1;
if yt_interface==2
% 连接智能变速云台1
com =  paravalue.yt.comport1;   
yt1 = serial(com);
yt1.baudrate = 2400;
yt1.parity = 'none';
yt1.stopbits = 1;
yt1.OutputBufferSize = 100; 
set(yt1 ,'Timeout',10);                                                     
set(yt1,'InputBufferSize',100);
tcom.BytesAvailableFcnMode = 'byte';
tcom.BytesAvailableFcnCount = 1;
tcom.BytesAvailableFcn = @com1serverback;
fname='连接云台1';
set(handles.statetext,'String',fname);
disp('连接云台1');
fopen(yt1);
fname='云台1连接已成功';
set(handles.statetext,'String',fname);
disp('云台1连接已成功');
% 连接智能变速云台2
com =  paravalue.yt.comport2;   
yt2 = serial(com);
yt2.baudrate = 2400;
yt2.parity = 'none';
yt2.stopbits = 1;
yt2.OutputBufferSize = 100; 
set(yt2 ,'Timeout',10);                                                     
set(yt2,'InputBufferSize',100);
yt2.BytesAvailableFcnMode = 'byte';
yt2.BytesAvailableFcnCount = 1;
yt2.BytesAvailableFcn = @com2serverback;
fname='连接云台2';
set(handles.statetext2,'String',fname);
disp('连接云台2');
if lidarQuantity == 2
    fopen(yt2);   
end
fname='云台2连接已成功';
set(handles.statetext2,'String',fname);
disp('云台2连接已成功');
ytstat = 1;
else 
% 连接智能变速云台1
str1 = num2str(paravalue.yt.ytip1);
str2 = str2num(paravalue.yt.ytport1);
yt1 = tcpip(str1,str2);       
set(yt1,'InputBufferSize',100);
yt1.BytesAvailableFcnMode = 'byte';
yt1.BytesAvailableFcnCount = 1;
yt1.BytesAvailableFcn = @com1serverback;
fname='连接云台1';
set(handles.statetext,'String',fname);
disp('连接云台1');
fopen(yt1);
fname='云台1连接已成功';
set(handles.statetext,'String',fname);
disp('云台1连接已成功');

% 连接智能变速云台2
str1 = num2str(paravalue.yt.ytip2);
str2 = str2num(paravalue.yt.ytport2);
yt2 = tcpip(str1,str2);       
set(yt2,'InputBufferSize',100);
yt2.BytesAvailableFcnMode = 'byte';
yt2.BytesAvailableFcnCount = 1;
yt2.BytesAvailableFcn = @com2serverback;
fname='连接云台2';
set(handles.statetext2,'String',fname);
disp('连接云台2');
if lidarQuantity == 2
	fopen(yt2);
end
fname='云台2连接已成功';
set(handles.statetext2,'String',fname);
disp('云台2连接已成功');
ytstat = 1;
end

% 连接激光雷达1
str1 = num2str(paravalue.lidarip.lidarip1);
str2 = str2num(paravalue.lidarip.lidarport1);
lidar1 = tcpip(str1,str2);  
bufferlen=9723;
set(lidar1,'InputBufferSize',bufferlen*10);
lidar1.BytesAvailableFcnMode = 'byte';
lidar1.BytesAvailableFcnCount = bufferlen;
if deviceType == 2
    lidar1.BytesAvailableFcn = @LYCnetcallback1;
else
    lidar1.BytesAvailableFcn = @netcallback1;
end
fname='连接激光雷达1';
set(handles.statetext,'String',fname);
disp('连接激光雷达1');
fopen(lidar1);
fname='激光雷达1连接已成功';
set(handles.statetext,'String',fname);
disp('激光雷达1连接已成功');
% send start measurement task cmd
command_startDAQ_ColaB = [hex2dec('02') hex2dec('02') hex2dec('02') hex2dec('02') hex2dec('00') hex2dec('00') hex2dec('00') hex2dec('11') ...
  hex2dec('73') hex2dec('45') hex2dec('4E') hex2dec('20') hex2dec('4C') hex2dec('4D') hex2dec('44') hex2dec('73') hex2dec('63') ...
  hex2dec('61') hex2dec('6E') hex2dec('64') hex2dec('61') hex2dec('74') hex2dec('61') hex2dec('20') hex2dec('01') hex2dec('33') ...
  ]; % 开始连续采集命令
fwrite(lidar1,command_startDAQ_ColaB,'uint8');
lidarstr1=[];

% 连接激光雷达2
str1 = num2str(paravalue.lidarip.lidarip2);
str2 = str2num(paravalue.lidarip.lidarport2);
lidar2 = tcpip(str1,str2);       
set(lidar2,'InputBufferSize',bufferlen*8);
lidar2.BytesAvailableFcnMode = 'byte';
lidar2.BytesAvailableFcnCount = bufferlen;
if deviceType == 2
    lidar2.BytesAvailableFcn = @LYCnetcallback2;    
else
    lidar2.BytesAvailableFcn = @netcallback2;
end
fname='连接激光雷达2';
set(handles.statetext2,'String',fname);
disp('连接激光雷达2');
if lidarQuantity == 2
	fopen(lidar2);
    fname='激光雷达2连接已成功';
    set(handles.statetext2,'String',fname);
    disp('激光雷达2连接已成功');
    fwrite(lidar2,command_startDAQ_ColaB,'uint8');
end
lidarstr2=[];
ldstat=1;

% 连接云平台服务器
str1 = num2str(paravalue.cloudserver.cloudserverip);
str2 = str2num(paravalue.cloudserver.cloudport);   
ys = tcpip(str1,str2); 
set(ys,'InputBufferSize',200);
ys.BytesAvailableFcnMode = 'byte';
ys.BytesAvailableFcnCount = 1;
ys.BytesAvailableFcn = @tcpserverback;

% 打开心跳定时发送程序
ListenTimer = timer('TimerFcn',@ListenTimerCallback, 'Period', 30.0, 'ExecutionMode','fixedDelay','BusyMode','drop'); % 
disp('打开心跳定时发送程序......');
fname='打开心跳定时发送程序';
set(handles.statetext,'String',fname);
start(ListenTimer);

else 
    disp('系统已开启，请不要重复点击......');
    fname='系统已开启，请不要重复点击';
    set(handles.statetext,'String',fname);
end


% --- Executes on button press in pushbutton23.
function pushbutton23_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton23 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global yt1;
global yt2;
global lidar1;
global lidar2;
global ys;
global ListenTimer;
global startflag;
global stopflag;
global ytstat;
global ldstat;
global runstat;
global lidarQuantity;

if stopflag==1
diary off;

% 关闭定时器
stop(ListenTimer);
delete(ListenTimer);
disp('定时器已关闭......');
fname='定时器已关闭';
set(handles.statetext,'String',fname);

% 关闭云台
data=[255,1,0,0,0,0,1];
fwrite(yt1,data,'uint8');
fclose(yt1);
clear yt1;
disp('与智能变速云台1已断开......');
fname='与智能变速云台1已断开';
set(handles.statetext,'String',fname);

if lidarQuantity == 2
fwrite(yt2,data,'uint8');
fclose(yt2);
end
clear yt2;
disp('与智能变速云台2已断开......');
fname='与智能变速云台2已断开';
set(handles.statetext,'String',fname);

% 关闭与云平台通信
fclose(ys);
clear ys;
disp('与调度服务连接已关闭......');
fname='与调度服务连接连接已关闭';
set(handles.statetext,'String',fname);

% 关闭雷达
fclose(lidar1);
disp('关闭雷达1......');
delete(lidar1);
clear lidar1;

if lidarQuantity == 2
    fclose(lidar2);
    disp('关闭雷达2......');
    delete(lidar2);
    clear lidar2;
end

fclose('all');
stopflag=1;
disp('系统已关闭......');
fname='系统已关闭';
set(handles.statetext,'String',fname);
startflag=0;
ytstat=0;
ldstat=0;
stopflag=0;
runstat=0;
else 
    disp('系统尚未开启......');
    fname='系统尚未开启......';
    set(handles.statetext,'String',fname);
end

function checkbox1_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hint: get(hObject,'Value') returns toggle state of checkbox1
global showEnable
if(get(hObject,'Value'))
  showEnable = 1; % 显示
else
  showEnable = 0; % 不显示
end


% --- Executes on button press in pushbutton24.
function pushbutton24_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton24 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
parChange;

% --- Executes on button press in pushbutton25.
function pushbutton25_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton25 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
pwdChange;

% --- Executes on button press in pushbutton26.
function pushbutton26_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton26 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes when selected object is changed in uipanel4.
function uipanel4_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in uipanel4 
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)
global yt_interface;
switch hObject
    case handles.ethernet
       yt_interface=1; 
    case handles.serial
       yt_interface=2; 
    otherwise
end


% --- Executes on button press in checkbox8.
function checkbox8_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox8


% --- Executes on button press in checkbox7.
function checkbox7_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox7


% --- Executes on button press in checkbox3.
function checkbox3_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox3


% --- Executes on button press in checkbox4.
function checkbox4_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox4


% --- Executes on button press in pushbutton27.
function pushbutton27_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton27 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global flag_SFMODE;
flag_SFMODE = 1;
figure1_DeleteFcn;
SFMODE;

function yt_control(hObject, eventdata, handles)
% hObject    handle to pushbutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global scanstat1;
global scanstat2;
global yt1;
global yt2;
global ytstat;
if ytstat==1
data(1)=255;
data(2)=1;
data(3)=0;
% 发送水平角度位置
data(4)=75;
data(5)=0;
data(6)=1;
crcb=sum(data(2:6));
if(crcb>255)
   crcb=mod(crcb,256);
end
data(7)=crcb;
fwrite(yt1,data,'uint8');
if lidarQuantity == 2
	fwrite(yt2,data,'uint8');
end
%发送垂直角度配置
data(4)=77;
data(5)=0;
data(6)=0;
crcb=sum(data(2:6));
if(crcb>255)
   crcb=mod(crcb,256);
end
data(7)=crcb;
fwrite(yt1,data,'uint8');
if lidarQuantity == 2
	fwrite(yt2,data,'uint8');
end
scanstat1=1;                                                    %进入扫描状态
scanstat2=1;                                                    %进入扫描状态
fname='控制云台旋转到起点';
set(handles.statetext,'String',fname);
set(handles.statetext2,'String',fname);
disp('控制云台旋转到起点');
else
    fname='请先连接云台';
    set(handles.statetext,'String',fname);
end
