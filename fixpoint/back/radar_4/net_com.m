function varargout = net_com(varargin)
% NET_COM M-file for net_com.fig
%      NET_COM, by itself, creates a new NET_COM or raises the existing
%      singleton*.
%
%      H = NET_COM returns the handle to a new NET_COM or the handle to
%      the existing singleton*.
%
%      NET_COM('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in NET_COM.M with the given input arguments.
%
%      NET_COM('Property','Value',...) creates a new NET_COM or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before net_com_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to net_com_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help net_com

% Last Modified by GUIDE v2.5 20-May-2015 23:18:10

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @net_com_OpeningFcn, ...
                   'gui_OutputFcn',  @net_com_OutputFcn, ...
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


% --- Executes just before net_com is made visible.
function net_com_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to net_com (see VARARGIN)
% Choose default command line output for net_com
global hObject1 handles1;
global showEnable showType
showEnable = 0;
showType = 0;
handles.output = hObject;
hObject1=hObject;
handles1=handles;
% Update handles structure
guidata(hObject, handles);
axes(handles.axes2);
grid on;
cla (handles.axes2) ;
cla (handles.axes3) ;
set(handles.text1,'String','体积测量结果');
% UIWAIT makes net_com wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = net_com_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes during object deletion, before destroying properties.
function figure1_DeleteFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close all;
% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global t1;
global t2;
global t3;
global bufferlen;
global ListenTimer;

para_config();
bufferlen = 1250;
t1 = tcpip('10.8.5.23',9008);
set(t1,'InputBufferSize',1250*2);
t1.BytesAvailableFcnMode = 'byte';
t1.BytesAvailableFcnCount = bufferlen;
t1.BytesAvailableFcn = @netcallback1;
fopen(t1);
disp('连接雷达1......');

t2 = tcpip('10.8.5.24',9008);
set(t2,'InputBufferSize',1250*2);
t2.BytesAvailableFcnMode = 'byte';
t2.BytesAvailableFcnCount = bufferlen;
t2.BytesAvailableFcn = @netcallback2;
fopen(t2);
disp('连接雷达2......');

t3 = tcpip('0.0.0.0',8004,'NetworkRole','server');
set(t3,'Timeout',10);                                                       %socket连接超时时间，是fread读取的阻塞时间，超过此时间未读到数据则退出fread
set(t3,'InputBufferSize',100);
t3.BytesAvailableFcnMode = 'byte';
t3.BytesAvailableFcnCount = 1;
t3.BytesAvailableFcn = @tcpserverback;
fopen(t3);
disp('建立服务器端，端口8004，等待连接......');

ListenTimer = timer('TimerFcn',@ListenTimerCallback, 'Period', 3.0, 'ExecutionMode','fixedDelay','BusyMode','drop'); % 
start(ListenTimer);
disp('打开定时器监听端口......');

% --- Executes during object creation, after setting all properties.
function figure1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
clc;

% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global t1;
global t2;
global t3;
global ListenTimer;

stop(ListenTimer);
delete(ListenTimer);

fclose(t1);
disp('关闭雷达1......');
delete(t1);
clear t1;

fclose(t2);
disp('关闭雷达2......');
delete(t2);
clear t2;

fclose(t3);
disp('关闭服务器......');
clear t3;

fclose('all');
clear all;

% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global ExceptionFlag;
ExceptionFlag = 1;

% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global proflag;
global storenam;
proflag=1;
storenam(1)=1;
% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global proflag;
proflag=2;

% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global proflag;
proflag=3;

%--------------测试代码------------------------------------------
% global toprenum toprestore showType
% toprenum = 1;
% toprestore = 1;
% if(~showType)
%   dianyunalg();                                                     % 进入数据处理函数
% else
%   dianyunalg2();
% end
%--------------测试代码------------------------------------------


% --- Executes during object creation, after setting all properties.
function axes2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes2


% --- Executes on button press in radiobuttonRaw.
function radiobuttonRaw_Callback(hObject, eventdata, handles)
% hObject    handle to radiobuttonRaw (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobuttonRaw


% --- Executes on button press in radiobuttonSim.
function radiobuttonSim_Callback(hObject, eventdata, handles)
% hObject    handle to radiobuttonSim (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobuttonSim


% --- Executes when selected object is changed in uipanel2.
function uipanel2_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in uipanel2 
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)
global showType
if(get(handles.radiobuttonRaw,'Value'))
  showType = 0; % 原始数据
else
  showType = 1; % 仿真模拟数据
end


% --- Executes on button press in checkbox1.
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


% --- Executes on button press in pushbuttonGenData.
function pushbuttonGenData_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonGenData (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
genStandardData;
