function [A,B] = LowRankMatrixBRP(L,varargin)
    % Esta función recibe una matriz y permite calcular una aproximación de rango bajo
    % usando el método de proyección aleatoria bilateral. La aproximación de rango bajo "LTilde", 
    % de rango r, la puede calcular como LTilde=A*B;
    %
    % Para más información ver el manual del Toolbox en <a href="matlab: 
    % web('https://tecnube1-my.sharepoint.com/:b:/g/personal/jfallas_itcr_ac_cr/ES65Im0jm15AvNH9XtsS8uwBvzdPE-U8CHa11fWpLCZGRw?e=fLPthq')"> Manual del Toolbox norma de Frobenius</a>.
    %
    % Sintaxis: [A,B] = LowRankMatrixBRP(L)
    %
    % Parámetro de entrada:    
    %       L:  Es la matriz que se quiere aproximar con la matriz de rango
    %           bajo usando el método BRP. Su dimensión es mxn.
    %
    % Sintaxis alternativa:  [A,B]=LowRankMatrixBRP(L,'r',r,'c',c);
    %
    % Sobre los parámetros opcionales:
    %       r:  Condición para el rango tal que 0<r<=rank(L). El valor por
    %           defecto es r=floor(min(m,n)/2).
    %       c:  Parámetro del "power scheme", se utiliza para mejorar la 
    %           generación de las matrices de proyección bilateral. Debe 
    %           ser entero, positivo y podría ser ajustado por el usuario. 
    %           Su valor por defecto es c=3.
    %
    % Parámetros de salida:    
    %        A: Es la matriz A=L*Qr, donde [Qr,~]=qr(Y2,0).
    %        B: Es la matriz B=Qr', donde [Qr,~]=qr(Y2,0).
  
    [m,n]=size(L);
    Minmn=min(m,n);
    defaultR= floor(Minmn/2);
    defaultC=3;
    p = inputParser;
    ValidC = @(x) isnumeric(x) && mod(x,1)==0 && (x>=2) && (x <= 10);
    ValidMatrix = @(x) ismatrix(x) && isnumeric(x);
    ValidR = @(x) isnumeric(x)&&(mod(x,1)==0) && (x>=1) && (x<=Minmn); 
    addRequired(p,'L',ValidMatrix);
    addOptional(p,'c',defaultC,ValidC);
    addOptional(p,'r',defaultR,ValidR);
    parse(p,L,varargin{:});
    L=p.Results.L;
    c=p.Results.c;
    r=p.Results.r;
%%% Fin de la validación de argumentos
    Y2 = randn(n,r);
    for i=1:c+1
        Y1 = L*Y2;
        Y2 = L'*Y1;
    end
    %%%%%%
    [Qr,~]=qr(Y2,0);
    A=L*Qr;
    B=Qr'; 
end

