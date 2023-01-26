% Ejemplo de Compresión de Imágenes usando el problema LRMA 
% con el  toolbox FroImPro

% ENTRADA: La función ImageCompression recibe un path de una imagen, un 
% radio de comprensión y una etiqueta 'BRP' o 'SVD', para que la función 
% se ejecute con la SVD o con el método MBRP.

% SALIDA: La función crea una carpeta 'Results' que contiene la imagen
% recibida en escala de grises y su representación matricial almacenada en
% el archivo L.txt, la imagen comprimida, las matrices A y B (corresponden 
% a D y C en el artículo, respectivamente) almacenadas en archivos de texto. 

% EJEMPLO PARTICULAR
clc; clear;
ImageCompression('images/volcan.jpg',0.174,'BRP');

% SOBRE EL TIEMPO DE EJECUCIÓN: El tiempo promedio de ejecutar esta función 
% en una computaodra portátil de 8GB de memoria RAM y procesador 11th Gen 
% Intel(R) Core(TM) i7-11850H @ 2.50GHz fue de: 1.25 segundos.
