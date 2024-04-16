function [LF,SF,Errors] = GoDec(XMatrix,r,k,Opcion,varargin)
% This function solves the problem: min||X-(L+S)|| where L has at most rank r 
% and S has at most cardinality k. To achieve this, it applies the BRP method (bilateral random projection) 
% or the SVD (classic GODEC), depending on what is indicated.
%
% For more information, refer to the Toolbox manual.
%
% Syntax: [L,S,Errors] = GoDec(X,r,k,'Option')
%
% Input parameters:
%       X: Matrix of size mnxp, constructed with p images of mxn pixels.
%       r: Maximum rank that matrix L will have.
%       k: Maximum cardinality that matrix S will have.
%       Option: Possible values 'BRP' or 'SVD'.
%
% Alternative Syntax: [L,S,Errors] = GoDec(X,r,k,'Option','c',c,'IteraMax',IteraMax,'Tol',Tol)
%   
% About optional parameters:
%       c:        Parameter of the "power scheme", used to improve the 
%                 generation of bilateral projection matrices. It must be 
%                 an integer, positive, and may be adjusted by the user. 
%                 The default value is c=3.
%       IteraMax: Maximum number of iterations to perform. The default value is 100.
%       Tol:      Tolerance, for the stopping criterion, difference between two consecutive errors
%                 less than Tol. The default value is 10^-8.
%
% Output parameters:  
%       L:      Matrix of size mnxp with at most rank r.
%       S:      Matrix of size mnxp with at most cardinality k.
%       Errors: Vector with the errors generated in the iterative process.

    
ExpectedOpcions={'BRP','SVD'};
Opcion=upper(strrep(Opcion,' ',''));
ValidarOpcion =@(x) any(strcmp(Opcion,ExpectedOpcions));
if ValidarOpcion(Opcion)==0
    error(['Unsupported option. Remember you must indicate BRP or SVD. You entered ',Opcion]);
end
% End of the Option validation

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


%%% End of the argument validation


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
    
        T=XMatrix-L;                 % Starts the update of S
        [~,idx]=sort(abs(T(:)),'descend');
        S=zeros(m,n);
        S(idx(1:k))=T(idx(1:k));                    
    
                            % Starts the calculation of the new error
        T=XMatrix-L-S;
        ErrorF=(norm(T,'fro'))^2/NormaX2;
        T(idx(1:k))=0;
  
        Errors=[Errors, ErrorF];
        ValorError= abs((Errors(end)-Errors(end-1)));
    end
elseif Opcion=='SVD'
    while ((ValorError>Tol) && (t<IteraMax))
        t=t+1;
        [U,Sigma,VT]=svd(XMatrix-S);   
        U=U(:,1:r);
        VT=VT(:,1:r);    
        Sigma=Sigma(1:r,1:r);
        L=U*Sigma*VT.';
    
        T=XMatrix-L;                  % Starts the update of S
        [~,idx]=sort(abs(T(:)),'descend');
        S=zeros(m,n);
        S(idx(1:k))=T(idx(1:k));                    
    
                            % Starts the calculation of the new error
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
%%% This function takes a matrix and computes a low-rank approximation
%%% using the bilateral random projection method.
%%% Parameters:
        %%% L:  It is the matrix to be approximated with the low-rank matrix
        %%%     using the BRP method. Its dimension is mxn.
        %%% r:  Rank condition such that 0<r<=rank(L). The default value is taken as floor(min(m,n)/2).
        %%% c:  Parameter of the "power scheme", used to improve the 
        %%%     generation of bilateral projection matrices. It must be 
        %%%     an integer, positive, and may be adjusted by the user. 
        %%%     The default value is 3.
%%% About the returned arguments:
        %%%     A: Since [Qr,~]=qr(Y2,0), then A=L*Qr;
        %%%     B: Since [Qr,~]=qr(Y2,0), then B=Qr';
%%% Note: The low-rank approximation LTilde, of rank r, can be computed as
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

