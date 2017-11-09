% isRPCAdone
% Checks if RPCA has been done for each folder and outputs the resulting
% list to excel

% Some stuff (variable names) is hardcoded in here, so be careful 

%{
Taz Bales-Heisterkamp and Joshua Beard
C: 1/23/17
E: 1/30/17
%}

%dataFolder = '\\ecefs1\ECE_Research-Space-Share\DATA\Tajikistan_2012_CTPhotos\Madiyan_Pshart\';
dataFolder = '\\ecefs1\ECE_Research-Space-Share\DATA\Tajikistan_2012_CTPhotos\Murghab_Concession\';

%resultsFolder = '\\ecefs1\ECE_Research-Space-Share\RESULTS\Tajikistan_2012_CTPhotos\Madiyan_Pshart\';
resultsFolder = '\\ecefs1\ECE_Research-Space-Share\RESULTS\Tajikistan_2012_CTPhotos\Murghab_Concession\';

%folderListName = 'unassignedFolderList_afterSpots2'
%folderListName = 'folderList2';
%folderListName = 'rpcaPriorityFolders';
folderListName = 'svmTrainFolderList';

load([resultsFolder folderListName]);
folderList = eval(folderListName);

setsNotDone = 0;
writeToExcel = false;

%%
for q = 1:length(folderList)
    
    thisFolder = [resultsFolder folderList(q).name];
    
    % If setInfo struct doesn't exist, create and save one.
    if isempty(dir([thisFolder '\setInfo.mat']))
        fprintf('setInfo.mat does not exist at \n%s\nMaking and saving one now.\n', thisFolder);
        setInfo = get_setInfo(thisFolder);
        save([thisFolder '\setInfo.mat'], 'setInfo')
    % If setInfo struct does exist, load it
    else
        load([thisFolder '\setInfo.mat']);
    end
    
    lastSet = num2str(length(setInfo));
    
    folderList(q).rpca_done = 1;
    
    % Check rpca_results.mat for every Set
    for s = 1:length(setInfo)
        % Get file path to set
        thisSet = [thisFolder '\Set_' num2str(s) '\'];
        
        if isempty(dir([thisSet 'rpca_results.mat'])) 
            setsNotDone = setsNotDone + 1;  
            folderList(q).rpca_done = 0;
            svmTrain_setsNotDone_paths{setsNotDone} = thisSet; 
        end
    end
end

%%
rpca_done_folderList = folderList;
save([resultsFolder 'rpca_done_folderList.mat'],'rpca_done_folderList');

svmTrain_setsNotDone_paths = svmTrain_setsNotDone_paths';
save([resultsFolder 'svmTrain_setsNotDone_paths.mat'],'svmTrain_setsNotDone_paths');

fprintf('Sets not done: %i\n', setsNotDone);

%% write to excel 
if(writeToExcel)
    %convert to cell array for easy writing to excel
    cellList = struct2cell(rpca_done_folderList);

    cellList = cellList';
    xlswrite([resultsFolder 'rpca_done_folderList.xls'], cellList);
end 
%}  