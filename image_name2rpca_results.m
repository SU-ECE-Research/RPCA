function rpca_results = image_name2rpca_results(fullPathToImage)
% Takes the full DATA path and gets rpca_results for it
%{
Joshua Beard
3/17/17
EDITS:
    3/23/17
        STRCMPI to ignore case in image name
    6/9/17
        Deleted load of L0 and S0

%}

%% Running as script:
%{
load('\\ecefs1\ECE_Research-Space-Share\RESULTS\Tajikistan_2012_CTPhotos\Murghab_Concession\featureSource.mat');
fullPathToImage = featureSource{1};
clear featureSource;
%}
%%

% Begin parsing path, add to RESULTS path
[T, R] = strtok(fullPathToImage,'\');
%resultsPath = ['\\' T '\'];
resultsPath = ['\\'];
% Go through path until we reach image name
while ~strcmpi(T(end-2:end), 'jpg')
    % Construct RESULTS path
    resultsPath = [resultsPath T '\'];
    [T, R] = strtok(R, '\');
    % Change DATA to RESULTS
    if strcmp(T, 'DATA')
        T = 'RESULTS';
    end
end

%% Get setInfo
load([resultsPath 'setInfo.mat'])

%% Find set
setNum = 0;
setFound = false;
while ~setFound
    %fprintf('Set %d did not contain %s\n', setNum, T); 
    setNum = setNum + 1;
    imageNum = 1;
    while imageNum <= setInfo(setNum).nImgs && ~setFound
        if strcmp(setInfo(setNum).names{imageNum}, T)
            setFound = true;
        end
        imageNum = imageNum + 1;
    end
end
imageNum = imageNum-1;
%% Get rpca_results
load([resultsPath 'Set_' num2str(setNum) '\rpca_results.mat'])
rpca_results.X = rpca_results.X(:,imageNum);
rpca_results.L = rpca_results.L(:,imageNum);
rpca_results.S = rpca_results.S(:,imageNum);
rpca_results.T = rpca_results.T(:,imageNum);
rpca_results.M = rpca_results.M(:,imageNum);