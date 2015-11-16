function [ modelcategory ] = getmodel()
% Get model type
modelcategory = menu('Type of Model','Socket','Liner Inner Mold','Liner Outter Mold',...
    'Standard Liner Inner Mold','Standard Liner Outter Mold');

% Write variable
switch modelcategory
    case modelcategory == 1
        modelcategory = 'Socket';
    case modelcategory == 2
        modelcategory = 'CustomLinnerInnerMold';
    case modelcategory == 3
        modelcategory = 'CustomLinnerOuterMolde';
    case modelcategory == 4
        modelcategory = 'StandardLinnerInnerMold';
    case modelcategory == 5
        modelcategory = 'StandardLinnerOuterMold';
end

end

