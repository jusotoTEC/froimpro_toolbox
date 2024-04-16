function [A,m,n] = ReadImageDataBase(Textpath,varargin)
% This function takes images from a folder and organizes them
% vectorially as columns of a matrix A. One column for each
% image.
%
% For more information, see the Toolbox manual
%
% Syntax: [A,m,n] = ReadImageDataBase('Textpath')
%
% Input:
%       Textpath: Path of the folder with the images.
%
% Alternative syntax: [A,m,n] = ReadImageDataBase('Textpath','Extension','ext')
%
% About optional parameters:
%        Extension: Accepted extensions are jpg, pgm, png, tif, bmp.
%                   The default value is .jpg
%
% Output:
%       A:   Matrix containing the original images, organized in columns.
%       m,n: Dimensions of each of the images in the database.


Extension='.jpg'; %%%%%% Validaciones
expectedExtensions = {'.jpg','.pgm','.bmp','.png','.tif'};
p = inputParser;
addRequired(p,'Textpath');
addParameter(p,'Extension',Extension,@(x) any(strcmp(lower(strrep(x,' ','')),expectedExtensions )));
parse(p,Textpath,varargin{:});
Extension=p.Results.Extension;
Extension=lower(strrep(Extension,' ',''));
%%%%%% End of validations
NameFilesVector=ls(Textpath); % Vector with the full names of all files in the folder
i=0; %%% Controls the number of valid files in the folder, as there might be
      %%% system files in the folder which need to be ignored.
 A=[];
 for j=1:size(NameFilesVector,1)
   Filej=NameFilesVector(j,:); % Take the file "j" from the folder
   [~,~,Fileextension]=fileparts(Filej); % Read the file extension
   %%% In the following if statement, validate the file and if the extension matches
   if (and(~isdir(fullfile(Textpath,Filej)),or(strcmpi(strtrim(Fileextension),Extension),isempty(Extension))))
       i=i+1; %% Valid file, increment the image counter.
       direccion=fullfile(Textpath,Filej); %% Load the full path of the file.
       ima=imread(direccion);
       if size(ima,3)==3
           ImageMatrix=im2double(rgb2gray(ima)); %%% Convert the image to a double type matrix
       else
           ImageMatrix=im2double(ima);
       end
       if i==1 [m,n]=size(ImageMatrix); end; %%% Record the dimensions of each image
        A(:,i)=reshape(ImageMatrix,[m*n 1]);% Load original images into columns of A
   end
 end
 num_img=i;
 if i==0 error(strcat('There are not images in your data base with the extension ',Extension));
end



