function [] = GoDecImageFull(TextPath,r,k,Opcion,varargin)
% This function receives a directory path of images. It vectorizes them and organizes them into a matrix X.
% Then, it uses the "GoDec" function to solve the problem: min||X-(L+S)||. It applies the BRP method or the SVD.
% In the current working directory, two subdirectories will be created, "ImageForS" and "ImageForL",
% where the images corresponding to matrix S and L, respectively, will be saved.
%
% For more information, refer to the Toolbox manual.
%
% Syntax: GoDecImageFull('Textpath',r,k,Option)
%
% Input parameters:
%       Textpath: Path of the directory of the image database. 
%       r: Maximum rank that matrix L will have.
%       k: Maximum cardinality that matrix S will have.
%       Option: Possible values 'BRP' or 'SVD'.
%
% Alternative Syntax: GoDecImageFull('Textpath',r,k,'Option','c',c,'Tol',Tol,'IteraMax',IteraMax)
%   
% About optional parameters:
%       c:        Parameter of the "power scheme", used to improve the 
%                 generation of bilateral projection matrices. It must be 
%                 an integer, positive, and may be adjusted by the user. 
%                 The default value is c=3.
%       Tol:      Tolerance, for the stopping criterion, difference between two consecutive errors
%                 less than Tol. The default value is 10^-8.
%       IteraMax: Maximum number of iterations to perform. The default value is 100.
  
[X,~,m,n]=ReadImageDataBase(TextPath);
[L,S,~]=GoDec(X,r,k,Opcion,varargin{:});
Matrix2Image(S,m,n,'ImagesForS','S');
Matrix2Image(L,m,n,'ImagesForL','L');
end

