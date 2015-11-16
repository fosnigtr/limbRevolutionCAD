function varargout = main(varargin)
% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @main_OpeningFcn, ...
                   'gui_OutputFcn',  @main_OutputFcn, ...
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

% --- Executes just before main is made visible.
function main_OpeningFcn(hParentObj, eventdata, handles, varargin)

% Choose default command line output for main
handles.output = hParentObj;

% Update handles structure
guidata(hParentObj, handles);

% --- Outputs from this function are returned to the command line.
function varargout = main_OutputFcn(hParentObj, eventdata, handles) 

% Get default command line output from handles structure
varargout{1} = handles.output;

function importAOP_Callback(hParentObj, eventdata, handles)
model = guidata(hParentObj);
% GET .AOP FILE
model = getAopFile( hParentObj, model );
% READ .AOP FILE
model = readAopFile( hParentObj, model );
% SAVE DATA
guidata(hParentObj,model);
% INITIALIZE GRAPHICS
initGL(model);

function Assembly_Callback(hParentObj, eventdata, handles)
model = guidata(hParentObj);
% LOAD ASSEMBLY
fn = uigetfile('.mat','Select outer mold');
load(fn,'model');
tmp = model.data;
fn = uigetfile('.mat','Select inner mold');
load(fn,'model');
model.data = cat(3,tmp,model.data);
% SAVE DATA
guidata(hParentObj,model);
% INITIALIZE GRAPHICS
initGL(model);

function Templates_Callback(hParentObj, eventdata, handles)
% hParentObj    handle to Templates (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

function Export_Callback(hParentObj, eventdata, handles)
% hParentObj    handle to Export (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

function exportAOP_Callback(hParentObj, eventdata, handles)
% hParentObj    handle to exportAOP (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

function Liner_Callback(hParentObj, eventdata, handles)
% hParentObj    handle to Liner (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
