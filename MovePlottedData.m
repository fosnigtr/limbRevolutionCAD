function varargout = MovePlottedData(varargin)
% MOVEPLOTTEDDATA MATLAB code for MovePlottedData.fig
%      MOVEPLOTTEDDATA, by itself, creates a new MOVEPLOTTEDDATA or raises the existing
%      singleton*.
%
%      H = MOVEPLOTTEDDATA returns the handle to a new MOVEPLOTTEDDATA or the handle to
%      the existing singleton*.
%
%      MOVEPLOTTEDDATA('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MOVEPLOTTEDDATA.M with the given input arguments.
%
%      MOVEPLOTTEDDATA('Property','Value',...) creates a new MOVEPLOTTEDDATA or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before MovePlottedData_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to MovePlottedData_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help MovePlottedData

% Last Modified by GUIDE v2.5 27-Jul-2014 12:32:23

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @MovePlottedData_OpeningFcn, ...
                   'gui_OutputFcn',  @MovePlottedData_OutputFcn, ...
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


% --- Executes just before MovePlottedData is made visible.
function MovePlottedData_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to MovePlottedData (see VARARGIN)

% Choose default command line output for MovePlottedData
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

hold(handles.axes1,'on');

set(hObject, ...
    'WindowButtonDownFcn',   @mouseDownCallback, ...
    'WindowButtonUpFcn',     @mouseUpCallback,   ...
    'WindowButtonMotionFcn', @mouseMotionCallback); 

% UIWAIT makes MovePlottedData wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = MovePlottedData_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% define an array of colours
colours = {'b','r','g','k','m','y'};

% is the plot handles field defined for the handles structure?
if ~isfield(handles,'plotHandles');
    handles.plotHandles = [];
end

% determine the number of handles (a maximum of six are plotted)
numHandles = mod(length(handles.plotHandles),6);

% get the x and y data for the sine wave, offset by the number of handles
x   = -2*pi:0.01:2*pi;
y   = sin(x) + numHandles;

% plot the data
h   = plot(handles.axes1,x,y,colours{numHandles+1});

% update the plot handles to the array of plot handles
handles.plotHandles = [handles.plotHandles ; h];

% save the data
guidata(hObject,handles);

function mouseDownCallback(figHandle,varargin)

    % get the handles structure
    handles = guidata(figHandle);
    
    % get the position where the mouse button was pressed (not released)
    % within the GUI
    currentPoint = get(figHandle, 'CurrentPoint');
    x            = currentPoint(1,1);
    y            = currentPoint(1,2);
    
    % get the position of the axes within the GUI
    axesPos = get(handles.axes1,'Position');
    minx    = axesPos(1);
    miny    = axesPos(2);
    maxx    = minx + axesPos(3);
    maxy    = miny + axesPos(4);
    
    % is the mouse down event within the axes?
    if x>=minx && x<=maxx && y>=miny && y<=maxy 
        
        % do we have graphics objects?
        if isfield(handles,'plotHandles')
            
            % get the position of the mouse down event within the axes
            currentPoint = get(handles.axes1, 'CurrentPoint');
            x            = currentPoint(2,1);
            y            = currentPoint(2,2);
            
            % we are going to use the x and y data for each graphic object
            % and determine which one is closest to the mouse down event
            minDist      = Inf;
            minHndl      = 0;

           for k=1:length(handles.plotHandles)
               xData = get(handles.plotHandles(k),'XData');
               yData = get(handles.plotHandles(k),'YData');
               dist  = min((xData-x).^2+(yData-y).^2); 
           
               if dist<minDist
                   minHndl = handles.plotHandles(k);
                   minDist = dist;
               end
           end
        
           % if we have a graphics handle that is close to the mouse down
           % event/position, then save the data
           if minHndl~=0
               handles.mouseIsDown     = true;
               handles.movingPlotHndle = minHndl;
               handles.prevPoint       = [x y];
               guidata(figHandle,handles);
           end
        end
    end

function mouseUpCallback(figHandle,varargin)

    % get the handles structure
    handles = guidata(figHandle);
    
    if isfield(handles,'mouseIsDown')
        if handles.mouseIsDown
            % reset all moving graphic fields
            handles.mouseIsDown     = false;
            handles.movingPlotHndle = [];
            handles.prevPoint       = [];
            
            % save the data
            guidata(figHandle,handles);
        end
    end

function mouseMotionCallback(figHandle,varargin)

    % get the handles structure
    handles = guidata(figHandle);
    
    if isfield(handles,'mouseIsDown')
        
        if handles.mouseIsDown
            currentPoint = get(handles.axes1, 'CurrentPoint');
            x            = currentPoint(2,1);
            y            = currentPoint(2,2);

            % compute the displacement from previous position to current
            xDiff = x - handles.prevPoint(1);
            yDiff = y - handles.prevPoint(2);

            % adjust this for the data corresponding to movingPlotHndle
            xData = get(handles.movingPlotHndle,'XData');
            yData = get(handles.movingPlotHndle,'YData');

            set(handles.movingPlotHndle,'YData',yData+yDiff,'XData',xData+xDiff);

            handles.prevPoint = [x y];
            
            % save the data
            guidata(figHandle,handles);
        end
    end