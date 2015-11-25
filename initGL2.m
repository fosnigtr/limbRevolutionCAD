function initGL2(model)
object.data = model.data;

% DETERMINE IF THIS IS A SINGLE PART OR ASSEMBLY
if size(object.data,3) == 1
    object.assembly = false;
elseif size(object.data,3) == 2
    object.assembly = true;
end

% INITIALIZE CANVAS
hObject = figure(1);
set(hObject,'color',[0.192156862745098 0.188235294117647 0.188235294117647]);
% set(hObject,'position', [2590 -98  637 877]);
set(hObject,'position', [2545 -248 617 883]);
set(hObject,'MenuBar','none');
set(hObject,'ToolBar','none');
set(hObject,'name','limbRevolution.CAD');
set(hObject,'NumberTitle','off');
cmap = colormap(hot); set(hObject,'colormap',cmap);

% INITIALIZE AXES
object.axes1 = axes('Parent',hObject,...
    'Color',[0.247058823529412 0.247058823529412 0.247058823529412],...
    'ZColor',[0 0 0],...
    'YColor',[0 0 0],...
    'XColor',[0 0 0],...
    'GridAlpha',1,...
    'GridColor',[0 0 0]);
box(object.axes1,'on');
set(object.axes1,'XTickLabel',''); 
set(object.axes1,'YTickLabel','');
grid(object.axes1,'on');
hold(object.axes1,'on');

% SET VIEW PORT
%****************change these so they're not hard coded in*****************
object.minX = -100; object.homeMinX = object.minX;
object.maxX = 100; object.homeMaxX = object.maxX;
object.minY = 0; object.homeMinY = object.minY;
object.maxY = 223; object.homeMaxY = object.maxY;
xlim([object.minX, object.maxX]); ylim([object.minY, object.maxY]);
%**************************************************************************

% SET HOME
object.numSliceHeights = size(model.data,1);
object.newRotationMatrix = rotx(45);
for idx = 1:object.numSliceHeights
    object.data(idx,:) = object.data(idx,:) * object.newRotationMatrix;
end

% object.newRotationMatrix = eye(3,3);
object.homeData = object.data;

