function [X,m,n,A]=FullRankConstrainedFilterX(Textpath,varargin)
     
    % This function reads a folder with images using the "ReadDataBase" function 
    % and computes the matrix X of reduced rank that minimizes ||A-XC||_fr.
    %
    % For more information, refer to the Toolbox manual.
    %
    % Syntax: [X,m,n,A]=FullRankConstrainedFilterX('Textpath')
    %
    % Input parameter: 
    %       Textpath: Path of the folder containing the images.
    %
    % Alternative Syntax:
    %       Option 1: [X,m,n,A]=FullRankConstrainedFilterX('Textpath','k',k_0, ...
    %                           'NoiseOption','gaussian','sigmagauss',n_0 ,'meangauss',n_1);
    %       Option 2: [X,m,n,A]=FullRankConstrainedFilterX('Textpath','k',k_0,'NoiseOption',...
    %                           's&p','d',n_0);
    %       Option 3: [X,m,n,A]=FullRankConstrainedFilterX('Textpath','k',k_0,...
    %                           'NoiseOption','speckle','sigmaspeckle',n_0);
    %
    % About optional parameters:
    %
    %       NoiseOption:  It is the type of noise, with options 'speckle',
    %                     's&p','gaussian', where 's&p' stands for "salt and
    %                     pepper". The default value is NoiseOption=gaussian.
    %       k:            It is the value with which the rank is restricted. It must satisfy
    %                     0<k<=min(mA,nA), where mA=m*n (mxn is the dimension of each
    %                     photograph in the basis) and nA is the number of images in the
    %                     basis. The default value is k=min(mA,nA).
    %       sigmagauss:   Variance for Gaussian noise. The default value is sigmagauss=0.01.
    %       meangauss:    Mean for Gaussian noise. The default value is meangauss=0.
    %       sigmaspeckle: Variance for speckle noise. The default value is sigmaspeckle=0.05.                  
    %       d:            Density of noise for s&p. The default value is d=0.05.
    %
    % Output parameters:       
    %       A:   Matrix containing the original images, organized in columns. 
    %       C:   Matrix containing the noisy images, organized in columns. 
    %       X:   Matrix corresponding to the constructed filter.
    %       m,n: They are the dimensions of each of the images in the basis.

    [A,m,n]=ReadImageDataBase(Textpath); %% Reads the image database
    [mA,nA]=size(A);
    %%%%%%%%%%%%%% Here I load the default values
    NoiseOption='gaussian';
    k=min(mA,nA);
    sigmagauss=0.01;
    meangauss=0;
    d=0.05;
    sigmaspeckle=0.05;
    %%%%%%%%%%%%%% Finished loading the default values
    expectedNoises = {'speckle','s&p','gaussian'}; % Possible values for the variable "NoiseOption"
    %%%%%%%%%%% I use the inputParser to validate arguments and assign default values.
    p = inputParser;
    validScalar1 = @(x) isnumeric(x) && isscalar(x) && (x > 0);
    validScalar2 = @(x) isnumeric(x) && isscalar(x) && (x >= 0);
    addRequired(p,'Textpath'); %% Mandatory parameter. The ones below are all optional.
    addParameter(p,'NoiseOption',NoiseOption,@(x) any(strcmp(lower(strrep(x,' ','')),expectedNoises))); 
                    %%%%  Validates if the 'NoiseOption' parameter exists.
                    %%%%  If it doesn't exist, assigns the default value.
                    %%%%  If it does exist, the "p" object contains the value entered by the user.
                    %%%%  It is accessed with p.Results.NoiseOption       
    addParameter(p,'k',k,@(x) x==floor(x) && (x>0));
    addParameter(p,'sigmagauss',sigmagauss,validScalar1);
    addParameter(p,'meangauss',meangauss,validScalar2);
    addParameter(p,'d',d,validScalar1);
    addParameter(p,'sigmaspeckle',sigmaspeckle,validScalar1);
    parse(p,Textpath,varargin{:});   
    %%%%%%%%%%%%%%%%% Closes the inputParser
    NoiseOption=p.Results.NoiseOption; % Load the type of noise
    NoiseOption=lower(strrep(NoiseOption,' ','')); % Remove empty spaces and uppercase
    k=p.Results.k; % Load the value of k that restricts the rank
    if (k >min(mA,nA)) % Complete the validation of k
        error(['The value of "k" is invalid. For your dataset it must satisfy the condition 0<k<=' int2str(min(mA,nA))]);
    end
    %%%%% From here on, load the other parameters, starting from the attributes of the object p
    sigmagauss=p.Results.sigmagauss;
    meangauss=p.Results.meangauss;
    d=p.Results.d;
    sigmaspeckle=p.Results.sigmaspeckle;
    %%%%% Close the variable loading
    %%%%% Now Create the noisy matrix using the NoiseFunction
    C=NoiseFunction(Textpath,'NoiseOption',NoiseOption,'sigmagauss',sigmagauss,'meangauss',meangauss,'d',d,'sigmaspeckle',sigmaspeckle); 
    %%%% Now Create the reduced-rank matrix X
    [X]=RankConstrainedFilterX(A,C,k);
end
