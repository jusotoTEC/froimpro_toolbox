function [XO,m1,n1] = Video2Matrix(PathTextVideo,varargin)
    % Esta funci�n lee un video en formato MP4 en la direcci�n indicada por
    % 'PathTextVideo', y lo codifica como una matriz de tama�o (mn x numFrames), 
    % donde cada frame del video es de tama�o mxn pixeles. El usuario tiene la opci�n de 
    % indicar el n�mero de frames que se procesar�n (los cuales se tomar�n distribuidos
    % uniformemente del video original). En caso que no lo indique, se
    % codifica el video completo. 
    %
    % Para m�s informaci�n ver el manual del Toolbox en <a href="matlab: 
    % web('https://tecnube1-my.sharepoint.com/:b:/g/personal/jfallas_itcr_ac_cr/ES65Im0jm15AvNH9XtsS8uwBvzdPE-U8CHa11fWpLCZGRw?e=fLPthq')"> Manual del Toolbox norma de Frobenius</a>.
    %
    % Sintaxis: [XO,m1,n1] = Video2Matrix('PathTextVideo')
    %
    % Par�metro de entrada: 
    %       PathTextVideo: Ruta del video que se va a procesar.
    %
    % Sintaxis alternativa: 
    %   [XO,m1,n1] = Video2Matrix('PathTextVideo','Scale',Scale,'numFrames',numFrames)
    %   
    % Sobre los par�metros opcionales:       
    %       Scale:     Escalar tal que 0<Scale<=1. Cada frame del video ser� escalado a un tama�o que resulta 
    %                  de muliplicar sus dimensiones originales por el factor "Scale". Su valor por 
    %                  defecto es 1. 
    %       numFrames: N�mero de frames que se usar�n del video para el proceso, tomados de manera 
    %                  uniforme. El valor por defecto es el n�mero total de frames del video original.
    %
    % Par�metros de salida:   
    %       XO:      Es una matriz de tama�ao (mn x numFrames), donde cada columna corresponde 
    %                a un frame del video vectorizado como columna.
    %       n1 y m1: Dimensiones de cada frame luego de ser reescalado seg�n el par�metro 'Scale'.

if exist(PathTextVideo,'file')~=2%Valida que el path del v�deo sea v�lido, y que corresponda a un archivo existente.
   error(['The path ',PathTextVideo,' is invalid']); 
end

%Carga el v�deo y determina el n�mero de frame que posee
VideoAProcesar = VideoReader(PathTextVideo);                 
FrameTotales = VideoAProcesar.NumberOfFrames;  

% Inicia la validaci�n de los datos de entrada
defaultScale=1;
defaultnumFrames=FrameTotales;
p = inputParser;

%Define las fuciones de validaci�n que suar� el parseador
validScale = @(x) isnumeric(x) && (x>0) && (x<=1);
validnumFrames = @(x) isnumeric(x) && mod(x,1)==0 && (x<=FrameTotales);

%Define los par�metros requeridos y opcionales y los validas con las
%funciones de validaci�n anteriores.
addRequired(p,'PathTextVideo');
addOptional(p,'Scale',defaultScale,validScale);
addOptional(p,'numFrames',defaultnumFrames,validnumFrames);

%Realice la validaci�n seg�n los par�metros establecidos
parse(p,PathTextVideo,varargin{:});

PathTextVideo=p.Results.PathTextVideo;
Scale=p.Results.Scale;
numFrames=p.Results.numFrames;

%Inicia la construcci�n de la matriz XO, misma que ser� retornada. 
FactorFrame=FrameTotales/numFrames;
Ima=rgb2gray(imresize(read(VideoAProcesar,fix(FactorFrame)),Scale));     %Primer Frame del v�deo en escala de grises.
[m1,n1]=size(Ima(:,:,1));                                                 %Tama�o del primer frame y de todos los dem�s.
XO=reshape(double(Ima),m1*n1,1);                                         %Paso del primer frame a vector.                                         %Redefine la forma de la matriz a columna de tama�o mxn a tama�o mnx1
for i=2:numFrames 
    Ima=rgb2gray(imresize(read(VideoAProcesar,fix(FactorFrame*i)),Scale));  %Pasos de todos los dem�s frames a vector, todos en 
    XO=[XO,reshape(double(Ima),m1*n1,1)];                                     %escala de grises. 
end
end

