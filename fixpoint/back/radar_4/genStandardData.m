function varargout = genStandardData(varargin)
% GENSTANDARDDATA MATLAB code for genStandardData.fig
%      GENSTANDARDDATA, by itself, creates a new GENSTANDARDDATA or raises the existing
%      singleton*.
%
%      H = GENSTANDARDDATA returns the handle to a new GENSTANDARDDATA or the handle to
%      the existing singleton*.
%
%      GENSTANDARDDATA('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GENSTANDARDDATA.M with the given input arguments.
%
%      GENSTANDARDDATA('Property','Value',...) creates a new GENSTANDARDDATA or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before genStandardData_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to genStandardData_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help genStandardData

% Last Modified by GUIDE v2.5 20-May-2015 17:10:50

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @genStandardData_OpeningFcn, ...
                   'gui_OutputFcn',  @genStandardData_OutputFcn, ...
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


% --- Executes just before genStandardData is made visible.
function genStandardData_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to genStandardData (see VARARGIN)

% Choose default command line output for genStandardData
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes genStandardData wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = genStandardData_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1
curSel = get(hObject,'Value');
if(curSel==1) % ¸Ö¾í
  set(handles.editOutRadii,'Enable','on');
  set(handles.editInRadii,'Enable','on');
  set(handles.editBottomLen1,'Enable','off');
  set(handles.editBottomLen2,'Enable','off');
elseif(curSel==2) % ÂÁ¶§
  set(handles.editOutRadii,'Enable','off');
  set(handles.editInRadii,'Enable','off');
  set(handles.editBottomLen1,'Enable','on');
  set(handles.editBottomLen2,'Enable','on');
end


% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editOutRadii_Callback(hObject, eventdata, handles)
% hObject    handle to editOutRadii (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editOutRadii as text
%        str2double(get(hObject,'String')) returns contents of editOutRadii as a double


% --- Executes during object creation, after setting all properties.
function editOutRadii_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editOutRadii (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editInRadii_Callback(hObject, eventdata, handles)
% hObject    handle to editInRadii (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editInRadii as text
%        str2double(get(hObject,'String')) returns contents of editInRadii as a double


% --- Executes during object creation, after setting all properties.
function editInRadii_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editInRadii (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editLen_Callback(hObject, eventdata, handles)
% hObject    handle to editLen (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editLen as text
%        str2double(get(hObject,'String')) returns contents of editLen as a double


% --- Executes during object creation, after setting all properties.
function editLen_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editLen (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editBottomLen1_Callback(hObject, eventdata, handles)
% hObject    handle to editBottomLen1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editBottomLen1 as text
%        str2double(get(hObject,'String')) returns contents of editBottomLen1 as a double


% --- Executes during object creation, after setting all properties.
function editBottomLen1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editBottomLen1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu2.
function popupmenu2_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu2


% --- Executes during object creation, after setting all properties.
function popupmenu2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editBottomLen2_Callback(hObject, eventdata, handles)
% hObject    handle to editBottomLen2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editBottomLen2 as text
%        str2double(get(hObject,'String')) returns contents of editBottomLen2 as a double


% --- Executes during object creation, after setting all properties.
function editBottomLen2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editBottomLen2 (see GCBO)
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
curSel = get(handles.popupmenu1,'Value');
direction = get(handles.popupmenu2,'Value');
if(curSel==1)
  temp1 = get(handles.editOutRadii,'String');
  outRadii = str2num(temp1);
  temp1 = get(handles.editInRadii,'String');
  inRadii = str2num(temp1);
  temp1 = get(handles.editLen,'String');
  len = str2num(temp1);
  rawData = genSingleTarget(curSel, outRadii, inRadii, len, direction);
elseif(curSel==2)
  temp1 = get(handles.editBottomLen1,'String');
  bottomLen1 = str2num(temp1);
  temp1 = get(handles.editBottomLen2,'String');
  bottomLen2 = str2num(temp1);
  temp1 = get(handles.editLen,'String');
  len = str2num(temp1);
  rawData = genSingleTarget(curSel, bottomLen1, bottomLen2, len, direction);
end

cla(handles.axes1);
plot3(rawData(:,1),rawData(:,2),rawData(:,3),'g*');
xlabel('x');ylabel('y');zlabel('z');
rotate3d on;
grid on;
axis equal;


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close(gcf);
