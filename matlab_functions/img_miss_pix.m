function []=img_miss_pix(Textpath,porc)
    % Esta función recibe la dirección de una imagen y un escalar 'porc',
    % tal que 0<porc<1, y genera una imagen, en el mismo directorio, con la
    % cantidad de pixeles perdidos indicados por 'porc'. Por ejemplo, si 
    % porc=0.25 significa que se va a generar una imagen con 25% de pixeles
    % perdidos.
    %
    % Para más información ver el manual del Toolbox en <a href="matlab: 
    % web('https://tecnube1-my.sharepoint.com/:b:/g/personal/jfallas_itcr_ac_cr/ES65Im0jm15AvNH9XtsS8uwBvzdPE-U8CHa11fWpLCZGRw?e=fLPthq')"> Manual del Toolbox norma de Frobenius</a>.
    %
    % Sintaxis: img_miss_pix('Textpath',porc)
    %
    % Parámetros de entrada:
    %       Textpath: Es la ruta de la imagen.
    %       porc:     Escalar tal que 0<porc<1, que denota el porcentaje de
    %                 pixeles perdidos que tendrá la nueva imagen.
    
    if (porc<=0 || porc>=1)  
        error('Take into account that 0<porc<1');
    end
    Y=imread(Textpath);  
    if size(Y,3)==3
           Y=rgb2gray(Y); %%% Convierte la imagen en matriz de tipo doble
    end  
    [m,n]=size(Y);
    for i=1:m
        for j=1:n
            if rand(1)<porc
                Y(i,j)=0;
            end
        end
    end
    VectorPosicion=strfind(Textpath,'\');
    Name=strcat('MissingPixelsImage',Textpath(end-3:end));
    if isempty(VectorPosicion) 
        imwrite(Y,Name);
    else
        NewPath=Textpath(1:VectorPosicion(end));
        imwrite(Y,strcat(NewPath,Name));
    end
end