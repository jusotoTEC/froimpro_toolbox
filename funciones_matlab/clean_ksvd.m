function Y=clean_ksvd(TextPath,D)
    % Esta función recibe la ruta de una imagen que presenta pixeles perdidos
    % y la reconstruye utilizando la matriz de diccionario D generada por el método K-SVD. Esta función
    % debe utilizarse posterior a la función "ksvd", que es la que genera la matriz D.
    %
    % Para más información ver el manual del Toolbox en <a href="matlab: 
    % web('https://tecnube1-my.sharepoint.com/:b:/g/personal/jfallas_itcr_ac_cr/ES65Im0jm15AvNH9XtsS8uwBvzdPE-U8CHa11fWpLCZGRw?e=fLPthq')"> Manual del Toolbox norma de Frobenius</a>.
    %
    % Sintaxis: Y=clean_ksvd('TextPath',D)
    %
    % Párametros de entrada: 
    %       TextPath: Ruta de la imagen que se desea reconstruir.
    %       D: Matriz diccionario generada por el método K-SVD
    % Parámetro de salida:
    %       Y: Matriz que representa la imagen reconstruida.  
    
    I=imread(TextPath);
    [m_org, n_org]=size(I);
    Z=im2double(block_img_8(I));
    
    [m_z,n_z]=size(Z);
    mBlock=m_z/8; nBlock=n_z/8;
    
    VecBlock=im2block8(Z);
    
    t=10; iter=0;
    blockImg=[];
    for i=1:mBlock
        Aux=[];
        for j=1:nBlock
            iter=iter+1;
            y=VecBlock(:,iter);
            D_d=decim_mat(D,y);
            x = OMP(y,D_d,t);
            Aux=[Aux reshape(D*x,[8,8])];
        end
        blockImg=[blockImg; Aux];
    end
    
    Y=im2uint8(imresize(blockImg,[m_org,n_org]));
end


function Y=im2block8(X)
    % Esta función convierte una matriz X de tamaño m x n en una matriz Y de
    % tamaño 64 x mn/64 , donde cada columna de Y vienen de un bloque
    % vectorizado de tamaño  8 x 8 de X
    
    [m,n]=size(X);
    b1=m/8; b2=n/8;
    Y=[];
    for i=1:b1
        for j=1:b2
            Aux=X((i-1)*8+1:i*8,(j-1)*8+1:j*8);
            Y=[Y Aux(:)];
        end
    end
end




function x=OMP(y,A,k)
    %Algoritmo "Orthogonal Matching Pursuit"
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

%Funciones Auxiliares del Algoritmo OMP

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

function D=decim_mat(D0,y)
    n=length(y); D=D0; m=size(D0,2);
    for i=1:n
        if y(i)==0
            D(i,:)=zeros(1,m);
        end
    end
end

function Y=block_img_8(X)
    % Esta función retorna una imagen, donde el número de filas y columnas
    % es divisible por 8. Las dimensiones de la nueva imagen Y son los
    % múltiplos de 8 más cercanos a las dimensiones de la imagen original X
    %
    % Estructura de la Funcion: Y=block_img_8(X)
    %
    % Parámetro de entrada: 
    %           X = una imagen de tamaño m x n
    % Parámetro de salida: 
    %           Y = una imagen de tamaño m1 x n1, donde m1 y
    %               n1 son divisibles por 8, y abs(m1-m) y 
    %               abs(n1-n) es mínimo
        
    [m,n]=size(X);
    s1=mod(m,8);
    s2=mod(n,8);
    if and(s1==0,s2==0)
        m1=m; n1=n;
    elseif and(s1==0,s2~=0)
        if s2<=4
            m1=m; n1=n-s2;
        else
            m1=m; n1=n+8-s2;
        end        
    elseif and(s1~=0,s2==0)
        if s1<=4
            m1=m-s1; n1=n;
        else
            m1=m+8-s1; n1=n;
        end
    elseif and(s1~=0,s2~=0)
        if s1<=4
            m1=m-s1;
        else
            m1=m+8-s1;
        end
        if s2<=4
            n1=n-s2;
        else
            n1=n+8-s2;
        end        
    end       
    Y=imresize(X,[m1,n1]);
end

