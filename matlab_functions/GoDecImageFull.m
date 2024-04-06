function [] = GoDecImageFull(TextPath,r,k,Opcion,varargin)
    % Esta funci�n recibe una ruta de un directorio de im�genes. Las
    % vectoriza y organiza en una matrix X. Luego, utiliza la funci�n "GoDec" para resolver
    % el problema: min||X-(L+S)||.Para ello aplica el m�todo BRP o la SVD. En el directorio actual 
    % de trabajo se crear�n dos subdirectorios, "ImageForS" y "ImageForL", donde se guardar�n 
    % las im�genes correspondientes a la matriz S y L, respectivamente.
    %
    % Para m�s informaci�n ver el manual del Toolbox en <a href="matlab: 
    % web('https://tecnube1-my.sharepoint.com/:b:/g/personal/jfallas_itcr_ac_cr/ES65Im0jm15AvNH9XtsS8uwBvzdPE-U8CHa11fWpLCZGRw?e=fLPthq')"> Manual del Toolbox norma de Frobenius</a>.
    %
    % Sintaxis: GoDecImageFull('Textpath',r,k,Opcion)
    %
    % Par�metros de entrada:
    %       Textpath: Ruta del directorio de la base de datos de im�genes. 
    %       r: Rango m�ximo que tendr� la matriz L.
    %       k: Cardinalidad m�xima que tendr� la matriz S.
    %       Opcion: Valores posibles 'BRP' o 'SVD'.
    %
    % Sintaxis alternativa: GoDecImageFull('Textpath',r,k,'Opcion','c',c,'Tol',Tol,'IteraMax',IteraMax)
    %   
    % Sobre los par�metros opcionales:
    %       c:        Par�metro del "power scheme", se utiliza para mejorar la 
    %                 generaci�n de las matrices de proyecci�n bilateral. Debe 
    %                 ser entero, positivo y podr�a ser ajustado por el usuario. 
    %                 Su valor por defecto es c=3.
    %       Tol:      Tolerancia, para el m�todo de paro, diferencia entre dos errores
    %                 consecutivos menor que Tol. EL valor por defecto es 10^-8.
    %       IteraMax: N�mero m�ximo de iteraciones a realizar. El valor por
    %                 defecto es 100.
  
[X,~,m,n]=ReadImageDataBase(TextPath);
[L,S,~]=GoDec(X,r,k,Opcion,varargin{:});
Matrix2Image(S,m,n,'ImagesForS','S');
Matrix2Image(L,m,n,'ImagesForL','L');
end

