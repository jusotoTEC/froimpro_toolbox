function []=SaveBlurredImages(pathOriginal,pathWriteNoise,varargin)
    % Esta función recibe la dirección de una carpeta(pathOriginal) donde están las
    % imágenes a las que se desea aplicar ruido y las imágenes con ruido las
    % escribe en la dirección pathWriteNoise.
    %
    % Para más información ver el manual del Toolbox en <a href="matlab: 
    % web('https://tecnube1-my.sharepoint.com/:b:/g/personal/jfallas_itcr_ac_cr/ES65Im0jm15AvNH9XtsS8uwBvzdPE-U8CHa11fWpLCZGRw?e=fLPthq')"> Manual del Toolbox norma de Frobenius</a>.
    %
    % Sintaxis: SaveBlurredImages('pathOriginal','pathWriteNoise');
    %   
    % Parámetro de entrada:  
    %       pathOriginal: Dirección de las imágenes a las que se les aplicará ruido.
    %       pathWriteNoise: Dirección donde se guardarán las imágenes con ruido.
    %
    % Sintaxis alternativa:
    %       Opción 1: SaveBlurredImages('pathOriginal','pathWriteNoise','NoiseOption',...
    %                     'gaussian','sigmagauss',n_0,'meangauss',n_1);
    %       Opción 2: SaveBlurredImages('pathOriginal','pathWriteNoise','NoiseOption','s&p','d',n_0);
    %       Opción 3: SaveBlurredImages('pathOriginal','pathWriteNoise','NoiseOption','speckle','sigmaspeckle',n_0);
    %
    % Sobre los parámetros opcionales:
    %
    %       NoiseOption:  Es el tipo de ruido, teniendo las opciones 'speckle',
    %                     's&p','gaussian', donde 's&p' significa "salt and
    %                     pepper". El valor por defecto es NoiseOption=gaussian.
    %       sigmagauss:   Varianza para el ruido gaussiano. El valor por defecto es sigmagauss=0.01
    %       meangauss:    Media para el ruido gaussiano. El valor por defecto es meangauss=0
    %       sigmaspeckle: Varianza para el ruido speckle. El valor por defecto es sigmaspeckle=0.05                  
    %       d:            Densidad del ruido para s&p. El valor por defecto es d=0.05
    %

    NoiseOption='gaussian';
    sigmagauss=0.01;
    meangauss=0;
    d=0.05;
    sigmaspeckle=0.05;
    %%%%%%%%%%%%%%Terminé de cargar los valores por default
    expectedNoises = {'speckle','s&p','gaussian'}; %Posibles valores para la variable "NoiseOption"
    %%%%%%%%%%% Uso el inputParser para validar argumentos y asignar valores por defecto. 
    p = inputParser;
    validScalar1 = @(x) isnumeric(x) && isscalar(x) && (x > 0);
    validScalar2 = @(x) isnumeric(x) && isscalar(x) && (x >= 0);
    addRequired(p,'pathOriginal'); %% Parámetro obligatorio.
    addRequired(p,'pathWriteNoise'); %% Parámetro obligatorio.
    addParameter(p,'NoiseOption',NoiseOption,@(x) any(strcmp(lower(strrep(x,' ','')),expectedNoises))); 
                    %%%%  Valida si el parámetro 'NoiseOption' existe.
                    %%%%  Si no existe, le asigna el valor por defecto.
                    %%%%  Si sí existe, el objeto "p" contiene el valor ingresado por el usuario.
                    %%%%  Se accesa con p.Results.NoiseOption         
    addParameter(p,'sigmagauss',sigmagauss,validScalar1);
    addParameter(p,'meangauss',meangauss,validScalar2);
    addParameter(p,'d',d,validScalar1);
    addParameter(p,'sigmaspeckle',sigmaspeckle,validScalar1);
    parse(p,pathOriginal,pathWriteNoise,varargin{:});   
    %%%%%%%%%%%%%%%%% Cierro el inputParser
    NoiseOption=p.Results.NoiseOption; %Cargo el tipo de ruido
    NoiseOption=lower(strrep(NoiseOption,' ','')); %Elimino espacios y paso a minúscula.
    %%%%% De acá en adelante cargo los demás parámetros, a partir de los atributos del objeto p
    sigmagauss=p.Results.sigmagauss;
    meangauss=p.Results.meangauss;
    d=p.Results.d;
    sigmaspeckle=p.Results.sigmaspeckle;
    %%%% Cierro la carga de variables    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%% Ahora creo la matriz con ruido. C tiene una columna para cada
    %%% imagen con ruido. 
    [C,~,m,n]=NoiseFunction(pathOriginal,'NoiseOption',NoiseOption,'sigmagauss',sigmagauss,'meangauss',meangauss,'d',d,'sigmaspeckle',sigmaspeckle); 
    [~,num_img]=size(C);
    %%%% Parte final, escribo las imágenes con ruido
    for i=1:num_img
        ImagenNIConRuidoColumna=C(:,i); % Leo la columna i de C
        ImagenNIConRuido=reshape(ImagenNIConRuidoColumna,[m n]); %La convierto en matriz
        imwrite(ImagenNIConRuido,strcat(pathWriteNoise,'\BlurredImage (',int2str(i),').jpg')); %Genero la imagen i
    end;
end