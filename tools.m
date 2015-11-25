function [ ] = tools( )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

prompt = {'Command window'};
dlg_title = '';
num_lines = 20;
l1 = 'Description {command}\n';
space = '\n';
l2 = 'Circumferencial percent reduction landmark heights (mm) {L [0 5 10 20]}\n';
l3 = 'Landmark circumferencial reduction (percent) {P- [0 1 2 3]}\n';
l4 = 'Circumferencial percent increase landmark heights (mm) {L [0 5 10 20]}\n';
l5 = 'Landmark circumferenical reduction (percent) {P+ [100 101 102 103]}\n';
l6 = 'Extend (mm) {E [3]}\n';
l7 = 'Extend between heights (mm) {EH [4 5]}\n';
start = '------------Type your code below-----------------';

string = sprintf(strcat(l1,space,space,l2,l3,l4,l5,l6,l7,start));
defaultans = {string};
answerInnerMold = inputdlg(prompt,dlg_title,num_lines,defaultans, 'on');

end

