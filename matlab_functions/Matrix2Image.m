function [] = Matrix2Image(X,m,n,TextPath,Name)
    % Esta funci�n recibe una matriz X de tama�o mnxp, la cual contiene en sus columnas la
    % informaci�n de p im�genes vectorizadas, de tama�o mxn. Al ejecutar la
    % funci�n se generar�n las im�genes correspondientes en el directorio 'TextPath'. 
    %
    % Para m�s informaci�n ver el manual del Toolbox en <a href="matlab: 
    % web('https://tecnube1-my.sharepoint.com/:b:/g/personal/jfallas_itcr_ac_cr/ES65Im0jm15AvNH9XtsS8uwBvzdPE-U8CHa11fWpLCZGRw?e=fLPthq')"> Manual del Toolbox norma de Frobenius</a>.
    %
    % Sintaxis: Matrix2Image(X,m,n,'Textpath','Name')
    %
    % Par�metro de entrada:
    %       X: Matriz X de tama�o mnxp.
    %       m,n: Son enteros positivos tales que mxn es el tama�o de cada
    %            una de las im�genes.
    %       Textpath: Ruta donde se guadar�n las im�genes asociadas a cada columna de X.
    %       Name: Ra�z con el que se nombrar�n las im�genes, seguido de un contador autom�tico.

isize=[m,n]; %tama�o de cada imagen
[~,p]=size(X); %n�mero de im�genes
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
%%Recibe una Cadena de caracteres en "Text" y un n�mero natural N.
%%Retorna una cadena donde se concaten� Text N veces.
TextOut='';
for i=1:N
   TextOut=strcat(TextOut,Text); 
end
end


