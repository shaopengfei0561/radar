function varargout = pwdChange(varargin)
% PWDCHANGE MATLAB code for pwdChange.fig
%      PWDCHANGE, by itself, creates a new PWDCHANGE or raises the existing
%      singleton*.
%
%      H = PWDCHANGE returns the handle to a new PWDCHANGE or the handle to
%      the existing singleton*.
%
%      PWDCHANGE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PWDCHANGE.M with the given input arguments.
%
%      PWDCHANGE('Property','Value',...) creates a new PWDCHANGE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before pwdChange_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to pwdChange_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help pwdChange

% Last Modified by GUIDE v2.5 21-Sep-2015 20:15:11

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @pwdChange_OpeningFcn, ...
                   'gui_OutputFcn',  @pwdChange_OutputFcn, ...
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


% --- Executes just before pwdChange is made visible.
function pwdChange_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to pwdChange (see VARARGIN)

% Choose default command line output for pwdChange
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes pwdChange wait for user response (see UIRESUME)
% uiwait(handles.figure1);
global SUPERPWD_CONSTANT
SUPERPWD_CONSTANT = 'laserScanner2015';
h = handles.figure1; %返回其句柄
newIcon = javax.swing.ImageIcon('wsn.jpg');
figFrame = get(h,'JavaFrame'); %取得Figure的JavaFrame。
figFrame.setFigureIcon(newIcon); %修改图标
clc;

% --- Outputs from this function are returned to the command line.
function varargout = pwdChange_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function superAdmPwd_Callback(hObject, eventdata, handles)
% hObject    handle to superAdmPwd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of superAdmPwd as text
%        str2double(get(hObject,'String')) returns contents of superAdmPwd as a double


% --- Executes during object creation, after setting all properties.
function superAdmPwd_CreateFcn(hObject, eventdata, handles)
% hObject    handle to superAdmPwd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
global superPassword
superPassword = get(hObject,'UserData');


function admPwd_Callback(hObject, eventdata, handles)
% hObject    handle to admPwd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of admPwd as text
%        str2double(get(hObject,'String')) returns contents of admPwd as a double


% --- Executes during object creation, after setting all properties.
function admPwd_CreateFcn(hObject, eventdata, handles)
% hObject    handle to admPwd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global superPassword SUPERPWD_CONSTANT
if strcmp(superPassword,SUPERPWD_CONSTANT)
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
newPwd = get(handles.admPwd,'String');
if(isempty(str2num(newPwd)))
  set(handles.status,'String','密码只能包含数字，且不能为空！');
  return;
end
fname=strcat('key','.yu');
fid=fopen(fname,'rb');
if(fid>0)
  tt=fread(fid, inf, 'uint16');
  tt=tt';
  len = length(tt);
  rand('seed',987654321);
  key = randi(1000,1,len);
  tt=tt-key;
  ttt = '';
  for i=1:length(tt)
    ttt = [ttt char(tt(i))];
  end
  fclose(fid);
  len = length(newPwd);
  rand('seed',987654321);
  key = randi(1000,1,len);
  fid=fopen(fname,'wb');
  if(fid>0)
    fwrite(fid, newPwd+key, 'uint16');
    fclose(fid);
    % 用新密钥更新原有的加密配置文件
    fname=strcat('Config','.yu');
    flag = iniDecrypt(fname,ttt);
    fname=strcat('Config','.ini');
    flag = iniEncrypt(fname,newPwd);
    if flag
      delete(fname);
    end
    set(handles.status,'String','管理员密码更新成功！');
  else
    error('open ini file failed!');
  end
else
  len = length(newPwd);
  rand('seed',987654321);
  key = randi(1000,1,len);
  fid=fopen(fname,'wb');
  fwrite(fid, newPwd+key, 'uint16');
  fclose(fid);
  % 用新密钥更新原有的加密配置文件
  fname=strcat('Config','.ini');
  flag = iniEncrypt(fname,newPwd);
  if flag
    delete(fname);
  end
  set(handles.status,'String','管理员密码更新成功！');
end
fclose('all');


% fid=fopen(fname,'rb');
% tt=fread(fid, inf, 'uint16');
% tt=tt';
% tt=tt-key;
% ttt = '';
% for i=1:length(tt)
%   ttt = [ttt char(tt(i))];
% end

% --- Executes on key press with focus on superAdmPwd and none of its controls.
function superAdmPwd_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to superAdmPwd (see GCBO)
% eventdata  structure with the following fields (see UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
global superPassword
superPassword = get(hObject,'UserData');
switch eventdata.Key
   case 'backspace'
      superPassword = superPassword(1:end-1);
   case 'return'
      uiresume;
      return;
   otherwise
      superPassword = [superPassword eventdata.Character];
      uiresume;
end
set(hObject,'String',char('*'*sign(superPassword)));
set(hObject,'UserData',superPassword);
% get(hObject,'UserData')


% --- Executes during object creation, after setting all properties.
function figure1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called



function admPWD_old_Callback(hObject, eventdata, handles)
% hObject    handle to admPWD_old (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of admPWD_old as text
%        str2double(get(hObject,'String')) returns contents of admPWD_old as a double


% --- Executes during object creation, after setting all properties.
function admPWD_old_CreateFcn(hObject, eventdata, handles)
% hObject    handle to admPWD_old (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
rand('seed',987654321);
fname=strcat('key','.yu');
fid=fopen(fname,'rb');
if(fid<=0)
  set(handles.status,'String','未找到key.yu文件！');
  return;
end
tt=fread(fid, inf, 'uint16');
tt=tt';
len = length(tt);
key = randi(1000,1,len);
tt=tt-key;
ttt = '';
for i=1:length(tt)
  ttt = [ttt char(tt(i))];
end
set(handles.admPWD_old,'String',ttt);
