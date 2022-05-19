function [] = ReconstructionExternalFacesDirectory(Textpath,W,varargin)
    % Esta funci�n recibe una ruta de un directorio de im�genes y usa la
    % matriz base W para reconstruir las im�genes y as� evaluar la calidad
    % de la base de caras W. Esta funci�n usa la funci�n ReconstructionExternalFace,
    % la cual guardar� las nuevas im�genes en formato jpg, en el directorio
    % "Results" dentro de la carpeta de trabajo. Si no existe, la crea autom�ticamente.
    %
    % Para m�s informaci�n ver el manual del Toolbox en <a href="matlab: 
    % web('https://tecnube1-my.sharepoint.com/:b:/g/personal/jfallas_itcr_ac_cr/ES65Im0jm15AvNH9XtsS8uwBvzdPE-U8CHa11fWpLCZGRw?e=fLPthq')"> Manual del Toolbox norma de Frobenius</a>.
    %
    % Sintaxis: ReconstructionExternalFacesDirectory('Textpath',W)
    %
    % Par�metro de entrada:    
    %       Textpath:   Ruta de la carpeta de im�genes que desea reconstruir.       
    %       W:          Es la matriz que representa la base de caras. Esta matriz se 
    %                   obtiene al ejecutar la funci�n ConstructionNNFM.
    %
    % Sintaxis alternativa: 
    %       ReconstructionExternalFacesDirectory('Textpath',W,'Extension','ext','NameOutput','name')   
    %
    % Sobre los par�metros opcionales:
    %       Extension: Las extensiones que se aceptan son jpg, pgm, png, tif, bpm. 
    %                  El valor por defecto es .jpg  
    %       NameOutput: Es el nombre que se utilizar� para guardar las im�genes nuevas. 
    %                   El valor por defecto es NameOutput='Reconstruted'.    
 
NameOutput='Reconstruted';% Validaciones
Extension='.jpg';
expectedExtensions = {'.jpg','.pgm','.bmp','.png','.tif'};
ValidMatrix = @(x) ismatrix(x) && isnumeric(x);
p = inputParser;
addRequired(p,'Textpath');
addRequired(p,'W',ValidMatrix);
addParameter(p,'Extension',Extension,@(x) any(strcmp(lower(strrep(x,' ','')),expectedExtensions )));
addParameter(p,'NameOutput',NameOutput);
parse(p,Textpath,W,varargin{:});
Extension=p.Results.Extension;
NameOutput=p.Results.NameOutput;
%%%%%
NameFilesVector=ls(Textpath); %Vector con los nombres completos de todos los archivos en la carpeta
i=0; %%%Controla el n�mero de archivos v�lidos en la carpeta, dado que en la carpeta
     %%% podr�an haber archivos del sistema, los cuales hay que ignorar.
 for j=1:size(NameFilesVector,1)
   Filej=NameFilesVector(j,:); %Toma el archivo j de la carpeta
   [~,~,Fileextension]=fileparts(Filej); %Lee la extenxi�n del archivo
   %%% En el siguiente if valida el archivo y si la extensi�n coincide
   if (and(~isdir(fullfile(Textpath,Filej)),or(strcmpi(strtrim(Fileextension),Extension),isempty(Extension))))
       i=i+1; %% Archivo v�lido, incrementa el contador de im�genes.
       direccion=fullfile(Textpath,Filej); %% Carga la direcci�n completa del archivo.
       ReconstructionExternalFace(direccion,W,strcat(NameOutput,int2str(i)));
   end
 end
 num_img=i;
 if i==0 
     error(strcat('There are not images in your data base with the extension ',Extension));
 end
 end


