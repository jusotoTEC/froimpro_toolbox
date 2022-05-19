function [C,A,m,n]=NoiseFunction(Textpath,varargin)
    % Esta funci�n lee una carpeta con im�genes con la funci�n "ReadDataBase" y calcula la matriz A 
    % que contiene de la im�genes originales en sus columnas, y C que es la matriz con las im�genes en 
    % en sus columnas, pero con ruido.
    %
    % Para m�s informaci�n ver el manual del Toolbox en <a href="matlab: 
    % web('https://tecnube1-my.sharepoint.com/:b:/g/personal/jfallas_itcr_ac_cr/ES65Im0jm15AvNH9XtsS8uwBvzdPE-U8CHa11fWpLCZGRw?e=fLPthq')"> Manual del Toolbox norma de Frobenius</a>.
    %
    % Sintaxis: [C,A,m,n]=NoiseFunction('Textpath')
    %    
    % Par�metro de entrada: 
    %       Textpath: Ruta de la carpeta con las im�genes.    
    %
    % Sintaxis alternativa:
    %       Opci�n 1: [C,A,m,n]=NoiseFunction('Textpath','NoiseOption','gaussian','sigmagauss',n_0,'meangauss',n_1);
    %       Opci�n 2: [C,A,m,n]=NoiseFunction('Textpath','NoiseOption','s&p','d',n_0);
    %       Opci�n 3: [C,A,m,n]=NoiseFunction('Textpath','NoiseOption','speckle','sigmaspeckle',n_0);
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
    % Par�metros de salida:       
    %       A:   Matriz que contiene las im�genes originales, organizadas en columnas. 
    %       C:   Matriz que contiene las im�genes con ruido, organizadas en columnas. 
    %       m,n: Son las dimensiones de cada una de las im�genes en la base.    
    
    [A,m,n]=ReadImageDataBase(Textpath); %%Lee la base de im�genes
    [~,num_img]=size(A);
    %%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%Ac� cargo los valores por default
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
    addRequired(p,'Textpath'); %% Par�metro obligatorio. Los de abajo todos son opcionales.
    addParameter(p,'NoiseOption',NoiseOption,@(x) any(strcmp(lower(strrep(x,' ','')),expectedNoises))); 
                    %%%%  Valida si el par�metro 'NoiseOption' existe.
                    %%%%  Si no existe, le asigna el valor por defecto.
                    %%%%  Si s� existe, el objeto "p" contiene el valor ingresado por el usuario.
                    %%%%  Se accesa con p.Results.NoiseOption         
    addParameter(p,'sigmagauss',sigmagauss,validScalar1);
    addParameter(p,'meangauss',meangauss,validScalar2);
    addParameter(p,'d',d,validScalar1);
    addParameter(p,'sigmaspeckle',sigmaspeckle,validScalar1);
    parse(p,Textpath,varargin{:});   
    %%%%%%%%%%%%%%%%% Cierro el inputParser
    NoiseOption=p.Results.NoiseOption; %Cargo el tipo de ruido
    NoiseOption=lower(strrep(NoiseOption,' ',''));
    if strcmp(NoiseOption,'s&p') NoiseOption='salt & pepper'; end; %Simplemente le cambio el nombre
    %%%%% De ac� en adelante cargo los dem�s par�metros, a partir de los atributos del objeto p
    sigmagauss=p.Results.sigmagauss;
    meangauss=p.Results.meangauss;
    d=p.Results.d;
    sigmaspeckle=p.Results.sigmaspeckle;
    %%%% Cierro la carga de variables    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%
    N=zeros(m,n,num_img);
    C=zeros(m*n,num_img);
    if strcmp(NoiseOption,'speckle')
            for i=1:num_img
                ImageMatrix=reshape(A(:,i),m,n);
                N=imnoise(ImageMatrix,NoiseOption,sigmaspeckle);
                C(:,i)=reshape(N,[m*n 1]); %Imagenes con ruido en las columnas 
            end;
    elseif strcmp(NoiseOption,'salt & pepper')
            for i=1:num_img  
                ImageMatrix=reshape(A(:,i),m,n);
                N=imnoise(ImageMatrix,NoiseOption,d);
                C(:,i)=reshape(N,[m*n 1]); %Imagenes con ruido en las columnas 
            end;
    elseif strcmp(NoiseOption,'gaussian') 
            for i=1:num_img    
                ImageMatrix=reshape(A(:,i),m,n);
                N=imnoise(ImageMatrix,NoiseOption,meangauss,sigmagauss);
                C(:,i)=reshape(N,[m*n 1]); %Imagenes con ruido en las columnas 
            end; 
    else
        error('The valid options for the parameter NoiseOption are gaussian, s&p and speckle.');
    end;  
     
end