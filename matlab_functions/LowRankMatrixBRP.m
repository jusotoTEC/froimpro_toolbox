function [A,B] = LowRankMatrixBRP(L,varargin)
% This function takes a matrix and allows to compute a low-rank approximation
% using the bilateral random projection method. The low-rank approximation "LTilde", 
% with rank r, can be computed as LTilde = A * B;
%
% For more information, refer to the Toolbox manual.
%
% Syntax: [A, B] = LowRankMatrixBRP(L)
%
% Input parameter:
%       L:  The matrix to be approximated with the low-rank matrix using
%           the BRP method. Its dimension is mxn.
%
% Alternative syntax:  [A, B] = LowRankMatrixBRP(L, 'r', r, 'c', c);
%
% About optional parameters:
%       r:  Rank condition such that 0 < r <= rank(L). The default value
%           is r = floor(min(m, n)/2).
%       c:  Parameter of the "power scheme", used to enhance the 
%           generation of bilateral projection matrices. It must be an 
%           integer, positive, and could be adjusted by the user. 
%           Its default value is c = 3.
%
% Output parameters:
%        A: Matrix A = L * Qr, where [Qr, ~] = qr(Y2, 0).
%        B: Matrix B = Qr', where [Qr, ~] = qr(Y2, 0).
  
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
%%% End of argument validation
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

