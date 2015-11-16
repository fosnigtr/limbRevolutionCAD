function plot2D( hObject, model )
%PLOT2D Summary of this function goes here
%   Detailed explanation goes here

% GET DATA INFORMATION
data = model.data;

% GET PROFILE
y = data(:,3);
x = data(:,1);

% UPDATE IMAGE
texture = [181/255,120/255,0/255];
h=figure(2)
plot(x,y,'color',texture);
% set(h,'AlignVertexCenters','off');
box on;
grid on; 
xlabel('Width (mm)');
ylabel('Height (mm)');
axis equal; 
set(gcf,'color','W');
end

