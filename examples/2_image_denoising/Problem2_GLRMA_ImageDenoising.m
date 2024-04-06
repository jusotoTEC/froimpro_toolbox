% Ejemplo de Eliminaci�n de Ruido usando el problema GLRMA 
% con el  toolbox FroImPro

% ENTRADA: La funci�n FullRankConstrainedFilterX recibe un path de una
% carpeta que contiene im�genes en escala de grises, todas del mismo tama�o. 

% SALIDA: Matriz A cuyas columnas son vectorizaciones de las im�genes recibidas
% y matriz X que corresponde al filtro que ser� utilizado para limpiar
% ruido de otra imagen.

% EJEMPLO PARTICULAR 
clc; clear; close all

% Parte A del ejemplo: Generar el filtro X.
X=FullRankConstrainedFilterX('trainingData');

% Parte B del ejemplo: Usar el filtro X para limpiar las im�genes almacenadas
% en la carpeta 'NoisyImg' y en la carpeta 'Results' (creada por el
% usuario) la funci�n SaveFilteredImages guarda la imagen con ruido y la 
% imagen limpiada al aplicar el filtro X.
SaveFilteredImages('NoisyImg','Results',X);

% SOBRE EL TIEMPO DE EJECUCI�N: El tiempo promedio de ejecutar esta funci�n 
% en una computaodra port�til de 8GB de memoria RAM y procesador 11th Gen 
% Intel(R) Core(TM) i7-11850H @ 2.50GHz fue de:  14.31 segundos.
