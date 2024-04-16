function [] = ImageCompression(Textpath,radio,Opcion)
 % This function receives an image and compresses it using a compression ratio
% indicated by the user, which corresponds to the percentage
% of non-zero singular values to be used. The compression ratio is a decimal $d$ such that $\tfrac{1}{\min\{m,n\}}\leq d\leq 1$. 
% In the "Results" folder, inside the working directory, the original image,
% the reconstructed image, and the information of matrices A and B will be saved
% in two text files, which are what make the compression process meaningful.
% If the "Results" folder does not exist, it is created automatically.
%
% For more information, refer to the Toolbox manual.
%
% Syntax: ImageCompression('Textpath',ratio,'Option')
%
% Input parameters:     
%       Textpath: Path of the image to be compressed.
%       ratio:    This scalar represents the percentage of non-zero
%                 singular values to be used for compression.
%                 Or in other words, the percentage of the image's rank
%                 to be used for compression.
%       Option: Label indicating whether BRP or SVD should be applied.

     ExpectedOptions = {'BRP','SVD'};%%%% Option validation
     Opcion=upper(strrep(Opcion,' ',''));
     ValidarOpcion=@(x) any(strcmp(Opcion,ExpectedOptions));
     if ValidarOpcion(Opcion)==0
        error(['Unsupported option. You must indicate BRP or SVD. You entered ',Opcion]);
     end
%%%% End of validation
ima=imread(Textpath);
if size(ima,3)==3
   L=im2double(rgb2gray(ima)); %%% Convert the image to a double type matrix
else
   L=im2double(ima);
end
[m,n]=size(L);
Minmn=min(m,n);
%%%%%% Validations
Validporcentaje = @(x) isnumeric(x) && (x>1/Minmn) && (x <= 1);
if Validporcentaje(radio)==0
    error(['The compression ratio indicated for this image is not valid. It should be a decimal d, such that ',num2str(1/Minmn),'<=d<=1.']);
end
%%%%%% End of validations
r=floor(radio*Minmn);
if Opcion=='BRP'
   [A,B]=LowRankMatrixBRP(L,'r',r);
else
    [U,S,V]=svd(L);
    Urecortada=U(:,1:r);
    Srecortada=S(1:r,1:r);
    Vrecortada=V(:,1:r);
    A=Urecortada*Srecortada;
    B=Vrecortada.';
end
LTilde=A*B;
toc
direccion=strcat('Results');
if exist(direccion)~=7
    mkdir(direccion);
end
dlmwrite('Results\L.txt',L);
dlmwrite('Results\A.txt',A);
dlmwrite('Results\B.txt',B);
imwrite(double2uint8(L),'Results\OriginalImage.jpg');
imwrite(double2uint8(LTilde),'Results\CompressedImage.jpg');
end