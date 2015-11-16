function [ model ] = distalEndCup( hObject, model )
%DISTALENDCUP Summary of this function goes here
%   Detailed explanation goes here

% GET DATA INFORMATION
data = model.data;
numSlicePoints = model.numSlicePoints;
sliceHeights = model.sliceHeights;
numSliceHeights = size(sliceHeights,1);
angleStep = model.angleStep;
capSet = model.capSet;
numCapRadii = length(capSet);
capHeight = model.capHeight;

% INTIALIZE BUFFERS
height = zeros(numCapRadii,1);

% FIND OPTIMAL CAP
for idx = 0:numSliceHeights-1
    tmpR(idx+1) = mean(sqrt(sum(data(idx*numSlicePoints+1:numSlicePoints*(idx+1),1:2).^2,2)));
end
for idx = 1:numCapRadii;
    [minR, locR] = min(abs(tmpR-capSet(idx)));
    height(idx) = locR;
end

% GET CAP THAT MINIMIZES AMOUNT OF MODEL CUT AWAY
[foo idxCap] = min(abs(sliceHeights(height)-capHeight));
idxSliceHeight = height(idxCap);

% ROUND TO NEAREST SLICE HEIGHT
idxHeight = idxSliceHeight*numSlicePoints+1; 

% UPDATE INFORMATION
model.data = data(idxHeight:end,:);
model.sliceHeights = sliceHeights(idxSliceHeight+1:end);
model.distalEndDia = capSet(idxCap);
guidata(hObject,model);
end

