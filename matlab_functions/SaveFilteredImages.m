function []=SaveFilteredImages(pathNoise,pathWriteFiltered,X)
    % Esta función recibe la dirección de una carpeta(pathNoise) donde están las
    % imágenes a las que se desea LIMPIAR el ruido y las imágenes filtradas las
    % escribe en la dirección pathWriteFiltered.
    %
    % Para más información ver el manual del Toolbox en <a href="matlab: 
    % web('https://tecnube1-my.sharepoint.com/:b:/g/personal/jfallas_itcr_ac_cr/ES65Im0jm15AvNH9XtsS8uwBvzdPE-U8CHa11fWpLCZGRw?e=fLPthq')"> Manual del Toolbox norma de Frobenius</a>.
    %
    % Sintaxis: SaveFilteredImages('pathNoise','pathWriteFiltered',X);
    %
    % Parámetro de entrada:     
    %       pathNoise:         Ruta de la carpeta de las imágenes con ruido.
    %       pathWriteFiltered: Ruta donde se guardarán las imágenes filtradas.
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