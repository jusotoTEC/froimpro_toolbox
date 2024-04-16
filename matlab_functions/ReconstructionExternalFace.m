function [] = ReconstructionExternalFace(Textpath,W,NameOutput)
% This function receives an image path and uses the base matrix W (generated with
% the ConstructionNNFM function) to reconstruct it and evaluate the quality of the face base W.
% This function saves the new image in jpg format, in the "Results" directory within
% the working folder. If it doesn't exist, it automatically creates it.
%
% For more information, see the Toolbox manual.
%
% Syntax: ReconstructionExternalFace('Textpath',W,'NameOutput')
%
% Input:
%       TextPath:   Path of the image you want to reconstruct.
%       W:          Matrix representing the face base. This matrix is
%                   obtained by executing the ConstructionNNFM function.
%       NameOutput: Name to be used for saving the reconstructed image.

    ValidMatrix = @(x) ismatrix(x) && isnumeric(x);
    if ValidMatrix(W)==0
        error('The value of W is not valid');
    end
    direccion=strcat('Results\ReconstructedFaces');
    if exist(direccion)~=7 % Validate the existence of the "Results" folder
        mkdir(direccion);
    end
    ImagenExterna=im2double(imread(Textpath));
    [m,n]=size(ImagenExterna);
    ImagenExternaVector=reshape(ImagenExterna,[m*n 1]);
    CoefImagenExterna=pinv(W)*ImagenExternaVector;
    ImagenReconstruidaVector=W*CoefImagenExterna;
    ImagenReconstruida=reshape(ImagenReconstruidaVector,[m n]);
    imwrite(ImagenReconstruida,strcat(direccion,'\',NameOutput,'.jpg'));
    imwrite(ImagenExterna,strcat(direccion,'\',NameOutput,'_Original.jpg'));
end

