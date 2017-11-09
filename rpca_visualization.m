function rpca_visualization(results, timeStep, C)
% Visualizes RPCA by showing each image in a set as a movie

%{
Input:
- rpca_results (struct made by run_RPCA.m)
- [OPTIONAL] timeStep (time between images in a set. Defaults to 0.5)
- [OPTIONAL] C (multiplier to stddev to threshold motion)
Output:
- N/A
%}

% Joshua Beard
% C: 11/12/16
% E: 11/21/16

%%

cm = 'Gray';
% Default C = 1 and timeStep = 0.5 seconds
if(nargin < 3)
    C = 1;
    if(nargin < 2)
        timeStep = 0.5;
    end
elseif(C < 0)
    mat  = @(x) reshape( x, results.dimensions(1), results.dimensions(2) ); clf;
    for k = 1:results.setSize
        colormap(cm);
        figure(1);
        imagesc( [mat(results.X(:,k)), mat(results.L(:,k)),  mat(results.S(:,k))]);
        % compare it to just using the median
        %imagesc( [mat(X(:,k)), mat(L0(:,k)),  mat(S0(:,k))] );
        axis off
        axis image
        drawnow;
        pause(timeStep);  
    end
else
    mat  = @(x) reshape( x, results.dimensions(1), results.dimensions(2) ); clf;
    sDev = @(x) std(results.S(:,x));
    for k = 1:results.setSize
        S_temp = (abs(mat(results.S(:,k))) > C*sDev(k))*255;
        %S_temp = ((mat(results.S(:,k))) > C*sDev(k))*255;
        colormap(cm);
    %     figure(2);
    %     im = imagesc( [mat(results.X(:,k)), mat(results.L(:,k)),  mat(results.S(:,k))]);
    %     axis off
    %     axis image
    %     drawnow;
        colormap(cm);
        figure(1);
        imagesc( [mat(results.X(:,k)), mat(results.L(:,k)),  S_temp]);
        % compare it to just using the median
        %imagesc( [mat(X(:,k)), mat(L0(:,k)),  mat(S0(:,k))] );
        axis off
        axis image
        drawnow;
        pause(timeStep);  
    end
end
end