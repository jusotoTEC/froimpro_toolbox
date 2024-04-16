function []=SaveFilteredImages(pathNoise,pathWriteFiltered,X)
% This function receives the directory path (pathNoise) where the
% images with noise are located, and writes the filtered images to the
% path specified by pathWriteFiltered.
%
% For more information, refer to the Toolbox manual at Manual del Toolbox norma de Frobenius.
%
% Syntax: SaveFilteredImages('pathNoise', 'pathWriteFiltered', X);
%
% Input parameters:
%       pathNoise:         Path to the folder containing noisy images.
%       pathWriteFiltered: Path where the filtered images will be saved.
%       X:                 The filter to be applied.


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
