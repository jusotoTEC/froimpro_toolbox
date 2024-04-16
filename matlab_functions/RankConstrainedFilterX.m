function [X]=RankConstrainedFilterX(A,C,k)
% Find the reduced rank matrix X that minimizes ||A-XC||_fr
%
% For more information, see the Toolbox manual at <a href="matlab:
% web('https://tecnube1-my.sharepoint.com/:b:/g/personal/jfallas_itcr_ac_cr/ES65Im0jm15AvNH9XtsS8uwBvzdPE-U8CHa11fWpLCZGRw?e=fLPthq')">Frobenius Norm Toolbox Manual</a>.
%
% Syntax: X=RankConstrainedFilterX(A,C,k)
%
% Input:
%       A:   Matrix containing the original images, organized in columns.
%       C:   Matrix containing the noisy images, organized in columns.
%       k:   Rank constraint. By default, k=min(mA,nA)
%
% Output:
%       X: Matrix corresponding to the constructed filter.


    [mA,nA]=size(A);
    pinvC=pinv(C);
    Matrix=A*pinvC*C;
    RankMatrix=rank(Matrix);
    if k<=RankMatrix
        [U,S,V]=svd(Matrix);
        Matrixk=zeros(mA,nA);
        for i=1:k
            Matrixk=Matrixk+S(i,i)*U(:,i)*V(:,i).';
        end
    else
        Matrixk=Matrix;
    end
    X=Matrixk*pinvC;
end
