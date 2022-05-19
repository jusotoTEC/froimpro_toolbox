function []=SaveBlurredImages(pathOriginal,pathWriteNoise,varargin)
    % Esta funci�n recibe la direcci�n de una carpeta(pathOriginal) donde est�n las
    % im�genes a las que se desea aplicar ruido y las im�genes con ruido las
    % escribe en la direcci�n pathWriteNoise.
    %
    % Para m�s informaci�n ver el manual del Toolbox en <a href="matlab: 
    % web('https://tecnube1-my.sharepoint.com/:b:/g/personal/jfallas_itcr_ac_cr/ES65Im0jm15AvNH9XtsS8uwBvzdPE-U8CHa11fWpLCZGRw?e=fLPthq')"> Manual del Toolbox norma de Frobenius</a>.
    %
    % Sintaxis: SaveBlurredImages('pathOriginal','pathWriteNoise');
    %   
    % Par�metro de entrada:  
    %       pathOriginal: Direcci�n de las im�genes a las que se les aplicar� ruido.
    %       pathWriteNoise: Direcci�n donde se guardar�n las im�genes con ruido.
    %
    % Sintaxis alternativa:
    %       Opci�n 1: SaveBlurredImages('pathOriginal','pathWriteNoise','NoiseOption',...
    %                     'gaussian','sigmagauss',n_0,'meangauss',n_1);
    %       Opci�n 2: SaveBlurredImages('pathOriginal','pathWriteNoise','NoiseOption','s&p','d',n_0);
    %       Opci�n 3: SaveBlurredImages('pathOriginal','pathWriteNoise','NoiseOption','speckle','sigmaspeckle',n_0);
    %
    % Sobre los par�metros opcionales:
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
    %%%%%%%%%%%%%%Termin� de cargar los valores por default
    expectedNoises = {'speckle','s&p','gaussian'}; %Posibles valores para la variable "NoiseOption"
    %%%%%%%%%%% Uso el inputParser para validar argumentos y asignar valores por defecto. 
    p = inputParser;
    validScalar1 = @(x) isnumeric(x) && isscalar(x) && (x > 0);
    validScalar2 = @(x) isnumeric(x) && isscalar(x) && (x >= 0);
    addRequired(p,'pathOriginal'); %% Par�metro obligatorio.
    addRequired(p,'pathWriteNoise'); %% Par�metro obligatorio.
    addParameter(p,'NoiseOption',NoiseOption,@(x) any(strcmp(lower(strrep(x,' ','')),expectedNoises))); 
                    %%%%  Valida si el par�metro 'NoiseOption' existe.
                    %%%%  Si no existe, le asigna el valor por defecto.
                    %%%%  Si s� existe, el objeto "p" contiene el valor ingresado por el usuario.
                    %%%%  Se accesa con p.Results.NoiseOption         
    addParameter(p,'sigmagauss',sigmagauss,validScalar1);
    addParameter(p,'meangauss',meangauss,validScalar2);
    addParameter(p,'d',d,validScalar1);
    addParameter(p,'sigmaspeckle',sigmaspeckle,validScalar1);
    parse(p,pathOriginal,pathWriteNoise,varargin{:});   
    %%%%%%%%%%%%%%%%% Cierro el inputParser
    NoiseOption=p.Results.NoiseOption; %Cargo el tipo de ruido
    NoiseOption=lower(strrep(NoiseOption,' ','')); %Elimino espacios y paso a min�scula.
    %%%%% De ac� en adelante cargo los dem�s par�metros, a partir de los atributos del objeto p
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
    %%%% Parte final, escribo las im�genes con ruido
    for i=1:num_img
        ImagenNIConRuidoColumna=C(:,i); % Leo la columna i de C
        ImagenNIConRuido=reshape(ImagenNIConRuidoColumna,[m n]); %La convierto en matriz
        imwrite(ImagenNIConRuido,strcat(pathWriteNoise,'\BlurredImage (',int2str(i),').jpg')); %Genero la imagen i
    end;
end