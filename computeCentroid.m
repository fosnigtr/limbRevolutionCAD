function [ model ] = computeCentroid( hObject, model )
%COMPUTECENTROID Summary of this function goes here
%   Detailed explanation goes here

% GET MODEL INFORMATION
data = model.data;

% COMPUTE CENTROID
x = mean(data(:,1));
y = mean(data(:,2));
z = mean(data(:,3));

% UPDATE DATA
model.centroidX = x;
model.centroidY = y;
model.centroidZ = z; 
guidata(hObject,model);
end

