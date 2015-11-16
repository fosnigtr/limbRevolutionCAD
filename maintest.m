clear all; close all;
% cd('C:\Users\Tyler Fosnight\Documents\Tyler Doc\PDI');

%% Copy right protection
% CHECK THE LICENSE ON 11/01/2015
flag = crprotection();

%% Structure
if flag == 0
    model = struct('file','struct',...
        'category','char',...
        'surface','char',...
        'layer1','struct',...
        'thickness_choice','char',...
        'data','double',...
        'datainter','double');
    
    %% Get .aop file
    model.file = getaopfile();
    
    %% Get model category
    model.category = getmodel();
    
    %% Get surface category
    model.surface = getsurface();
    
    %% Get layer1
    model.layer1 = getlayer1();
    
    %% Get layer2
    model.thickness_choice = getlayer2();
    
    %% Read aop file
    model.data = readaopfile(model.file);
    
    %% Center model data
    % model.data = centermodel(model.data);
    
    %% Interpolate model data
    % Fix errors by reverting to backup version
    model.interpdata = interpmodel(model.data,model.layer1);
end
