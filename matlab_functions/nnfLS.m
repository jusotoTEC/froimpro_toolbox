function [W,H,VectorError]=nnfLS(A,varargin)
    % Esta función usa las "Multiplicative update rules" para realizar una
    % factorización no negativa de la matriz A de dimension mAxnA, como A \approx WH.
    %
    % Para más información ver el manual del Toolbox en <a href="matlab: 
    % web('https://tecnube1-my.sharepoint.com/:b:/g/personal/jfallas_itcr_ac_cr/ES65Im0jm15AvNH9XtsS8uwBvzdPE-U8CHa11fWpLCZGRw?e=fLPthq')"> Manual del Toolbox norma de Frobenius</a>.
    %
    % Sintaxis: [W,H,VectorError] = nnfLS(A)
    %
    % Parámetro de entrada:    
    %       A: Es la matriz que se desea factorizar.
    %
    % Sintaxis alternativa: [W,H,VectorError] = nnfLS(A,'r',r,'IteraMax',IteraMax,'Tol',Tol)
    %
    % Sobre los parámetros opcionales:
    %       r:         Es la condición para el número de columnas de W. El valor por defecto es r=floor(min(mA,nA)/2)
    %       IteraMax:  Es el número máximo de iteraciones. El valor por defecto es 2*nA         
    %       Tol:       Es la tolerancia, su valor por defecto es 10^-6
    %
    % Parámetros de salida:   
    %       W:           Primer factor, que en procesamiento de imágenes se denomina
    %                    la base caras.
    %       H:           Segundo factor, que en procesamiento de imágenes se demonina
    %                    la matriz de coeficientes para las combinaciones de las caras.
    %       VectorError: Es el vector de errores, por si el usuario desea graficarlos. 

[mA,nA]=size(A);%Valores por defecto
Min=min(mA,nA);
r=floor(Min/2);
IteraMax=2*nA;
Tol=10^-6;
%Validación de argumentos
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
%Código de la función
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