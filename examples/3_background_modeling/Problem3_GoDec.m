% Ejemplo de Modelado de Fondo usando el algoritmo GoDec 
% con el  toolbox FroImPro

% ENTRADA: La funci�n GoDecVideoFull recibe un path de un video en formato 
% .mp4, una restricci�n para el rango r<=min{m,n} y 's' una constante de 
% esparcidad. 

% SALIDA: Tres videos que se generan en la carpeta de trabajo. El video L
% modelo el fondo y el video S modela los objetos en movimiento. El video
% XLS muestra los tres videos juntos para mejor visualizaci�n.

% EJEMPLO PARTICULAR
clc; clear;
r=2;
s=2150000;
GoDecVideoFull('video.mp4',r,s,'BRP','Scale');

% SOBRE EL TIEMPO DE EJECUCI�N: El tiempo promedio de ejecutar esta funci�n 
% en una computaodra port�til de 8GB de memoria RAM y procesador 11th Gen 
% Intel(R) Core(TM) i7-11850H @ 2.50GHz fue de: 275 segundos.
