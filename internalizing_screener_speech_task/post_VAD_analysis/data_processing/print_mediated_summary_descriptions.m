%% print_mediated_summary_descriptions.m produces single matrix housing
% all summary descriptions of mediated patient mat files with respective
% PID. 

%% Patient mat file variables required: 
% mediateDescription, audioName

clear all, clc, close all
%% Read in mediated files
myFolder1 = uigetdir('D:\Documents\Research2017\MATLAB','FOLDER 1: containing mat files');

if ~isdir(myFolder1)
    errorMessage = sprintf('Error: The following folder does not exist:\n%s', myFolder1);
    uiwait(warndlg(errorMessage));
    return;
end

filePattern1 = fullfile(myFolder1, '*.mat');
matFiles1 = dir(filePattern1);

for k = 1:length(matFiles1)
    baseFileName1 = matFiles1(k).name;
    fullFileName1 = fullfile(myFolder1, baseFileName1);
    matData1(k) = load(fullFileName1);
end
%% Create matrix 
for i=1:length(matData1)
   mediateDescription = matData1(i).mediateDescription;
   PID = matData1(i).audioName;
   summaryDescriptions(i,1) = string(PID);
   summaryDescriptions(i,2) = string(mediateDescription{end,2});
   clear summaryDescription PID
end