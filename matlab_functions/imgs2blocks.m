function Y=imgs2blocks(Textpath,Extension)
    % Esta funci�n recibe una ruta de una carpeta con 'p' im�genes y construye 
    % una matriz Y de tama�o 64 x (pmn/64), donde cada columna de Y
    % corresponde a una vectorizaci�n de los bloques de tama�o 8 x 8 tomados 
    % de cada una de las im�genes.
    %
    % Para m�s informaci�n ver el manual del Toolbox en <a href="matlab: 
    % web('https://tecnube1-my.sharepoint.com/:b:/g/personal/jfallas_itcr_ac_cr/ES65Im0jm15AvNH9XtsS8uwBvzdPE-U8CHa11fWpLCZGRw?e=fLPthq')"> Manual del Toolbox norma de Frobenius</a>.
    % 
    % Sintaxis: Y=imgs2blocks('Textpath','Extension')
    %
    % Par�metro de entrada:
    %           Textpath : Ruta de la carpeta con las im�genes.
    %           Extension: Es la extensi�n de las im�genes.
    %
    % Par�metro de salida:
    %           Y = Matriz de tama�o (64 x pmn/64)
    
NameFilesVector=ls(Textpath); %Vector con los nombres completos de todos los archivos en la carpeta
i=0; %%%Controla el n�mero de archivos v�lidos en la carpeta, dado que en la carpeta
     %%% podr�an haber archivos del sistema, los cuales hay que ignorar.
 Y=[];
 for j=1:size(NameFilesVector,1)
   Filej=NameFilesVector(j,:); %Toma el archivo j de la carpeta
   [~,~,Fileextension]=fileparts(Filej); %Lee la extensi�n del archivo
   %%% En el siguiente if valida el archivo y si la extensi�n coincide
   if (and(~isdir(fullfile(Textpath,Filej)),or(strcmpi(strtrim(Fileextension),Extension),isempty(Extension))))
       i=i+1; %% Archivo v�lido, incrementa el contador de im�genes.
       direccion=fullfile(Textpath,Filej); %% Carga la direcci�n completa del archivo.
       ima=imread(direccion);
       if size(ima,3)==3
           ImageMatrix=rgb2gray(ima); %%% Convierte la imagen en matriz de tipo doble
       else
           ImageMatrix=ima;
       end
       if i==1 [m,n]=size(ImageMatrix); end; %%% Registra las dimensiones de cada imagen
        Xaux1=ImageMatrix; 
        Xaux2=im2double(block_img_8(Xaux1));
        Xaux3=im2block8(Xaux2); 
        Y=[Y Xaux3];
   end
 end
 num_img=i;
 if i==0 error(strcat('There are not images in your data base with the extension ',Extension));
 end
end

function Y=im2block8(X)
    % Esta funci�n convierte una matriz X de tama�o m x n en una matriz Y de
    % tama�o (64 x mn/64), donde cada columna de Y vienen de un bloque
    % vectorizado de tama�o  8 x 8 de X.    
    [m,n]=size(X);
    b1=m/8; b2=n/8;
    Y=[];
    for i=1:b1
        for j=1:b2
            Aux=X((i-1)*8+1:i*8,(j-1)*8+1:j*8);
            Y=[Y Aux(:)];
        end
    end
end

function Y=block_img_8(X)
    % Esta funci�n retorna una imagen, donde el n�mero de filas y columnas
    % es divisible por 8. Las dimensiones de la nueva imagen Y son los
    % m�ltiplos de 8 m�s cercanos a las dimensiones de la imagen original X
    %
    % Sintaxis: Y=block_img_8(X)
    %
    % Par�metro de entrada: 
    %           X = Una imagen de tama�o m x n.
    % Par�metro de salida: 
    %           Y = Una imagen de tama�o m1 x n1, donde m1 y
    %               n1 son divisibles por 8, y abs(m1-m) y 
    %               abs(n1-n) es m�nimo
        
    [m,n]=size(X);
    s1=mod(m,8);
    s2=mod(n,8);
    if and(s1==0,s2==0)
        m1=m; n1=n;
    elseif and(s1==0,s2~=0)
        if s2<=4
            m1=m; n1=n-s2;
        else
            m1=m; n1=n+8-s2;
        end        
    elseif and(s1~=0,s2==0)
        if s1<=4
            m1=m-s1; n1=n;
        else
            m1=m+8-s1; n1=n;
        end
    elseif and(s1~=0,s2~=0)
        if s1<=4
            m1=m-s1;
        else
            m1=m+8-s1;
        end
        if s2<=4
            n1=n-s2;
        else
            n1=n+8-s2;
        end        
    end       
    Y=imresize(X,[m1,n1]);
end
