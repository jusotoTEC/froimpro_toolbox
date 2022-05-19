function [X]=RankConstrainedFilterX(A,C,k)
    % Encuentra la matriz X de rango reducido que minimiza ||A-XC||_fr
    %
    % Para m�s informaci�n ver el manual del Toolbox en <a href="matlab: 
    % web('https://tecnube1-my.sharepoint.com/:b:/g/personal/jfallas_itcr_ac_cr/ES65Im0jm15AvNH9XtsS8uwBvzdPE-U8CHa11fWpLCZGRw?e=fLPthq')"> Manual del Toolbox norma de Frobenius</a>.
    %
    % Sintaxis: X=RankConstrainedFilterX(A,C,k)
    %
    % Par�metro de entrada:
    %       A:   Matriz que contiene las im�genes originales, organizadas en columnas. 
    %       C:   Matriz que contiene las im�genes con ruido, organizadas en columnas. 
    %       k:   Es la restricci�n para el rango. Por defecto, se toma k=min(mA,nA)
    %
    % Par�metros de salida:        
    %       X: Matriz que corresponde al filtro construido.

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