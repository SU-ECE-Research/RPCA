function res = morph_RPCA(res,strelSize, strelShape)
% Performs morphological operations on rpca_results struct.
%{ 
Input: 
- rpca_results (struct generated from run_RPCA.m)
- [OPTIONAL] strelSize (structural element size, defaults to 100)
- [OPTIONAL] strelShape (structural element shape, defaults to 'disk')

Joshua Beard
C: 12/1/16
E: 12/1/16
%} 

N = 1;

if( nargin < 2 )
    % Default structural element shape to disk & size to 100px
    strelShape = 'disk';
    strelSize = 100;
elseif(nargin < 3)
    % Default structural element shape to disk
    strelShape = 'disk';
    
% Make sure strelSize is positive integer
elseif( mod(strelSize,1) > 0 )
    error([num2str(strelSize) ' is an invalid structural element size. Use only positive integers.']);
end

% Define structural element for morphological operation
se = strel(strelShape,strelSize);
% Initialize morphed field for speed
res.M = zeros(res.dimensions(1)*res.dimensions(2),res.setSize);

for( imN = 1:res.setSize )
    % Get template and image in matrix form
    template = rpca_reshape(res,'T',imN);
    image = rpca_reshape(res,'X',imN);
    % Perform each morphological operation
    m1 = bwmorph(template,'majority',N);
    m2 = imclose(m1, se);
    % Assign morphed image onto new field
    res.M(:,imN) = m2(:);
end
res.M = logical(res.M);