function [D,X,Err]=ksvd(TextPath,r,c,varargin)    
    % El método K-SVD aproxima las matrices D y X del problema 
    % min ||Y-DX||, donde ||X(:,i)||_0<=c, donde Y es tamaño mxn, D de
    % tamaño mxr y X es de tamaño rxn. Además, c es una constante de
    % esparcidad de las columnas, la cual debe cumplir 1<=c<=m. 
    % La matriz D se denomina "diccionario".
    %
    % Para más información ver el manual del Toolbox en <a href="matlab: 
    % web('https://tecnube1-my.sharepoint.com/:b:/g/personal/jfallas_itcr_ac_cr/ES65Im0jm15AvNH9XtsS8uwBvzdPE-U8CHa11fWpLCZGRw?e=fLPthq')"> Manual del Toolbox norma de Frobenius</a>.
    %   
    % Sintaxis de la función: [D,X,Err]=ksvd('TextPath',r,c)    
    %
    % Parámetros de entrada: 
    %       TextPath: Ruta de la carpeta con las imágenes de entrenamiento
    %       r:        Número de columnas del diccionario (se le conoce como número de átomos)
    %       c:        Constante de esparcidad
    %
    % Sintaxis alternativa: [D,X,Err]=ksvd('TextPath',r,c,'Extension','.ext','IteraMax',IteraMax,'Tol',Tol) 
    %
    % Sobre los parámetros opcionales:
    %       Extension: Las extensiones que se aceptan son jpg, pgm, png, tif, bpm. 
    %                  El valor por defecto es .jpg
    %       IteraMax:  Número máximo de iteraciones a realizar. El valor por
    %                  defecto es 200.
    %       Tol:       Tolerancia, para el método de paro, diferencia entre dos errores
    %                  consecutivos menor que Tol. EL valor por defecto es 10^-3.
    %
    % Parámetros de salida
    %       D:     Matriz diccionario de tamaño mxr
    %       X:     Matriz esparcida de tamaño rxn
    %       Err: Error relativo normalizado del método
    %
    Extension='.jpg'; %%%%%% Validaciones
    expectedExtensions = {'.jpg','.pgm','.bmp','.png','.tif'};
    defaultIteraMax=200;
    defaultTol=10^-3;
    p = inputParser;
    addParameter(p,'Extension',Extension,@(x) any(strcmp(lower(strrep(x,' ','')),expectedExtensions )));
    validIteraMax = @(x) isnumeric(x) && mod(x,1)==0 && (x>=2) && (x <= 10000);
    validTol = @(x) isnumeric(x) && (x>=10^-15) && (x <= 100);
    validR = @(x) isnumeric(x) && mod(x,1)==0 && (x>=1);
    addRequired(p,'TextPath');
    addRequired(p,'r',validR);
    addRequired(p,'c');
    addOptional(p,'Tol',defaultTol,validTol);
    addOptional(p,'IteraMax',defaultIteraMax,validIteraMax);
    parse(p,TextPath,r,c,varargin{:});
    TextPath=p.Results.TextPath;
    r=p.Results.r;
    c=p.Results.c;
    Tol=p.Results.Tol;
    IteraMax=p.Results.IteraMax;
    Extension=p.Results.Extension;
    Extension=lower(strrep(Extension,' ',''));
    
    %
    % Referencia:  M. Aharon, M. Elad and A. Bruckstein, "K-SVD: An algorithm for designing overcomplete dictionaries for sparse representation," 
    %              in IEEE Transactions on Signal Processing, vol. 54, no. 11, pp. 4311-4322, Nov. 2006, doi: 10.1109/TSP.2006.881199.
    %
    Y=imgs2blocks(TextPath,Extension);
    [m,~]=size(Y);
    if (isnumeric(c) && mod(c,1)==0 && (c>=1) && (c <= m))==0 
        error(strcat('The value of c is invalid. It must be integer and satisfy 1<=c<=',int2str(m)));
    end
    D=normc(rand(size(Y,1),r));
    for it = 1:IteraMax     
        X = sparce_matrix(Y,D,c);
        if it==1
            e_old=norm(Y-D*X,'fro');
        end
        R = Y - D*X;
        for k=1:r
            I = find(X(k,:));
            Ri = R(:,I) + D(:,k)*X(k,I);
            [U,S,V] = svds(Ri,1,'L');
            D(:,k) = U;
            X(k,I) = S*V';
            R(:,I) = Ri - D(:,k)*X(k,I);
        end 
        e_new=norm(Y-D*X,'fro');
        Err=abs(e_old-e_new)/abs(e_new);
        if and(it>1,Err<Tol)
            break
        end
        e_old=e_new;
    end
end

function X = sparce_matrix(Y, D0,c)
    %Calcula la matriz de esparcidad X

    N=size(Y,2); K=size(D0,2);    
    X=zeros(K,N);
    for i=1:N
        X(:,i)=OMP(Y(:,i),D0,c);
    end

end


function x=OMP(y,A,k)
    %Algoritmo "Orthogonal Matching Pursuit"
    [~,n]=size(A); r=y; T=[];    
    x=zeros(n,1);
    for i=1:k
       g=A'*r;
       t=argmax_OMP(g,A);   
       T=sort([T t]);       
       A_T=mtx_colt(T,A);   
       xaux=pinv(A_T)*y;    
       for j=1:length(T)
           x(T(j))=xaux(j); 
       end
       r=y-A*x;             
    end    
end

%Funciones Auxiliares del Algoritmo OMP

function t=argmax_OMP(g,A)
    x=[]; n=size(A,2);    
    for j=1:n
       z=abs(g(j))/(norm(A(:,j)));
       x_n=[x z];
       x=x_n;
    end    
    [~, t] = max(x);    
end

function B=mtx_colt(T,A)
    m=size(A,1);
    n1=length(T);
    B=zeros(m,n1);
    for i=1:n1
        B(:,i)=A(:,T(i));
    end
end