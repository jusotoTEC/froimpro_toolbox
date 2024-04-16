function [] = Matrix2Video(X,m,n,PathNameVideo)
% This function transforms a matrix X, whose columns correspond to frames of a video
% (each one of size mxn pixels), and converts it into an MP4 video format, which will be saved 
% at the location specified by 'PathNameVideo'.
%
% For more information, refer to the Toolbox manual.
%
% Syntax: Matrix2Video(X, m, n, 'PathNameVideo')
%
% Input parameters:    
%       X:             Matrix of size mnxp.
%       m, n:          Positive integers such that mxn corresponds to the size of each frame.
%       PathNameVideo: The name (or complete path, if desired) assigned to the video to be
%                      saved in the working directory. 

if not(isnumeric(X) && ismatrix(X))
    Error('The parameter X is invalid.');
end
if not(isnumeric(m)&& (mod(m,1)==0))
    Error('The value for parameter "m" is invalid.')
end
if not(isnumeric(n)&& (mod(n,1)==0))
    Error('The value for parameter "n" is invalid.')
end
[~,numFrames]=size(X);
if (m*n==numFrames)
    Error('The values of m and n do not correspond to the number of pixels in each frame: Pixels number = m*n');
end

%%% Parameter validation ends and video creation begins
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
    writeVideo(v,double2uint8(reshape(X(:,ii),isize))); % Add one frame at a time to the video.
end
close(v)
end

