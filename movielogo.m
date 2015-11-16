function [ ] = movielogo( )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
videoObj = VideoReader('.\LogoMovie.mp4');

nFrames = videoObj.NumberOfFrames;
vidHeight = videoObj.Height;
vidWidth = videoObj.Width;

% Preallocate movie structure.
mov(1:nFrames) = ...
    struct('cdata', zeros(vidHeight, vidWidth, 3, 'uint8'),...
    'colormap', []);

% Read one frame at a time.
for k = 1 : nFrames
    mov(k).cdata = read(videoObj, k);
end

h = figure; set(h,'menubar','none'); set(h,'Position', [241 272 960 266]);
set(h,'NumberTitle','off'); 

% Change icon
warning('off','MATLAB:HandleGraphics:ObsoletedProperty:JavaFrame');
jframe=get(h,'javaframe');
jIcon=javax.swing.ImageIcon('.\Logo.png');
jframe.setFigureIcon(jIcon);

% Play back the movie once at the video's frame rate.
movie(h, mov, 1, videoObj.FrameRate);
pause(1);

% Close logo video
close(h);
end

