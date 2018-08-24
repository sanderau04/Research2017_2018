%% ExportAudioClipsNoPEpochPartitionDebug.m exports all speech task partition 
% clips that do not have existing 'Patient' label epochs. Script was used
% in the debugging process to determine if no 'Patient' speech epochs within
% a partition was due to quality issues or patient not executing task.

%% Required patient mat file variables: 
% analysisTableSummaryPartition1, analysisTableSummaryPartition2,
% analysisTableSummaryPartition3, analysisTableSpeechDetailsPartition1, 
% analysisTableSpeechDetailsPartition2,
% analysisTableSpeechDetailsPartition3, analysisTablePauseDetailsPartition1,
% analysisTablePauseDetailsPartition2, analysisTablePauseDetailsPartition3,
% energyMatrixP1, energyMatrixP2, energyMatrixP3, audioWExt, audioName, Fs

clc, clear all, close all
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

summaryTableNames = {'analysisTableSummaryPartition1', 'analysisTableSummaryPartition2', 'analysisTableSummaryPartition3'};
speechDetailTableNames = {'analysisTableSpeechDetailsPartition1','analysisTableSpeechDetailsPartition2', 'analysisTableSpeechDetailsPartition3'};
pauseDetailTableNames = {'analysisTablePauseDetailsPartition1', 'analysisTablePauseDetailsPartition2', 'analysisTablePauseDetailsPartition3'};

%% Extracting applicable partition audio clips
for p=1:3
    x = 1;
    y = 1;
    z = 1;
    for i = 1:length(matFiles)
        % Initializing all variables needed for conditions
        audioName = matData(i).audioName;
        audioFile = [matFiles(i).folder,'\',matData(i).audioWExt];
        Fs = matData(i).Fs;
        energyMatrixP1 = matData(i).energyMatrixP1;
        energyMatrixP2 = matData(i).energyMatrixP2;
        energyMatrixP3 = matData(i).energyMatrixP3;
        summaryFeat = extractfield(matData(i),summaryTableNames{p});
        speechFeat = extractfield(matData(i),speechDetailTableNames{p});
        pauseFeat = extractfield(matData(i),pauseDetailTableNames{p});
        
        
        partitionOnlyCheck = 0;
        if energyMatrixP1 == 0
            partitionOnlyCheck = partitionOnlyCheck + 1;
        end
        if energyMatrixP2 == 0
            partitionOnlyCheck = partitionOnlyCheck + 1;
        end
        if energyMatrixP3 == 0
            partitionOnlyCheck = partitionOnlyCheck + 1;
        end
        
        % check the condition if the entire speech task (partitinOnlyCheck)
        % has no 'Patient'epochs. If so, reject said patient audio from 
        % further analysis. If specific partition has no 'Patient' epochs
        % extract audio and save it to current working directory with
        % appropriate filename.
        if (width(summaryFeat{1,1}) == 3) && (width(speechFeat{1,1}) == 3)...
                && (width(pauseFeat{1,1}) == 3) && (partitionOnlyCheck ~= 3)
            fullAudio = audioread(audioFile);
            fullAudio =  sum(fullAudio, 2) / size(fullAudio,2);
            if p == 1
                p1Audio = fullAudio(1:(100*Fs));
                audioTitle = ['p1_',matData(i).audioWExt];
                audiowrite(audioTitle,p1Audio,Fs);
                AudioList{x,p} = audioTitle;
                x = x + 1;
            end
            
            if p == 2
                p2Audio = fullAudio((100*Fs):(160*Fs));
                audioTitle = ['p2_',matData(i).audioWExt];
                audiowrite(audioTitle,p2Audio,Fs);
                AudioList{y,p} = audioTitle;
                y = y + 1;
            end
            
            if p == 3
                p3Audio = fullAudio((160*Fs):end);
                audioTitle = ['p3_',matData(i).audioWExt];
                audiowrite(audioTitle,p3Audio,Fs);
                AudioList{z,p} = audioTitle;
                z = z + 1;
            end
        end
        clearvars -except summaryTableNames pauseDetailTableNames speechDetailTableNames...
            p i matFiles matData x y z AudioList
    end
end