% Ejemplo de Extracción de Características de caras usando 
% el problema NNMF con el  toolbox FroImPro


% ENTRADA: La función ConstructionNNFM recibe un path de una carpeta con imágenes en
% escala de grises, del mismo tamaño, y una restricción para el rango r<=min{m,n}. 

% SALIDA: Matrices X1 y X2, donde A\approx X1*X2 y A es la matriz original
% de imágenes vectorizadas. Además, X1 representa la base de caras.
% EJEMPLO PARTICULAR COMPLEMENTARIO AL ARTÍCULO:
clc; clear all; 
[X1,X2]=ConstructionNNFM('database','r',285);

% SOBRE EL TIEMPO DE EJECUCIÓN: El tiempo promedio de ejecutar esta función 
% en una computaodra portátil de 8GB de memoria RAM y procesador 11th Gen 
% Intel(R) Core(TM) i7-11850H @ 2.50GHz fue de: 805.1302 segundos.
% Aclaración sobre los resultados: En la carpeta 'Results' X1=W y X2=H.

% RECONSTRUCCIÓN DE UNA IMAGEN EXTERNA
ReconstructionExternalFace('f1.jpg',X1,'f2')
