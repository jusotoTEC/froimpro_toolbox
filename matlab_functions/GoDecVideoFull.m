function [] = GoDecVideoFull(TextPath,r,k,Opcion,varargin)
    % This function takes a video, encodes it into a matrix X, and applies the GoDec function to it.
% Additionally, it generates the corresponding videos for matrices S and L.
%
% For more information, refer to the Toolbox manual.
%
% Syntax: GoDecVideoFull('Textpath',r,k,Option)
%
% Input parameters:
%       Textpath: Path of the video to be processed. 
%       r: Maximum rank that matrix L will have.
%       k: Maximum cardinality that matrix S will have.
%       Option: Possible values 'BRP' or 'SVD'.
%
% Alternative Syntax: 
%   GoDecVideoFull('Textpath',r,k,'Option','Scale',Scale,'numFrames',numFrames,'c',c,'Tol',Tol,'IteraMax',IteraMax)
%   
% About optional parameters:   
%       Scale:     Scale such that 0<Scale<=1. Each frame of the video will be scaled to a size resulting 
%                  from multiplying its original dimensions by the "Scale" factor. The default value is 1. 
%       numFrames: Number of frames to be used from the video for the process, taken uniformly. 
%                  The default value is the total number of frames of the original video. 
%       c:         Parameter of the "power scheme", used to improve the 
%                  generation of bilateral projection matrices. It must be 
%                  an integer, positive, and may be adjusted by the user. 
%                  The default value is c=3.
%       Tol:       Tolerance, for the stopping criterion, difference between two consecutive errors
%                  less than Tol. The default value is 10^-8.
%       IteraMax:  Maximum number of iterations to perform. The default value is 100. 
   
LongVarar=length(varargin);
% This block is responsible for taking the optional parameters and splitting them to be sent
% in the two following functions:
%   -Video2Matrix(TextPath,Lista1{:});
%   -GoDec(X,r,k,Lista2{:})
%These parameters are not validated here because they will be subjected to
%validation within these functions.
j=1;
l1=1;
l2=1;
Lista1={};
Lista2={};
while j<=LongVarar
    switch varargin{j}
    case 'Scale'
        Lista1{l1}=varargin{j};
        Lista1{l1+1}=varargin{j+1};
        l1=l1+2;
    case 'numFrames'
        Lista1{l1}=varargin{j};
        Lista1{l1+1}=varargin{j+1};
        l1=l1+2;
    case 'c'
        Lista2{l2}=varargin{j};
        Lista2{l2+1}=varargin{j+1};
        l2=l2+2;
    case 'IteraMax'
        Lista2{l2}=varargin{j};
        Lista2{l2+1}=varargin{j+1};
        l2=l2+2;
    case 'Tol'
        Lista2{l2}=varargin{j};
        Lista2{l2+1}=varargin{j+1};
        l2=l2+2;
    otherwise
        error(strcat('The parameter ', varargin{j}, ' is not recognized'));
    end
    j=j+2;
end


[X,m1,n1]=Video2Matrix(TextPath,Lista1{:});
[LRF,SRF,~]=GoDec(X,r,k,Opcion,Lista2{:});
Matrix2Video(SRF,m1,n1,'S');
Matrix2Video(LRF,m1,n1,'L');
MatrixXLS2Video(X,LRF,SRF,m1,n1,'XLS');
end


function [] = MatrixXLS2Video(X,L,S,m,n,PathNameVideo)
% This function is responsible for transforming a matrix X whose columns
% correspond to frames of size mxn pixels into a video that will be saved
% at the address indicated in PathNameVideo. This video
% will be saved in MP4 format.
%%%%%%%%%%%%%
% Receives: 
%%%%%%%%%%%%%
%%% A matrix X: This matrix is of size mnxp. Each column of this matrix
       % corresponds to a frame of the video.
%%% m and n: Correspond to the number of rows and the number of columns that each frame will have
       % seen as a matrix. It is necessary to receive them because each frame in X
       % is expressed as a single column, so it is necessary
       % to resize each column of X into a matrix of size mxn.

% Start the validation of the received parameters, in this case all the
% parameters are mandatory.


if not(isnumeric(L) && ismatrix(L))
    Error('The parameter X is invalid.');
end
if not(isnumeric(S) && ismatrix(S))
    Error('The parameter X is invalid.');
end
if not(isnumeric(X) && ismatrix(X))
    Error('The parameter X is invalid.');
end
if not(isnumeric(m)&& (mod(m,1)==0))
    Error('The value for parameter "m" is invalid.')
end
if not(isnumeric(n)&& (mod(n,1)==0))
    Error('The value for parameter "n" is invalid.')
end
[numPixeles,numFrames]=size(X);
if (m*n~=numPixeles)
    Error('The values of m and n do not correspond to the number of pixels in each frame: Pixels number = m*n');
end



%%% End of parameter validation and start of video creation

posUltiLinea=max(strfind(PathNameVideo,'\'));
if posUltiLinea>1
    if exist(PathNameVideo(1:posUltiLinea-1))~=7
        mkdir(PathNameVideo(1:posUltiLinea-1));
    end
end
v = VideoWriter(PathNameVideo,'MPEG-4'); % Define the video.
open(v)                                  % Open the video for editing.
isize=[m,n];
for ii = 1:numFrames
    Frame=[double2uint8(reshape(X(:,ii),isize)),double2uint8(reshape(L(:,ii),isize)),double2uint8(reshape(S(:,ii),isize))];
    writeVideo(v,Frame); % Add one frame at a time to the video.
end
close(v)
end

