function [ model ] = addDistalEndCup( hObject, model )
%DISTALENDCUP Summary of this function goes here
%   Detailed explanation goes here

% GET DATA INFORMATION
data = model.data;
numSlicePoints = model.numSlicePoints;
sliceHeights = model.sliceHeights;
numSliceHeights = length(sliceHeights);
angleStep = model.angleStep;
capSet = model.capSet;
numCapRadii = length(capSet);
capHeight = model.capHeight;

% INTIALIZE BUFFERS
idxHeight = zeros(numCapRadii,1);

% FIND OPTIMAL CAP
for idx = 0:numSliceHeights-1
    tmpR(idx+1) = mean(sqrt(sum(data(idx*numSlicePoints+1:numSlicePoints*(idx+1),1:2).^2,2)));
end
for idx = 1:numCapRadii;
    [minR, locR] = min(abs(tmpR-capSet(idx)));
    idxHeight(idx) = locR;
end

% GET CAP THAT MINIMIZES HEIGHT ERROR
[foo idxCap] = min(abs(sliceHeights(idxHeight)-capHeight));
idxSliceHeight = idxHeight(idxCap);

% ROUND TO NEAREST SLICE HEIGHT
idxHeight = (idxSliceHeight-1)*numSlicePoints+1; 

% UPDATE INFORMATION
model.data = data(idxHeight:end,:);
model.sliceHeights = sliceHeights(idxSliceHeight:end);
model.distalEndDia = capSet(idxCap);
guidata(hObject,model);
end

