function [OutX] = double2uint8(X)
  
    % Converts a double matrix into a matrix in uint8 format by rescaling the
    % matrix data to values between 0 and 255. Then this matrix can be
    % used to generate the corresponding image.
    %
    % For more information, refer to the Toolbox manual.
    %
    % Syntax: OutX = double2uint8(X)
    %
    % Input parameter:
    %       X: It is a matrix with entries of type double.
    %
    % Output parameters:
    %       OutX: It is the rescaled matrix with entries of type uint8.
mini=min(min(X));
maxi=max(max(X));
OutX=uint8(255/(maxi-mini)*(X-mini));
end

