function drawScene( hObject )
object = guidata(hObject);

% ROTATE OBJECT
% for idx = 1:object.numSliceHeights
%     object.sceneData(idx,:) = object.sceneData(idx,:) * object.newRotationMatrix;
% end


% xlim([object.minX, object.maxX]); ylim([object.minY, object.maxY]);
camorbit( , );
% set(object.handlePatch,'vertices',object.sceneData(:,:,1));
% drawnow;
% set(gca,'XTickLabel',''); set(gca,'YTickLabel','');

% SAVE DATA
guidata(hObject,object);
end

