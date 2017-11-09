function reshaped = rpca_reshape(results, field, imgNum)
% Gets specified field image and reshapes it into a matrix
%{
Input:
- results (rpca_results made by run_RPCA)
- field (X, L, S, T, L0, S0)
- imgNum (specific image number)

Joshua Beard
C: 11/21/16
E: 12/1/16
%}

% Throw error if there's a problem
if(~isfield(results, field))
    error(['"' field '" is not a field name for this struct']);  
elseif(numel(eval(['results.' field])) < 3)
    error(['"' field '" is not an image']);
else
    % Reshape function
    mat  = @(x) reshape( x, results.dimensions(1), results.dimensions(2) );
    % Reshaped field
    reshaped = mat(eval(['results.' field '(:,imgNum)']));
    %reshaped = reshape(eval(['results.' field '(:,imgNum)']), results.dimensions(1), results.dimensions(2));
end