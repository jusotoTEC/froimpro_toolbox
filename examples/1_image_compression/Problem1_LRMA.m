% Example of Image Compression using the LRMA problem
% with the FroImPro toolbox

% INPUT: The ImageCompression function receives a path to an image, a
% compression ratio, and a label 'BRP' or 'SVD', for the function
% to run with SVD or with the MBRP method.

% OUTPUT: The function creates a 'Results' folder containing the image
% received in grayscale and its matrix representation stored in
% the file L.txt, the compressed image, matrices A and B (corresponding
% to D and C in the article, respectively) stored in text files.

% PARTICULAR EXAMPLE

clc; clear;
ImageCompression('volcan.jpg',0.174,'BRP');

% RUNTIME INFORMATION: The average time to execute this function
% on a laptop with 8GB of RAM and an 11th Gen Intel(R) Core(TM) i7-11850H
% processor @ 2.50GHz was: 1.25 seconds.
