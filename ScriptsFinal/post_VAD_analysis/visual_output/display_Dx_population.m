%% display_Dx_population.m creates a table that displays patient diagnoses
% diagnoses displayed are deteremined by variable PDxIndices

%% Patient mat file variables required:
% audioName, patientDx


clc, clear all
%% Reading in all mat files
myFolder = uigetdir('D:\Documents\Research2017\MATLAB','Pick a folder containing mat files');

if ~isdir(myFolder)
    errorMessage = sprintf('Error: The following folder does not exist:\n%s', myFolder);
    uiwait(warndlg(errorMessage));
    return;
end

filePattern = fullfile(myFolder, '*.mat');
matFiles = dir(filePattern);

for k = 1:length(matFiles)
    baseFileName = matFiles(k).name;
    fullFileName = fullfile(myFolder, baseFileName);
    matData(k) = load(fullFileName);
end

[~, titles] = xlsread('Excel/mcginnisdissertation8.2.16.UPDATED.VALUES.xlsx');
%% Assign Speech code indices you wish to display and create table
PdxIndices = [29, 41, 42, 46, 48, 70, 71, 73, 77, 86, 87, 94:102, 103:118, 119, 126, 225];
w = 1;
PdxName{1} = 'PID';
for y=2:length(PdxIndices) + 1
    PdxName{y} = titles{1,PdxIndices(w)};
    w = w + 1;
end

for i=1:length(PdxIndices)
    for x=1:length(matData)
        PID(x) = str2num(matData(x).audioName);
        patientDx(x,i) = matData(x).patientDx(PdxIndices(i));
    end
end
PdxArray = [PID',patientDx];
T = array2table(PdxArray,'VariableNames',PdxName);
