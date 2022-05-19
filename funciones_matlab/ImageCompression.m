function [] = ImageCompression(Textpath,radio,Opcion)
    % Esta función recibe una imagen y la comprime utilizando un radio de 
    % compresión indicado por el usuario, el cual corresponde al porcentaje 
    % de valores singulares no nulos que se deben utilizar. El radio de 
    % compresión es un decimal $d$ tal que $\tfrac{1}{\min\{m,n\}}\leq d\leq 1$. 
    % En la carpeta "Results", dentro del directorio de trabajo,  se guardará 
    % la imagen original, la imagen reconstruida y la información de las matrices
    % A y B en dos archivos de texto, que son las que dan sentido al proceso 
    % de compresión. Si la carpeta ``Results'' no existe, la crea automáticamente.
    %
    % Para más información ver el manual del Toolbox en <a href="matlab: 
    % web('https://tecnube1-my.sharepoint.com/:b:/g/personal/jfallas_itcr_ac_cr/ES65Im0jm15AvNH9XtsS8uwBvzdPE-U8CHa11fWpLCZGRw?e=fLPthq')"> Manual del Toolbox norma de Frobenius</a>.
    %
    % Sintaxis: ImageCompression('Textpath',radio,'Opcion')
    %
    % Parámetros de entrada:     
    %       Textpath: Ruta de la imagen que desea comprimir.
    %       radio:    Este escalar representa el porcentaje de valores
    %                 singulares no nulos que se utilizarán para la compresión.
    %                 O lo que es lo mismo, el porcentaje del rango de la
    %                 imagen que se utilizará para comprimir.
    %       Opcion: Etiqueta con la que se indica si se desea aplicar BRP o SVD.

     ExpectedOptions = {'BRP','SVD'};%%%% Validación de la opción
     Opcion=upper(strrep(Opcion,' ',''));
     ValidarOpcion=@(x) any(strcmp(Opcion,ExpectedOptions));
     if ValidarOpcion(Opcion)==0 
        error(['Opción no admitida. Debe indicar BRP o SVD. Usted digitó ',Opcion]);
     end
%%%% Fin de la validación
ima=imread(Textpath);
if size(ima,3)==3
   L=im2double(rgb2gray(ima)); %%% Convierte la imagen en matriz de tipo doble
else
   L=im2double(ima);
end
[m,n]=size(L);
Minmn=min(m,n);
%%%%%% Validaciones
Validporcentaje = @(x) isnumeric(x) && (x>1/Minmn) && (x <= 1);
if Validporcentaje(radio)==0 
    error(['El radio de compresión indicado para esta imagen no es válido. Deber ser un decimal d, tal que ',num2str(1/Minmn),'<=d<=1.']);
end
%%%%%% Fin de validaciones
r=floor(radio*Minmn);
if Opcion=='BRP'
   [A,B]=LowRankMatrixBRP(L,'r',r);
else
    [U,S,V]=svd(L);
    Urecortada=U(:,1:r);
    Srecortada=S(1:r,1:r);
    Vrecortada=V(:,1:r);
    A=Urecortada*Srecortada;
    B=Vrecortada.';
end
LTilde=A*B;
toc
direccion=strcat('Results');
if exist(direccion)~=7
    mkdir(direccion);
end
dlmwrite('Results\L.txt',L);
dlmwrite('Results\A.txt',A);
dlmwrite('Results\B.txt',B);
imwrite(double2uint8(L),'Results\OriginalImage.jpg');
imwrite(double2uint8(LTilde),'Results\CompressedImage.jpg');
end