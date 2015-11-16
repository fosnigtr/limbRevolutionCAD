function drawSceneAssembly( hObject )
object = guidata(hObject);

% ROTATE ASSEMBLY
for idx = 1:object.numSliceHeights
    object.data(idx,:,1) = object.data(idx,:,1) * object.newRotationMatrix;
    object.data(idx,:,2) = object.data(idx,:,2) * object.newRotationMatrix;
end

% DRAW SCENE
axes1 = axes('Parent',hObject,...
    'Color',[0.247058823529412 0.247058823529412 0.247058823529412],...
    'ZColor',[0 0 0],...
    'YColor',[0 0 0],...
    'XColor',[0 0 0],...
    'GridAlpha',1,...
    'GridColor',[0 0 0]);
box(axes1,'on');
grid(axes1,'on');
hold(axes1,'on');
xlim([object.minX, object.maxX]); ylim([object.minY, object.maxY]);
plot(axes1,object.data(:,1,1),object.data(:,3,1),...
    object.data(:,1,2),object.data(:,3,2),...
    'LineWidth',2);
pause(.0001);
set(gca,'XTickLabel',''); set(gca,'YTickLabel','');

% SAVE DATA
guidata(hObject,object);
end

