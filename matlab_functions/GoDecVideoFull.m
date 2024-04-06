function [] = GoDecVideoFull(TextPath,r,k,Opcion,varargin)
    % Esta función se encarga de tomar un video, codificarlo en una matriz
    % X y aplicarle la función GoDec. Además, genera los videos correspondientes
    % a las matrices S y L.
    %
    % Para más información ver el manual del Toolbox en <a href="matlab: 
    % web('https://tecnube1-my.sharepoint.com/:b:/g/personal/jfallas_itcr_ac_cr/ES65Im0jm15AvNH9XtsS8uwBvzdPE-U8CHa11fWpLCZGRw?e=fLPthq')"> Manual del Toolbox norma de Frobenius</a>.
    %
    % Sintaxis: GoDecVideoFull('Textpath',r,k,Opcion)
    %
    % Parámetro de entrada:
    %       Textpath: Ruta del video que se va a procesar. 
    %       r: Rango máximo que tendrá la matriz L.
    %       k: Cardinalidad máxima que tendrá la matriz S.
    %       Opcion: Valores posibles 'BRP' o 'SVD'.
    %
    % Sintaxis alternativa: 
    %   GoDecVideoFull('Textpath',r,k,'Opcion','Scale',Scale,'numFrames',numFrames,'c',c,'Tol',Tol,'IteraMax',IteraMax)
    %   
    % Sobre los parámetros opcionales:   
    %       Scale:     Escalar tal que 0<Scale<=1. Cada frame del video será escalado a un tamaño que resulta 
    %                  de muliplicar sus dimensiones originales por el factor "Scale". Su valor por 
    %                  defecto es 1. 
    %       numFrames: Número de frames que se usarán del video para el proceso, tomados de manera 
    %                  uniforme. El valor por defecto es el número total de frames del video original. 
    %       c:         Parámetro del "power scheme", se utiliza para mejorar la 
    %                  generación de las matrices de proyección bilateral. Debe 
    %                  ser entero, positivo y podría ser ajustado por el usuario. 
    %                  Su valor por defecto es c=3.
    %       Tol:       Tolerancia, para el método de paro, diferencia entre dos errores
    %                  consecutivos menor que Tol. EL valor por defecto es 10^-8.
    %       IteraMax:  Número máximo de iteraciones a realizar. El valor por
    %                  defecto es 100.    
   
LongVarar=length(varargin);
    %Este bloque se encarga de tomar los datos opcionales y separarlos para ser enviados 
    %en las dos funciones siguientes:
    %   -Video2Matrix(TextPath,Lista1{:});
    %   -GoDec(X,r,k,Lista2{:})
    %Estos parámetros no son validados aquí pues luego serán sometidos a
    %una validación dentro de estas funciones.
j=1;
l1=1;
l2=1;
Lista1={};
Lista2={};
while j<=LongVarar
    switch varargin{j}
    case 'Scale'
        Lista1{l1}=varargin{j};
        Lista1{l1+1}=varargin{j+1};
        l1=l1+2;
    case 'numFrames'
        Lista1{l1}=varargin{j};
        Lista1{l1+1}=varargin{j+1};
        l1=l1+2;
    case 'c'
        Lista2{l2}=varargin{j};
        Lista2{l2+1}=varargin{j+1};
        l2=l2+2;
    case 'IteraMax'
        Lista2{l2}=varargin{j};
        Lista2{l2+1}=varargin{j+1};
        l2=l2+2;
    case 'Tol'
        Lista2{l2}=varargin{j};
        Lista2{l2+1}=varargin{j+1};
        l2=l2+2;
    otherwise
        error(strcat('El parámetro ', varargin{j}, 'no es reconocido'));
    end
    j=j+2;
end


[X,m1,n1]=Video2Matrix(TextPath,Lista1{:});
%k=fix(0.075*n1*m1*200);
[LRF,SRF,~]=GoDec(X,r,k,Opcion,Lista2{:});
Matrix2Video(SRF,m1,n1,'S');
Matrix2Video(LRF,m1,n1,'L');
MatrixXLS2Video(X,LRF,SRF,m1,n1,'XLS');
end


function [] = MatrixXLS2Video(X,L,S,m,n,PathNameVideo)
%Esta función se encargar de transformar una matriz X cuyas columnas
%corresponden a frames de tamaño mxn pixeles y lo convierte en un vídeo que
%guardará en la dirección de que se indica en PathNameVideo. Este vídeo
%se guardará en formato MP4.
%%%%%%%%%%%%%
%Recibe: 
%%%%%%%%%%%%%
%%% Una matriz X: Esta matriz es de tamaño mnxp. Cada columna de esta matriz
       %corresponde a un frame del vídeo.
%%%m y n: Corresponde al número de filas y el número columnas que que tendrá
       %cada frame visto como matriz. Es necesario recibirlos pues cada frame en X
       %está expresado como una sola columna, por lo que es necesario
       %redimensionar cada columna de X en una matriz de tamaño mxn.

% Inicio de la validación los parámetros recibidos, en este caso todos los
%  son obligatorios.

if not(isnumeric(L) && ismatrix(L))
    Error('The parameter X is invalid.');
end
if not(isnumeric(S) && ismatrix(S))
    Error('The parameter X is invalid.');
end
if not(isnumeric(X) && ismatrix(X))
    Error('The parameter X is invalid.');
end
if not(isnumeric(m)&& (mod(m,1)==0))
    Error('The value for parameter "m" is invalid.')
end
if not(isnumeric(n)&& (mod(n,1)==0))
    Error('The value for parameter "n" is invalid.')
end
[numPixeles,numFrames]=size(X);
if (m*n~=numPixeles)
    Error('The values of m and n do not correspond to the number of pixels in each frame: Pixels number = m*n');
end



%%% Termina la validación de parámetros e inicia la creación del vídeo
posUltiLinea=max(strfind(PathNameVideo,'\'));
if posUltiLinea>1
    if exist(PathNameVideo(1:posUltiLinea-1))~=7
        mkdir(PathNameVideo(1:posUltiLinea-1));
    end
end
v = VideoWriter(PathNameVideo,'MPEG-4'); %Define el vídeo.
open(v)                                  %abre el vídeo para editarlo.
isize=[m,n];
for ii = 1:numFrames
    Frame=[double2uint8(reshape(X(:,ii),isize)),double2uint8(reshape(L(:,ii),isize)),double2uint8(reshape(S(:,ii),isize))];
    writeVideo(v,Frame); %Agregar un frame a la vez al vídeo
end
close(v)
end

