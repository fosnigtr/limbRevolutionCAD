function [ model ] = addMoldKeys( hObject, model )
%ADDMOLDKEYS Summary of this function goes here
%   Detailed explanation goes here

% GET MODEL INFORMATION
data = model.data;
offset = model.guiMoldKeysOffset;

% TRANSLATE DISTAL END IN X AND Y
moldKeys(:,1) = moldKeys(:,1)+x; 
moldKeys(:,2) = moldKeys(:,2)+y;

% ADD DISTAL END
data = cat(2,data, moldKeys);

% UPDATE MODEL
model.data = data;
guidata( hObject, model );
end

