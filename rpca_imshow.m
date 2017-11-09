function im = rpca_imshow(results, field, imgNum)
% Uses imshow to show specified field and image of rpca_results
%{
Input:
- results (rpca_results made by run_RPCA)
- field (X, L, S, T, L0, S0)
- imgNum (specific image number)
Output:
- N/A

Joshua Beard
C: 11/21/16
E: 11/21/16
%}

% Throw error if there's a problem
if(~isfield(results, field))
    error(['"' field '" is not a field name for this struct']);  
else
    % Reshape function
    mat  = @(x) reshape( x, results.dimensions(1), results.dimensions(2) );
    colormap('Gray');
    im = figure;
    imshow(mat(eval(['results.' field '(:,imgNum)'])), []);
    
end
    
