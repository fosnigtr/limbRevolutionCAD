clear all; close all;
cd('C:\Users\Tyler Fosnight\Documents\Tyler Documents\PDI\CAD');
load('innerMold.mat');

% MESH
numSlices = length(model.sliceHeights);
numFaces = (model.numSlicePoints-1)*(numSlices-1);
% f = bsxfun(@plus, ones(model.numSlicePoints*(length(model.sliceHeights)-1)-1,4),...
%     (0:(model.numSlicePoints*(length(model.sliceHeights)-1)-2))');
% f = bsxfun(@plus,f,[0,1,model.numSlicePoints,1+model.numSlicePoints]);
f = bsxfun(@plus, ones(numFaces,4),(0:numFaces-1)');
f = bsxfun(@plus,f,[0,1,1+model.numSlicePoints,model.numSlicePoints]);

% n = 1;
% while n < model.numSlicePoints*(length(model.sliceHeights)-1)
%     ft(n,:) = [n, n+1, n+model.numSlicePoints, 1+n+model.numSlicePoints];
%     n = n + 1;
% end

% n = model.data;
% clear scene
% scene.Vertices = n;
% scene.Faces = f;
% scene.FaceColor = 'Flat';
% scene.EdgeColor = 'none';
% % scene.FaceAlpha = .5;
% % scene.FaceLighting = 'gouraud';
% % scene.BackFaceLighting = 'lit';
% scene.CData = 1:size(scene.Faces,1);
% scene.CDataMapping = 'scaled';
% R = rotx(45);
% fig = figure(1);
% cmap = colormap(hot);
% set(fig,'colormap',cmap);
% 
% % INITIALIZE CANVAS
% axes1 = axes('Parent',fig,...
%     'Color',[0.247058823529412 0.247058823529412 0.247058823529412],...
%     'ZColor',[0 0 0],...
%     'YColor',[0 0 0],...
%     'XColor',[0 0 0],...
%     'GridAlpha',1,...
%     'GridColor',[0 0 0]);
% box(axes1,'on');
% grid(axes1,'on');
% hold(axes1,'on');
% p1 = patch(scene);
% 
% % ROTATE OBJECT
% for idx = 1:90
% newRotationMatrix = rotz(idx) * R;
% for idx = 1:size(scene.Vertices,1)
%     scene.Vertices(idx,:) = scene.Vertices(idx,:) * newRotationMatrix;
% end
% set(p1,'vertices',scene.Vertices);
% drawnow
% end


fig = figure(1);
set(fig,'color',[0.192156862745098 0.188235294117647 0.188235294117647]);
% set(fig'position', [2590 -98  637 877]);
set(fig,'position', [2545 -248 617 883]);
% set(fig,'MenuBar','none');
% set(fig,'ToolBar','none');
set(fig,'name','limbRevolution.CAD');
set(fig,'NumberTitle','off');
cmap = colormap(hot); set(fig,'colormap',cmap);

% INITIALIZE AXES
object.axes1 = axes('Parent',fig,...
    'Color',[0.247058823529412 0.247058823529412 0.247058823529412],...
    'ZColor',[0 0 0],...
    'YColor',[0 0 0],...
    'XColor',[0 0 0],...
    'GridAlpha',1,...
    'GridColor',[0 0 0]);
box(object.axes1,'on');
grid(object.axes1,'on');
hold(object.axes1,'on');

for idx = 1:size(model.data,1)
    model.data(idx,:) = model.data(idx,:) * rotx(90);
end

% COMPUTE AVERAGE LOCAL SLOPE
tmpData = reshape(model.data(:,1:2),model.numSlicePoints,numSlices,2);
d1 = abs(diff(tmpData,1)); 
d2 = abs(diff(tmpData,1,2));
% slope = (d1(:,1:numSlices-1,1) + d2(1:model.numSlicePoints-1,:,1))./2;
% slope = sqrt(sum(slope.^2,3));
slope = reshape(d2(1:89,:,1),1,numFaces);
% slope = reshape(d1(:,1:108,1),1,numFaces);

p1 = patch('Faces',f,'Vertices',model.data);
set(p1,'FaceColor','Flat');
set(p1,'EdgeColor','none');
set(p1,'CData',slope);
% set(p1,'CData',1:size(f,1));
set(p1,'CDataMapping','scaled');

% R = rotx(45);
% % ROTATE OBJECT
% for idx = 1:90
% newRotationMatrix = rotz(idx) * R;
% for idx = 1:size(model.data,1)
%     model.data(idx,:) = model.data(idx,:) * newRotationMatrix;
% end
% set(p1,'vertices',model.data);
% drawnow
% end