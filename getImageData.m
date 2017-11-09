function [X, r, c] = getImageData(imageFolder, varargin)
% Creates a cell array of matrices containing values in range [0, 255] 
% representing all images contained in imageFolder.
%{
Joshua Beard
C: 10/5/16
EDITS:
    1/20/17:
        Converts images to uint8 instead of double (for storage and
    data transfer optimization)
    4/11/17:
        varargin to support future file extensions if needed
%}
if(nargin < 2)
    ext = 'JPG';
else
    if strcmp(lower(varargin{1}), 'extension')
        ext = varargin{2};
    else
        ext = varargin{1};
    end
end

imageDirectory = dir([imageFolder '\*.' ext]);

for(q = 1:length(imageDirectory))
     temp = uint8(rgb2gray(imread([imageFolder '\' imageDirectory(q).name])));
     X(:,q) = temp(:);
end
[r, c] = size(temp);