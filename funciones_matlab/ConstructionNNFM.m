function [W,H,m,n] = ConstructionNNFM(Textpath,varargin)
    % Esta funci�n utiliza la funci�n ReadImageDataBase para leer una carpeta de
    % im�genes y construir la matriz A de dimensi�n mAxnA, que contiene la vectorizaci�n de las im�genes en sus
    % columnas. Posteriormente, usa la funci�n nnfLS para construir las matrices W y H, 
    % las cuales se almacenan en la carpeta �Results�. 
    %
    % Para m�s informaci�n ver el manual del Toolbox en <a href="matlab: 
    % web('https://tecnube1-my.sharepoint.com/:b:/g/personal/jfallas_itcr_ac_cr/ES65Im0jm15AvNH9XtsS8uwBvzdPE-U8CHa11fWpLCZGRw?e=fLPthq')"> Manual del Toolbox norma de Frobenius</a>.
    %
    % Sintaxis: [W,H,m,n] = ConstructionNNFM('Textpath')
    %
    % Par�metro de entrada:
    %       Textpath: Ruta de la carpeta con las im�genes.
    %
    % Sintaxis alternativa: [W,H,m,n] = ConstructionNNFM(Textpath,'Extension',ext,'r',r,'IteraMax',itera,'Tol',tol)
    %
    % Sobre los par�metros opcionales:
    %       Extension: Las extensiones que se aceptan son jpg, pgm, png, tif, bpm. 
    %                  El valor por defecto es .jpg
    %       r:         Es la condici�n para el rango. El valor por defecto es r=floor(min(mA,nA)/2)
    %       IteraMax:  Es el n�mero m�ximo de iteraciones. El valor por defecto es 2*nA         
    %       Tol:       Es la tolerancia, su valor por defecto es 10^-6
    %
    % Par�metros de salida:        
    %       W:   Es la matriz de base de las im�genes. Adem�s, guarda un archivo W.mat en 
    %            la carpeta "Results".
    %       H:   Es la matriz de los coeficientes. Adem�s, guarda un archivo H.mat en la 
    %            carpeta "Results".
    %       m,n: Son las dimensiones de cada una de las im�genes en la base. 

[Lista1,Lista2]=SplitVarargin(varargin);
[A,m,n] = ReadImageDataBase(Textpath,Lista1{:});
[W,H,~]=nnfLS(A,Lista2{:});
direccion=strcat('Results\ImagesBase');
if exist(direccion)~=7
    mkdir(direccion);
end
save('Results\W.mat','W');
save('Results\H.mat','H');
Matrix2Image(W,m,n,'Results\ImagesBase','BaseImage');
end

function [Lista1,Lista2]=SplitVarargin(listaparametros)
LongVarar=length(listaparametros);
j=1;
l1=1;
l2=1;
Lista1={};
Lista2={};
while j<=LongVarar
    switch listaparametros{j}
    case 'Extension'
        Lista1{l1}=listaparametros{j};
        Lista1{l1+1}=listaparametros{j+1};
        l1=l1+2;
    case 'r'
        Lista2{l2}=listaparametros{j};
        Lista2{l2+1}=listaparametros{j+1};
        l2=l2+2;
    case 'IteraMax'
        Lista2{l2}=listaparametros{j};
        Lista2{l2+1}=listaparametros{j+1};
        l2=l2+2;
    case 'Tol'
        Lista2{l2}=listaparametros{j};
        Lista2{l2+1}=listaparametros{j+1};
        l2=l2+2;
    otherwise
        error(strcat('El par�metro ', listaparametros{j}, 'no es reconocido'));
    end
    j=j+2;
end

end