% Example of Noise Removal using the GLRMA problem
% with the FroImPro toolbox

% INPUT: The FullRankConstrainedFilterX function receives a path to a
% folder containing grayscale images, all of the same size.

% OUTPUT: Matrix A whose columns are vectorizations of the received images
% and matrix X which corresponds to the filter that will be used to clean
% noise from another image.

% PARTICULAR EXAMPLE

clc; clear; close all

% Part A of the example: Generate filter X.
X=FullRankConstrainedFilterX('trainingData');

% Part B of the example: Use filter X to clean the images stored
% in the 'NoisyImg' folder, and in the 'Results' folder (created by the
% user), the SaveFilteredImages function saves the noisy image and the
% cleaned image after applying filter X.
SaveFilteredImages('NoisyImg','Results',X);

% RUNTIME INFORMATION: The average time to execute this function
% on a laptop with 8GB of RAM and an 11th Gen Intel(R) Core(TM) i7-11850H
% processor @ 2.50GHz was: 14.31 seconds.

