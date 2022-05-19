function [X,m,n,A]=FullRankConstrainedFilterX(Textpath,varargin)
	% Esta funci�n lee una carpeta con im�genes con la funci�n "ReadDataBase" 
    % y calcula la matriz X de rango reducido que minimiza ||A-XC||_fr.
    %
    % Para m�s informaci�n ver el manual del Toolbox en <a href="matlab: 
    % web('https://tecnube1-my.sharepoint.com/:b:/g/personal/jfallas_itcr_ac_cr/ES65Im0jm15AvNH9XtsS8uwBvzdPE-U8CHa11fWpLCZGRw?e=fLPthq')"> Manual del Toolbox norma de Frobenius</a>.
    %
    % Sintaxis: [X,m,n,A]=FullRankConstrainedFilterX('Textpath')
    %
    % Par�metro de entrada: 
    %       Textpath: Ruta de la carpeta con las im�genes.
    %
    % Sintaxis alternativa:
    %       Opci�n 1: [X,m,n,A]=FullRankConstrainedFilterX('Textpath','k',k_0, ...
    %                           'NoiseOption','gaussian','sigmagauss',n_0 ,'meangauss',n_1);
    %       Opci�n 2: [X,m,n,A]=FullRankConstrainedFilterX('Textpath','k',k_0,'NoiseOption',...
    %                           's&p','d',n_0);
    %       Opci�n 3: [X,m,n,A]=FullRankConstrainedFilterX('Textpath','k',k_0,...
    %                           'NoiseOption','speckle','sigmaspeckle',n_0);
    %
    % Sobre los par�metros opcionales:
    %
    %       NoiseOption:  Es el tipo de ruido, teniendo las opciones 'speckle',
    %                     's&p','gaussian', donde 's&p' significa "salt and
    %                     pepper". El valor por defecto es NoiseOption=gaussian.
    %       k:            Es el valor con el cual se restringe el rango. Debe cumplir
    %                     0<k<=min(mA,nA), donde mA=m*n (mxn es la dimensi�n de cada
    %                     fotograf�a en la base) y nA es el n�mero de im�genes en la
    %                     base. El valor por defecto es k=min(mA,nA).
    %       sigmagauss:   Varianza para el ruido gaussiano. El valor por defecto es sigmagauss=0.01
    %       meangauss:    Media para el ruido gaussiano. El valor por defecto es meangauss=0
    %       sigmaspeckle: Varianza para el ruido speckle. El valor por defecto es sigmaspeckle=0.05                  
    %       d:            Densidad del ruido para s&p. El valor por defecto es d=0.05
    %
    % Par�metros de salida:       
    %       A:   Matriz que contiene las im�genes originales, organizadas en columnas. 
    %       C:   Matriz que contiene las im�genes con ruido, organizadas en columnas. 
    %       X:   Matriz que corresponde al filtro construido.
    %       m,n: Son las dimensiones de cada una de las im�genes en la base.

    [A,m,n]=ReadImageDataBase(Textpath); %%Lee la base de im�genes
    [mA,nA]=size(A);
    %%%%%%%%%%%%%%Ac� cargo los valores por default
    NoiseOption='gaussian';
    k=min(mA,nA);
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
    addParameter(p,'k',k,@(x) x==floor(x) && (x>0));
    addParameter(p,'sigmagauss',sigmagauss,validScalar1);
    addParameter(p,'meangauss',meangauss,validScalar2);
    addParameter(p,'d',d,validScalar1);
    addParameter(p,'sigmaspeckle',sigmaspeckle,validScalar1);
    parse(p,Textpath,varargin{:});   
    %%%%%%%%%%%%%%%%% Cierro el inputParser
    NoiseOption=p.Results.NoiseOption; %Cargo el tipo de ruido
    NoiseOption=lower(strrep(NoiseOption,' ','')); %Elimino espacios vac�os y may�sculas
    k=p.Results.k; %Cargo el valor de k que restringe al rango
    if (k >min(mA,nA)) %Complemento la validaci�n de k
        error(['The value of "k" is invalid. For your dataset it must satisfy the condition 0<k<=' int2str(min(mA,nA))]);
    end
    %%%%% De ac� en adelante cargo los dem�s par�metros, a partir de los atributos del objeto p
    sigmagauss=p.Results.sigmagauss;
    meangauss=p.Results.meangauss;
    d=p.Results.d;
    sigmaspeckle=p.Results.sigmaspeckle;
    %%%% Cierro la carga de variables
    %%%% Ahora Creo la matriz con ruido mediante la funci�n NoiseFunction
    C=NoiseFunction(Textpath,'NoiseOption',NoiseOption,'sigmagauss',sigmagauss,'meangauss',meangauss,'d',d,'sigmaspeckle',sigmaspeckle); 
    %%%% Ahora Creo la matriz X de rango reducido
    [X]=RankConstrainedFilterX(A,C,k);
end
