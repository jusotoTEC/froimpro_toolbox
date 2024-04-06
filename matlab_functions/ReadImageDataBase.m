function [A,m,n] = ReadImageDataBase(Textpath,varargin)
    % Esta función toma las imágenes de una carpeta y las organiza
    % vectorialmente como columnas de una matriz A. Una columna para cada
    % imagen.
    %
    % Para más información ver el manual del Toolbox en <a href="matlab: 
    % web('https://tecnube1-my.sharepoint.com/:b:/g/personal/jfallas_itcr_ac_cr/ES65Im0jm15AvNH9XtsS8uwBvzdPE-U8CHa11fWpLCZGRw?e=fLPthq')"> Manual del Toolbox norma de Frobenius</a>.
    %
    % Sintaxis: [A,m,n] = ReadImageDataBase('Textpath')
    %
    % Parámetro de entrada:
    %       Textpath: Ruta de la carpeta con las imágenes.
    %
    % Sintaxis alternativa: [A,m,n] = ReadImageDataBase('Textpath','Extension','ext')
    %
    % Sobre los parámetros opcionales:
    %        Extension: Las extensiones que se aceptan son jpg, pgm, png, tif, bpm. 
    %                   El valor por defecto es .jpg
    %
    % Parámetros de salida:          
    %       A:   Matriz que contiene las imágenes originales, organizadas en columnas.
    %       m,n: Son las dimensiones de cada una de las imágenes en la base.

Extension='.jpg'; %%%%%% Validaciones
expectedExtensions = {'.jpg','.pgm','.bmp','.png','.tif'};
p = inputParser;
addRequired(p,'Textpath'); 
addParameter(p,'Extension',Extension,@(x) any(strcmp(lower(strrep(x,' ','')),expectedExtensions )));
parse(p,Textpath,varargin{:});
Extension=p.Results.Extension;
Extension=lower(strrep(Extension,' ',''));
%%%%%% Fin de validaciones
NameFilesVector=ls(Textpath); %Vector con los nombres completos de todos los archivos en la carpeta
i=0; %%%Controla el número de archivos válidos en la carpeta, dado que en la carpeta
     %%% podrían haber archivos del sistema, los cuales hay que ignorar.
 A=[];
 for j=1:size(NameFilesVector,1)
   Filej=NameFilesVector(j,:); %Toma el archivo j de la carpeta
   [~,~,Fileextension]=fileparts(Filej); %Lee la extenxión del archivo
   %%% En el siguiente if valida el archivo y si la extensión coincide
   if (and(~isdir(fullfile(Textpath,Filej)),or(strcmpi(strtrim(Fileextension),Extension),isempty(Extension))))
       i=i+1; %% Archivo válido, incrementa el contador de imágenes.
       direccion=fullfile(Textpath,Filej); %% Carga la dirección completa del archivo.
       ima=imread(direccion);
       if size(ima,3)==3
           ImageMatrix=im2double(rgb2gray(ima)); %%% Convierte la imagen en matriz de tipo doble
       else
           ImageMatrix=im2double(ima);
       end
       if i==1 [m,n]=size(ImageMatrix); end; %%% Registra las dimensiones de cada imagen
        A(:,i)=reshape(ImageMatrix,[m*n 1]);%Carga imagenes originales en las columnas de A 
   end
 end
 num_img=i;
 if i==0 error(strcat('There are not images in your data base with the extension ',Extension));
end



