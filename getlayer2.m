function [ thickness_choice ] = getlayer2()

% Thickness Selection Menu
thickness_choice=menu('Choose a socket thickness (all are at .6 layer thickness unless noted)'...
    ,'Normal(default)'...                                                  % thickness_choice = 1
    ,'1.0 cm'...                                                               % thickness_choice = 2
    ,'1.25 cm'...                                                               % thickness_choice = 3
    ,'2.0 cm'...                                                                % thickness_choice = 4
    ,'2.5 cm'...                                                               % thickness_choice = 5
    ,'3.0 cm'); 

% Write variable
switch thickness_choice
    case thickness_choice == 1
        thickness_choice = 'Normal';
    case thickness_choice == 2
        thickness_choice = '1.0 cm';
    case thickness_choice == 3
        thickness_choice = '1.23 cm';
    case thickness_choice == 4
        thickness_choice = '2.0 cm';
    case thickness_choice == 5
        thickness_choice = '2.5 cm';
    case thickness_choice == 6
        thickness_choice = '3.0 cm';
end

end

