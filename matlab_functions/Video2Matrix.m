function [XO,m1,n1] = Video2Matrix(PathTextVideo,varargin)
% This function reads a video in MP4 format from the specified 'PathTextVideo'
% and encodes it as a matrix of size (mn x numFrames), where each video frame
% is of size mxn pixels. The user has the option to specify the number of frames
% to be processed (which will be evenly sampled from the original video). If not
% specified, the entire video will be encoded.
%
% For more information, refer to the Toolbox manual.
%
% Syntax: [XO, m1, n1] = Video2Matrix('PathTextVideo')
%
% Input parameter:
%       PathTextVideo: Path to the video to be processed.
%
% Alternative syntax:
%   [XO, m1, n1] = Video2Matrix('PathTextVideo', 'Scale', Scale, 'numFrames', numFrames)
%
% Optional parameters:
%       Scale:     Scaling factor such that 0 < Scale <= 1. Each video frame will be
%                  scaled to dimensions resulting from multiplying its original
%                  dimensions by the factor "Scale". Default value is 1.
%       numFrames: Number of frames to be used from the video for processing,
%                  evenly sampled. Default value is the total number of frames
%                  in the original video.
%
% Output parameters:
%       XO:      Matrix of size (mn x numFrames), where each column corresponds
%                to a vectorized video frame.
%       n1 and m1: Dimensions of each frame after being rescaled according to the 'Scale' parameter.

if exist(PathTextVideo,'file')~=2% Validates that the video path is valid and corresponds to an existing file.
   error(['The path ',PathTextVideo,' is invalid']);
end

% Load the video and determine the number of frames it contains
VideoAProcesar = VideoReader(PathTextVideo);
FrameTotales = VideoAProcesar.NumberOfFrames;

% Start input validation
defaultScale=1;
defaultnumFrames=FrameTotales;
p = inputParser;

% Define the validation functions that the parser will use
validScale = @(x) isnumeric(x) && (x>0) && (x<=1);
validnumFrames = @(x) isnumeric(x) && mod(x,1)==0 && (x<=FrameTotales);

% Define the required and optional parameters and validate them using the
% previously defined validation functions.
addRequired(p,'PathTextVideo');
addOptional(p,'Scale',defaultScale,validScale);
addOptional(p,'numFrames',defaultnumFrames,validnumFrames);

% Validate according to the established parameters
parse(p,PathTextVideo,varargin{:});

PathTextVideo=p.Results.PathTextVideo;
Scale=p.Results.Scale;
numFrames=p.Results.numFrames;

% Start building the matrix XO, which will be returned.
FactorFrame=FrameTotales/numFrames;
Ima=rgb2gray(imresize(read(VideoAProcesar,fix(FactorFrame)),Scale));     % First frame of the video in grayscale.
[m1,n1]=size(Ima(:,:,1));                                                 % Size of the first frame and all subsequent frames.
XO=reshape(double(Ima),m1*n1,1);                                         % Convert the first frame to a vector.        % Redefine the matrix shape from an mxn column to an mnx1 column.
for i=2:numFrames
    Ima=rgb2gray(imresize(read(VideoAProcesar,fix(FactorFrame*i)),Scale));  % Convert all subsequent frames to vectors, all in grayscale.
    XO=[XO,reshape(double(Ima),m1*n1,1)];
end
end

