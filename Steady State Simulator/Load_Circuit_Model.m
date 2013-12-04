function [Distance, Corner_Radius, track_length]=Load_Circuit_Model(filename, path)
% Performance Simulator v1.1
% Date: 2-12-2013
% Author: César Álvarez Porras (www.cesar-ap.com)

% Open the Circuit Model File using the filename and path provided from the
% main function.

track_length = 500; % m
Distance =          [0, 200, 210, 220, 225, 230, 270, 280, 285, 290, 300, 310, 325, 335];
Corner_Radius =     [0  120, 110, 100, 110, 0,   90,  85,  80,  70,  75, 80,  100, 0];

% track_length = 40; % m
% Distance =         [4, 7,   9,   11,  13, 15, 17, 19, 21, 23, 25, 27, 29, 31, 33, 35, 37];
% Corner_Radius =    [0, 120, 110, 100, 90, 85, 90, 95, 0,  70, 65, 60, 70, 75, 80, 85, 0];

end