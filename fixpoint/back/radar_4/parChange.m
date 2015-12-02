function varargout = parChange(varargin)
% PARCHANGE MATLAB code for parChange.fig
%      PARCHANGE, by itself, creates a new PARCHANGE or raises the existing
%      singleton*.
%
%      H = PARCHANGE returns the handle to a new PARCHANGE or the handle to
%      the existing singleton*.
%
%      PARCHANGE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PARCHANGE.M with the given input arguments.
%
%      PARCHANGE('Property','Value',...) creates a new PARCHANGE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before parChange_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to parChange_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help parChange

% Last Modified by GUIDE v2.5 28-Sep-2015 15:32:12

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @parChange_OpeningFcn, ...
                   'gui_OutputFcn',  @parChange_OutputFcn, ...
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


% --- Executes just before parChange is made visible.
function parChange_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to parChange (see VARARGIN)

% Choose default command line output for parChange
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes parChange wait for user response (see UIRESUME)
% uiwait(handles.figure1);
h = handles.figure1; %返回其句柄
newIcon = javax.swing.ImageIcon('wsn.jpg');
figFrame = get(h,'JavaFrame'); %取得Figure的JavaFrame。
figFrame.setFigureIcon(newIcon); %修改图标
clc;
% --- Outputs from this function are returned to the command line.
function varargout = parChange_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
global curPassword
curPassword = get(hObject,'UserData');


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global curPassword ADMPWD_CONSTANT
rand('seed',987654321);
fname=strcat('key','.yu');
fid=fopen(fname,'rb');
tt=fread(fid, inf, 'uint16');
fclose(fid);
tt=tt';
len = length(tt);
key = randi(1000,1,len);
tt=tt-key;
ADMPWD_CONSTANT = '';
for i=1:length(tt)
  ADMPWD_CONSTANT = [ADMPWD_CONSTANT char(tt(i))];
end
if strcmp(curPassword,ADMPWD_CONSTANT)
  set(handles.status,'String','验证通过！');
  set(handles.pushbutton2,'Enable','on');
  set(handles.pushbutton3,'Enable','on');
else
  set(handles.status,'String','验证失败，请重输或退出！');
  set(handles.pushbutton2,'Enable','off');
  set(handles.pushbutton3,'Enable','off');
end

% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global ADMPWD_CONSTANT
fname=strcat('Config','.yu');
flag = iniDecrypt(fname,ADMPWD_CONSTANT);
if flag
  set(handles.status,'String','生成明文成功！请尽快修改参数文件后点击应用按钮！');
else
  set(handles.status,'String','生成明文失败！请重试或查找原因！');
end

% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global ADMPWD_CONSTANT
fname=strcat('Config','.ini');
flag = iniEncrypt(fname,ADMPWD_CONSTANT);
if flag
  set(handles.status,'String','更新参数成功！');
  delete(fname);
else
  set(handles.status,'String','更新参数失败！请重试或查找原因！');
end


% --- Executes on key press with focus on edit1 and none of its controls.
function edit1_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  structure with the following fields (see UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
global curPassword
curPassword = get(hObject,'UserData');
switch eventdata.Key
   case 'backspace'
      curPassword = curPassword(1:end-1);
   case 'return'
      uiresume;
      return;
   otherwise
      curPassword = [curPassword eventdata.Character];
end
set(hObject,'String',char('*'*sign(curPassword)));
set(hObject,'UserData',curPassword);
% get(hObject,'UserData')


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
delete(hObject);
warning off;
delete('Config.ini');
warning on;