% MESH MODEL (USE SQUARE AS PRIMITIVE SHAPE, DESIGNATE NORMAL POINTING OUTWARD)
object.faces = bsxfun(@plus, ones(model.numSlicePoints*(length(model.sliceHeights)-1)-1,4),...
    (0:(model.numSlicePoints*(length(model.sliceHeights)-1)-2))');
object.faces = bsxfun(@plus,object.faces,[0,1,1+model.numSlicePoints,model.numSlicePoints]);

% INITIALIZE PATCH
object.handlePatch = patch('Faces',object.faces,'Vertices',object.data);
light('Position',[0 0 300],'Style','infinite')
% [0.870588235294118 0.623529411764706 0.0431372549019608] - model color
% [0 0 0] - model black
% [0 106/255 255/255] - assembly color
set(object.handlePatch,'FaceColor',[.2 .2 .2]);
set(object.handlePatch,'FaceLighting','gouraud');
% set(object.handlePatch,'BackFaceLighting','lit');
set(object.handlePatch,'EdgeColor',[0 0 0]);
% set(object.handlePatch,'EdgeColor',[0.870588235294118 0.623529411764706 0.0431372549019608]);
% set(object.handlePatch,'LineStyle',':');
set(object.handlePatch,'FaceAlpha',1);
set(object.handlePatch,'EdgeAlpha',1);
% set(object.handlePatch,'EdgeLighting','flat');
% set(object.handlePatch,'CData',1:size(object.data,1));
% set(object.handlePatch,'CDataMapping','scaled');

% object.data(:,1:2,2) = object.data(:,1:2) *.8;
% object.data(:,3,2) = object.data(:,3,1);
% 
% object.handlePatch2 = patch('Faces',object.faces,'Vertices',object.data(:,:,2));
% light('Position',[0 -300 0],'Style','infinite')
% % [0.870588235294118 0.623529411764706 0.0431372549019608]
% set(object.handlePatch2,'FaceColor',[255/255 85/255 0]);
% set(object.handlePatch2,'FaceLighting','gouraud');
% set(object.handlePatch2,'BackFaceLighting','lit');
% set(object.handlePatch2,'EdgeColor','none');
% % set(object.handlePatch,'EdgeColor',[0.870588235294118 0.623529411764706 0.0431372549019608]);
% % set(object.handlePatch,'LineStyle',':');
% set(object.handlePatch2,'FaceAlpha',1);
% set(object.handlePatch2,'EdgeAlpha',1);
% % set(object.handlePatch,'EdgeLighting','flat');
% % set(object.handlePatch,'CData',1:size(object.data,1));
% % set(object.handlePatch,'CDataMapping','scaled');

% SET UI CALLBACKS
set(hObject,'WindowButtonDownFcn',{@handleMouseDown});
set(hObject,'KeyPressFcn',{@handleKeyDown});
set(hObject,'KeyReleaseFcn',{@handleKeyUp});

% SAVE DATA
guidata(hObject,object);
tick(hObject);

function openModel( hObject )
object = guidata(hObject);

% LOAD MODEL
cd('C:\Users\Tyler Fosnight\Documents\Tyler Documents\PDI\CAD');
load('openGLTestExample.mat','model');
object.data = model.data; 
object.homeData = model.data;
object.numSliceHeights = size(model.data,1);
object.newRotationMatrix = eye(3,3);
object.assembly = false;

% SAVE DATA
guidata(hObject,object);
tick(hObject);

function openAssembly( hObject )
object = guidata(hObject);

% LOAD ASSEMBLY
cd('C:\Users\Tyler Fosnight\Documents\Tyler Documents\PDI\CAD');
load('innerMold.mat','model');
object.data = model.data;
load('innerMold2.mat','model');
object.data = cat(3,object.data,model.data);
object.homeData = object.data;
object.numSliceHeights = size(model.data,1);
object.newRotationMatrix = eye(3,3);
object.assembly = true;

% SAVE DATA
guidata(hObject,object);
tick(hObject);

function handleMouseDown( hObject, varArgIn )
object = guidata(hObject);
props.WindowButtonMotionFcn = get(hObject,'WindowButtonMotionFcn');
props.WindowButtonUpFcn = get(hObject,'WindowButtonUpFcn');
setappdata(hObject,'callBacks',props);
tmp = get(hObject,'CurrentPoint');
object.lastMouseX = tmp(1);
object.lastMouseY = tmp(2);
guidata(hObject, object);
set(hObject,'WindowButtonMotionFcn',{@handleMouseMove})
set(hObject,'WindowButtonUpFcn',{@handleMouseUp})

function handleMouseMove( hObject, varArgIn )
object = guidata(hObject);
tmp = get(hObject,'CurrentPoint');
object.newX = tmp(1);
object.newY = tmp(2);
deltaX = object.newX - object.lastMouseX;
deltaY = object.newY - object.lastMouseY;
object.newRotationMatrix = rotz(deltaX / 10) * rotx(deltaY / 10);
object.lastMouseX = object.newX;
object.lastMouseY = object.newY;
guidata(hObject, object);
tick(hObject);

function handleMouseUp( hObject, varArgIn )
object = guidata(hObject);
props = getappdata(hObject,'callBacks');
set(hObject,props);

function handleKeyDown( hObject, varArgIn )
object = guidata(hObject);
object.currentlyPressedKeys = varArgIn.Key;
guidata(hObject,object);
handleKeys(hObject);

function handleKeyUp( hObject, varArgIn )
object = guidata(hObject);
object.currentlyPressedKeys = false;
guidata(hObject,object);

function handleKeys( hObject )
object = guidata(hObject);
object.x = 0;
object.z = 0;
if strcmp(object.currentlyPressedKeys,'uparrow');
    object.x = 1;
elseif strcmp(object.currentlyPressedKeys,'downarrow');
    object.x = -1;
elseif strcmp(object.currentlyPressedKeys,'rightarrow');
    object.z = 1;
elseif strcmp(object.currentlyPressedKeys,'leftarrow');
    object.z = -1;
elseif strcmp(object.currentlyPressedKeys,'a');
    % anterior view (assume homeData is anterior view)
    object.data = object.homeData;
    object.minX = object.homeMinX; 
    object.maxX = object.homeMaxX;
    object.minY = object.homeMinY;
    object.maxY = object.homeMaxY;
elseif strcmp(object.currentlyPressedKeys,'p');
    % posterior view
    object.data = object.homeData;
    object.z = 180;
    object.data = object.homeData;
    object.minX = object.homeMinX; 
    object.maxX = object.homeMaxX;
    object.minY = object.homeMinY;
    object.maxY = object.homeMaxY;
elseif strcmp(object.currentlyPressedKeys,'m');
    % medial view (assume right leg)
    object.data = object.homeData;
    object.z = -45;
    object.data = object.homeData;
    object.minX = object.homeMinX; 
    object.maxX = object.homeMaxX;
    object.minY = object.homeMinY;
    object.maxY = object.homeMaxY;
elseif strcmp(object.currentlyPressedKeys,'l');
    % lateral view (assume right leg)
    object.data = object.homeData;
    object.z = 45;
    object.data = object.homeData;
    object.minX = object.homeMinX; 
    object.maxX = object.homeMaxX;
    object.minY = object.homeMinY;
    object.maxY = object.homeMaxY;
elseif strcmp(object.currentlyPressedKeys,'d');
    % distal view
    object.data = object.homeData;
    object.x = 90;
    object.minX = object.homeMinX; 
    object.maxX = object.homeMaxX;
    object.minY = object.homeMinX;
    object.maxY = object.homeMaxX;
elseif strcmp(object.currentlyPressedKeys,'s');
    % superior/proximal view 
    object.data = object.homeData;
    object.x = -90;
    object.minX = object.homeMinX; 
    object.maxX = object.homeMaxX;
    object.minY = object.homeMinX;
    object.maxY = object.homeMaxX;
elseif strcmp(object.currentlyPressedKeys,'add');
    object.minX = object.minX + 10;
    object.maxX = object.maxX - 10;
    object.maxY = object.maxY - 10;
elseif strcmp(object.currentlyPressedKeys,'subtract');
    object.minX = object.minX - 10;
    object.maxX = object.maxX + 10;
    object.maxY = object.maxY + 10;
end
object.newRotationMatrix = roty(object.z)*rotx(object.x);
guidata(hObject,object);
tick(hObject);

function tick( hObject )
object = guidata(hObject);
if object.assembly
    drawSceneAssembly(hObject);
elseif ~object.assembly
    drawScene(hObject);
end

