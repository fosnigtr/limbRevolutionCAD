function [ model ] = addDistalEnd( model )
%ADDDISTALEND Summary of this function goes here
%   Detailed explanation goes here

% GET MODEL INFORMATION
data = model.data;
diameter = model.cylinAdapDia;
height = model.cyclinAdapHeight;
x = model.cyclinAdapX;
y = model.cyclinAdapY;

% ADD CYCLINDRICAL ADAPTER
win = round(landmark(:,3))*numSlices+1:round(landmark(:,3))*numSlices;
adjustPerSlice = adjust./diff(landmark(:,3))./thicknessSlice;
data(win,:) = data(win,:)+adjustPerSlice;

% UPDATE MODEL
model.data = data;

end

