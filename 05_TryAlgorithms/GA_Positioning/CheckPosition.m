% Validate GA positioning algorithm
% Given tag postion and calculate accurate distance,
%     calulate position using 'getPositon' and compare with the given tag

% XiaoCY 2021-10-18

%%
clear;clc

% Positions of four anchors
A = [  0    0 1300
    5000    0 1700
       0 5000 1700
    5000 5000 1300 ];

% Real position of the given tag
tag = [700 800 900];

% Distances between tag and anchors
dist = vecnorm(A-tag,2,2)';

% Caculated position using GA algorithm
pos = getPosition(dist,A,'showProcess',true);
