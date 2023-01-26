% Ejemplo de Extracción de Características de caras usando 
% el problema NNMF con el  toolbox FroImPro


% ENTRADA: La función ConstructionNNFM recibe un path de una carpeta con imágenes en
% escala de grises, del mismo tamaño una restricción para el rango
% r<=min{m,n} y una constante c de esparcidad.

% SALIDA: Matrices X1 y X2, donde A\approx X1*X2 y A es la matriz original,
% basado en el algoritmo KSVD

% EJEMPLO PARTICULAR
clc; clear;
r=15; c=2; 
[X1,X2,Err]=ksvd('dataset',r,c);

% RECONTRUCCIÓN IMAGEN CON PIXELES PERDIDOS
Img_Rec=clean_ksvd('img_pix.pgm',X1); 





