function [XO,m1,n1] = Video2Matrix(PathTextVideo,varargin)
    % Esta función lee un video en formato MP4 en la dirección indicada por
    % 'PathTextVideo', y lo codifica como una matriz de tamaño (mn x numFrames), 
    % donde cada frame del video es de tamaño mxn pixeles. El usuario tiene la opción de 
    % indicar el número de frames que se procesarán (los cuales se tomarán distribuidos
    % uniformemente del video original). En caso que no lo indique, se
    % codifica el video completo. 
    %
    % Para más información ver el manual del Toolbox en <a href="matlab: 
    % web('https://tecnube1-my.sharepoint.com/:b:/g/personal/jfallas_itcr_ac_cr/ES65Im0jm15AvNH9XtsS8uwBvzdPE-U8CHa11fWpLCZGRw?e=fLPthq')"> Manual del Toolbox norma de Frobenius</a>.
    %
    % Sintaxis: [XO,m1,n1] = Video2Matrix('PathTextVideo')
    %
    % Parámetro de entrada: 
    %       PathTextVideo: Ruta del video que se va a procesar.
    %
    % Sintaxis alternativa: 
    %   [XO,m1,n1] = Video2Matrix('PathTextVideo','Scale',Scale,'numFrames',numFrames)
    %   
    % Sobre los parámetros opcionales:       
    %       Scale:     Escalar tal que 0<Scale<=1. Cada frame del video será escalado a un tamaño que resulta 
    %                  de muliplicar sus dimensiones originales por el factor "Scale". Su valor por 
    %                  defecto es 1. 
    %       numFrames: Número de frames que se usarán del video para el proceso, tomados de manera 
    %                  uniforme. El valor por defecto es el número total de frames del video original.
    %
    % Parámetros de salida:   
    %       XO:      Es una matriz de tamañao (mn x numFrames), donde cada columna corresponde 
    %                a un frame del video vectorizado como columna.
    %       n1 y m1: Dimensiones de cada frame luego de ser reescalado según el parámetro 'Scale'.

if exist(PathTextVideo,'file')~=2%Valida que el path del vídeo sea válido, y que corresponda a un archivo existente.
   error(['The path ',PathTextVideo,' is invalid']); 
end

%Carga el vídeo y determina el número de frame que posee
VideoAProcesar = VideoReader(PathTextVideo);                 
FrameTotales = VideoAProcesar.NumberOfFrames;  

% Inicia la validación de los datos de entrada
defaultScale=1;
defaultnumFrames=FrameTotales;
p = inputParser;

%Define las fuciones de validación que suará el parseador
validScale = @(x) isnumeric(x) && (x>0) && (x<=1);
validnumFrames = @(x) isnumeric(x) && mod(x,1)==0 && (x<=FrameTotales);

%Define los parámetros requeridos y opcionales y los validas con las
%funciones de validación anteriores.
addRequired(p,'PathTextVideo');
addOptional(p,'Scale',defaultScale,validScale);
addOptional(p,'numFrames',defaultnumFrames,validnumFrames);

%Realice la validación según los parámetros establecidos
parse(p,PathTextVideo,varargin{:});

PathTextVideo=p.Results.PathTextVideo;
Scale=p.Results.Scale;
numFrames=p.Results.numFrames;

%Inicia la construcción de la matriz XO, misma que será retornada. 
FactorFrame=FrameTotales/numFrames;
Ima=rgb2gray(imresize(read(VideoAProcesar,fix(FactorFrame)),Scale));     %Primer Frame del vídeo en escala de grises.
[m1,n1]=size(Ima(:,:,1));                                                 %Tamaño del primer frame y de todos los demás.
XO=reshape(double(Ima),m1*n1,1);                                         %Paso del primer frame a vector.                                         %Redefine la forma de la matriz a columna de tamaño mxn a tamaño mnx1
for i=2:numFrames 
    Ima=rgb2gray(imresize(read(VideoAProcesar,fix(FactorFrame*i)),Scale));  %Pasos de todos los demás frames a vector, todos en 
    XO=[XO,reshape(double(Ima),m1*n1,1)];                                     %escala de grises. 
end
end

