function [LF,SF,Errors] = GoDec(XMatrix,r,k,Opcion,varargin)
    % Esta función resuelve el problema: min||X-(L+S)|| donde L es de a lo sumo rango r 
    % y S es de a lo sumo cardinalidad k. Para ello aplica el método BRP (bilateral ramdom projection)
    % o la SVD (GODEC clásico), según se indique.
    %
    % Para más información ver el manual del Toolbox en <a href="matlab: 
    % web('https://tecnube1-my.sharepoint.com/:b:/g/personal/jfallas_itcr_ac_cr/ES65Im0jm15AvNH9XtsS8uwBvzdPE-U8CHa11fWpLCZGRw?e=fLPthq')"> Manual del Toolbox norma de Frobenius</a>.
    %
    % Sintaxis: [L,S,Errors] = GoDec(X,r,k,'Opcion')
    %
    % Parámetro de entrada:
    %       X: Matriz de tamaño mnxp, construida con p imágenes de mxn pixeles.
    %       r: Rango máximo que tendrá la matriz L.
    %       k: Cardinalidad máxima que tendrá la matriz S.
    %       Opcion: Valores posibles 'BRP' o 'SVD'.
    %
    % Sintaxis alternativa: [L,S,Errors] = GoDec(X,r,k,'Opcion','c',c,'IteraMax',IteraMax,'Tol',Tol)
    %   
    % Sobre los parámetros opcionales:
    %       c:        Parámetro del "power scheme", se utiliza para mejorar la 
    %                 generación de las matrices de proyección bilateral. Debe 
    %                 ser entero, positivo y podría ser ajustado por el usuario. 
    %                 Su valor por defecto es c=3.
    %       IteraMax: Número máximo de iteraciones a realizar. El valor por
    %                 defecto es 100.
    %       Tol:      Tolerancia, para el método de paro, diferencia entre dos errores
    %                 consecutivos menor que Tol. EL valor por defecto es 10^-8.
    %
    % Parámetros de salida:  
    %       L:      Matriz de tamaño mnxp de a lo sumo rango r.
    %       S:      Matriz de tamaño mnxp de a lo sumo cardinalid k
    %       Errors: Vector con los errores generados en el proceso iterativo.
    
ExpectedOpcions={'BRP','SVD'};
Opcion=upper(strrep(Opcion,' ',''));
ValidarOpcion =@(x) any(strcmp(Opcion,ExpectedOpcions));
if ValidarOpcion(Opcion)==0
    error(['Opción no admitida. Recuede que debe indicar BRP o SVD. Usted digitó ',Opcion]);
end
%Fin de la validación de Opcion

defaultC=3;
defaultIteraMax=100;
defaultTol=0.00000001;
defaultType=1;
p = inputParser;
[m,n]=size(XMatrix);


validC = @(x) isnumeric(x) && mod(x,1)==0 && (x>=2) && (x <= 10);
validIteraMax = @(x) isnumeric(x) && mod(x,1)==0 && (x>=2) && (x <= 10000);
validTol = @(x) isnumeric(x) && (x>=10^-15) && (x <= 100);
ValidMatrix = @(x) ismatrix(x) && isnumeric(x);
ValidR = @(x) isnumeric(x)&&(mod(x,1)==0) && (x>=1) && (x<=rank(XMatrix)); 
ValidK = @(x) isnumeric(x)&&(mod(x,1)==0) && (x>=0) && (x<m*n);

addRequired(p,'XMatrix',ValidMatrix);
addRequired(p,'r',ValidR);
addRequired(p,'k',ValidK);
addOptional(p,'c',defaultC,validC);
addOptional(p,'Tol',defaultTol,validTol);
addOptional(p,'IteraMax',defaultIteraMax,validIteraMax);

parse(p,XMatrix,r,k,varargin{:});

XMatrix=p.Results.XMatrix;
k=p.Results.k;
c=p.Results.c;
Tol=p.Results.Tol;
IteraMax=p.Results.IteraMax;


%%% Fin de la validación de argumentos


Bandera=false;
if  m<n
    XMatrix=XMatrix';
    [m,n]=size(XMatrix);
    Bandera=true;
end

S=sparse(zeros(m,n));
t=0;
L=XMatrix;
Errors=[inf];
NormaX2=(norm(XMatrix,'fro'))^2;
ValorError=inf;
if Opcion=='BRP'
    while ((ValorError>Tol) && (t<IteraMax))
        t=t+1;
       [A,B]=LowRankMatrixBRPSinValidacion(XMatrix-S,r,c);
       L=A*B;
    
        T=XMatrix-L;                  %Inicia la actualización de S
        [~,idx]=sort(abs(T(:)),'descend');
        S=zeros(m,n);
        S(idx(1:k))=T(idx(1:k));                    
    
                            %Inicia el cálculo del nuevo error
        T=XMatrix-L-S;
        ErrorF=(norm(T,'fro'))^2/NormaX2;
        T(idx(1:k))=0;
  
        Errors=[Errors, ErrorF];
        ValorError= abs((Errors(end)-Errors(end-1)));
    end
elseif Opcion=='SVD'
    while ((ValorError>Tol) && (t<IteraMax))
        t=t+1;
        [U,Sigma,VT]=svd(XMatrix-S);    %funciona pero esto lo hace muy caro.
        U=U(:,1:r);
        VT=VT(:,1:r);    
        Sigma=Sigma(1:r,1:r);
        L=U*Sigma*VT.';
    
        T=XMatrix-L;                  %Inicia la actualización de S
        [~,idx]=sort(abs(T(:)),'descend');
        S=zeros(m,n);
        S(idx(1:k))=T(idx(1:k));                    
    
                            %Inicia el cálculo del nuevo error
        T=XMatrix-L-S;
        ErrorF=(norm(T,'fro'))^2/NormaX2;
        T(idx(1:k))=0;
  
        Errors=[Errors, ErrorF];
        ValorError= abs((Errors(end)-Errors(end-1)));
    end    
end
if Bandera
   LF=L';
   SF=S';
else
    LF=L;
    SF=S;
end
Errors=Errors(2:end);
end



function [A,B] = LowRankMatrixBRPSinValidacion(L,r,c)
%%% Esta función recibe una matriz y calcula una aproximación de rango bajo
%%% usando el método de proyección aleatoria bilateral.
%%% Parámetros:
        %%% L:  Es la matriz que se quiere aproximar con la matriz de rango
        %%%     bajo usando el método BRP. Su dimensión es mxn.
        %%% r:  Condición para el rango tal que 0<r<=rank(L). El valor por
        %%%     defecto se toma como floor(min(m,n)/2);
        %%% c:  Parámetro del "power scheme", se utiliza para mejorar la 
        %%%     generación de las matrices de proyección bilateral. Debe 
        %%%     ser entero, positivo y podría ser ajustado por el usuario. 
        %%%     Su valor por defecto es 3.
%%% Sobre los argumentos que retorna:
        %%%     A: Dado que [Qr,~]=qr(Y2,0), entonces A=L*Qr;
        %%%     B: Dado que [Qr,~]=qr(Y2,0), entonces B=Qr';
%%% Nota: La aproximación de rango bajo LTilde, de rango r, la puede calcular como
%%%       LTilde=A*B;
 
    [~,n]=size(L);
    Y2 = randn(n,r);
    for i=1:c+1
        Y1 = L*Y2;
        Y2 = L'*Y1;
    end
    [Qr,~]=qr(Y2,0);
    A=L*Qr;
    B=Qr';   
end

