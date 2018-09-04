%% wilcoxon_ranksum_childgender.m performs wilcoxon rank sum test on patient 
% gender. 

%% Required patient mat file variables:
% patientDx, analysisTableSpeechDetails, analysisTableSummary, audioName

%% Reading in all mat files
clear all, clc
x= 1;
y = 1;

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

%% Divide mat data based on patient gender

for i = 1:length(matFiles)
    pDx = extractfield(matData(i),'patientDx');
    
    switch pDx(80)
        case 1
            matData0(x) = matData(i);
            x = x + 1;
        case 2
            matData1(y) = matData(i);
            y = y + 1;
    end
end

%% Extract features for both mat data gender categories

for i = 1:length(matData0)
    feat = extractfield(matData0(i),'analysisTableSummary');
    audioName1(i,1) = str2num(matData0(i).audioName);
    avgSPDomFreq(i) = mean(matData0(i).analysisTableSpeechDetails.Speech_Epoch_Max_Frequency);
    stdSPDomFreq(i) = std(matData0(i).analysisTableSpeechDetails.Speech_Epoch_Max_Frequency);
    avgSPMeanFreq(i) = mean(matData0(i).analysisTableSpeechDetails.Speech_Epoch_Mean_Frequency);
    stdSPMeanFreq(i) = std(matData0(i).analysisTableSpeechDetails.Speech_Epoch_Mean_Frequency);
    childage1(i) = matData0(i).patientDx(29);
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


for x=1:length(matData1)
    feat1 = extractfield(matData1(x),'analysisTableSummary');
    audioName2(x,1) = str2num(matData1(x).audioName);
    avgSPDomFreq1(x) = mean(matData1(x).analysisTableSpeechDetails.Speech_Epoch_Max_Frequency);
    stdSPDomFreq1(x) = std(matData1(x).analysisTableSpeechDetails.Speech_Epoch_Max_Frequency);
    avgSPMeanFreq1(x) = mean(matData1(x).analysisTableSpeechDetails.Speech_Epoch_Mean_Frequency);
    stdSPMeanFreq1(x) = std(matData1(x).analysisTableSpeechDetails.Speech_Epoch_Mean_Frequency);
    childage2(x) = matData1(x).patientDx(29);
    summaryFeatures1(x,1) = feat1{1,1}.Initial_Speech_Lag;
    summaryFeatures1(x,2) = feat1{1,1}.Final_Speech_Lag;
    summaryFeatures1(x,3) = feat1{1,1}.Average_SP_Length;
    summaryFeatures1(x,4) = feat1{1,1}.Standard_Deviation_of_SP_Length;
    summaryFeatures1(x,5) = feat1{1,1}.SP_Total_Occurance;
    summaryFeatures1(x,6) = feat1{1,1}.Average_Speech_Epoch_Length;
    summaryFeatures1(x,7) = feat1{1,1}.Standard_Deviation_of_Speech_Epoch_Length;
    summaryFeatures1(x,8) = feat1{1,1}.Speech_Epoch_Total_Occurance;
    summaryFeatures1(x,9) = feat1{1,1}.Percent_Pause_Present;
    summaryFeatures1(x,10) = feat1{1,1}.Percent_Speech_Present;
    summaryFeatures1(x,11) = feat1{1,1}.Percent_Freq_Below_500Hz;
    summaryFeatures1(x,12) = feat1{1,1}.Percent_Above_500Hz;
    summaryFeatures1(x,13) = feat1{1,1}.Standard_Deviation_Max_Frequency;
    summaryFeatures1(x,14) = feat1{1,1}.Standard_Deviation_Mean_Frequency;
end
%% perform wilcoxon rank sum on the two mat data categories
[p(1), h(1)] = ranksum(avgSPDomFreq, avgSPDomFreq1);
[p(2), h(2)] = ranksum(avgSPMeanFreq, avgSPMeanFreq1);
[p(3), h(3)] = ranksum(stdSPDomFreq, stdSPDomFreq1);
[p(4), h(4)] = ranksum(stdSPMeanFreq, stdSPMeanFreq1);

w = 5;
for q=1:14
    [p(w), h(w)] = ranksum(summaryFeatures(:,q),summaryFeatures1(:,q));
    w = w +1;
end

%% Create table of output
RowNames = {'Avg_Dominant_Freq', 'Avg_Mean_Freq', 'Std_Dominant_Freq', 'Std_Mean_Freq', 'Initial_Speech_Lag', 'Final_Speech_Lag', 'Average_SP_Length', ...
    'Standard_Deviation_of_SP_Length', 'SP_Total_Occurance', 'Average_Speech_Epoch_Length', 'Std_of_Speech_Epoch_Length', 'Speech_Epoch_Total_Occurance',...
    'Percent_Pause_Present', 'Percent_Speech_Present', 'Percent_Freq_Below_500Hz', 'Percent_Above_500Hz', 'Standard_Deviation_Max_Frequency',...
    'Standard_Deviation_Mean_Frequency'};
Variables = {'P_Value', 'h_1_Null_Hypothesis_Rejected'}

intDxRankSumTable = table(p',h','VariableNames', Variables, 'RowNames', RowNames);




