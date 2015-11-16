function [ model ] = getlayer1( hObject, model )

% DIALOGUE BOX ENTRIES
name='Enter the Initial Parameters for the First Layers';
prompt={'Input starting Spindle Speed:','Input starting Feed Speed:',...
    'Input base Feed Speed:','Input Extrusion Modifier:','Input layer height percent (do not change this):'};
% DIALOGUE BOX DEFAULT VALUES
defaultanswer={'100','400','800','0','1.2'};
% DISPLAY DIALOGUE BOX
answer=inputdlg(prompt,name,1,defaultanswer);                             
% WRITE VARIABLES
model.int_spind_speed_val=cell2mat(answer(1)); %spindle speed = extrusion rate
model.int_feed_speed_val=cell2mat(answer(2)); %feed speed = platform rotation
model.base_feed_speed_val=cell2mat(answer(3));
model.ex_mod_val=cell2mat(answer(4));
model.layer_height_val=cell2mat(answer(5));
% layer.layer_hight_val=str2double(layer_hight_val);
% UPADE INFORMATION
guidata(hObject, model);
end

