function []=img_miss_pix(Textpath,porc)
% This function receives the path of an image and a scalar 'porc',
% such that 0<porc<1, and generates an image, in the same directory, with the
% number of missing pixels indicated by 'porc'. For example, if
% porc=0.25 it means that an image with 25% missing pixels will be generated.
%
% For more information, refer to the Toolbox manual.
%
% Syntax: img_miss_pix('Textpath',porc)
%
% Input parameters:
%       Textpath: Path of the image.
%       porc:     Scalar such that 0<porc<1, denoting the percentage of
%                 missing pixels that the new image will have.
    
    if (porc<=0 || porc>=1)  
        error('Take into account that 0<porc<1');
    end
    Y=imread(Textpath);  
    if size(Y,3)==3
           Y=rgb2gray(Y);%%% Convert the image to a double type matrix
    end  
    [m,n]=size(Y);
    for i=1:m
        for j=1:n
            if rand(1)<porc
                Y(i,j)=0;
            end
        end
    end
    VectorPosicion=strfind(Textpath,'\');
    Name=strcat('MissingPixelsImage',Textpath(end-3:end));
    if isempty(VectorPosicion) 
        imwrite(Y,Name);
    else
        NewPath=Textpath(1:VectorPosicion(end));
        imwrite(Y,strcat(NewPath,Name));
    end
end