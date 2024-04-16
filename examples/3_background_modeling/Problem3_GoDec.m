% Example of Background Modeling using the GoDec algorithm
% with the FroImPro toolbox

% INPUT: The GoDecVideoFull function receives a path to a video in .mp4 format,
% a constraint for the rank r<=min{m,n}, and 's' a sparsity constant.

% OUTPUT: Three videos generated in the working directory. The L video
% models the background and the S video models the moving objects. The
% XLS video shows the three videos together for better visualization.

% PARTICULAR EXAMPLE

clc; clear;
r=2;
s=2150000;
GoDecVideoFull('video.mp4',r,s,'BRP','Scale');

% RUNTIME INFORMATION: The average time to execute this function
% on a laptop with 8GB of RAM and an 11th Gen Intel(R) Core(TM) i7-11850H
% processor @ 2.50GHz was: 275 seconds.

