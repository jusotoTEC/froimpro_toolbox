% Ejemplo de Extracci�n de Caracter�sticas de caras usando 
% el problema NNMF con el  toolbox FroImPro


% ENTRADA: La funci�n ConstructionNNFM recibe un path de una carpeta con im�genes en
% escala de grises, del mismo tama�o, y una restricci�n para el rango r<=min{m,n}. 

% SALIDA: Matrices X1 y X2, donde A\approx X1*X2 y A es la matriz original
% de im�genes vectorizadas. Adem�s, X1 representa la base de caras.
% EJEMPLO PARTICULAR COMPLEMENTARIO AL ART�CULO:
clc; clear all; 
[X1,X2]=ConstructionNNFM('database','r',285);

% SOBRE EL TIEMPO DE EJECUCI�N: El tiempo promedio de ejecutar esta funci�n 
% en una computaodra port�til de 8GB de memoria RAM y procesador 11th Gen 
% Intel(R) Core(TM) i7-11850H @ 2.50GHz fue de: 805.1302 segundos.
% Aclaraci�n sobre los resultados: En la carpeta 'Results' X1=W y X2=H.

% RECONSTRUCCI�N DE UNA IMAGEN EXTERNA
ReconstructionExternalFace('f1.jpg',X1,'f2')
