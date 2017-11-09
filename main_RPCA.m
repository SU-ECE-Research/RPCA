%{
Joshua Beard
C: 4/1/17
E: 6/7/17

This is the script that will run every part of RPCA consecutively.
NOTE:
- If you haven't already, run << setup_fastRPCA.m >> first
- For assistance in learning how to access and use the << rpca_results >> 
struct, check out << demo_accessing_rpca_results.m >>
%}
%% Constant Parameters (to remain the same throughout the whole process)
clear all; close all;

% Global variable with folder name for input images from one year. Note that this
% folder will include many subfolders corresponding to approximately a month
% worth of images.
global inputMainFolderName;

% Global variable with folder name for results from processing images from
% one year. Note that this folder will consist of subfolders corresponding
% to folders where input images are stored (meaning, it has the same
% structure as the input folder).
global outputMainFolderName;

% Max, min Set Size
global maxSetSize;
global minSetSize;
maxSetSize = 50;
minSetSize = 2;

% Name of setInfo text file (the product of CREATESETS)
setInfoTextFileName = 'setInfo.txt';

%% Variable Parameters


% Navigation and organization ---------------------------------------------

pathPrefix = '\\ecefs1\ECE_Research-Space-Share';        % Which drive you're using
% The following are mutually exclusive
pathSuffix = 'Madiyan_2012_Renamed';   % Which study you're analyzing (OPTIONAL)
%pathSuffix = 'Murghab_2012_Renamed';   %

inputMainFolderName  = pathJoin(pathPrefix,...
                                'DATA\Tajikistan_2012_CTPhotos_Renamed',...
                                pathSuffix);
                            
outputMainFolderName = pathJoin(pathPrefix,...
                                'RESULTS\Tajikistan_2012_CTPhotos_Renamed',...
                                pathSuffix);


% RPCA Parameters ---------------------------------------------------------

lambda    = 2e-2;               % Default: 2e-2
% tolerance for fidelity to data 
epsilon   = 5e-3*norm(X,'fro'); % Default: 5e-3*norm(X,'fro')
tau0      = 3e5;                % Default: 3e5
SPGL1_tol = 1e-1;               % Default: 1e-1
tol       = 1e-3;               % Default: 1e-3
% Mutually exclusive; defines the optimization function for RPCA
optimizationFunctionMax = true; % Default: true
optimizationFunctionSum = ~optimizationFunctionMax;

% Group all parameters for simple passing
RPCA_paramters = struct(   'lambda', lambda,...
                            'epsilon', epsilon,...
                            'tau0', tau0,...
                            'SPGL1_tol', SPGL1_tol,...
                            'tol', tol,...
                            'sum', optimizationFunctionSum,...
                            'max', optimizationFunctionMax);
                        
                        
% Templating Parameters ---------------------------------------------------

% Motion threshold for RPCA (corresponds with number of standard deviations
% from mean at which to threshold; all pixels within (threshold*stdDev) of
% mean become background, all outliers become foreground)
% Future work: experiment more with this.

% NOTE: See the << sparseHistogram >> function to see why we decided to use
% one standard deviation
motionThreshold = 1;

% Structuring element for binary morphology to create template.
% Future work: scale strel_size based on number of foreground pixels and
% size of blobs
strelSize = 100;
strelShape = 'disk';
%% Get folder list
% create the above folder if it's not already there
mkdir(outputMainFolderName);

% Get list of folders, make folderList if DNE
try
    load(pathJoin(outputShareFolderName, 'folderList.mat'));
catch
    fprintf('folderList DNE. Getting folders now...\n');
    [folderList, numFolders, emptyFolderList] = getFolders();
    fprintf('DONE\n');
end

save(pathJoin(outputMainFolderName, 'folderList.mat'), 'folderList');
save(pathJoin(outputMainFolderName, 'emptyFolderList.mat'), 'emptyFolderList');
%% Create temporal sets

% for each folder, create sets of images and process them accordingly
for f = 1 : numFolders   
    % get the name of the folder
    folderName = folderList(f).name;
     
    % If setInfo has not been created, make it
    if isempty(dir(pathJoin(outputMainFolderName, folderName, setInfoTextFileName)))
        fprintf('\nCreating Sets\nFOLDER: %s\n(%d out of %d)\n', folderName, f, numFolders);
        createSets(folderName); 
        % Get and save setInfo struct for each setInfo.txt
        setInfo = get_setInfo(pathJoin(outputMainFolderName, folderName));
        save(pathJoin(outputMainFolderName, folderName, 'setInfo.mat'), 'setInfo' ,'-v7.3');
    end
end

%% RPCA

% Run robust principal component analysis
for f = 1 : numFolders
    % Get the name of the folder
    folderName = folderList(f).name;
    % Get directory of sets in this folder
    directoryOfSets = dir(pathJoin(outputMainFolderName, folderName, 'Set_*'));
    for q = 1:length(directoryOfSets)
        thisSet = directoryOfSets(q);
        % Get image data
        imageDataLocation = pathjoin(outputShareFolderName, folderName, thisSet.name);
        % let X be a DxN matrix representing a set of original images, where
        %   D is imageHeight x imageWidth
        %   N is number of images in a set
        %   Each column in X represents one image
        [X, imageHeight, imageWidth] = getImageData(imageDataLocation);

        % Run RPCA
        rpca_results = run_RPCA(X, imageHeight, imageWidth, RPCA_parameters);

        % Motion threhsolding
        rpca_results = threshold_RPCA(rpca_results, motionThreshold);

        % Binary morphology
        rpca_results = morph_RPCA(rpca_results, strelSize, strelShape);

        % Save RPCA results
        rpca_results_fileName = pathJoin(outputMainFolderName, folderName, thisSet.name, 'rpca_results.mat');
        save(rpca_results_fileName, 'rpca_results', '-v7.3');
    end
end

%%
% Play a little audio notification
done;
