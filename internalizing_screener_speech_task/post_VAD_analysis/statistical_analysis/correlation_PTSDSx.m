%% PTSDSxCorr.m performs initial spearman correlations with 
% PDx PTSDSx and summary features ONLY. 

%% Required patient mat file variables: 
% analysisTableSummary, patientDx, analysisTableSpeechDetails

%% Reading in all mat files
clear all, clc
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
%% Assign features from each mat file to matrix summaryFeatures

for i = 1:length(matData)
    PTSDSx(i) = matData(i).patientDx(126);
    feat = extractfield(matData(i),'analysisTableSummary');
    avgSPDomFreq(i) = mean(matData(i).analysisTableSpeechDetails.Speech_Epoch_Max_Frequency);
    stdSPDomFreq(i) = std(matData(i).analysisTableSpeechDetails.Speech_Epoch_Max_Frequency);
    avgSPMeanFreq(i) = mean(matData(i).analysisTableSpeechDetails.Speech_Epoch_Mean_Frequency);
    stdSPMeanFreq(i) = std(matData(i).analysisTableSpeechDetails.Speech_Epoch_Mean_Frequency);
    summaryFeatures(i,1) = feat{1,1}.Initial_Speech_Lag;
    summaryFeatures(i,2) = feat{1,1}.Final_Speech_Lag;
    summaryFeatures(i,3) = feat{1,1}.Average_SP_Length;
    summaryFeatures(i,4) = feat{1,1}.Standard_Deviation_of_SP_Length;
    summaryFeatures(i,5) = feat{1,1}.SP_Total_Occurance;
    summaryFeatures(i,6) = feat{1,1}.Average_Speech_Epoch_Length;
    summaryFeatures(i,7) = feat{1,1}.Standard_Deviation_of_Speech_Epoch_Length;
    summaryFeatures(i,8) = feat{1,1}.Speech_Epoch_Total_Occurance;
    summaryFeatures(i,9) = feat{1,1}.Percent_Pause_Present;
    summaryFeatures(i,10) = feat{1,1}.Percent_Speech_Present;
    summaryFeatures(i,11) = feat{1,1}.Percent_Freq_Below_500Hz;
    summaryFeatures(i,12) = feat{1,1}.Percent_Above_500Hz;
    summaryFeatures(i,13) = feat{1,1}.Standard_Deviation_Max_Frequency;
    summaryFeatures(i,14) = feat{1,1}.Standard_Deviation_Mean_Frequency;
end
%% Run spearman correlations on features and PTSDSx

[rho(1), pval(1)] = corr(avgSPDomFreq',PTSDSx', 'type', 'spearman');
[rho(2), pval(2)] = corr(avgSPMeanFreq', PTSDSx', 'type', 'spearman');

x = 3;
for w=1:14
   [rho(x), pval(x)] = corr(summaryFeatures(:,w),PTSDSx','type','spearman');
   x = x + 1;
end

RowNames = {'Avg_Dominant_Freq', 'Avg_Mean_Freq', 'Initial_Speech_Lag', 'Final_Speech_Lag', 'Average_SP_Length', ...
    'Standard_Deviation_of_SP_Length', 'SP_Total_Occurance', 'Average_Speech_Epoch_Length', 'Std_of_Speech_Epoch_Length', 'Speech_Epoch_Total_Occurance',...
    'Percent_Pause_Present', 'Percent_Speech_Present', 'Percent_Freq_Below_500Hz', 'Percent_Above_500Hz', 'Standard_Deviation_Max_Frequency',...
    'Standard_Deviation_Mean_Frequency'};
Variables = {'rho', 'pValue'}

PTSDSxCorrTable = table(rho',pval','VariableNames', Variables, 'RowNames', RowNames);

