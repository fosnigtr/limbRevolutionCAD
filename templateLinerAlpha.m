function templateLinerAlpha( hObject, model )
%% UPDATE MODEL HORIZONTAL ALINGMENT
model = computeCentroid( hObject, model );

% UPDATE DATA
model.data = bsxfun(@minus,model.data,model.centroid);
model.zUndo = model.centroid(3);

% UPDATE MODEL CENTROID
model = computeCentroid( hObject, model );

%% UPDATE ANGULAR ALINGMENT
% *************************CHECK WITH BRAD*********************************
% When he does the angular alignment does he look at the entire model or
% the bottom third, quarter, or etc.
% Note: Finish debugging accuracy algorithm
% *************************************************************************
model.guiTheta0 = 5;
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

%% APPLY CIRCUMFERENCIAL REDUCTION
% GET DATA INFORMATION
numSlices = length(model.sliceHeights);
model.dxLandMark = 50;

model.guiLandMarks = model.sliceHeights(1):model.dxLandMark:floor(max(model.sliceHeights));
model.guiPerRed = 1;
for idx = 1:length(model.guiLandMarks)-1
    model.guiPerRed(idx+1) = model.guiPerRed(idx) - .01; 
end
model.guiPerRed = cat(2, model.guiPerRed, mean(diff(model.guiPerRed))...
    /model.dxLandMark * max(model.sliceHeights) + 1);
model.guiLandMarks = cat(2, model.guiLandMarks, max(model.sliceHeights));
model.guiPerRed = interpn(model.guiLandMarks,model.guiPerRed,model.sliceHeights);

model = adjustCir( hObject, model );

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

%% ADD MOLD KEYS
% USER DEFINED VALUES
model.guiMoldKeysOffSet = 20; % mm

% ADD MOLDE KEYS
model = addMoldKeys( hObject, model );

%% SAVE INNER MOLD
guidata(hObject,model);
innerMold = model.data;
uisave('innerModel');

% %% EXTEND MOLD TO 600 MM
% % USER DEFINED VALUES
% maxheight = 600; % mm
% landmark = [25 200]; % mm
% 
% % GET DATA INFORMATION
% data = model.data;
% height = max(data(:,3)); % mm
% adjParamExtend = maxheight - height; % mm
% 
% % CHECK THAT THE MODEL WILL FIT IN PRINTER ENVOLPE
% if adjParamExtend < 0
%     warning('Mold height too large');
% end
% 
% % UPDATE DATA
% model.landmark = landmark; % mm
% model.adjParamExtend = adjParamExtend; % mm
% 
% % EXTEND MOLD
% model = adjustExtend(model);
% 
% %% APPLY LINER THICKNESS PROFILE
% % USER DEFINED VALUES
% landmarks = [25 50]; % mm
% adjParamCir = [5 5]; % percent
% landMarkIncrement = 50; % mm
% adjParamCir = 0; % percent
% 
% % GET DATA
% data = model.data;
% height = max(data(:,3)); % mm
% foo = height - 50; % mm
% 
% % ADD LANDMARKS
% idxLandmark = 50; % mm
% idxAdjParamCir = 5; % percent
% while idxLandMark <= height
%     idxLandMark = idxLandMark + landMarkIncrement;
%     idxAdjParamCir = idxAdjParamCir + idxAdjParamCirIncrement;
%     adjParamCir = cat(2,adjParamCir,idxAdjParamCir);
%     landmarks = cat(2,landmarks,idxLandMark);
% end
% 
% % UPDATE DATA
% model.landmarks = landmarks; % array of landmark heights (mm)
% model.adjParamCir = adjParamCir; % array of percents circumference reduction
% 
% % ADJUST CIRCUMFERENCE
% model = adjustCircumference(model);

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
