% Ejemplo de Extracci�n de Caracter�sticas de caras usando 
% el problema NNMF con el  toolbox FroImPro


% ENTRADA: La funci�n ConstructionNNFM recibe un path de una carpeta con im�genes en
% escala de grises, del mismo tama�o una restricci�n para el rango
% r<=min{m,n} y una constante c de esparcidad.

% SALIDA: Matrices X1 y X2, donde A\approx X1*X2 y A es la matriz original,
% basado en el algoritmo KSVD

% EJEMPLO PARTICULAR
clc; clear;
r=15; c=2; 
[X1,X2,Err]=ksvd('dataset',r,c);

% RECONTRUCCI�N IMAGEN CON PIXELES PERDIDOS
Img_Rec=clean_ksvd('img_pix.pgm',X1); 





