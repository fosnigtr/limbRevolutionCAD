function [ event ] = handleTouchMove( hObject, event )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

newX = event.clientX;
newY = event.clientY;

deltaX = newX - lastTouchX;
newRotationMatrix = rotx(deltaX / 10);

deltaY = newY - lastTouchY;
newRotationMatrix = newRotationMatrix * roty(deltaY / 10);

deltaZ = newZ - lastTouchZ;
newRotationMatrix = newRotationMatrix * roty(deltaZ / 10);

event.lastTouchX = newX;
event.lastTouchY = newY;

% UPDATE DATA
event.newRotationMatrix = newRotationMatrix;
guidata(hObject,event);
end

