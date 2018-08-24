%% check_for_label_discrepancies.m reads in two different labeled patient 
% mat file pools and finds discrepencies between the two different epoch 
% labelings from a patient mat file.

%% Required patient mat file variables: 
% audioName, EpochLabel

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
%% Reading in mat files from folder 2
myFolder2 = uigetdir('D:\Documents\Research2017\MATLAB','FOLDER 2: containing mat files');

if ~isdir(myFolder2)
    errorMessage = sprintf('Error: The following folder does not exist:\n%s', myFolder2);
    uiwait(warndlg(errorMessage));
    return;
end

filePattern2 = fullfile(myFolder2, '*.mat');
matFiles2 = dir(filePattern2);

for x = 1:length(matFiles2)
    baseFileName2 = matFiles2(x).name;
    fullFileName2 = fullfile(myFolder2, baseFileName2);
    matData2(x) = load(fullFileName2);
end
%% Checking For Discrepancies between two folders

% Extract epoch labels and respective PIDs from Folder 1
for i=1:length(matData1)
    PID1(i) = str2num(matData1(i).audioName);
    EpochLabels1{i,1} = PID1(i);
    EpochLabels1{i,2}= matData1(i).EpochLabel;
    
end

% Extract epoch labels and respective PIDs from Folder 2
for i=1:length(matData2)
   PID2(i) = str2num(matData2(i).audioName);
   EpochLabels2{i,1} = PID2(i);
   EpochLabels2{i,2} = matData2(i).EpochLabel;
end

% Determine all intersecting PIDs between Folder 1 and 2
[intersectPID,ind1,ind2] = intersect(PID1, PID2);
intersections = [intersectPID;ind1';ind2'];
diffGianna = setdiff(PID1,PID2)';
diffKatAdv = setdiff(PID2,PID1)';

% Extract epoch labels from PIDs with intersections
for i=1:length(intersectPID)
    LabelMismatchIndices{i,1} = intersectPID(i);
end

Discrepancy(:,1) = intersectPID;
for q=1:length(intersectPID)
    DiscrepancyDetails{q,1} = intersectPID(q);
end

%% Determine discrepancies and display Epoch label arrays with discrepancies
% Output to two separate tables
for x=1:length(ind1)
    % Extract one PID's epoch label array from both folders
    LabelArray1 = EpochLabels1{ind1(x),2};
    LabelArray2 = EpochLabels2{ind2(x),2};
    error= 0;
    % Condition 1: If epoch label arrays of same PID are not the same size
    % print out the problem PID 
    if length(LabelArray1) ~= length(LabelArray2)
        notSameSize = ['PID: ' num2str(intersectPID(x)), ' NOT SAME SIZE'];
        Details = 0;
        error = 999;
        LabelMismatchIndices{x,2} = 999;
        disp(notSameSize)
    else
        j=1;
        % Iterate through each epoch label within the two label arrays
        for i=1:length(LabelArray1)
            % Assign variables for indices and values in which the two
            % label arrays do not equal eachother
            if LabelArray1{i} ~= LabelArray2{i}
                LabelMismatchIndices{x,j + 1} = i;
                Gianna(x,j) = LabelArray1{i};
                KatAdv(x,j) = LabelArray2{i};
                error = error + 1;
                j = j + 1;
            else
                Details = 0;
            end
        end
    end
    Discrepancy(x,2) = i;
    Discrepancy(x,3) = error;
    clear LabelArray1 LabelArray2 error
end
%% Create tables displaying epoch labels with discrepancies
TGianna = table(intersectPID',Gianna);
TKatAdv = table(intersectPID',KatAdv);
Variables = {'PID', 'Epoch_Label_ArraySize', 'Number_Of_Discrepancies'};

T = array2table(Discrepancy,'VariableNames',Variables);
