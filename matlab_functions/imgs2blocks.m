function Y=imgs2blocks(Textpath,Extension)
% This function receives a path to a folder with 'p' images and constructs
% a matrix Y of size 64 x (pmn/64), where each column of Y
% corresponds to a vectorization of the 8 x 8 blocks taken
% from each of the images.
%
% For more information, refer to the Toolbox manual.
% 
% Syntax: Y=imgs2blocks('Textpath','Extension')
%
% Input parameters:
%           Textpath : Path of the folder with the images.
%           Extension: Extension of the images.
%
% Output parameter:
%           Y = Matrix of size (64 x pmn/64)

    
NameFilesVector=ls(Textpath);% Vector with the full names of all files in the folder
i=0; %%% Control the number of valid files in the folder, since there may be
    %%% system files in the folder that need to be ignored.
 Y=[];
 for j=1:size(NameFilesVector,1)
   Filej=NameFilesVector(j,:); % Take file j from the folder
   [~,~,Fileextension]=fileparts(Filej); % Read the extension of the file
   %%% In the following if statement, validate the file and if the extension matches
   if (and(~isdir(fullfile(Textpath,Filej)),or(strcmpi(strtrim(Fileextension),Extension),isempty(Extension))))
       i=i+1; %% Valid file, increment the image counter.
       direccion=fullfile(Textpath,Filej); %% Load the full path of the file.
       ima=imread(direccion);
       if size(ima,3)==3
           ImageMatrix=rgb2gray(ima); %%% Convert the image to a double type matrix
       else
           ImageMatrix=ima;
       end
       if i==1 [m,n]=size(ImageMatrix); end; %%% Record the dimensions of each image
        Xaux1=ImageMatrix; 
        Xaux2=im2double(block_img_8(Xaux1));
        Xaux3=im2block8(Xaux2); 
        Y=[Y Xaux3];
   end
 end
 num_img=i;
 if i==0 error(strcat('There are not images in your data base with the extension ',Extension));
 end
end

function Y=im2block8(X)
% This function converts a matrix X of size m x n into a matrix Y of
% size (64 x mn/64), where each column of Y comes from a vectorized
% 8 x 8 block of X.    
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

function Y=block_img_8(X)
% This function returns an image, where the number of rows and columns
% is divisible by 8. The dimensions of the new image Y are the
% nearest multiples of 8 to the dimensions of the original image X.
%
% Syntax: Y=block_img_8(X)
%
% Input parameter:
%           X = An image of size m x n.
% Output parameter:
%           Y = An image of size m1 x n1, where m1 and
%               n1 are divisible by 8, and abs(m1-m) and
%               abs(n1-n) are minimal
        
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
