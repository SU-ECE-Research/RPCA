function templatedImage = rpca_templatedImage(rpca_results, imgNum)
% Templates an image for you
%{
Joshua Beard
C: 1/27/17
E: 1/27/17
%}

templatedImage = reshape(rpca_results.X(:,imgNum).*uint8(rpca_results.M(:,imgNum)), rpca_results.dimensions(1), rpca_results.dimensions(2));
