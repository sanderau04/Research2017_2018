%% export_csv_labeled_task_results.m supplies the data processing that was 
% needed to determine if speaker recognition was possible through 
% cluster analysis.

%% Required patient mat file variables: 
% energyMatrix, EpochLabel

%% Reading in all mat files
clear all, clc
myFolder = uigetdir('D:\Documents\Research2017\MATLAB\FeatureAnalysis','Pick a folder containing mat files');

if ~isdir(myFolder)
  errorMessage = sprintf('Error: The following folder does not exist:\n%s', myFolder);
  uiwait(warndlg(errorMessage));
  return;
end

filePattern = fullfile(myFolder, '*.mat');
matFiles = dir(filePattern);

folder = ['csvExport',datestr(now, 'dd-mmm-yyyy_HH_MM_SS')];
mkdir(folder);

for k = 1:length(matFiles)
  baseFileName = matFiles(k).name;
  fullFileName = fullfile(myFolder, baseFileName);
  matData(k) = load(fullFileName);
end
%% Iterate through each mat file and extract energyMatrix and EpochLabel
% Assign Epoch Labels to respective energyMatrix column and export all
% as indvidual CSVs to a timestamped folder saved to current directory
for i = 1:length(matFiles)
    clear pDx epochLabel epochLabelRaw audioName energyMatrix filename fid
    pDx = extractfield(matData(i),'patientDx');
	epochLabelRaw = matData(i).EpochLabel;
    audioName = char(extractfield(matData(i),'audioName'));
    energyMatrix = matData(i).energyMatrix;
    for x = 1:length(energyMatrix(1,:))
        epochLabel{x} = epochLabelRaw{x};
    end
    filename = [folder,'/', audioName,'.csv'];
    fid = fopen(filename, 'w') ;
    fprintf(fid, '%s,', epochLabel{1,1:end-1}) ;
    fprintf(fid, '%s\n', epochLabel{1,end}) ;
    fclose(fid) ;
    dlmwrite(filename, energyMatrix(1:end,:), '-append') ;
end