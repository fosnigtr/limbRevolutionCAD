function [ interpdata ] = interpmodel( data, layer1 )

% data in the form: [z r]

slice_values = data(:,1);
slices = size(data,1);
slice_points = size(data,2)-2;
dtheta = 4;
theta = 0:dtheta:360/slice_points;
data  = data(:,2:end);
xi=zeros(ceil(slice_values(slices,1)),1);                               
layer_height_val = str2num(layer1.layer_height_val);

interpdata=zeros(length(xi),slice_points+1);

% Physical dimensioning
for idx=0:floor((slice_values(slices,1)-1)/layer_height_val)                    
    xi(1+idx,1)=idx*layer_height_val;                                       
end

% Interpolate
for idx=0:slice_points
    interpdata(:,idx+1)=interp1(slice_values(:,1),data(:,idx+1),xi);  
end
end

