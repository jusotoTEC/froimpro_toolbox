function [] = Matrix2Image(X,m,n,TextPath,Name)
% This function takes a matrix X of size mnxp, which contains in its columns
% the information of p vectorized images of size mxn. Upon executing the
% function, the corresponding images will be generated in the 'TextPath' directory.
%
% For more information, refer to the Toolbox manual.
%
% Syntax: Matrix2Image(X, m, n, 'TextPath', 'Name')
%
% Input parameters:
%       X: Matrix X of size mnxp.
%       m, n: Positive integers such that mxn is the size of each of the images.
%       TextPath: Path where the images associated with each column of X will be saved.
%       Name: Root with which the images will be named, followed by an automatic counter.

isize=[m,n]; % Size of each image
[~,p]=size(X); % Number of images
direccion=strcat(TextPath,'\',Name);
if exist(TextPath)~=7
    mkdir(TextPath);
end
NumCeros=length(num2str(p));
CerosText=NStr('0',NumCeros);
for i=1:p
    NumCerosActual=length(num2str(i));
    CerosActual=CerosText(1:(NumCeros-NumCerosActual));
    imwrite(double2uint8(reshape(X(:,i),isize)),strcat(direccion,CerosActual,num2str(i),'.jpg'));
end
end

function [TextOut] = NStr(Text,N)
% Receives a character string in "Text" and a natural number N.
% Returns a string where Text was concatenated N times.
TextOut='';
for i=1:N
   TextOut=strcat(TextOut,Text); 
end
end


