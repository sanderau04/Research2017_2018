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

%%
for p=1:3
    x = 1;
    y = 1;
    z = 1;
    for i = 1:length(matFiles)
        audioName = matData(i).audioName;
        audioFile = [matFiles(i).folder,'\',matData(i).audioWExt];
        Fs = matData(i).Fs;
        energyMatrixP1 = matData(i).energyMatrixP1;
        energyMatrixP2 = matData(i).energyMatrixP2;
        energyMatrixP3 = matData(i).energyMatrixP3;
        summaryFeat = extractfield(matData(i),summaryTableNames{p});
        speechFeat = extractfield(matData(i),speechDetailTableNames{p});
        pauseFeat = extractfield(matData(i),pauseDetailTableNames{p});
        noGoodCount = 0;
        if energyMatrixP1 == 0
            noGoodCount = noGoodCount + 1;
        end
        if energyMatrixP2 == 0
            noGoodCount = noGoodCount + 1;
        end
        if energyMatrixP3 == 0
            noGoodCount = noGoodCount + 1;
        end
        
        
        if (width(summaryFeat{1,1}) == 3) && (width(speechFeat{1,1}) == 3)...
                && (width(pauseFeat{1,1}) == 3) && (noGoodCount ~= 3)
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