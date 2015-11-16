% LINER TOOL

clear all; close all;

%% GET .AOP FILE
model.file = getaopfile();

%% GET MODEL CATEGORY
model.category = getmodel();

%% GET SURFACE CATEGORY
model.surface = getsurface();

%% GET LAYER1
model.layer1 = getlayer1();

%% GET LAYER2
model.thickness_choice = getlayer2();

%% READ .AOP FILE
model.data = readaopfile(model.file);

%% CENTER MODEL
% model.data = centermodel(model.data);

%% INTERPOLATE MODEL DATA
% Fix errors by reverting to backup version
model.interpdata = interpmodel(model.data,model.layer1);