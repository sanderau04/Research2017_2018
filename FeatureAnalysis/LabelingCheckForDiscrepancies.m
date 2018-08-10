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
for i=1:length(matData1)
    PID1(i) = str2num(matData1(i).audioName);
    EpochLabels1{i,1} = PID1(i);
    EpochLabels1{i,2}= matData1(i).EpochLabel;
    
end

for i=1:length(matData2)
   PID2(i) = str2num(matData2(i).audioName);
   EpochLabels2{i,1} = PID2(i);
   EpochLabels2{i,2} = matData2(i).EpochLabel;
end

[intersectPID,ind1,ind2] = intersect(PID1, PID2);
intersections = [intersectPID;ind1';ind2'];
diffGianna = setdiff(PID1,PID2)';
diffKatAdv = setdiff(PID2,PID1)';

for i=1:length(intersectPID)
    LabelMismatchIndices{i,1} = intersectPID(i);
end

Discrepancy(:,1) = intersectPID;
for q=1:length(intersectPID)
    DiscrepancyDetails{q,1} = intersectPID(q);
end

for x=1:length(ind1)
    LabelArray1 = EpochLabels1{ind1(x),2};
    LabelArray2 = EpochLabels2{ind2(x),2};
    error= 0;
    if length(LabelArray1) ~= length(LabelArray2)
        notSameSize = ['PID: ' num2str(intersectPID(x)), ' NOT SAME SIZE'];
        Details = 0;
        error = 999;
        LabelMismatchIndices{x,2} = 999;
        disp(notSameSize)
    else
        j=1;
        for i=1:length(LabelArray1)
            if LabelArray1{i} ~= LabelArray2{i}
                %display = [num2str(intersectPID(x)),': ', num2str(i)];
                %disp(display)
                LabelMismatchIndices{x,j + 1} = i;
                Gianna(x,j) = LabelArray1{i};
                KatAdv(x,j) = LabelArray2{i};
                %Details{i,1} = LabelArray1{i};
                %Details{i,2} = LabelArray2{i};
                error = error + 1;
                j = j + 1;
            else
                Details = 0;
            end
        end
    end
    %DiscrepancyDetails{x,2} = Details;
    %LabelMismatchIndices{x,2} = indices{x,:};
    Discrepancy(x,2) = i;
    Discrepancy(x,3) = error;
    clear LabelArray1 LabelArray2 error
end

TGianna = table(intersectPID',Gianna);
TKatAdv = table(intersectPID',KatAdv);
Variables = {'PID', 'Epoch_Label_ArraySize', 'Number_Of_Discrepancies'};

T = array2table(Discrepancy,'VariableNames',Variables);
