% Example of Face Feature Extraction using the NNMF problem
% with the FroImPro toolbox

% INPUT: The ConstructionNNFM function receives a path to a folder with grayscale
% images, all of the same size, a constraint for the rank r<=min{m,n},
% and a sparsity constant c.

% OUTPUT: Matrices X1 and X2, where A\approx X1*X2 and A is the original
% matrix, based on the KSVD algorithm.

% PARTICULAR EXAMPLE

clc; clear;
r=15; c=2;
[X1,X2,Err]=ksvd('dataset',r,c);

% IMAGE RECONSTRUCTION WITH MISSING PIXELS

Img_Rec=clean_ksvd('img_pix.pgm',X1);





