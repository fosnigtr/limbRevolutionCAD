function computeCentroid( hObject )
%COMPUTECENTROID Summary of this function goes here
%   Detailed explanation goes here
model = guidata(hObject);

% COMPUTE CENTROID
model.centroid = mean(model.data,1);

% UPDATE DATA
guidata(hObject,model);
end

