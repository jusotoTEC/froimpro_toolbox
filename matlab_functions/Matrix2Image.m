function [] = Matrix2Image(X,m,n,TextPath,Name)
    % Esta función recibe una matriz X de tamaño mnxp, la cual contiene en sus columnas la
    % información de p imágenes vectorizadas, de tamaño mxn. Al ejecutar la
    % función se generarán las imágenes correspondientes en el directorio 'TextPath'. 
    %
    % Para más información ver el manual del Toolbox en <a href="matlab: 
    % web('https://tecnube1-my.sharepoint.com/:b:/g/personal/jfallas_itcr_ac_cr/ES65Im0jm15AvNH9XtsS8uwBvzdPE-U8CHa11fWpLCZGRw?e=fLPthq')"> Manual del Toolbox norma de Frobenius</a>.
    %
    % Sintaxis: Matrix2Image(X,m,n,'Textpath','Name')
    %
    % Parámetro de entrada:
    %       X: Matriz X de tamaño mnxp.
    %       m,n: Son enteros positivos tales que mxn es el tamaño de cada
    %            una de las imágenes.
    %       Textpath: Ruta donde se guadarán las imágenes asociadas a cada columna de X.
    %       Name: Raíz con el que se nombrarán las imágenes, seguido de un contador automático.

isize=[m,n]; %tamaño de cada imagen
[~,p]=size(X); %número de imágenes
direccion=strcat(TextPath,'\',Name);
if exist(TextPath)~=7
    mkdir(TextPath);
end
NumCeros=length(num2str(p));
CerosText=NStr('0',NumCeros);
for i=1:p
    NumCerosActual=length(num2str(i));
    CerosActual=CerosText(1:(NumCeros-NumCerosActual));
    imwrite(double2uint8(reshape(X(:,i),isize)),strcat(direccion,CerosActual,num2str(i),'.jpg'));
end
end

function [TextOut] = NStr(Text,N)
%%Recibe una Cadena de caracteres en "Text" y un número natural N.
%%Retorna una cadena donde se concatenó Text N veces.
TextOut='';
for i=1:N
   TextOut=strcat(TextOut,Text); 
end
end


