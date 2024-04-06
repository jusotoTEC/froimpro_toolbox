function [W,H,VectorError]=nnfLS(A,varargin)
    % Esta funci�n usa las "Multiplicative update rules" para realizar una
    % factorizaci�n no negativa de la matriz A de dimension mAxnA, como A \approx WH.
    %
    % Para m�s informaci�n ver el manual del Toolbox en <a href="matlab: 
    % web('https://tecnube1-my.sharepoint.com/:b:/g/personal/jfallas_itcr_ac_cr/ES65Im0jm15AvNH9XtsS8uwBvzdPE-U8CHa11fWpLCZGRw?e=fLPthq')"> Manual del Toolbox norma de Frobenius</a>.
    %
    % Sintaxis: [W,H,VectorError] = nnfLS(A)
    %
    % Par�metro de entrada:    
    %       A: Es la matriz que se desea factorizar.
    %
    % Sintaxis alternativa: [W,H,VectorError] = nnfLS(A,'r',r,'IteraMax',IteraMax,'Tol',Tol)
    %
    % Sobre los par�metros opcionales:
    %       r:         Es la condici�n para el n�mero de columnas de W. El valor por defecto es r=floor(min(mA,nA)/2)
    %       IteraMax:  Es el n�mero m�ximo de iteraciones. El valor por defecto es 2*nA         
    %       Tol:       Es la tolerancia, su valor por defecto es 10^-6
    %
    % Par�metros de salida:   
    %       W:           Primer factor, que en procesamiento de im�genes se denomina
    %                    la base caras.
    %       H:           Segundo factor, que en procesamiento de im�genes se demonina
    %                    la matriz de coeficientes para las combinaciones de las caras.
    %       VectorError: Es el vector de errores, por si el usuario desea graficarlos. 

[mA,nA]=size(A);%Valores por defecto
Min=min(mA,nA);
r=floor(Min/2);
IteraMax=2*nA;
Tol=10^-6;
%Validaci�n de argumentos
valid_r = @(x) isnumeric(x) && mod(x,1)==0 && (x>=1) && (x <= Min);
valid_Itera = @(x) isnumeric(x) && mod(x,1)==0 && (x>=1);
valid_Tol = @(x) isnumeric(x) && (x>0);
ValidMatrix = @(x) ismatrix(x) && isnumeric(x);
p = inputParser;
addRequired(p,'A',ValidMatrix);
addOptional(p,'r',r,valid_r);
addOptional(p,'IteraMax',IteraMax,valid_Itera);
addOptional(p,'Tol',Tol,valid_Tol);
parse(p,A,varargin{:});
r=p.Results.r;
IteraMax=p.Results.IteraMax;
Tol=p.Results.Tol;
%C�digo de la funci�n
W=rand(mA,r); H=rand(r,nA);
VectorError=[];
contador=0;
Error=inf;
while (contador<=IteraMax)&&(Error>Tol)
    contador=contador+1;
    H=H.*(W'*A)./(W'*W*H);
    W=W.*(A*H')./(W*H*H');
    Error=norm(A-W*H,'fro')/sqrt(mA*nA);
    VectorError=[VectorError Error];
end
end