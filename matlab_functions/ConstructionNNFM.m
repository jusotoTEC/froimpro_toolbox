function [W,H,m,n] = ConstructionNNFM(Textpath,varargin)
  
    % This function utilizes the ReadImageDataBase function to read a folder of
    % images and construct the matrix A of dimension mAxnA, which contains the vectorization of the images in its
    % columns. Subsequently, it uses the nnfLS function to build the matrices W and H, 
    % which are stored in the "Results" folder.
    %
    % For more information, refer to the Toolbox manual.
    %
    %
    % Syntax: [W,H,m,n] = ConstructionNNFM('Textpath')
    %
    % Input parameter:
    %       Textpath: Path of the folder containing the images.
    %
    % Alternative Syntax: [W,H,m,n] = ConstructionNNFM(Textpath,'Extension',ext,'r',r,'IteraMax',itera,'Tol',tol)
    %
    % About optional parameters:
    %       Extension: The accepted extensions are jpg, pgm, png, tif, bpm. 
    %                  The default value is .jpg.
    %       r:         It is the condition for the rank. The default value is r=floor(min(mA,nA)/2).
    %       IteraMax:  It is the maximum number of iterations. The default value is 2*nA.         
    %       Tol:       It is the tolerance, its default value is 10^-6.
    %
    % Output parameters:        
    %       W:   It is the basis matrix of the images. Additionally, it saves a W.mat file in 
    %            the "Results" folder.
    %       H:   It is the coefficient matrix. Additionally, it saves an H.mat file in the 
    %            "Results" folder.
    %       m,n: They are the dimensions of each of the images in the basis.


[Lista1,Lista2]=SplitVarargin(varargin);
[A,m,n] = ReadImageDataBase(Textpath,Lista1{:});
[W,H,~]=nnfLS(A,Lista2{:});
direccion=strcat('Results\ImagesBase');
if exist(direccion)~=7
    mkdir(direccion);
end
save('Results\W.mat','W');
save('Results\H.mat','H');
Matrix2Image(W,m,n,'Results\ImagesBase','BaseImage');
end

function [Lista1,Lista2]=SplitVarargin(listaparametros)
LongVarar=length(listaparametros);
j=1;
l1=1;
l2=1;
Lista1={};
Lista2={};
while j<=LongVarar
    switch listaparametros{j}
    case 'Extension'
        Lista1{l1}=listaparametros{j};
        Lista1{l1+1}=listaparametros{j+1};
        l1=l1+2;
    case 'r'
        Lista2{l2}=listaparametros{j};
        Lista2{l2+1}=listaparametros{j+1};
        l2=l2+2;
    case 'IteraMax'
        Lista2{l2}=listaparametros{j};
        Lista2{l2+1}=listaparametros{j+1};
        l2=l2+2;
    case 'Tol'
        Lista2{l2}=listaparametros{j};
        Lista2{l2+1}=listaparametros{j+1};
        l2=l2+2;
    otherwise
        error(strcat('The parameter ', listaparametros{j}, ' is not recognized'));

    end
    j=j+2;
end

end