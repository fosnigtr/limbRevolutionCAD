function [ surface ] = getsurface()

% Choose surface category
surface = menu('Type of Surface','Normal','Rough','Flanged');

% Write surface category
switch surface
    case surface == 1
        surface = 'Normal';
    case surface == 2
        surface = 'Rough';
    case surface == 3
        surface = 'Flanged';
end

end

