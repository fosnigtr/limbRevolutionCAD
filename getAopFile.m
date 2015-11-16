function [ model ] = getAopFile( hObject, model )
% GET FILE
[name pname]=uigetfile('*.aop','Select the AOP File to Display');
model.pname = pname; model.fname = name;
% ERROR CHECKING
model.id=fopen([pname name], 'r');                                                  
while model.id == -1 
    errordlg('File could not be opened, check name or path.','File Import Error')
    model.name=uigetfile('*.aop','Select the AOP File to Display');
    pause(2);  
end
fclose(model.id);
% UPDATE INFORMATION
guidata(hObject, model);
end

