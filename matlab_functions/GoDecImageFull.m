function [] = GoDecImageFull(TextPath,r,k,Opcion,varargin)
    % Esta función recibe una ruta de un directorio de imágenes. Las
    % vectoriza y organiza en una matrix X. Luego, utiliza la función "GoDec" para resolver
    % el problema: min||X-(L+S)||.Para ello aplica el método BRP o la SVD. En el directorio actual 
    % de trabajo se crearán dos subdirectorios, "ImageForS" y "ImageForL", donde se guardarán 
    % las imágenes correspondientes a la matriz S y L, respectivamente.
    %
    % Para más información ver el manual del Toolbox en <a href="matlab: 
    % web('https://tecnube1-my.sharepoint.com/:b:/g/personal/jfallas_itcr_ac_cr/ES65Im0jm15AvNH9XtsS8uwBvzdPE-U8CHa11fWpLCZGRw?e=fLPthq')"> Manual del Toolbox norma de Frobenius</a>.
    %
    % Sintaxis: GoDecImageFull('Textpath',r,k,Opcion)
    %
    % Parámetros de entrada:
    %       Textpath: Ruta del directorio de la base de datos de imágenes. 
    %       r: Rango máximo que tendrá la matriz L.
    %       k: Cardinalidad máxima que tendrá la matriz S.
    %       Opcion: Valores posibles 'BRP' o 'SVD'.
    %
    % Sintaxis alternativa: GoDecImageFull('Textpath',r,k,'Opcion','c',c,'Tol',Tol,'IteraMax',IteraMax)
    %   
    % Sobre los parámetros opcionales:
    %       c:        Parámetro del "power scheme", se utiliza para mejorar la 
    %                 generación de las matrices de proyección bilateral. Debe 
    %                 ser entero, positivo y podría ser ajustado por el usuario. 
    %                 Su valor por defecto es c=3.
    %       Tol:      Tolerancia, para el método de paro, diferencia entre dos errores
    %                 consecutivos menor que Tol. EL valor por defecto es 10^-8.
    %       IteraMax: Número máximo de iteraciones a realizar. El valor por
    %                 defecto es 100.
  
[X,~,m,n]=ReadImageDataBase(TextPath);
[L,S,~]=GoDec(X,r,k,Opcion,varargin{:});
Matrix2Image(S,m,n,'ImagesForS','S');
Matrix2Image(L,m,n,'ImagesForL','L');
end

