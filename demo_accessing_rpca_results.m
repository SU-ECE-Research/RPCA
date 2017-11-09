%{
This script is designed to help with learning about how to access <<
rpca_results >> struct, and what each field means

Joshua Beard
4/11/17
%}

%% Parameters
filePath = '\\ecefs1\ECE_Research-Space-Share\RESULTS\Tajikistan_2012_CTPhotos\Madiyan_Pshart\MAD05\P024\Set_1\';
fileName = 'rpca_results.mat';
%{
Choose the image number from the set.

Unfortunately, we can't select an image by name except by using some
complex addressing, which is beyond the scope of this document.
%}
imageNumber = 3; 
%{
Choose the field you want. Valid fields are as follows:
- X: Actual image data
- L: Low-rank background
- S: Sparse motion
- T: Thresholded S
- M: Morphologied threshold (this is the matrix we call the 'Template')
- dimensions: a 2-value vector defining the rows and columns of the
original data, respectively
- setSize: Number of images in this set
%}
field = 'X';
%% Loading (takes a while)
% Load rpca_results
% Note that it will be called 'rpca_results' in your workspace
load([filePath fileName]);

%% Accessing single image (the following all yield the same image)
% Get a single image using function supplied by JB
singleImage_a = rpca_reshape(rpca_results, field, imageNumber);

% Get a single image manually
dataVector = rpca_results.X(:,imageNumber); % Vector of the image
numRows = rpca_results.dimensions(1);       % Number of pixel rows
numCols = rpca_results.dimensions(2);       % Number of pixel columns

singleImage_b = reshape(dataVector,...
                        numRows,...
                        numCols);
                        
% Get a single image systematically (if you want to use it in an algorithm)
% This is how my above function works under the hood
singleImage_c = reshape(eval(['rpca_results.' field '(:,imageNumber)']),...
                        rpca_results.dimensions(1),...
                        rpca_results.dimensions(2));
                    
%% Displaying single image (the following both yield the same image)
% Display single image using function supplied by JB
% This function works the same way as rpca_reshape
im_a = rpca_imshow(rpca_results, field, imageNumber);

% Display single image manually
colormap('Gray');
im_b = figure;
imshow(singleImage_b);


