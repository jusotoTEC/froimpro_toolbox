function [] = ReconstructionExternalFacesDirectory(Textpath,W,varargin)
% This function receives a directory path containing images and uses the
% base matrix W to reconstruct the images and evaluate the quality
% of the face base W. This function uses the ReconstructionExternalFace function,
% which will save the new images in jpg format, in the
% "Results" directory within the working folder. If it doesn't exist, it automatically creates it.
%
% For more information, see the Toolbox manual.
%
% Syntax: ReconstructionExternalFacesDirectory('Textpath',W)
%
% Input:
%       Textpath:   Path of the image directory you want to reconstruct.
%       W:          Matrix representing the face base. This matrix is
%                   obtained by executing the ConstructionNNFM function.
%
% Alternative syntax:
%       ReconstructionExternalFacesDirectory('Textpath',W,'Extension','ext','NameOutput','name')
%
% About optional parameters:
%       Extension: Accepted extensions are jpg, pgm, png, tif, bmp.
%                  The default value is .jpg
%       NameOutput: Name to be used for saving the new images.
%                   The default value is NameOutput='Reconstruted'.


NameOutput='Reconstruted';% Validations
Extension='.jpg';
expectedExtensions = {'.jpg','.pgm','.bmp','.png','.tif'};
ValidMatrix = @(x) ismatrix(x) && isnumeric(x);
p = inputParser;
addRequired(p,'Textpath');
addRequired(p,'W',ValidMatrix);
addParameter(p,'Extension',Extension,@(x) any(strcmp(lower(strrep(x,' ','')),expectedExtensions )));
addParameter(p,'NameOutput',NameOutput);
parse(p,Textpath,W,varargin{:});
Extension=p.Results.Extension;
NameOutput=p.Results.NameOutput;
%%%%%
NameFilesVector=ls(Textpath); % Vector with the full names of all files in the folder
i=0; %%% Controls the number of valid files in the folder, as there might be
%%% system files in the folder which need to be ignored.

 for j=1:size(NameFilesVector,1)
   Filej=NameFilesVector(j,:); % Take the j-th file from the folder
   [~,~,Fileextension]=fileparts(Filej); % Read the file extension
   %%% In the following if statement, validate the file and if the extension matches
   if (and(~isdir(fullfile(Textpath,Filej)),or(strcmpi(strtrim(Fileextension),Extension),isempty(Extension))))
       i=i+1; %% Valid file, increment the image counter.
       direccion=fullfile(Textpath,Filej); %% Load the full path of the file.
       ReconstructionExternalFace(direccion,W,strcat(NameOutput,int2str(i)));
   end
 end
 num_img=i;
 if i==0
     error(strcat('There are not images in your data base with the extension ',Extension));
 end
 end


