function varargout = GUI_InfoAndRecord(varargin)
%%%%%%   OUTPUT FUNCTION    %%%%%% (notes from McGinnis) GITHUB
%%%%%%   varargout{1}  = handles.output
% GUI_INFOANDRECORD MATLAB code for GUI_InfoAndRecord.fig
%      GUI_INFOANDRECORD, by itself, creates a new GUI_INFOANDRECORD or raises the existing
%      singleton*.
%
%      H = GUI_INFOANDRECORD returns the handle to a new GUI_INFOANDRECORD or the handle to
%      the existing singleton*.
%
%      GUI_INFOANDRECORD('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI_INFOANDRECORD.M with the given input arguments.
%
%      GUI_INFOANDRECORD('Property','Value',...) creates a new GUI_INFOANDRECORD or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GUI_InfoAndRecord_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GUI_InfoAndRecord_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GUI_InfoAndRecord

% Last Modified by GUIDE v2.5 31-Oct-2017 17:10:13

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GUI_InfoAndRecord_OpeningFcn, ...
                   'gui_OutputFcn',  @GUI_InfoAndRecord_OutputFcn, ...
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


% --- Executes just before GUI_InfoAndRecord is made visible.
function GUI_InfoAndRecord_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GUI_InfoAndRecord (see VARARGIN)

% Choose default command line output for GUI_InfoAndRecord
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes GUI_InfoAndRecord wait for user response (see UIRESUME)
% uiwait(handles.GUIMAIN);


% --- Outputs from this function are returned to the command line.
function varargout = GUI_InfoAndRecord_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function firstName_Callback(hObject, eventdata, handles)
% hObject    handle to firstName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of firstName as text
%        str2double(get(hObject,'String')) returns contents of firstName as a double


% --- Executes during object creation, after setting all properties.
function firstName_CreateFcn(hObject, eventdata, handles)
% hObject    handle to firstName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function lastName_Callback(hObject, eventdata, handles)
% hObject    handle to lastName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of lastName as text
%        str2double(get(hObject,'String')) returns contents of lastName as a double


% --- Executes during object creation, after setting all properties.
function lastName_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lastName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in male.
function male_Callback(hObject, eventdata, handles)
% hObject    handle to male (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of male


% --- Executes on button press in female.
function female_Callback(hObject, eventdata, handles)
% hObject    handle to female (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of female



function DOB_Callback(hObject, eventdata, handles)
% hObject    handle to DOB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of DOB as text
%        str2double(get(hObject,'String')) returns contents of DOB as a double


% --- Executes during object creation, after setting all properties.
function DOB_CreateFcn(hObject, eventdata, handles)
% hObject    handle to DOB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function height_Callback(hObject, eventdata, handles)
% hObject    handle to height (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of height as text
%        str2double(get(hObject,'String')) returns contents of height as a double


% --- Executes during object creation, after setting all properties.
function height_CreateFcn(hObject, eventdata, handles)
% hObject    handle to height (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function weight_Callback(hObject, eventdata, handles)
% hObject    handle to weight (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of weight as text
%        str2double(get(hObject,'String')) returns contents of weight as a double


% --- Executes during object creation, after setting all properties.
function weight_CreateFcn(hObject, eventdata, handles)
% hObject    handle to weight (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in liveRecording.
function liveRecording_Callback(hObject, eventdata, handles)
% hObject    handle to liveRecording (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of liveRecording


% --- Executes on button press in importRecording.
function importRecording_Callback(hObject, eventdata, handles)
% hObject    handle to importRecording (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of importRecording
set(handles.browse,'Enable','On');

% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object creation, after setting all properties.
function male_CreateFcn(hObject, eventdata, handles)
% hObject    handle to male (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function female_CreateFcn(hObject, eventdata, handles)
% hObject    handle to female (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on button press in browse.
function browse_Callback(hObject, eventdata, handles)
% hObject    handle to browse (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
filename = uigetfile;

% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in cancel.
function cancel_Callback(hObject, eventdata, handles)
% hObject    handle to cancel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close all

% --- Executes on button press in ok.
function ok_Callback(hObject, eventdata, handles)
% hObject    handle to ok (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
firstName = get(handles.firstName,'String');
lastName = get(handles.lastName,'String');
genderObj = get(handles.genderPanel, 'SelectedObject');
genderStr = get(genderObj, 'String');
dob = get(handles.DOB,'String');
height = get(handles.height,'String');
recordObj = get(handles.recordPanel, 'SelectedObject');
recordStr = get(recordObj,'String');

close all
