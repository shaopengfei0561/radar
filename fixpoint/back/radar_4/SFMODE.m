function varargout = SFMODE(varargin)
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

% Last Modified by GUIDE v2.5 14-Oct-2015 16:53:06

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @SFMODE_OpeningFcn, ...
                   'gui_OutputFcn',  @SFMODE_OutputFcn, ...
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
function SFMODE_OpeningFcn(hObject, eventdata, handles, varargin)
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
clc;
% UIWAIT makes YT wait for user response (see UIRESUME)
% uiwait(handles.figure1);
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% --- Outputs from this function are returned to the command line.
function varargout = SFMODE_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in up.
function up_Callback(hObject, eventdata, handles)
% hObject    handle to up (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global yt1;
global yt2;
global ytstat;
if ytstat==1
str3=get(handles.degspd,'string');
degspd=str2num(str3);
if(degspd>63)
    degspd=63;
end
data(1)=255;
data(2)=1;
data(3)=0;
data(4)=8;
data(5)=0;
data(6)=degspd;
crcb=sum(data(2:6));
if(crcb>255)
   crcb=mod(crcb,256);
end
data(7)=crcb;
if get(handles.checkbox3,'value')
    fwrite(yt1,data,'uint8');
end
if get(handles.checkbox4,'value')
    fwrite(yt2,data,'uint8');
end
fname='向云台发送向上转动指令';
set(handles.statetext,'String',fname);
set(handles.statetext2,'String',fname);
disp('向云台发送向上转动指令');
else
    fname='请先连接云台';
    set(handles.statetext,'String',fname);
    set(handles.statetext2,'String',fname);
end

% --- Executes on button press in left.
function left_Callback(hObject, eventdata, handles)
% hObject    handle to left (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global yt1;
global yt2;
global ytstat;
if ytstat==1
str3=get(handles.degspd,'string');;
degspd=str2num(str3);
if(degspd>63)
    degspd=63;
end
data(1)=255;
data(2)=1;
data(3)=0;
data(4)=4;
data(5)=degspd;
data(6)=0;
crcb=sum(data(2:6));
if(crcb>255)
   crcb=mod(crcb,256);
end
data(7)=crcb;
if get(handles.checkbox3,'value')
    fwrite(yt1,data,'uint8');
end
if get(handles.checkbox4,'value')
    fwrite(yt2,data,'uint8');
end
disp('向云台发送向左转动指令');
fname='向云台发送向左转动指令';
set(handles.statetext,'String',fname);
set(handles.statetext2,'String',fname);
else
    fname='请先连接云台';
    set(handles.statetext,'String',fname);
    set(handles.statetext2,'String',fname);
end
% --- Executes on button press in right.
function right_Callback(hObject, eventdata, handles)
% hObject    handle to right (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global tcom;
global ytstat;
global yt1;
global yt2;
if ytstat==1
str3=get(handles.degspd,'string');
degspd=str2num(str3);
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
if get(handles.checkbox3,'value')
    fwrite(yt1,data,'uint8');
end
if get(handles.checkbox4,'value')
    fwrite(yt2,data,'uint8');
end
fname='向云台发送向右转动指令';
set(handles.statetext,'String',fname);
set(handles.statetext2,'String',fname);
disp('向云台发送向右转动指令');
else
    fname='请先连接云台';
    set(handles.statetext,'String',fname);
    set(handles.statetext2,'String',fname);
end

function down_Callback(hObject, eventdata, handles)
% hObject    handle to down (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global yt1;
global yt2;
global ytstat;
if ytstat==1
str3=get(handles.degspd,'string');
degspd=str2num(str3);
if(degspd>63)
    degspd=63;
end
data(1)=255;
data(2)=1;
data(3)=0;
data(4)=16;
data(5)=0;
data(6)=degspd;
crcb=sum(data(2:6));
if(crcb>255)
   crcb=mod(crcb,256);
end
data(7)=crcb;
if get(handles.checkbox3,'value')
    fwrite(yt1,data,'uint8');
end
if get(handles.checkbox4,'value')
    fwrite(yt2,data,'uint8');
end
fname='向云台发送向下转动指令';
set(handles.statetext,'String',fname);
set(handles.statetext2,'String',fname);
disp('向云台发送向下转动指令');
else
    fname='请先连接云台';
    set(handles.statetext,'String',fname);
    set(handles.statetext2,'String',fname);
end

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


% --- Executes on button press in ytcontrl.
function ytcontrl_Callback(hObject, eventdata, handles)
% hObject    handle to ytcontrl (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global yt1;
global yt2;
global ytstat;
if ytstat==1
str1=get(handles.hdegval,'string');
str2=get(handles.vdegval,'string');
hdegree=str2num(str1);
M_hdegree=mod(hdegree,256);
L_hdegree=floor(hdegree/256);
vdegree=str2num(str2);
M_vdegree=mod(vdegree,256);
L_vdegree=floor(vdegree/256);
data(1)=255;
data(2)=1;
data(3)=0;
% 发送水平角度位置
data(4)=75;
data(5)=M_hdegree;
data(6)=L_hdegree;
crcb=sum(data(2:6));
if(crcb>255)
   crcb=mod(crcb,256);
end
data(7)=crcb;
if get(handles.checkbox3,'value')
    fwrite(yt1,data,'uint8');
end
if get(handles.checkbox4,'value')
    fwrite(yt2,data,'uint8');
end
%发送垂直角度配置
data(4)=77;
data(5)=M_vdegree;
data(6)=L_vdegree;
crcb=sum(data(2:6));
if(crcb>255)
   crcb=mod(crcb,256);
end
data(7)=crcb;
if get(handles.checkbox3,'value')
    fwrite(yt1,data,'uint8');
end
if get(handles.checkbox4,'value')
    fwrite(yt2,data,'uint8');
end
fname='向云台发送角度配置指令';
set(handles.statetext,'String',fname);
set(handles.statetext2,'String',fname);
disp('向云台发送角度配置指令');
else
    fname='请先连接云台';
    set(handles.statetext,'String',fname);
    set(handles.statetext2,'String',fname);
    disp('请先连接云台');
end
% --- Executes on button press in ytdiscnt.
function ytdiscnt_Callback(hObject, eventdata, handles)
% hObject    handle to ytdiscnt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global yt1;
global yt2;
global ytstat;
if ytstat==1
data=[255,1,0,0,0,0,1];
if get(handles.checkbox3,'value')
    fwrite(yt1,data,'uint8');
    fclose(yt1);
    delete(yt1);
    clear yt1;
end
if get(handles.checkbox4,'value')
    fwrite(yt2,data,'uint8');
    fclose(yt2);
    delete(yt2);
    clear yt2;
end
fname='向云台发送停止指令，断开云台连接';
set(handles.statetext,'String',fname);
disp('向云台发送停止指令，断开云台连接');
ytstat=2;
else
    fname='请先连接云台';
    set(handles.statetext,'String',fname);
    set(handles.statetext2,'String',fname);
    disp('请先连接云台');
end

% --- Executes on button press in ytcnt.
function ytcnt_Callback(hObject, eventdata, handles)
% hObject    handle to ytcnt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global ytstat;
global yt_interface;
global yt1;
global yt2;
global paravalue;

if ytstat==0||ytstat==2
    if yt_interface==2
        if get(handles.checkbox3,'value')
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
            fopen(yt1);
            fname='串口1连接已成功';
            set(handles.statetext,'String',fname);
            disp('串口1连接已成功');
            ytstat=1;
        end
        if get(handles.checkbox4,'value')
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
            fopen(yt2);
            fname='串口2连接已成功';
            set(handles.statetext2,'String',fname);
            disp('串口2连接已成功');
            ytstat=1; 
        end
    else 
        if get(handles.checkbox3,'value')
        str1 = num2str(paravalue.yt.ytip1);
        str2 = str2num(paravalue.yt.ytport1);
        yt1 = tcpip(str1,str2);
        set(yt1,'InputBufferSize',100);
        yt1.BytesAvailableFcnMode = 'byte';
        yt1.OutputBufferSize = 100; 
        yt1.BytesAvailableFcnCount = 1;
        yt1.BytesAvailableFcn = @com1serverback;
        disp('连接云台1......');
        fname='连接云台1......';
        set(handles.statetext,'String',fname);
        fopen(yt1);
        disp('云台1连接已建立');
        fname='云台1连接已建立';
        set(handles.statetext,'String',fname);
        ytstat=1;
        end
        if get(handles.checkbox4,'value')
        str1 = num2str(paravalue.yt.ytip2);
        str2 = str2num(paravalue.yt.ytport2);
        yt2 = tcpip(str1,str2);
        set(yt2,'InputBufferSize',100);
        yt2.BytesAvailableFcnMode = 'byte';
        yt2.OutputBufferSize = 100; 
        yt2.BytesAvailableFcnCount = 1;
        yt2.BytesAvailableFcn = @com2serverback;
        disp('连接云台2......');
        fname='连接云台2......';
        set(handles.statetext2,'String',fname);
        fopen(yt2);
        disp('云台2连接已建立');
        fname='云台2连接已建立';
        set(handles.statetext2,'String',fname);
        ytstat=1;
        end
    end
else
    fname='云台已连接，请不要重复连接';
    set(handles.statetext,'String',fname);
    set(handles.statetext2,'String',fname);
    disp('云台已连接，请不要重复连接');
end

% --- Executes on button press in pushbutton8.
function pushbutton8_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global scanstat1;
global scanstat2;
global yt1;
global yt2;
global ytstat;
global toprenum;
global storeconfig;
global paravalue;
global lidar1;
global lidar2;
global ldstat;
global flag_SFMODE;
toprenum=1;
storeconfig=zeros(toprenum,8);
flag_SFMODE=1;
for i=1:toprenum
   storeconfig(i,1)=1;                             %库号                       
   storeconfig(i,2)=1;                             %仓位号
   storeconfig(i,3)=str2num(paravalue.alg.xmin);   %该仓位x最小值
   storeconfig(i,4)=str2num(paravalue.alg.xmax);   %该仓位x最大值
   storeconfig(i,5)=str2num(paravalue.alg.ymin);   %该仓位y最小值
   storeconfig(i,6)=str2num(paravalue.alg.ymax);   %该仓位y最大值
   storeconfig(i,7)=str2num(paravalue.alg.zmin);   %该仓位z最小值
   storeconfig(i,8)=str2num(paravalue.alg.zmax);   %该仓位z最大值
end
if ldstat==0
fopen(lidar1);
%fopen(lidar2);
command_startDAQ_ColaB = [hex2dec('02') hex2dec('02') hex2dec('02') hex2dec('02') hex2dec('00') hex2dec('00') hex2dec('00') hex2dec('11') ...
hex2dec('73') hex2dec('45') hex2dec('4E') hex2dec('20') hex2dec('4C') hex2dec('4D') hex2dec('44') hex2dec('73') hex2dec('63') ...
hex2dec('61') hex2dec('6E') hex2dec('64') hex2dec('61') hex2dec('74') hex2dec('61') hex2dec('20') hex2dec('01') hex2dec('33') ...
]; % 开始连续采集命令
fwrite(lidar1,command_startDAQ_ColaB,'uint8');
%fwrite(lidar2,command_startDAQ_ColaB,'uint8');
ldstat=1;
end

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
   crcb = mod(crcb,256);
end
data(7) = crcb;
if get(handles.checkbox3,'value')
fwrite(yt1,data,'uint8');
scanstat1 = 1;         %进入扫描状态
end
if get(handles.checkbox4,'value')
fwrite(yt2,data,'uint8');
scanstat2 = 1;         %进入扫描状态
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
if get(handles.checkbox3,'value')
fwrite(yt1,data,'uint8');
end
if get(handles.checkbox4,'value')
fwrite(yt2,data,'uint8');
end
fname='控制云台旋转到起点';
set(handles.statetext,'String',fname);
set(handles.statetext2,'String',fname);
disp('控制云台旋转到起点');
else
    fname='请先连接云台';
    set(handles.statetext,'String',fname);
    set(handles.statetext2,'String',fname);
    disp('请先连接云台');
end


% --- Executes when selected object is changed in uipanel1.
function uipanel1_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in uipanel1 
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)
global com;
switch hObject
    case handles.com1
       com='com1'; 
    case handles.com2
       com='com2';
    case handles.com3
       com='com3';
    case handles.com4
       com='com4';
    otherwise
end


% --- Executes on button press in ytstop.
function ytstop_Callback(hObject, eventdata, handles)
% hObject    handle to ytstop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global yt1;
global yt2;
global ytstat;
if ytstat==1
data=[255,1,0,0,0,0,1];
if get(handles.checkbox3,'value')
    fwrite(yt1,data,'uint8');
end
if get(handles.checkbox4,'value')
    fwrite(yt2,data,'uint8');
end
fname='向云台发送停止指令';
set(handles.statetext,'String',fname);
disp('向云台发送停止指令');
else
    fname='请先连接云台';
    set(handles.statetext,'String',fname);
    disp('请先连接云台');
end

% --- Executes during object deletion, before destroying properties.
function figure1_DeleteFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global ytstat;
global ldstat;
global yt1;
global yt2;
global flag_SFMODE;
global lidar1;
global lidar2;
global oridatadisplayflag;
oridatadisplayflag = 0;
if ytstat==1
data=[255,1,0,0,0,0,1];
if get(handles.checkbox3,'value')
    fwrite(yt1,data,'uint8');
    fclose(yt1);
    delete(yt1);
    clear yt1;
end
if get(handles.checkbox4,'value')
    fwrite(yt2,data,'uint8');
    fclose(yt2);
    delete(yt2);
    clear yt2;
end
fname='串口关闭并已释放';
set(handles.statetext,'String',fname);
disp('串口关闭并已释放');
ytstat=0;
end

if ldstat==1
if get(handles.checkbox7,'value')
    fclose(lidar1);
    disp('关闭雷达1......');
    fname='关闭雷达1......';
    set(handles.statetext,'String',fname);
    delete(lidar1);
    clear lidar1;
end
if get(handles.checkbox8,'value')
    fclose(lidar2);
    disp('关闭雷达2......');
    fname='关闭雷达2......';
    set(handles.statetext,'String',fname);
    delete(lidar2);
    clear lidar2;
end
ldstat=0;
end
flag_SFMODE = 0;

% --- Executes on button press in pushbutton20.
function pushbutton20_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton20 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global ldstat;
global bufferlen;
global lidar1;
global lidar2;
global lidarstr1;
global lidarstr2;
global paravalue;
global  lidarQuantity;
global  lidar2frm;
lidar2frm = zeros(2401,1);
lidarQuantity = str2num(paravalue.systeminfor.lidarquantity);
if ldstat==0||ldstat==2
% 连接激光雷达1
if get(handles.checkbox7,'value')
str1 = num2str(paravalue.lidarip.lidarip1);
str2 = str2num(paravalue.lidarip.lidarport1);
lidar1 = tcpip(str1,str2);  
bufferlen=9723;
set(lidar1,'InputBufferSize',bufferlen*10);
lidar1.BytesAvailableFcnMode = 'byte';
lidar1.BytesAvailableFcnCount = bufferlen;
lidar1.BytesAvailableFcn = @netcallback1;
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
ldstat=1;
end

% 连接激光雷达2
if get(handles.checkbox8,'value')
str1 = num2str(paravalue.lidarip.lidarip2);
str2 = str2num(paravalue.lidarip.lidarport2);
lidar2 = tcpip(str1,str2);       
set(lidar2,'InputBufferSize',bufferlen*8);
lidar2.BytesAvailableFcnMode = 'byte';
lidar2.BytesAvailableFcnCount = bufferlen;
lidar2.BytesAvailableFcn = @netcallback2;
fname='连接激光雷达2';
set(handles.statetext2,'String',fname);
disp('连接激光雷达2');
if lidarQuantity == 2
fopen(lidar2);
fwrite(lidar2,command_startDAQ_ColaB,'uint8');
end
fname='激光雷达2连接已成功';
set(handles.statetext2,'String',fname);
disp('激光雷达2连接已成功');

lidarstr2=[];
ldstat=1;
end
else
    disp('雷达已连接，请不要重复连接');
    fname='雷达已连接，请不要重复连接';
    set(handles.statetext,'String',fname);
    set(handles.statetext2,'String',fname);
end
% --- Executes on button press in pushbutton21.
function pushbutton21_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton21 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global lidar1;
global lidar2;
global proflag;
global ldstat;
global oridatadisplayflag;
oridatadisplayflag = 0;
if ldstat==1
    if get(handles.checkbox7,'value')
    fclose(lidar1);
    disp('关闭雷达1');
    delete(lidar1);
    clear lidar1;
    ldstat=2;
    proflag=0;
    end
    if get(handles.checkbox8,'value')
    fclose(lidar2);
    disp('关闭雷达2');
    delete(lidar2);
    clear lidar2;
    ldstat=2;
    proflag=0;
    end
else
    disp('请先连接雷达');
    fname='请先连接雷达';
    set(handles.statetext,'String',fname);
    set(handles.statetext2,'String',fname);
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

temp=isempty(startflag);
if startflag==0||temp==1
stopflag=0;
% 连接智能变速云台1
str1 = num2str(paravalue.yt.ytip1);
str2 = str2num(paravalue.yt.ytport1);
yt1 = tcpip(str1,str2);       
set(yt1,'InputBufferSize',100);
yt1.BytesAvailableFcnMode = 'byte';
yt1.BytesAvailableFcnCount = 1;
yt1.BytesAvailableFcn = @com1serverback;
disp('连接智能变速云台1......');
fopen(yt1);
disp('连接成功......');

% 连接智能变速云台2
str1 = num2str(paravalue.yt.ytip2);
str2 = str2num(paravalue.yt.ytport2);
yt2 = tcpip(str1,str2);       
set(yt2,'InputBufferSize',100);
yt2.BytesAvailableFcnMode = 'byte';
yt2.BytesAvailableFcnCount = 1;
yt2.BytesAvailableFcn = @com2serverback;
disp('连接智能变速云台1......');
fopen(yt2);
disp('连接成功......');

% 连接激光雷达1
str1 = num2str(paravalue.lidarip.lidarip1);
str2 = str2num(paravalue.lidarip.lidarport1);
lidar1 = tcpip(str1,str2);       
set(lidar1,'InputBufferSize',100);
lidar1.BytesAvailableFcnMode = 'byte';
lidar1.BytesAvailableFcnCount = 1;
lidar1.BytesAvailableFcn = @netcallback1;
disp('连接激光雷达1......');
fopen(lidar1);
disp('连接成功......');

% 连接激光雷达2
str1 = num2str(paravalue.yt.ytip2);
str2 = str2num(paravalue.yt.ytport2);
lidar2 = tcpip(str1,str2);       
set(lidar2,'InputBufferSize',100);
lidar2.BytesAvailableFcnMode = 'byte';
lidar2.BytesAvailableFcnCount = 1;
lidar2.BytesAvailableFcn = @netcallback2;
disp('连接激光雷达2......');
fopen(lidar2);
disp('连接成功......');

% 连接云平台服务器
str1 = num2str(paravalue.cloudserver.cloudserverip);
str2 = str2num(paravalue.cloudserver.cloudport);   
ys = tcpip(str1,str2); 
set(ys,'InputBufferSize',100);
ys.BytesAvailableFcnMode = 'byte';
ys.BytesAvailableFcnCount = 1;
ys.BytesAvailableFcn = @tcpserverback;
disp('连接云平台服务器......');
fopen(ys);  
fname='云平台服务器已连接';
set(handles.statetext,'String',fname);

% 连接云台
% ytcnt_Callback(hObject, eventdata, handles);

ListenTimer = timer('TimerFcn',@ListenTimerCallback, 'Period', 5.0, 'ExecutionMode','fixedDelay','BusyMode','drop'); % 
disp('打开定时器监听端口......');
fname='打开定时器监听端口';
set(handles.statetext,'String',fname);
start(ListenTimer);

startflag=1;
disp('系统已开启......');
fname='系统已开启';
set(handles.statetext,'String',fname);
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

if stopflag==0
diary off;

% 关闭定时器
stop(ListenTimer);
delete(ListenTimer);
disp('定时器已关闭......');
fname='定时器已关闭';
set(handles.statetext,'String',fname);

% 关闭云台
fclose(yt1);
clear yt1;
disp(['与智能变速云台1已断开......']);
fname='与智能变速云台1已断开';
set(handles.statetext,'String',fname);

fclose(yt2);
clear yt2;
disp(['与智能变速云台2已断开......']);
fname='与智能变速云台2已断开';
set(handles.statetext,'String',fname);

% 关闭与云平台通信
fclose(ys);
clear ys;
disp('与云平台通信客户端socket已关闭......');
fname='与云平台通信客户端socket已关闭';
set(handles.statetext,'String',fname);

% 关闭与云台之间的串口通信
% ytdiscnt_Callback(hObject, eventdata, handles);

% 关闭雷达
fclose(lidar1);
disp('关闭雷达1......');
delete(lidar1);
clear lidar1;

fclose(lidar2);
disp('关闭雷达2......');
delete(lidar2);
clear lidar2;

fclose('all');
stopflag=1;
disp('系统已关闭......');
fname='系统已关闭';
set(handles.statetext,'String',fname);
startflag=0;
else 
    disp('系统已关闭，请不要重复点击......');
    fname='系统已关闭，请不要重复点击......';
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


% --- Executes on button press in checkbox9.
function checkbox9_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox9
global oridatadisplayflag
global ldstat;
global lidar1;
global lidar2;
if(get(hObject,'Value'))
    oridatadisplayflag = 1; % 显示原始数据
    command_startDAQ_ColaB = [hex2dec('02') hex2dec('02') hex2dec('02') hex2dec('02') hex2dec('00') hex2dec('00') hex2dec('00') hex2dec('11') ...
    hex2dec('73') hex2dec('45') hex2dec('4E') hex2dec('20') hex2dec('4C') hex2dec('4D') hex2dec('44') hex2dec('73') hex2dec('63') ...
    hex2dec('61') hex2dec('6E') hex2dec('64') hex2dec('61') hex2dec('74') hex2dec('61') hex2dec('20') hex2dec('01') hex2dec('33') ...
    ]; % 开始连续采集命令
    if ldstat==0
        if get(handles.checkbox7,'value')
        fopen(lidar1);
        fwrite(lidar1,command_startDAQ_ColaB,'uint8');
        ldstat=1;
        end
        if get(handles.checkbox8,'value')
        fopen(lidar2);
        fwrite(lidar2,command_startDAQ_ColaB,'uint8');
        ldstat=1;
        end   
    end
else
    oridatadisplayflag = 0; % 不显示原始数据
    if ldstat==1
        if get(handles.checkbox7,'value')
        fclose(lidar1);
        ldstat=0;
        end
        if get(handles.checkbox8,'value')
        fclose(lidar2);
        ldstat=0;
        end
    end
end
