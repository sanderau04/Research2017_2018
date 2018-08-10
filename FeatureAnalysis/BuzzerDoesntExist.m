clear all, clc, close all
%% Reading in mat files from folder 1
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
%% Checking For Discrepancies between two folders
for i=1:length(matData1)
    PID1(i) = str2num(matData1(i).audioName);
    EpochLabels1{i,1} = PID1(i);
    EpochLabels1{i,2}= matData1(i).EpochLabel;
    
end

Bcount(:,1) = PID1;

for x=1:length(EpochLabels1)
    LabelArray1 = EpochLabels1{x,2};
    Buzzercount = 0;
    for i=1:length(LabelArray1)
        if LabelArray1{i} == 'B'
            Buzzercount = Buzzercount + 1;
        end
    end
    Bcount(x,2) = Buzzercount;
    clear LabelArray1
end

T = array2table(Bcount, 'VariableNames', {'PID','BuzzerCount'});


