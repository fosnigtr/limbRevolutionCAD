function [ layer ] = getlayer()
% Dialogue box inputs 
layer.name1='Enter the Initial Parameters for the First Layers';
layer.prompt1={'Input starting Spindle Speed:','Input starting Feed Speed:',...
    'Input base Feed Speed:','Input Extrusion Modifier:','Input layer height percent (do not change this):'};

% Dialogue box defaults
layer.defaultanswer1={'100','400','800','0','1.2'};

% Display dialogue box
layer.answer1=inputdlg(prompt1,name1,1,defaultanswer1);                             

% Write variables
layer.int_spind_speed_val=cell2mat(answer1(1));                                  %spindle speed = extrusion rate
layer.int_feed_speed_val=cell2mat(answer1(2));                                   %feed speed = platform rotation
layer.base_feed_speed_val=cell2mat(answer1(3));
layer.ex_mod_val=cell2mat(answer1(4));
layer.layer_hight_val=cell2mat(answer1(5));
layer.layer_hight_val=str2double(layer_hight_val);

end

