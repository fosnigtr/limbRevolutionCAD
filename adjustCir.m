function adjustCir( hObject )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
model = guidata(hObject);

numSlices = length(model.sliceHeights);

if size(model.guiPerRed,1) ==  1
    tmpData = reshape(model.data(:,1:2),model.numSlicePoints,numSlices,2);
    tmpData = bsxfun(@times,tmpData,model.guiPerRed);
    model.data(:,1:2) = reshape(tmpData,model.numSlicePoints*numSlices,2);
else
    model.data(:,1:2) = model.data(:,1:2) .* model.guiPerRed;
end

% SAVE DATA
guidata(hObject,model);
end

