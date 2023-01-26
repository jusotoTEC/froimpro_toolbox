% Ejemplo de Compresi�n de Im�genes usando el problema LRMA 
% con el  toolbox FroImPro

% ENTRADA: La funci�n ImageCompression recibe un path de una imagen, un 
% radio de comprensi�n y una etiqueta 'BRP' o 'SVD', para que la funci�n 
% se ejecute con la SVD o con el m�todo MBRP.

% SALIDA: La funci�n crea una carpeta 'Results' que contiene la imagen
% recibida en escala de grises y su representaci�n matricial almacenada en
% el archivo L.txt, la imagen comprimida, las matrices A y B (corresponden 
% a D y C en el art�culo, respectivamente) almacenadas en archivos de texto. 

% EJEMPLO PARTICULAR
clc; clear;
ImageCompression('images/volcan.jpg',0.174,'BRP');

% SOBRE EL TIEMPO DE EJECUCI�N: El tiempo promedio de ejecutar esta funci�n 
% en una computaodra port�til de 8GB de memoria RAM y procesador 11th Gen 
% Intel(R) Core(TM) i7-11850H @ 2.50GHz fue de: 1.25 segundos.
