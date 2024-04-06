function [] = Matrix2Video(X,m,n,PathNameVideo)
    % Esta función transforma una matriz X, cuyas columnas corresponden a los frames de un video
    % (cada uno de tamaño mxn pixeles), y lo convierte en un video en formato MP4, que se guardará 
    % en la dirección indicada por 'PathNameVideo'.
    %
    % Para más información ver el manual del Toolbox en <a href="matlab: 
    % web('https://tecnube1-my.sharepoint.com/:b:/g/personal/jfallas_itcr_ac_cr/ES65Im0jm15AvNH9XtsS8uwBvzdPE-U8CHa11fWpLCZGRw?e=fLPthq')"> Manual del Toolbox norma de Frobenius</a>.
    %
    % Sintaxis: Matrix2Video(X,m,n,'PathNameVideo')
    %
    % Parámetro de entrada:    
    %       X:             Matriz de tamaño mnxp.
    %       m,n:           Enteros positivos tales que mxn corresponde al tamaño de cada frame.
    %       PathNameVideo: Es el nombre (o ruta completa, si se desea) que le asigna al video que se
    %                      guardará en la carpeta de trabajo. 

if not(isnumeric(X) && ismatrix(X))
    Error('The parameter X is invalid.');
end
if not(isnumeric(m)&& (mod(m,1)==0))
    Error('The value for parameter "m" is invalid.')
end
if not(isnumeric(n)&& (mod(n,1)==0))
    Error('The value for parameter "n" is invalid.')
end
[~,numFrames]=size(X);
if (m*n==numFrames)
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
    writeVideo(v,double2uint8(reshape(X(:,ii),isize))); %Agregar un frame a la vez al vídeo
end
close(v)
end

