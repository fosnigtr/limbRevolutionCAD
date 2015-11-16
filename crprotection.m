function [ flag ] = crprotection(  )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

flag = 0;
today = date;
expiredate = '01-Nov-2015';

if strcmp(today,expiredate);
    h = msgbox('WARNING: Your license has expired. Email fosnigtr@gmail.com to renew your license.');
    % Change icon
%     warning('off','MATLAB:HandleGraphics:ObsoletedProperty:JavaFrame');
%     jframe=get(h,'javaframe');
%     jIcon=javax.swing.ImageIcon('.\Logo.png');
%     jframe.setFigureIcon(jIcon);
    delete('test.txt') % change this so that it deletes the .exe file
    flag = 1;
end

if flag == 0
    warning = sprintf('WARNING: Your license will expire on %s', expiredate);
    h = msgbox(warning);
    % Change icon
%     warning('off','MATLAB:HandleGraphics:ObsoletedProperty:JavaFrame');
%     jframe=get(h,'javaframe');
%     jIcon=javax.swing.ImageIcon('.\Logo.png');
%     jframe.setFigureIcon(jIcon);
end

pause(10);
end

