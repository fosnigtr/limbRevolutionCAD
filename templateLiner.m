% function templateLiner()
% LINER TEMPLATE
clear all; close all;
cd('C:\Users\Tyler Fosnight\Documents\Tyler Documents\PDI\CAD');
% javax.swing.UIManager.setLookAndFeel('javax.swing.plaf.nimbus.NimbusLookAndFeel');

%% INITIALIZE BUFFER
model = struct;

%% MAKE DUMMY GUI FOR TESTING
hObject = figure(1); title('Dummy GUI');
set(hObject,'Position', [1393 551 550 0]);

%% GET .AOP FILE
model = getAopFile( hObject, model );

%% READ .AOP FILE
model = readAopFile( hObject, model );

%% UPDATE MODEL HORIZONTAL ALINGMENT
model = computeCentroid( hObject, model );

% UPDATE DATA
model.data(:,1) = model.data(:,1)-model.centroidX;
model.data(:,2) = model.data(:,2)-model.centroidY;
model.data(:,3) = model.data(:,3)-model.centroidZ;
model.zUndo = model.centroidZ;

% UPDATE MODEL CENTROID
model = computeCentroid( hObject, model );

%% UPDATE ANGULAR ALINGMENT
% *************************CHECK WITH BRAD*********************************
% When he does the angular alignment does he look at the entire model or
% the bottom third, quarter, or etc.
% Note: Finish debugging accuracy algorithm
% *************************************************************************
% USER DEFINED VARIABLES
model.guiTheta0 = 1; % degrees
mouseX = 'default'; mouseY = mouseX; mouseZ = mouseX;
model = setAngularAlignment( hObject, model );

%% PREPARE INNER MOLD DISTAL END
%***************************CHECK WITH BRAD********************************
% Get the cap height from Brad.
%**************************************************************************
% USER DEFINED VARIABLES
cap1 = 32; cap2 = 39.5; cap3 = 45; % mm
model.capHeight = 25; % mm
model.capSet = cat(2 ,cap1, cap2, cap3);

model = addDistalEndCup( hObject, model );

save('innerMold.mat','model');
%% APPLY CIRCUMFERENCIAL REDUCTION
% GET DATA INFORMATION
data = model.data;
numSlicePoints = model.numSlicePoints;
sliceHeights = model.sliceHeights;
numSliceHeights = size(sliceHeights,1);

tmp = floor(max(sliceHeights/50));
step = tmp/numSliceHeights;
cirReduction = 1-((step:step:tmp)/100);

% APPLY PERCENT CIRCUMFERENCIAL REDUCTION
for idx = 0:numSliceHeights-1
    data(idx*numSlicePoints+1:numSlicePoints*(idx+1),1:2) = ...
        data(idx*numSlicePoints+1:numSlicePoints*(idx+1),1:2).*cirReduction(idx+1);
end

% UPDATE DATA
model.data = data;

%% EXTEND MODEL
% USER DEFINED VALUES
% Estimated error =
modelHeight = model.data(end,3);
model.guiZEnvelope = 563;
model.guiExtend = model.guiZEnvelope - modelHeight; % 563 mm is the printer z envelope
model.guiExtendPoint1 = [0 0 modelHeight];
model.guiExtendPoint2 = [0 0 modelHeight];

% EXTEND MODEL
model = extendModel( hObject, model );

%% SAVE MODEL
save('outerMold.mat','model');

%% ADD MOLD KEYS
% USER DEFINED VALUES
model.guiMoldKeysOffset = 20; % mm

data = model.data;
point1 = model.guiExtendPoint1(3);
point2 = model.data(:,end);
zEnvelope = model.guiZEnvelope;
sliceHeights = model.sliceHeights; % unit
numSlicePoints = model.numSlicePoints; % points
offset = model.guiMoldKeysOffset;
numSlice = length(sliceHeights); % points
slicePerStep = mean(diff(sliceHeights)); % unit per step
angleIdx = [1, round(numSlicePoints*.25),round(numSlicePoints*.75), numSlicePoints];

point1 = round(point1 / slicePerStep);
point2 = round(zEnvelope / slicePerStep);
n = point2 - point1;
y = linspace(1,300,n);
model.cirReduction = offset/log10(300)*log10(y);

idx2 = 1;
for idx = point1:point2
    window = idx/slicePerStep*numSlicePoints+1:numSlicePoints*(idx/slicePerStep+1);
    window = window(angleIdx);
    data(window,1:2) = data(window,1:2)+cirReduction(idx2);
    idx2 = idx2 + 1;
end

% model = addMoldKeys( hObject, model );

%% SAVE INNER MOLD

%% EXTEND MOLD TO 600 MM
% USER DEFINED VALUES
maxheight = 600; % mm
landmark = [25 200]; % mm

% GET DATA INFORMATION
data = model.data;
height = max(data(:,3)); % mm
adjParamExtend = maxheight - height; % mm

% CHECK THAT THE MODEL WILL FIT IN PRINTER ENVOLPE
if adjParamExtend < 0
    warning('Mold height too large');
end

% UPDATE DATA
model.landmark = landmark; % mm
model.adjParamExtend = adjParamExtend; % mm

% EXTEND MOLD
model = adjustExtend(model);

%% APPLY LINER THICKNESS PROFILE
% USER DEFINED VALUES
landmarks = [25 50]; % mm
adjParamCir = [5 5]; % percent
landMarkIncrement = 50; % mm
adjParamCir = 0; % percent

% GET DATA
data = model.data;
height = max(data(:,3)); % mm
foo = height - 50; % mm

% ADD LANDMARKS
idxLandmark = 50; % mm
idxAdjParamCir = 5; % percent
while idxLandMark <= height
    idxLandMark = idxLandMark + landMarkIncrement;
    idxAdjParamCir = idxAdjParamCir + idxAdjParamCirIncrement;
    adjParamCir = cat(2,adjParamCir,idxAdjParamCir);
    landmarks = cat(2,landmarks,idxLandMark);
end

% UPDATE DATA
model.landmarks = landmarks; % array of landmark heights (mm)
model.adjParamCir = adjParamCir; % array of percents circumference reduction

% ADJUST CIRCUMFERENCE
model = adjustCircumference(model);

%% PREPAPRE OUTER MOLD DISTAL END
%model = addDistalEnd( hObject, model );

%% SAVE OUT MOLD

%% CENTER MODEL
% model.data = centermodel(model.data);

%% INTERPOLATE MODEL DATA
% Fix errors by reverting to backup version
% model.interpdata = interpmodel(model.data,model.layer1);

%% NOTES
% Allow the user to make their own templates and save them for later use
