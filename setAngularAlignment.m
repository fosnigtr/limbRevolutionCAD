function [ model ] = setAngularAlignment( hObject, model )
%SETANUGULARALIGNMENT Summary of this function goes here
%   Detailed explanation goes here
% Algorithm from Patent US7033327

% GET DATA
data = model.data;
modelCentroid = [model.centroidX model.centroidY model.centroidZ];
zUndo = model.zUndo;
sliceHeights = model.sliceHeights;
numPoints = size(data,1);

% DEFINE ICOSAHEDRON
[V, E, F] = createIcosahedron;
numFaces = size(F,1);
V = V+modelCentroid(3);

% CALCULATE FACE CENTROIDS
for idx = 1:numFaces
    faceCentroids(idx,:) = mean(V(F(idx,:),:),1);
end

% COMPUTE MOMENTS OF INTERIA ABOUT COORDINATE AXES
Ixx = sum(sum(data(:,[2,3]).^2,2),1); % moment of inertia about x-axis
Iyy = sum(sum(data(:,[3,1]).^2,2),1); % moment of inertia about y-axis
Izz = sum(sum(data(:,[1,2]).^2,2),1); % moment of inertia about z-axis

% COMPUTE PRODUCTS OF INERTIA
Ixy = -sum(prod(data(:,[1,2]),2),1); Iyx = Ixy;
Iyz = -sum(prod(data(:,[2,3]),2),1); Izy = Iyz;
Ixz = -sum(prod(data(:,[1,3]),2),1); Izx = Ixz;

% CONTRUCT MOMENT OF INTERIA TENSOR
I = [Ixx, Ixy, Ixz;...
    Iyx, Iyy, Iyz;...
    Izx, Izy, Izz];

% CACULATE MOMENT OF THE MODEL ABOUT EACH AXIS LINE
for idx = 1:numFaces
    nHat = faceCentroids(idx,:)/norm(faceCentroids(idx,:));
    moments(idx) = nHat*I*nHat';
end

% FIND MOMENT MINIMIZING AXIS AND THE ASSOCIATED AXIS
[minMoment, locMinMoment] = min(abs(moments));
momentMinAxis = faceCentroids(locMinMoment,:);

% DETERMINE TRIANGLE VERTEX LINE
vertexLine = V(F(locMinMoment,1),:);

% DETERMINE ANGLE OF ACCURACY
cosTheta = dot(vertexLine,momentMinAxis)...
    /(norm(vertexLine)*norm(momentMinAxis));
theta = acosd(cosTheta);

% DETERMINE IF ANGLE FOR ROTATION IS GOOD ENOUGH
theta0 = model.guiTheta0; 
% while theta0 <= theta
%     
%     % GET FACE VERTICES FOR MOMENT MINIMIZING AXIS
%     v0 = vertexLine;
%     v1 = V(F(locMinMoment,2));
%     v2 = V(F(locMinMoment,3));
%     sphereRadius = abs(v1);
%     
%     % COMPUTE MIDPOINTS
%     m01 = (v0+v1)/2;
%     m12 = (v1+v2)/2;
%     m20 = (v2+v0)/2;
%     
%     % DEFINE NEW VERTICES
%     V = cat(1,v0,v1,v2,m01,m12,m20);
%     
%     % COMPUTE RAISED MIDPOINTS
%     m01Raised = m01 + (m01 - (m01/norm(m01).*sphereRadius));
%     m12Raised = m12 + (m12 - (m12/norm(m01).*sphereRadius));
%     m20Raised = m20 + (m20 - (m20/norm(m20).*sphereRadius));
%     
%     % DEFINE DOME TRIANGLES
%     T0 = cat(1, v1, m01Raised, m12Raised);
%     T1 = cat(1, m01Raised, m12Raised, m20Raised);
%     T2 = cat(1, m12Raised, m20Raised, v2);
%     T3 = cat(1, m01Raised, m20Raised, v0);
%     F = [1, 4, 5;...
%         4, 5, 6;...
%         5, 6, 3;...
%         4, 6, 2];
%     
%     % COMPUTE DOME TRIANGLES CENTROIDS
%     centroidT = cat(1, mean(T0,1), mean(T1,1),...
%         mean(T2,1), mean(T3,1));
%     
%     % CACULATE MOMENT FOR EACH AXIS LINE
%     for idx = 1:4
%         moments(idx) = abs(modelCentroid .* centroidT(idx,:));
%     end
%     
%     % FIND MOMENT MINIMIZING AXIS AND THE ASSOCIATED AXIS
%     [minMoment, locMinMoment] = min(abs(moments));
%     momentMinAxis = centroidT(locMinMoment,:);
%     
%     % DETERMINE TRIANGLE VERTEX LINE
%     vertexLine = V(F(locMinMoment,1));
%     
%     % DETERMINE ANGLE OF ACCURACY
%     cosTheta = dot(vertexLine,momentMinAxis)...
%         /(norm(vertexLine)*norm(momentMinAxis));
%     theta = acosd(cosTheta);
% end

% COMPUTE AXIS ANGLE BETWEEN TWO VECTORS
% (http://stackoverflow.com/questions/15101103/euler-angles-between-two-3d-vectors0
momentMinAxis = momentMinAxis/norm(momentMinAxis); % normalized vector
modelCentroid = modelCentroid/norm(modelCentroid); % normalized vector
v = cross(momentMinAxis,modelCentroid); % axis of rotation
angle = dot(momentMinAxis,modelCentroid)...
    /(norm(momentMinAxis)*norm(modelCentroid)); % angle of rotation

% CONVERT AXIS-ANGLE TO EULER ANGLES ALPHA, BETA, AND GAMMA
% (WWW.EUCLIDEANSPACE.COM)
s = sin(angle); c = cos(angle); t = 1 - c;
x = v(1); y = v(2); z = v(3);
% north pole singularity detected
if ((x*y*t + z*s) > 0.998)
		alpha = 0;
        beta = 2*atan2(x*sin(angle/2),cos(angle/2));
		gamma = pi/2;
% south pole singularity detected
elseif ((x*y*t + z*s) < -0.998) 
		alpha = 0;
        beta = -2*atan2(x*sin(angle/2),cos(angle/2));
		gamma = -pi/2;
else
    alpha = atan2(x*s-y*z*(1-c),1-(x^2+z^2)*(1-c)); % bank
    beta = atan2(y*s-x*y*(1-c),1-(y^2+z^2)*(1-c)); % heading
    gamma = asin(x*y*(1-c)+z*s); % attitude
end

% COMPUTE ROTATION MATRIX 
R = rotx(alpha*180/pi)*roty(beta*180/pi)*rotz(gamma*180/pi);

% MAKE MOMENT MINIMIZING AXIS THE MODEL CENTROID 
for idx = 1:size(data,1);
    data(idx,:) = R*data(idx,:)';
end

% TRANSLATE MODEL DISTAL END TO ORIGIN
data(:,3) = data(:,3) - min(data(:,3)); 

% SMOOTH OUT HEIGHT DATA
numSliceHeights = length(sliceHeights);
x = (1:size(data,1))';
b = x\data(:,3); 
data(:,3) = x * b - b;
sliceHeights = linspace(0,data(end,3),numSliceHeights);

% UPDATE DATA
model.sliceHeights = sliceHeights;
model.data = data;
guidata(hObject,model);
end

