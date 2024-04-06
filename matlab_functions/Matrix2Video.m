function [] = Matrix2Video(X,m,n,PathNameVideo)
    % Esta funci�n transforma una matriz X, cuyas columnas corresponden a los frames de un video
    % (cada uno de tama�o mxn pixeles), y lo convierte en un video en formato MP4, que se guardar� 
    % en la direcci�n indicada por 'PathNameVideo'.
    %
    % Para m�s informaci�n ver el manual del Toolbox en <a href="matlab: 
    % web('https://tecnube1-my.sharepoint.com/:b:/g/personal/jfallas_itcr_ac_cr/ES65Im0jm15AvNH9XtsS8uwBvzdPE-U8CHa11fWpLCZGRw?e=fLPthq')"> Manual del Toolbox norma de Frobenius</a>.
    %
    % Sintaxis: Matrix2Video(X,m,n,'PathNameVideo')
    %
    % Par�metro de entrada:    
    %       X:             Matriz de tama�o mnxp.
    %       m,n:           Enteros positivos tales que mxn corresponde al tama�o de cada frame.
    %       PathNameVideo: Es el nombre (o ruta completa, si se desea) que le asigna al video que se
    %                      guardar� en la carpeta de trabajo. 

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

%%% Termina la validaci�n de par�metros e inicia la creaci�n del v�deo
posUltiLinea=max(strfind(PathNameVideo,'\'));
if posUltiLinea>1
    if exist(PathNameVideo(1:posUltiLinea-1))~=7
        mkdir(PathNameVideo(1:posUltiLinea-1));
    end
end
v = VideoWriter(PathNameVideo,'MPEG-4'); %Define el v�deo.
open(v)                                  %abre el v�deo para editarlo.
isize=[m,n];
for ii = 1:numFrames
    writeVideo(v,double2uint8(reshape(X(:,ii),isize))); %Agregar un frame a la vez al v�deo
end
close(v)
end

