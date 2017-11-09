
function results = run_RPCA(X, r, c, params)
% Runs RPCA on a given image set, then returns a struct
%{
INPUT:
- X (set of images ordered PxN)
 - P = number of pixels in an image
 - N = number of images in a set

Joshua Beard
C: 12/1/16
E: 1/20/17
Edits:
    1/20/17
        %{
        X = uint8(X);
        L = single(L);
        S = single(S);
        L0 = single(L0);
        S0 = single(S0);
        %}

%}
X = double(X);
nFrames = size(X,2);
L0 = repmat( median(X,2), 1, nFrames );
S0 = X - L0;

if nargin < 4
    % Defaults (defined by Becker's Code)
    lambda  = 2e-2;                                                       %
    epsilon = 5e-3*norm(X,'fro'); % tolerance for fidelity to data        %
    opts    = struct(   'sum',false,...
                        'L0',L0,...
                        'S0',S0,...
                        'max',true,...
                        'tau0',3e5,...
                        'SPGL1_tol',1e-1,...
                        'tol',1e-3);
    
else    % User defined parameters
    lambda  = params.lambda;
    epsilon = params.epsilon;
    opts    = struct(   'sum',params.sum,...
                        'L0',L0,...
                        'S0',S0,...
                        'max',params.max,...
                        'tau0',params.tau0,...
                        'SPGL1_tol',params.SPGL1_tol,...
                        'tol',params.tol);
end

% RPCA lives here (SPGL1 is the default)
[L,S] = solver_RPCA_SPGL1(X,lambda,epsilon,[],opts);

% Convert all data to save space and transfer times
X = uint8(X);      % Data
L = single(L);     % Low-rank background
S = single(S);     % Sparse motion

% Put it all in a struct
results = struct('X',X,'L',L,'S',S,'dimensions',[r,c],'setSize',nFrames);