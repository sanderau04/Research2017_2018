clc, clear all, close all
%% Initial Option
startPrompt = 'Export Excel spreadsheet? [0] for NO, [1] for YES';
choice = input(startPrompt);

%% Reading in all mat files
myFolder = 'D:\Documents\Research2017\MATLAB\FeatureAnalysis\SpeechTaskResults'; % Define your working folder
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

%% Feature Analysis

% Extracting what we need
for i = 1:length(matFiles)
    pDx(i,:) = extractfield(matData(i),'patientDx');
	feat(i,:) = extractfield(matData(i),'analysisTableSummary');
    summaryFeatures(i,1) = feat{i,1}.Initial_Speech_Lag;
    summaryFeatures(i,2) = feat{i,1}.Final_Speech_Lag;
    summaryFeatures(i,3) = feat{i,1}.Average_SP_Length;
    summaryFeatures(i,4) = feat{i,1}.Standard_Deviation_of_SP_Length;
    summaryFeatures(i,5) = feat{i,1}.SP_Total_Occurance;
    summaryFeatures(i,6) = feat{i,1}.Average_Speech_Epoch_Length;
    summaryFeatures(i,7) = feat{i,1}.Standard_Deviation_of_Speech_Epoch_Length;
    summaryFeatures(i,8) = feat{i,1}.Speech_Epoch_Total_Occurance;
    summaryFeatures(i,9) = feat{i,1}.Percent_Pause_Present;
    summaryFeatures(i,10) = feat{i,1}.Percent_Speech_Present;
    summaryFeatures(i,11) = feat{i,1}.Percent_Freq_Below_500Hz;
    summaryFeatures(i,12) = feat{i,1}.Percent_Above_500Hz;
    summaryFeatures(i,13) = feat{i,1}.Standard_Deviation_Max_Frequency;
    summaryFeatures(i,14) = feat{i,1}.Standard_Deviation_Mean_Frequency;
    
    extrPDx(i,1) = pDx(i,1); %PID
    extrPDx(i,2) = pDx(i,29); %childage
    extrPDx(i,3) = pDx(i,41); %NSp2PB
    extrPDx(i,4) = pDx(i,42); %sp2fsumw
    extrPDx(i,5) = pDx(i,46); %internalTmerged
    extrPDx(i,6) = pDx(i,48); %PTSDSX
    extrPDx(i,7) = pDx(i,70); %ExternalTmerged
    extrPDx(i,8) = pDx(i,73); %INTdx
    extrPDx(i,9) = pDx(i,80); %ChildGender
    extrPDx(i,10) = pDx(i,126); %SP2FVsum
    extrPDx(i,11) = pDx(i,225); %NSp2pV
end

Features = [extrPDx summaryFeatures];
if choice == 1
    Variables = ["PID", "childage", "NSp2PB", "sp2fsumw", "internalTmerged", "PTSDSX", "ExternalTmerged", "INTdx", "ChildGender", "SP2FVsum", "NSp2pV", "Initial Speech Lag", "Final Speech Lag", "Average SP Length", "Standard Deviation of SP Length", "SP Total Occurance", "Average Speech Epoch Length", "Standard Deviation of Speech Epoch Length", "Speech Epoch Total Occurance", "Percent Pause Present", "Percent Speech Present", "Percent Freq Below 500Hz", "Percent Above 500Hz", "Standard Deviation Max Frequency", "Standard Deviation Mean Frequency"];
    XlFeatures = [Variables; Features];
    excelFile = ['exportedSpreadSheets/export_',datestr(now, 'dd-mmm-yyyy_HH_MM_SS_'),'.xlsx'];
    xlswrite(excelFile,XlFeatures)
end
    

