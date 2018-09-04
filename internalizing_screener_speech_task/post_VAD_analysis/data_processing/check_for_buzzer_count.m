%% check_for_buzzer_count.m reads all patient mat file epoch labels and 
% counts how many Buzzer labels exist in each file. Script was used in the
% debugging process of preparing files for tri-partition. 

%% Required patient mat file variables:
% audioName, EpochLabel

clear all, clc, close all
%% Reading in mat files from folder 
myFolder1 = uigetdir('D:\Documents\Research2017\MATLAB','get them mat files');

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
%% Reading all epoch labels for each patent file in myFolder1 
% Count how many Buzzer labels exist in each, and display in table Bcount
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