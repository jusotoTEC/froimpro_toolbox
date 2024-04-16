% Example of Face Feature Extraction using the NNMF problem
% with the FroImPro toolbox

% INPUT: The ConstructionNNFM function receives a path to a folder with grayscale
% images, all of the same size, and a constraint for the rank r<=min{m,n}.

% OUTPUT: Matrices X1 and X2, where A\approx X1*X2 and A is the original
% matrix of vectorized images. Additionally, X1 represents the face basis.
% PARTICULAR EXAMPLE COMPLEMENTARY TO THE ARTICLE:

clc; clear all;
[X1,X2]=ConstructionNNFM('database','r',285);

% RUNTIME INFORMATION: The average time to execute this function
% on a laptop with 8GB of RAM and an 11th Gen Intel(R) Core(TM) i7-11850H
% processor @ 2.50GHz was: 805.1302 seconds.
% Clarification about the results: In the 'Results' folder, X1=W and X2=H.

% RECONSTRUCTION OF AN EXTERNAL IMAGE

ReconstructionExternalFace('f1.jpg',X1,'f2')
