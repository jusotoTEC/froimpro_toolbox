function [D,X,Err]=ksvd(TextPath,r,c,varargin)    
% The K-SVD method approximates the matrices D and X of the problem
% min ||Y-DX||, where ||X(:,i)||_0<=c, where Y is of size mxn, D is of
% size mxr, and X is of size rxn. Additionally, c is a sparsity constant
% that must satisfy 1<=c<=m. The matrix D is called the "dictionary".

% For more information, see the Toolbox manual.
%
% Function syntax: [D,X,Err] = ksvd('TextPath',r,c)

% Input parameters:
%       TextPath: Path of the folder with training images
%       r:        Number of columns in the dictionary (known as the number of atoms)
%       c:        Sparsity constant

% Alternative syntax: [D,X,Err] = ksvd('TextPath',r,c,'Extension','.ext','IteraMax',IteraMax,'Tol',Tol) 

% Optional parameters:
%       Extension: Accepted extensions are jpg, pgm, png, tif, bpm. 
%                  The default value is .jpg
%       IteraMax:  Maximum number of iterations. Default value is 200.
%       Tol:       Tolerance for the stopping method, difference between two consecutive errors
%                  less than Tol. Default value is 10^-3.

% Output parameters:
%       D:     Dictionary matrix of size mxr
%       X:     Sparse matrix of size rxn
%       Err:   Normalized relative error of the method

    Extension='.jpg'; %%%%%% Validations
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
    % Reference:  M. Aharon, M. Elad and A. Bruckstein, "K-SVD: An algorithm for designing overcomplete dictionaries for sparse representation," 
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
    % Calculate the sparsity matrix X

    N=size(Y,2); K=size(D0,2);    
    X=zeros(K,N);
    for i=1:N
        X(:,i)=OMP(Y(:,i),D0,c);
    end

end


function x=OMP(y,A,k)
    %"Orthogonal Matching Pursuit" Algorithm
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

% Auxiliary functions of the OMP Algorithm

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