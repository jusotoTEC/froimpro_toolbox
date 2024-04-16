function [W,H,VectorError]=nnfLS(A,varargin)
% This function uses the Multiplicative Update Rules to perform a
% non-negative factorization of the matrix A of size mAxnA, such that A ? WH.
%
% For more information, refer to the Toolbox manual.
%
% Syntax: [W, H, VectorError] = nnfLS(A)
%
% Input parameter:    
%       A: The matrix to be factorized.
%
% Alternative syntax: [W, H, VectorError] = nnfLS(A, 'r', r, 'IteraMax', IteraMax, 'Tol', Tol)
%
% About optional parameters:
%       r:         Condition for the number of columns of W. The default value is r = floor(min(mA, nA)/2)
%       IteraMax:  Maximum number of iterations. The default value is 2 * nA
%       Tol:       Tolerance, its default value is 10^-6
%
% Output parameters:   
%       W:           First factor, which in image processing is called
%                    the basis faces.
%       H:           Second factor, which in image processing is called
%                    the coefficient matrix for combinations of faces.
%       VectorError: Error vector, in case the user wants to plot them. 

[mA,nA]=size(A);% Default values
Min=min(mA,nA);
r=floor(Min/2);
IteraMax=2*nA;
Tol=10^-6;
% Argument validation
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
% Function code
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