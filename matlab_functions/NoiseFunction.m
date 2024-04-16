function [C,A,m,n]=NoiseFunction(Textpath,varargin)
% This function reads a folder with images using the "ReadDataBase" function and calculates the matrix A
% containing the original images in its columns, and C, which is the matrix with the images but with noise
% in its columns.
%
% For more information, refer to the Toolbox manual.
%
% Syntax: [C, A, m, n] = NoiseFunction('TextPath')
%
% Input parameter:
%       TextPath: Path of the folder with the images.
%
% Alternative syntax:
%       Option 1: [C, A, m, n] = NoiseFunction('TextPath', 'NoiseOption', 'gaussian', 'sigmagauss', n_0, 'meangauss', n_1);
%       Option 2: [C, A, m, n] = NoiseFunction('TextPath', 'NoiseOption', 's&p', 'd', n_0);
%       Option 3: [C, A, m, n] = NoiseFunction('TextPath', 'NoiseOption', 'speckle', 'sigmaspeckle', n_0);
%
% About optional parameters:
%
%       NoiseOption:  Type of noise, with options 'speckle',
%                     's&p', 'gaussian', where 's&p' stands for "salt and
%                     pepper". The default value is NoiseOption = gaussian.
%       sigmagauss:   Variance for Gaussian noise. The default value is sigmagauss = 0.01.
%       meangauss:    Mean for Gaussian noise. The default value is meangauss = 0.
%       sigmaspeckle: Variance for speckle noise. The default value is sigmaspeckle = 0.05.
%       d:            Density of noise for s&p. The default value is d = 0.05.
%
% Output parameters:
%       A:   Matrix containing the original images, organized in columns.
%       C:   Matrix containing the images with noise, organized in columns.
%       m, n: Dimensions of each of the images in the database.

    [A,m,n]=ReadImageDataBase(Textpath); % Read the image database.
    [~,num_img]=size(A);
    %%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%% Here I load the default values
    NoiseOption='gaussian';
    sigmagauss=0.01;
    meangauss=0;
    d=0.05;
    sigmaspeckle=0.05;
   %%%%%%%%%%%%%% Default values loaded successfully.
    expectedNoises = {'speckle','s&p','gaussian'};% Possible values for the variable "NoiseOption"
    %%%%%%%%%%% I use the inputParser to validate arguments and assign default values.
    p = inputParser;
    validScalar1 = @(x) isnumeric(x) && isscalar(x) && (x > 0);
    validScalar2 = @(x) isnumeric(x) && isscalar(x) && (x >= 0);
    addRequired(p,'Textpath'); %% Mandatory parameter. The ones below are all optional.
    addParameter(p,'NoiseOption',NoiseOption,@(x) any(strcmp(lower(strrep(x,' ','')),expectedNoises)));
                    %%%% Validates if the parameter 'NoiseOption' exists.
                    %%%% If it doesn't exist, it assigns the default value.
                    %%%% If it does exist, the object "p" contains the value entered by the user.
                    %%%% It is accessed with p.Results.NoiseOption

    addParameter(p,'sigmagauss',sigmagauss,validScalar1);
    addParameter(p,'meangauss',meangauss,validScalar2);
    addParameter(p,'d',d,validScalar1);
    addParameter(p,'sigmaspeckle',sigmaspeckle,validScalar1);
    parse(p,Textpath,varargin{:});
    %%%%%%%%%%%%%%%%% Closing the inputParser
    NoiseOption=p.Results.NoiseOption; % Load the type of noise
    NoiseOption=lower(strrep(NoiseOption,' ',''));
    if strcmp(NoiseOption,'s&p') NoiseOption='salt & pepper'; end; % I simply change its name
    %%%%% From here on, I load the other parameters, starting from the attributes of the object p
    sigmagauss=p.Results.sigmagauss;
    meangauss=p.Results.meangauss;
    d=p.Results.d;
    sigmaspeckle=p.Results.sigmaspeckle;
    %%%% Close the variable loading
    %%%%%%%%%%%%%%%%%%%%%%%%%%%
    N=zeros(m,n,num_img);
    C=zeros(m*n,num_img);
    if strcmp(NoiseOption,'speckle')
            for i=1:num_img
                ImageMatrix=reshape(A(:,i),m,n);
                N=imnoise(ImageMatrix,NoiseOption,sigmaspeckle);
                C(:,i)=reshape(N,[m*n 1]); % Images with noise in the columns
            end;
    elseif strcmp(NoiseOption,'salt & pepper')
            for i=1:num_img
                ImageMatrix=reshape(A(:,i),m,n);
                N=imnoise(ImageMatrix,NoiseOption,d);
                C(:,i)=reshape(N,[m*n 1]); % Images with noise in the columns
            end;
    elseif strcmp(NoiseOption,'gaussian')
            for i=1:num_img
                ImageMatrix=reshape(A(:,i),m,n);
                N=imnoise(ImageMatrix,NoiseOption,meangauss,sigmagauss);
                C(:,i)=reshape(N,[m*n 1]); % Images with noise in the columns
            end;
    else
        error('The valid options for the parameter NoiseOption are gaussian, s&p and speckle.');
    end;

end
