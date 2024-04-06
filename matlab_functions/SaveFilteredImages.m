function []=SaveFilteredImages(pathNoise,pathWriteFiltered,X)
    % Esta funci�n recibe la direcci�n de una carpeta(pathNoise) donde est�n las
    % im�genes a las que se desea LIMPIAR el ruido y las im�genes filtradas las
    % escribe en la direcci�n pathWriteFiltered.
    %
    % Para m�s informaci�n ver el manual del Toolbox en <a href="matlab: 
    % web('https://tecnube1-my.sharepoint.com/:b:/g/personal/jfallas_itcr_ac_cr/ES65Im0jm15AvNH9XtsS8uwBvzdPE-U8CHa11fWpLCZGRw?e=fLPthq')"> Manual del Toolbox norma de Frobenius</a>.
    %
    % Sintaxis: SaveFilteredImages('pathNoise','pathWriteFiltered',X);
    %
    % Par�metro de entrada:     
    %       pathNoise:         Ruta de la carpeta de las im�genes con ruido.
    %       pathWriteFiltered: Ruta donde se guardar�n las im�genes filtradas.
    %       X:                 Es el filtro que se debe aplicar.
    
    [C,m,n]=ReadImageDataBase(pathNoise);
    [~,NumImgWithNoise]=size(C);
    for i=1:NumImgWithNoise
        ImagenNIConRuidoColumna=C(:,i);
        ImagenNIConRuido=reshape(ImagenNIConRuidoColumna,[m n]);
        imwrite(ImagenNIConRuido,strcat(pathWriteFiltered,'\BlurredImage (',int2str(i),').jpg'));
        imagenNIFiltradaColumna=X*ImagenNIConRuidoColumna;
        imagenNIFiltrada=reshape(imagenNIFiltradaColumna,[m n]);
        imwrite(imagenNIFiltrada,strcat(pathWriteFiltered,'\FilteredImage (',int2str(i),').jpg'));
    end;    
end