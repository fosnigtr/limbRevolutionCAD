function [ guiPos ] = slider( )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
% object = guidata(object);

hObject = figure;
name = 'Cylindical Alingment';
set(hSlider,'color',[0.192156862745098 0.188235294117647 0.188235294117647]);
set(hSlider,'name','limbRevolution.CAD');
set(hSlider,'NumberTitle','off');
set(hSlider,'MenuBar','none');
set(hSlider,'ToolBar','none');
set(hSlider,'Position',[2738 695 329 112]);

% UI SLIDER
h = uicontrol('style','slider','units',...
    'pixel','position',[15 20 300 20],...
    'Callback',@sliderCallBack);

% Add a text uicontrol to label the slider.
txt = uicontrol('Style','text',...
    'Position',[15 50 300 20],...
    'String',name);

% GET DATA 
guiPos = guidata(hObject);
end

function sliderCallBack( hObject, handle )
    event = guidata(hObject);
    event.guiPos = handle.Source.Value;
    guidata(hObject,event);
end

