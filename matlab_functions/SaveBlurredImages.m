function []=SaveBlurredImages(pathOriginal,pathWriteNoise,varargin)
% This function receives the directory of a folder (pathOriginal) where the
% images to which noise will be applied are located, and writes the noisy images to the
% directory pathWriteNoise.
%
% For more information, see the Toolbox manual at <a href="matlab:
% web('https://tecnube1-my.sharepoint.com/:b:/g/personal/jfallas_itcr_ac_cr/ES65Im0jm15AvNH9XtsS8uwBvzdPE-U8CHa11fWpLCZGRw?e=fLPthq')">Frobenius Norm Toolbox Manual</a>.
%
% Syntax: SaveBlurredImages('pathOriginal','pathWriteNoise');
%
% Input:
%       pathOriginal: Directory of the images to which noise will be applied.
%       pathWriteNoise: Directory where the noisy images will be saved.
%
% Alternative syntax:
%       Option 1: SaveBlurredImages('pathOriginal','pathWriteNoise','NoiseOption',...
%                     'gaussian','sigmagauss',n_0,'meangauss',n_1);
%       Option 2: SaveBlurredImages('pathOriginal','pathWriteNoise','NoiseOption','s&p','d',n_0);
%       Option 3: SaveBlurredImages('pathOriginal','pathWriteNoise','NoiseOption','speckle','sigmaspeckle',n_0);
%
% About optional parameters:
%
%       NoiseOption:  Type of noise, with options 'speckle',
%                     's&p','gaussian', where 's&p' stands for "salt and
%                     pepper". The default value is NoiseOption=gaussian.
%       sigmagauss:   Variance for Gaussian noise. The default value is sigmagauss=0.01
%       meangauss:    Mean for Gaussian noise. The default value is meangauss=0
%       sigmaspeckle: Variance for speckle noise. The default value is sigmaspeckle=0.05
%       d:            Noise density for s&p. The default value is d=0.05


    NoiseOption='gaussian';
    sigmagauss=0.01;
    meangauss=0;
    d=0.05;
    sigmaspeckle=0.05;
    %%%%%%%%%%%%%%% Default values loaded successfully
    expectedNoises = {'speckle','s&p','gaussian'}; % Possible values for the variable "NoiseOption"
    %%%%%%%%%%% I use the inputParser to validate arguments and assign default values.
    p = inputParser;
    validScalar1 = @(x) isnumeric(x) && isscalar(x) && (x > 0);
    validScalar2 = @(x) isnumeric(x) && isscalar(x) && (x >= 0);
    addRequired(p,'pathOriginal'); %% Mandatory parameter.
    addRequired(p,'pathWriteNoise'); %% Mandatory parameter.
    addParameter(p,'NoiseOption',NoiseOption,@(x) any(strcmp(lower(strrep(x,' ','')),expectedNoises)));
                    %%%%  Validates if the parameter 'NoiseOption' exists.
                    %%%%  If it doesn't exist, it assigns the default value.
                    %%%%  If it does exist, the object "p" contains the value entered by the user.
                    %%%%  It is accessed with p.Results.NoiseOption
    addParameter(p,'sigmagauss',sigmagauss,validScalar1);
    addParameter(p,'meangauss',meangauss,validScalar2);
    addParameter(p,'d',d,validScalar1);
    addParameter(p,'sigmaspeckle',sigmaspeckle,validScalar1);
    parse(p,pathOriginal,pathWriteNoise,varargin{:});
   %%%%%%%%%%%%%%%%% Closing the inputParser
    NoiseOption=p.Results.NoiseOption; % Load the type of noise
    NoiseOption=lower(strrep(NoiseOption,' ','')); % Remove spaces and convert to lowercase.
    %%%%% From here on, I load the other parameters, starting from the attributes of the object p
    sigmagauss=p.Results.sigmagauss;
    meangauss=p.Results.meangauss;
    d=p.Results.d;
    sigmaspeckle=p.Results.sigmaspeckle;
    %%%% Closing the variable loading
    %%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%% Now I create the noisy matrix. C has one column for each
    %%% noisy image.
    [C,~,m,n]=NoiseFunction(pathOriginal,'NoiseOption',NoiseOption,'sigmagauss',sigmagauss,'meangauss',meangauss,'d',d,'sigmaspeckle',sigmaspeckle);
    [~,num_img]=size(C);
    %%%% Final part, I write the noisy images
    for i=1:num_img
        ImagenNIConRuidoColumna=C(:,i); % Read column i of C
        ImagenNIConRuido=reshape(ImagenNIConRuidoColumna,[m n]); % Convert it into a matrix
        imwrite(ImagenNIConRuido,strcat(pathWriteNoise,'\BlurredImage (',int2str(i),').jpg')); % Generate image i
    end;
end
