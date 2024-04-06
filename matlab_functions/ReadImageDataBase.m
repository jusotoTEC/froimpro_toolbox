function [A,m,n] = ReadImageDataBase(Textpath,varargin)
    % Esta funci�n toma las im�genes de una carpeta y las organiza
    % vectorialmente como columnas de una matriz A. Una columna para cada
    % imagen.
    %
    % Para m�s informaci�n ver el manual del Toolbox en <a href="matlab: 
    % web('https://tecnube1-my.sharepoint.com/:b:/g/personal/jfallas_itcr_ac_cr/ES65Im0jm15AvNH9XtsS8uwBvzdPE-U8CHa11fWpLCZGRw?e=fLPthq')"> Manual del Toolbox norma de Frobenius</a>.
    %
    % Sintaxis: [A,m,n] = ReadImageDataBase('Textpath')
    %
    % Par�metro de entrada:
    %       Textpath: Ruta de la carpeta con las im�genes.
    %
    % Sintaxis alternativa: [A,m,n] = ReadImageDataBase('Textpath','Extension','ext')
    %
    % Sobre los par�metros opcionales:
    %        Extension: Las extensiones que se aceptan son jpg, pgm, png, tif, bpm. 
    %                   El valor por defecto es .jpg
    %
    % Par�metros de salida:          
    %       A:   Matriz que contiene las im�genes originales, organizadas en columnas.
    %       m,n: Son las dimensiones de cada una de las im�genes en la base.

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
i=0; %%%Controla el n�mero de archivos v�lidos en la carpeta, dado que en la carpeta
     %%% podr�an haber archivos del sistema, los cuales hay que ignorar.
 A=[];
 for j=1:size(NameFilesVector,1)
   Filej=NameFilesVector(j,:); %Toma el archivo j de la carpeta
   [~,~,Fileextension]=fileparts(Filej); %Lee la extenxi�n del archivo
   %%% En el siguiente if valida el archivo y si la extensi�n coincide
   if (and(~isdir(fullfile(Textpath,Filej)),or(strcmpi(strtrim(Fileextension),Extension),isempty(Extension))))
       i=i+1; %% Archivo v�lido, incrementa el contador de im�genes.
       direccion=fullfile(Textpath,Filej); %% Carga la direcci�n completa del archivo.
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



