function [OutX] = double2uint8(X)
    % Convierte una matriz double en un matriz en formato uint8, realizando un
    % reescalado de los datos de la matriz a valores entre 0 y 255. Luego se
    % puede usar esa matriz para generar la imagen correspondiente.
    %
    % Para más información ver el manual del Toolbox en <a href="matlab: 
    % web('https://tecnube1-my.sharepoint.com/:b:/g/personal/jfallas_itcr_ac_cr/ES65Im0jm15AvNH9XtsS8uwBvzdPE-U8CHa11fWpLCZGRw?e=fLPthq')"> Manual del Toolbox norma de Frobenius</a>.
    %
    % Sintaxis: OutX = double2uint8(X)
    %
    % Parámetro de entrada:
    %       X: Es una matriz con entradas de tipo double.
    %
    % Parámetros de salida:
    %       OutX: Es la matriz reescalada con entradas de tipo uint8.
    
mini=min(min(X));
maxi=max(max(X));
OutX=uint8(255/(maxi-mini)*(X-mini));
end

