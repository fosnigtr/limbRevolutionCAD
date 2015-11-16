function [ model ] = extendModel( hObject, model )
%EXTENDMODEL Summary of this function goes here
%   Detailed explanation goes here

% GET MODEL INFORMATION
data = model.data; % unit
sliceHeights = model.sliceHeights; % unit
extend = model.guiExtend; % unit
point1 = model.guiExtendPoint1(3); % unit
point2 = model.guiExtendPoint2(3); % unit
numSlicePoints = model.numSlicePoints; % points
numSlice = length(sliceHeights); % points
slicePerStep = mean(diff(sliceHeights)); % unit per step

% EXTEND MODEL
if point1 == point2
    % get last slice data
    tmpData = data((numSlice-1)*numSlicePoints+1:end,:); 
    % get new heights for extension
    tmpSliceHeights = sliceHeights(end)+slicePerStep:slicePerStep:extend+sliceHeights(end); 
    for idx = 1:length(tmpSliceHeights)
        tmpData(:,3) = tmpSliceHeights(idx);
        data = cat(1,data,tmpData);
    end
    sliceHeights = cat(2,sliceHeights,tmpSliceHeights);
else
    %**********************NEEDS CHECKING****************************%
    xx = point1/slicePerStep:slicePerStep:(point2-point1+extend)/slicePerStep;  % new section length
    point1 = round(point1 *slicePerStep * numSlicePoints);
    point2 = round(point2 *slicePerStep * numSlicePoints);
    window = point1:point2;
    
    tmpData = reshape(data(window,:),lenght(window),numSlicePoints);
    tmpData = spline(tmpData,xx);
    
    data = cat(1,data(1:window(1)-1,:), tmpData, data(window(2)+1,:)); 
end

% UPDATE MODEL
model.data = data;
model.sliceHeights = sliceHeights;
guidata(hObject,model);
end