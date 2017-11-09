function res = threshold_RPCA(res, C)
% Thresholds motion images (sparse matrix S from RPCA) in rpca_results 
% struct (generated from run_RPCA.m) using a scaled standard deviation 
% threshold. 
% Input: 
% - rpca_results (struct generated from run_RPCA.m)
% - C (multiplier for calculcating threshold)
% Output:
% - rpca_results (with a new data member the templated images)

% Joshua Beard
% C: 11/21/16
% E: 11/21/16

% If C is not defined, default to C = 1

if(nargin < 2)
    C = 1;
end

% Initialize field for speed
res.T = zeros(res.dimensions(1)*res.dimensions(2),res.setSize);

% Define function for calculating standard deviation of sparse matrix
sparse_sigma = @(x) std(res.S(:,x));

for k = 1:res.setSize
    % Template is sparse matrix with any values outside template
    res.T(:,k) = (abs(res.S(:,k)) > C*sparse_sigma(k))*255;
end
% Turn it binary for space
res.T = logical(res.T);

