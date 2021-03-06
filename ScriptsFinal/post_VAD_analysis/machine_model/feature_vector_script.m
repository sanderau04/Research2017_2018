function total_labels = feature_vector_script
% Load patient mat file for feat_labels input
load('MEDIATED_LABELED_Patient_12__18-Jun-2018_10_41_34_.mat', 'analysisTableSpeechDetailsPartition1')

qw = 1;
% Assign all initial feature variable names
for xi = 4:width(analysisTableSpeechDetailsPartition1)
    initialSpeechVarNames{qw} = ['init_', analysisTableSpeechDetailsPartition1.Properties.VariableNames{xi}];
    qw = qw + 1;
end

% Assign all MFCC feature variable names
MVariables = {'maxM1', 'maxM2', 'maxM3', 'maxM4', 'maxM5','maxM6',...
    'maxM7', 'maxM8', 'maxM9', 'maxM10', 'maxM11', 'maxM12', 'maxM13', 'maxM14'};
si = 1;
for wi = 1:length(MVariables)
    for g=1:3
        fullMVar{si} = ['avg', MVariables{wi}];
        fullMVar{si+1} = ['med',MVariables{wi}];
        fullMVar{si+2} = ['std',MVariables{wi}];
    end
    si = si + 3;
end

% Build feature label vector
feat_labels = [{'Avg_SPause_Length','STD_SPause_Length',...
    'SPause_Total_Count', 'Avg_Speech_Epoch_Length', 'Std_of_Speech_Epoch_Length',...
    'Percent_Pause_Present', 'Percent_Freq_Above_200Hz', 'Percent_Above_500Hz','Percent_Above_700Hz',...
    'Percent_Above_1000Hz','Percent_Above_2000Hz','Avg_Epoch_Dominant_Freq','Avg_Epoch_Mean_Freq',...
    'Max_Epoch_Dominant_Freq','Max_Epoch_Mean_Freq','Avg_Epoch_Mean_Spectral_Centroid',...
    'Avg_Epoch_Max_Spectral_Centroid','Avg_Epoch_Min_Spectral_Centroid' ...
    'Std_Max_Frequency','Std_Mean_Frequency','Std_SpectralCentroid',...
    'Dom_Freq_Slope', 'Mean_Freq_Slope', 'Mean_Spectral_Centroid_Slope',...
    'Max_Spectral_Centroid_Slope', 'Min_Spectral_Centroid_Slope','Mean_PSD_Skew',...
    'Std_PSD_Skew','Mean_PSD_Kurtosis','Std_PSD_Kurtosis','P_C_LabelCount_Ratio',...
    'P_to_O_LabelCount_Ratio','avgMeanZCWave','maxMeanZCWave','stdMeanZCWave',...
    'avgMaxZCWave', 'maxMaxZCWave','stdMaxZCWave','avgMinZCWave','stdMinZCWave',...
    'avgStdZCWave','stdStdZCWave','avgMeanZCPSD','maxMeanZCPSD','stdMeanZCPSD',...
    'avgMaxZCPSD','maxMaxZCPSD','stdMaxZCPSD','avgMinZCPSD','stdMinZCPSD',...
    'avgStdZCPSD','stdStdZCPSD','avgEnergySlope','stdEnergySlope','avgMeanF1',...
    'maxMeanF1','stdMeanF1','avgMeanF2','maxMeanF2','stdMeanF2',...
    'avgMeanF3','maxMeanF3','stdMeanF3',...
    'avgStdF1', 'sumStdF1', 'avgStdF2', 'sumStdF2', 'avgStdF3', 'sumStdF3',...
    'avgSlopeF1', 'sumSlopeF1', 'stdSlopeF1', 'avgSlopeF2', 'sumSlopeF2',...
    'stdSlopeF2', 'avgSlopeF3', 'sumSlopeF3', 'stdSlopeF3', 'SPause_Slope',...
    'SPause_YIntercept','avgAvgMeanZCPs','stdAvgMeanZCPs', 'maxAvgMeanZCPs',...
    'avgStdMeanZCPs','maxStdMeanZCPs','avgAvgMaxZCPs','maxAvgMaxZCPs',...
    'avgStdMaxZCPs','maxStdMaxZCPs','minStdMaxZCPs','avgAvgStdZCPs',...
    'maxAvgStdZCPs','minAvgStdZCPs','medAvgMeanZCPs','medAvgMaxZCPs',...
    'medAvgStdZCPs','medMedMedZCPs', 'avgMedMedZCPs','stdMedMedZCPs',...
    'medAvgMedZCPs', 'avgAvgMedZCPs','stdAvgMedZCPs','medStdMedZCPs',...
    'avgStdMedZCPs','stdStdMedZCPs','avgMedSPF', 'medMedSPF','stdMedSPF',...
    'avgMeanSPF','medMeanSPF','stdMeanSPF','avgStdSPF',...
    'medStdSPF','stdStdSPF', 'initAvgStdZCPs', 'initStdMeanZCPs',...
    'initAvgSpecCentroid', 'initMeanZCPSD', 'initPauseDuration',...
    'avgRmsEpoch', 'medRmsEpoch', 'stdRmsEpoch','avgRmsEnergy',...
    'medRmsEnergy', 'stdRmsEnergy'},fullMVar,...
    initialSpeechVarNames];

total_labels = cell(length(feat_labels)*6,1);
feat_types = {'p2'};
for i = 1:length(feat_types)
    for j = 1:length(feat_labels)
        total_labels{(i-1)*length(feat_labels)+j}=[feat_types{i},'_',feat_labels{j}];
    end
end
end
