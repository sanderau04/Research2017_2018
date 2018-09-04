%% correlation_script_tri_partition.m produces all PDx vs feature spearman
% correlations  with tri-partitioned patient mat files. 

%% Required patient mat file variables:
% analysisTableSummaryPartition1, analysisTableSummaryPartition2,
% analysisTableSummaryPartition3, analysisTableSpeechDetailsPartition1, 
% analysisTableSpeechDetailsPartition2,
% analysisTableSpeechDetailsPartition3, analysisTablePauseDetailsPartition1,
% analysisTablePauseDetailsPartition2, analysisTablePauseDetailsPartition3,
% audioName, Fs, patientDx


clear all, clc
[~, titles] = xlsread('Excel/mcginnisdissertation8.2.16.UPDATED.VALUES.xlsx');
%% Assign Speech code indices you wish to correlate
PdxIndices = [29, 41, 42, 46, 48, 70, 71, 73, 77, 86, 87, 94:102, 103:118, 119, 126, 225];
for y=1:length(PdxIndices)
    PdxName{y} = titles{1,PdxIndices(y)};
end

% Assign character arrays pertaining to each feature table
summaryTableNames = {'analysisTableSummaryPartition1', 'analysisTableSummaryPartition2', 'analysisTableSummaryPartition3'};
speechDetailTableNames = {'analysisTableSpeechDetailsPartition1','analysisTableSpeechDetailsPartition2', 'analysisTableSpeechDetailsPartition3'};
pauseDetailTableNames = {'analysisTablePauseDetailsPartition1', 'analysisTablePauseDetailsPartition2', 'analysisTablePauseDetailsPartition3'};

myFolder = uigetdir('D:\Documents\Research2017\MATLAB','Pick a folder containing mat files');

% Choose folder containing mat files to correlate
if ~isdir(myFolder)
    errorMessage = sprintf('Error: The following folder does not exist:\n%s', myFolder);
    uiwait(warndlg(errorMessage));
    return;
end

filePattern = fullfile(myFolder, '*.mat');
matFiles = dir(filePattern);

%% Extract features and perform all spearman correlations for each partition

% Iterate through each partition
for p=1:3
    %%
    xi = 1;
    
    % Iterate through each diangosis to correlate with
    for j =1:length(PdxIndices)
        q = 1;
        
        % Extract mat files from folder that are applicable for specific 
        % diagnoisis correlation
        for k = 1:length(matFiles)
            baseFileName = matFiles(k).name;
            fullFileName = fullfile(myFolder, baseFileName);
            tempMatData(k) = load(fullFileName);
            % Condition 1: Patient Dx to be correlated must exist and not 
            % be equal to 999
            if ((isnan(tempMatData(k).patientDx(PdxIndices(j))) == 0) && (tempMatData(k).patientDx(PdxIndices(j))~= 999))
                matData(q) = tempMatData(k);
                q = q + 1;
            end
            clear tempMatData
        end
        
        u = 1;
        s = 1;
        % Extract all features from each applicable patient and assign them
        % to matrix SummaryFeatures
        for i = 1:length(matData)
            summaryFeat = extractfield(matData(i),summaryTableNames{p});
            speechFeat = extractfield(matData(i),speechDetailTableNames{p});
            pauseFeat = extractfield(matData(i),pauseDetailTableNames{p});
            
            % Condition: 'Patient' epochs must exist within a partition
            if (width(summaryFeat{1,1}) > 3) && (width(speechFeat{1,1}) > 3) && (width(pauseFeat{1,1}) > 3)
                currentPdx(u) = matData(i).patientDx(PdxIndices(j));
                
                % Commented code in this script may be un-commented for
                % partial correlations with specified patient Dx below
                %{
                childagePdx(u) = matData(i).patientDx(29);
                AnxDepTmergedPdx(u) = matData(i).patientDx(94);
                perPdx(u) = matData(i).patientDx(117);
                attentionprobsTmergedPdx(u) = matData(i).patientDx(97);
                sp2fbsumw(u) = matData(i).patientDx(42);
                %}
                
                % Extracting all features for correlations (Lines 87 - 478)
                audioName{u,j} = str2num(matData(i).audioName);
                avgSPDomFreq = mean(speechFeat{1,1}.Speech_Epoch_Max_Frequency);
                avgSPMeanFreq = mean(speechFeat{1,1}.Speech_Epoch_Mean_Frequency);
                maxSPDomFreq = max(speechFeat{1,1}.Speech_Epoch_Max_Frequency);
                maxSPMeanFreq = max(speechFeat{1,1}.Speech_Epoch_Mean_Frequency);
                meanSkew = mean(speechFeat{1,1}.PSD_Skew);
                stdSkew = std(speechFeat{1,1}.PSD_Skew);
                meanKurt = mean(speechFeat{1,1}.PSD_Kurtosis);
                stdKurt = std(speechFeat{1,1}.PSD_Kurtosis);
                
                avgMeanZCWave = mean(speechFeat{1,1}.Mean_ZC_Waveform);
                maxMeanZCWave = max(speechFeat{1,1}.Mean_ZC_Waveform);
                stdMeanZCWave = std(speechFeat{1,1}.Mean_ZC_Waveform);
                
                avgMaxZCWave = mean(speechFeat{1,1}.Max_ZC_Waveform);
                maxMaxZCWave = max(speechFeat{1,1}.Max_ZC_Waveform);
                stdMaxZCWave = std(speechFeat{1,1}.Max_ZC_Waveform);
                
                avgMinZCWave = mean(speechFeat{1,1}.Min_ZC_Waveform);
                stdMinZCWave = std(speechFeat{1,1}.Min_ZC_Waveform);
                
                avgStdZCWave = mean(speechFeat{1,1}.Std_ZC_Waveform);
                stdStdZCWave = std(speechFeat{1,1}.Std_ZC_Waveform);
                
                avgMeanZCPSD = mean(speechFeat{1,1}.Mean_ZC_normPSD);
                maxMeanZCPSD = max(speechFeat{1,1}.Mean_ZC_normPSD);
                stdMeanZCPSD = std(speechFeat{1,1}.Mean_ZC_normPSD);
                
                avgMaxZCPSD = mean(speechFeat{1,1}.Max_ZC_normPSD);
                maxMaxZCPSD = max(speechFeat{1,1}.Max_ZC_normPSD);
                stdMaxZCPSD = std(speechFeat{1,1}.Max_ZC_normPSD);
                
                avgMinZCPSD = mean(speechFeat{1,1}.Min_ZC_normPSD);
                stdMinZCPSD = std(speechFeat{1,1}.Min_ZC_normPSD);
                
                avgStdZCPSD = mean(speechFeat{1,1}.Std_ZC_normPSD);
                stdStdZCPSD = std(speechFeat{1,1}.Std_ZC_normPSD);
                
                avgEnergySlope = mean(speechFeat{1,1}.Energy_Over_Time_Slope);
                stdEnergySlope = std(speechFeat{1,1}.Energy_Over_Time_Slope);
                
                avgMeanF1 = mean(speechFeat{1,1}.avg_F1);
                maxMeanF1 = max(speechFeat{1,1}.avg_F1);
                stdMeanF1 = std(speechFeat{1,1}.avg_F1);
                
                avgMeanF2 = mean(speechFeat{1,1}.avg_F2);
                maxMeanF2 = max(speechFeat{1,1}.avg_F2);
                stdMeanF2 = std(speechFeat{1,1}.avg_F2);
                
                avgMeanF3 = mean(speechFeat{1,1}.avg_F3);
                maxMeanF3 = max(speechFeat{1,1}.avg_F3);
                stdMeanF3 = std(speechFeat{1,1}.avg_F3);
                
                avgStdF1 = mean(speechFeat{1,1}.std_F1);
                sumStdF1 = sum(speechFeat{1,1}.std_F1);
                
                avgStdF2 = mean(speechFeat{1,1}.std_F2);
                sumStdF2 = sum(speechFeat{1,1}.std_F2);
                
                avgStdF3 = mean(speechFeat{1,1}.std_F3);
                sumStdF3 = sum(speechFeat{1,1}.std_F3);
                
                avgSlopeF1 = mean(speechFeat{1,1}.slope_F1);
                sumSlopeF1 = sum(speechFeat{1,1}.slope_F1);
                stdSlopeF1 = std(speechFeat{1,1}.slope_F1);
                
                avgSlopeF2 = mean(speechFeat{1,1}.slope_F2);
                sumSlopeF2 = sum(speechFeat{1,1}.slope_F2);
                stdSlopeF2 = std(speechFeat{1,1}.slope_F2);
                
                avgSlopeF3 = mean(speechFeat{1,1}.slope_F3);
                sumSlopeF3 = sum(speechFeat{1,1}.slope_F3);
                stdSlopeF3 = std(speechFeat{1,1}.slope_F3);
                
                polyPause = polyfit(pauseFeat{1,1}.SP_Start_Time, pauseFeat{1,1}.SP_Duration,1);
                SPauseSlope = polyPause(1);
                SPauseYintercept = polyPause(2);
                
                avgAvgMeanZCPs =  mean(speechFeat{1,1}.avgMeanZCPs);
                stdAvgMeanZCPs = std(speechFeat{1,1}.avgMeanZCPs);
                maxAvgMeanZCPs = max(speechFeat{1,1}.avgMeanZCPs);
                
                avgStdMeanZCPs = mean(speechFeat{1,1}.stdMeanZCPs);
                maxStdMeanZCPs = max(speechFeat{1,1}.stdMeanZCPs);
                
                avgAvgMaxZCPs = mean(speechFeat{1,1}.avgMaxZCPs);
                maxAvgMaxZCPs = max(speechFeat{1,1}.avgMaxZCPs);
                
                avgStdMaxZCPs = mean(speechFeat{1,1}.stdMaxZCPs);
                maxStdMaxZCPs = max(speechFeat{1,1}.stdMaxZCPs);
                minStdMaxZCPs = min(speechFeat{1,1}.stdMaxZCPs);
                
                avgAvgStdZCPs = mean(speechFeat{1,1}.avgStdZCPs);
                maxAvgStdZCPs = max(speechFeat{1,1}.avgStdZCPs);
                minAvgStdZCPs = min(speechFeat{1,1}.avgStdZCPs);
                
                medAvgMeanZCPs = median(speechFeat{1,1}.avgMeanZCPs);
                medAvgMaxZCPs = median(speechFeat{1,1}.avgMaxZCPs);
                medAvgStdZCPs = median(speechFeat{1,1}.avgStdZCPs);
                
                medMedMedZCPs = median(speechFeat{1,1}.medMedZCPs);
                avgMedMedZCPs = mean(speechFeat{1,1}.medMedZCPs);
                stdMedMedZCPs = std(speechFeat{1,1}.medMedZCPs);
                
                medAvgMedZCPs = median(speechFeat{1,1}.avgMedZCPs);
                avgAvgMedZCPs = mean(speechFeat{1,1}.avgMedZCPs);
                stdAvgMedZCPs = std(speechFeat{1,1}.avgMedZCPs);
                
                medStdMedZCPs = median(speechFeat{1,1}.stdMedZCPs);
                avgStdMedZCPs = mean(speechFeat{1,1}.stdMedZCPs);
                stdStdMedZCPs = std(speechFeat{1,1}.stdMedZCPs);
                
                avgMedSPF = mean(speechFeat{1,1}.medSPF);
                medMedSPF = median(speechFeat{1,1}.medSPF);
                stdMedSPF = std(speechFeat{1,1}.medSPF);
                
                avgMeanSPF = mean(speechFeat{1,1}.avgSPF);
                medMeanSPF = median(speechFeat{1,1}.avgSPF);
                stdMeanSPF = std(speechFeat{1,1}.avgSPF);
                
                avgStdSPF = mean(speechFeat{1,1}.stdSPF);
                medStdSPF = median(speechFeat{1,1}.stdSPF);
                stdStdSPF = std(speechFeat{1,1}.stdSPF);
                
                initAvgStdZCPs = speechFeat{1,1}.avgStdZCPs(1);
                initStdMeanZCPs = speechFeat{1,1}.stdMeanZCPs(1);
                initAvgSpecCentroid = speechFeat{1,1}.Mean_Perceptual_Spectral_Centroid(1);
                initMeanZCPSD = speechFeat{1,1}.Mean_ZC_normPSD(1);
                
                avgRmsEpoch = mean(speechFeat{1,1}.rmsEpoch);
                medRmsEpoch = median(speechFeat{1,1}.rmsEpoch);
                stdRmsEpoch = std(speechFeat{1,1}.rmsEpoch);
                
                
                avgRmsEnergy = mean(speechFeat{1,1}.rmsEnergy);
                medRmsEnergy = median(speechFeat{1,1}.rmsEnergy);
                stdRmsEnergy = std(speechFeat{1,1}.rmsEnergy);
                
                avgMaxM1 = mean(speechFeat{1,1}.maxM1);
                medMaxM1 = median(speechFeat{1,1}.maxM1);
                stdMaxM1 = std(speechFeat{1,1}.maxM1);
                
                avgMaxM2 = mean(speechFeat{1,1}.maxM2);
                medMaxM2 = median(speechFeat{1,1}.maxM2);
                stdMaxM2 = std(speechFeat{1,1}.maxM2);
                
                avgMaxM3 = mean(speechFeat{1,1}.maxM3);
                medMaxM3 = median(speechFeat{1,1}.maxM3);
                stdMaxM3 = std(speechFeat{1,1}.maxM3);
                
                avgMaxM4 = mean(speechFeat{1,1}.maxM4);
                medMaxM4 = median(speechFeat{1,1}.maxM4);
                stdMaxM4 = std(speechFeat{1,1}.maxM4);
                
                avgMaxM5 = mean(speechFeat{1,1}.maxM5);
                medMaxM5 = median(speechFeat{1,1}.maxM5);
                stdMaxM5 = std(speechFeat{1,1}.maxM5);
                
                avgMaxM6 = mean(speechFeat{1,1}.maxM6);
                medMaxM6 = median(speechFeat{1,1}.maxM6);
                stdMaxM6 = std(speechFeat{1,1}.maxM6);
                
                avgMaxM7 = mean(speechFeat{1,1}.maxM7);
                medMaxM7 = median(speechFeat{1,1}.maxM7);
                stdMaxM7 = std(speechFeat{1,1}.maxM7);
                
                avgMaxM8 = mean(speechFeat{1,1}.maxM8);
                medMaxM8 = median(speechFeat{1,1}.maxM8);
                stdMaxM8 = std(speechFeat{1,1}.maxM8);
                
                avgMaxM9 = mean(speechFeat{1,1}.maxM9);
                medMaxM9 = median(speechFeat{1,1}.maxM9);
                stdMaxM9 = std(speechFeat{1,1}.maxM9);
                
                avgMaxM10 = mean(speechFeat{1,1}.maxM10);
                medMaxM10 = median(speechFeat{1,1}.maxM10);
                stdMaxM10 = std(speechFeat{1,1}.maxM10);
                
                avgMaxM11 = mean(speechFeat{1,1}.maxM11);
                medMaxM11 = median(speechFeat{1,1}.maxM11);
                stdMaxM11 = std(speechFeat{1,1}.maxM11);
                
                avgMaxM12 = mean(speechFeat{1,1}.maxM12);
                medMaxM12 = median(speechFeat{1,1}.maxM12);
                stdMaxM12 = std(speechFeat{1,1}.maxM12);
                
                avgMaxM13 = mean(speechFeat{1,1}.maxM13);
                medMaxM13 = median(speechFeat{1,1}.maxM13);
                stdMaxM13 = std(speechFeat{1,1}.maxM13);
                
                avgMaxM14 = mean(speechFeat{1,1}.maxM14);
                medMaxM14 = median(speechFeat{1,1}.maxM14);
                stdMaxM14 = std(speechFeat{1,1}.maxM14);
                
                if height(pauseFeat{1,1}) ~= 0
                    initPauseDuration = pauseFeat{1,1}.SP_Duration(1);
                else
                    initPauseDuration = NaN;
                end
                
                speechFeatArray = table2array(speechFeat{1,1});
                qw = 1;
                for xi = 4:width(speechFeat{1,1}) 
                   initialSpeechVars(qw) = speechFeatArray(1,xi);
                   initialSpeechVarNames{qw} = ['init_', speechFeat{1,1}.Properties.VariableNames{xi}];
                   qw = qw + 1;
                end
                
                finalInd = 167 + length(initialSpeechVars);
                
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
                
                summaryFeatures(u,1) = summaryFeat{1,1}.Average_SP_Length;
                summaryFeatures(u,2) = summaryFeat{1,1}.Standard_Deviation_of_SP_Length;
                summaryFeatures(u,3) = summaryFeat{1,1}.SP_Total_Occurance;
                summaryFeatures(u,4) = summaryFeat{1,1}.Average_Speech_Epoch_Length;
                summaryFeatures(u,5) = summaryFeat{1,1}.Standard_Deviation_of_Speech_Epoch_Length;
                summaryFeatures(u,6) = summaryFeat{1,1}.Percent_Pause_Present;
                summaryFeatures(u,7) = summaryFeat{1,1}.Percent_Above_200Hz;
                summaryFeatures(u,8) = summaryFeat{1,1}.Percent_Above_500Hz;
                summaryFeatures(u,9) = summaryFeat{1,1}.Percent_Above_700Hz;
                summaryFeatures(u,10) = summaryFeat{1,1}.Percent_Above_1000Hz;
                summaryFeatures(u,11) = summaryFeat{1,1}.Percent_Above_2000Hz;
                summaryFeatures(u,12) = avgSPDomFreq;
                summaryFeatures(u,13) = avgSPMeanFreq;
                summaryFeatures(u,14) = maxSPDomFreq;
                summaryFeatures(u,15) = maxSPMeanFreq;
                summaryFeatures(u,16) = mean(speechFeat{1,1}.Mean_Perceptual_Spectral_Centroid);
                summaryFeatures(u,17) = mean(speechFeat{1,1}.Max_Perceptual_Spectral_Centroid);
                summaryFeatures(u,18) = mean(speechFeat{1,1}.Min_Perceptual_Spectral_Centroid);
                summaryFeatures(u,19) = summaryFeat{1,1}.Standard_Deviation_Max_Frequency;
                summaryFeatures(u,20) = summaryFeat{1,1}.Standard_Deviation_Mean_Frequency;
                summaryFeatures(u,21) = mean(speechFeat{1,1}.Std_Perceptual_Spectral_Centroid);
                summaryFeatures(u,22) = summaryFeat{1,1}.Dom_Freq_Slope;
                summaryFeatures(u,23) = summaryFeat{1,1}.Mean_Freq_Slope;
                summaryFeatures(u,24) = summaryFeat{1,1}.PC_Mean_Slope;
                summaryFeatures(u,25) = summaryFeat{1,1}.PC_Max_Slope;
                summaryFeatures(u,26) = summaryFeat{1,1}.PC_Min_Slope;
                summaryFeatures(u,27) = meanSkew;
                summaryFeatures(u,28) = stdSkew;
                summaryFeatures(u,29) = meanKurt;
                summaryFeatures(u,30) = stdKurt;
                summaryFeatures(u,31) = summaryFeat{1,1}.Patient_To_Clinician_CountRatio;
                summaryFeatures(u,32) = summaryFeat{1,1}.Patient_To_Other_CountRatio;
                summaryFeatures(u,33) = avgMeanZCWave;
                summaryFeatures(u,34) = maxMeanZCWave;
                summaryFeatures(u,35) = stdMeanZCWave;
                summaryFeatures(u,36) = avgMaxZCWave;
                summaryFeatures(u,37) = maxMaxZCWave;
                summaryFeatures(u,38) = stdMaxZCWave;
                summaryFeatures(u,39) = avgMinZCWave;
                summaryFeatures(u,40) = stdMinZCWave;
                summaryFeatures(u,41) = avgStdZCWave;
                summaryFeatures(u,42) = stdStdZCWave;
                summaryFeatures(u,43) = avgMeanZCPSD;
                summaryFeatures(u,44) = maxMeanZCPSD;
                summaryFeatures(u,45) = stdMeanZCPSD;
                summaryFeatures(u,46) = avgMaxZCPSD;
                summaryFeatures(u,47) = maxMaxZCPSD;
                summaryFeatures(u,48) = stdMaxZCPSD;
                summaryFeatures(u,49) = avgMinZCPSD;
                summaryFeatures(u,50) = stdMinZCPSD;
                summaryFeatures(u,51) = avgStdZCPSD;
                summaryFeatures(u,52) = stdStdZCPSD;
                summaryFeatures(u,53) = avgEnergySlope;
                summaryFeatures(u,54) = stdEnergySlope;
                summaryFeatures(u,55) = avgMeanF1;
                summaryFeatures(u,56) = maxMeanF1;
                summaryFeatures(u,57) = stdMeanF1;
                summaryFeatures(u,58) = avgMeanF2;
                summaryFeatures(u,59) = maxMeanF2;
                summaryFeatures(u,60) = stdMeanF2;
                summaryFeatures(u,61) = avgMeanF3;
                summaryFeatures(u,62) = maxMeanF3;
                summaryFeatures(u,63) = stdMeanF3;
                summaryFeatures(u,64) = avgStdF1;
                summaryFeatures(u,65) = sumStdF1;
                summaryFeatures(u,66) = avgStdF2;
                summaryFeatures(u,67) = sumStdF2;
                summaryFeatures(u,68) = avgStdF3;
                summaryFeatures(u,69) = sumStdF3;
                summaryFeatures(u,70) = avgSlopeF1;
                summaryFeatures(u,71) = sumSlopeF1;
                summaryFeatures(u,72) = stdSlopeF1;
                summaryFeatures(u,73) = avgSlopeF2;
                summaryFeatures(u,74) = sumSlopeF2;
                summaryFeatures(u,75) = stdSlopeF2;
                summaryFeatures(u,76) = avgSlopeF3;
                summaryFeatures(u,77) = sumSlopeF3;
                summaryFeatures(u,78) = stdSlopeF3;
                summaryFeatures(u,79) = SPauseSlope;
                summaryFeatures(u,80) = SPauseYintercept;
                summaryFeatures(u,81) = avgAvgMeanZCPs;
                summaryFeatures(u,82) = stdAvgMeanZCPs;
                summaryFeatures(u,83) = maxAvgMeanZCPs;
                summaryFeatures(u,84) = avgStdMeanZCPs;
                summaryFeatures(u,85) = maxStdMeanZCPs;
                summaryFeatures(u,86) = avgAvgMaxZCPs;
                summaryFeatures(u,87) = maxAvgMaxZCPs;
                summaryFeatures(u,88) = avgStdMaxZCPs;
                summaryFeatures(u,89) = maxStdMaxZCPs;
                summaryFeatures(u,90) = minStdMaxZCPs;
                summaryFeatures(u,91) = avgAvgStdZCPs;
                summaryFeatures(u,92) = maxAvgStdZCPs;
                summaryFeatures(u,93) = minAvgStdZCPs;
                summaryFeatures(u,94) = medAvgMeanZCPs;
                summaryFeatures(u,95) = medAvgMaxZCPs;
                summaryFeatures(u,96) = medAvgStdZCPs;
                summaryFeatures(u,97) = medMedMedZCPs;
                summaryFeatures(u,98) = avgMedMedZCPs;
                summaryFeatures(u,99) = stdMedMedZCPs;
                summaryFeatures(u,100) = medAvgMedZCPs;
                summaryFeatures(u,101) = avgAvgMedZCPs;
                summaryFeatures(u,102) = stdAvgMedZCPs;
                summaryFeatures(u,103) = medStdMedZCPs;
                summaryFeatures(u,104) = avgStdMedZCPs;
                summaryFeatures(u,105) = stdStdMedZCPs;
                summaryFeatures(u,106) = avgMedSPF;
                summaryFeatures(u,107) = medMedSPF;
                summaryFeatures(u,108) = stdMedSPF;
                summaryFeatures(u,109) = avgMeanSPF;
                summaryFeatures(u,110) = medMeanSPF;
                summaryFeatures(u,111) = stdMeanSPF;
                summaryFeatures(u,112) = avgStdSPF;
                summaryFeatures(u,113) = medStdSPF;
                summaryFeatures(u,114) = stdStdSPF;
                summaryFeatures(u,115) = initAvgStdZCPs;
                summaryFeatures(u,116) = initStdMeanZCPs;
                summaryFeatures(u,117) = initAvgSpecCentroid;
                summaryFeatures(u,118) = initMeanZCPSD;
                summaryFeatures(u,119) = initPauseDuration;
                summaryFeatures(u,120) = avgRmsEpoch;
                summaryFeatures(u,121) = medRmsEpoch;
                summaryFeatures(u,122) = stdRmsEpoch;
                summaryFeatures(u,123) = avgRmsEnergy;
                summaryFeatures(u,124) = medRmsEnergy;
                summaryFeatures(u,125) = stdRmsEnergy;
                summaryFeatures(u,126) = avgMaxM1;
                summaryFeatures(u,127) = medMaxM1;
                summaryFeatures(u,128) = stdMaxM1;
                summaryFeatures(u,129) = avgMaxM2;
                summaryFeatures(u,130) = medMaxM2;
                summaryFeatures(u,131) = stdMaxM2;
                summaryFeatures(u,132) = avgMaxM3;
                summaryFeatures(u,133) = medMaxM3;
                summaryFeatures(u,134) = stdMaxM3;
                summaryFeatures(u,135) = avgMaxM4;
                summaryFeatures(u,136) = medMaxM4;
                summaryFeatures(u,137) = stdMaxM4;
                summaryFeatures(u,138) = avgMaxM5;
                summaryFeatures(u,139) = medMaxM5;
                summaryFeatures(u,140) = stdMaxM5;
                summaryFeatures(u,141) = avgMaxM6;
                summaryFeatures(u,142) = medMaxM6;
                summaryFeatures(u,143) = stdMaxM6;
                summaryFeatures(u,144) = avgMaxM7;
                summaryFeatures(u,145) = medMaxM7;
                summaryFeatures(u,146) = stdMaxM7;
                summaryFeatures(u,147) = avgMaxM8;
                summaryFeatures(u,148) = medMaxM8;
                summaryFeatures(u,149) = stdMaxM8;
                summaryFeatures(u,150) = avgMaxM9;
                summaryFeatures(u,151) = medMaxM9;
                summaryFeatures(u,152) = stdMaxM9;
                summaryFeatures(u,153) = avgMaxM10;
                summaryFeatures(u,154) = medMaxM10;
                summaryFeatures(u,155) = stdMaxM10;
                summaryFeatures(u,156) = avgMaxM11;
                summaryFeatures(u,157) = medMaxM11;
                summaryFeatures(u,158) = stdMaxM11;
                summaryFeatures(u,159) = avgMaxM12;
                summaryFeatures(u,160) = medMaxM12;
                summaryFeatures(u,161) = stdMaxM12;
                summaryFeatures(u,162) = avgMaxM13;
                summaryFeatures(u,163) = medMaxM13;
                summaryFeatures(u,164) = stdMaxM13;
                summaryFeatures(u,165) = avgMaxM14;
                summaryFeatures(u,166) = medMaxM14;
                summaryFeatures(u,167) = stdMaxM14;
                summaryFeatures(u,168:finalInd) = initialSpeechVars;
                
                u = u + 1;
            else
                noPatientEpochs{1,p}{j,s} = str2num(matData(i).audioName);
                s = s + 1;
            end
            clearvars -except summaryFeatures currentPdx audioName...
                T matFiles myFolder filePattern PdxIndices PdxName j...
                noPatientEpochs matData i u s p summaryTableNames...
                speechDetailTableNames pauseDetailTableNames Tpartition g...
                Tchildage TAnxDep TPer TAttention TSp2fbsumw TchildagePartition TAnxDepPartition...
                TPerPartition TAttentionPartition TSp2fbsumwPartition...
                childagePdx AnxDepTmergedPdx perPdx attentionprobsTmergedPdx...
                sp2fbsumw duplicates uniquePvals initialSpeechVarNames RowNames xi...
                AllVars fullMVar
        end
                % Assigning all feature names to be represented in
                % correlation table
                RowNames = [{'Avg_SPause_Length','STD_SPause_Length',...
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
            'avgRmsEpoch', 'medRmsEpoch', 'stdRmsEpoch' 'avgRmsEnergy',...
            'medRmsEnergy', 'stdRmsEnergy'},fullMVar ,initialSpeechVarNames,...
            {'N'}];
        
        % Performing all spearman correlations for specified Dx and feature
        % set
        N(j) = length(summaryFeatures(:,1));
        
        C = unique(summaryFeatures(2,:));
        if length(C) ~= length(summaryFeatures(1,:))
            duplicates(p,j) = true;
        else
            duplicates(p,j) = false;
        end
        
        for w=1:length(summaryFeatures(1,:))
            [rho(w), pval(w)] = corr(summaryFeatures(:,w),currentPdx','type','spearman','rows','complete');
            %{
            [partChildageRho(w), partChildagePval(w)] = partialcorr(summaryFeatures(:,w),currentPdx',childagePdx','rows','complete');
            [partAnxDepRho(w), partAnxDepPval(w)] = partialcorr(summaryFeatures(:,w),currentPdx',AnxDepTmergedPdx','rows','complete');
            [partPerRho(w), partPerPval(w)] = partialcorr(summaryFeatures(:,w),currentPdx',perPdx','rows','complete');
            [partAttentionRho(w), partAttentionPval(w)] = partialcorr(summaryFeatures(:,w),currentPdx',attentionprobsTmergedPdx','rows','complete');
            [partSp2fbsumwRho(w), partSp2fbsumwPval(w)] = partialcorr(summaryFeatures(:,w),currentPdx',sp2fbsumw','rows','complete');
            %}
        end
        CpVal = unique(pval);
        uniquePvals(p,j) = length(CpVal);
        
        %% Partial Correlations
        %{
        if PdxName{j} ~= 'childage'
            for w=1:length(summaryFeatures(1,:))
                [partChildageRho(w), partChildagePval(w)] = partialcorr(summaryFeatures(:,w),currentPdx',childagePdx');
            end
        end
        if PdNAme{j} ~= 'AnxDepTmerged'
            for w=1:length(summaryFeatures(1,:))
                [partAnxDepRho(w), partAnxDepPval(w)] = partialcorr(summaryFeatures(:,w),currentPdx',AnxDepTmergedPdx');
            end
        end
        if PdxName{j} ~= 'per'
            for w=1:length(summaryFeatures(1,:))
                [partPerRho(w), partPerPval(w)] = partialcorr(summaryFeatures(:,w),currentPdx',perPdx');
            end
        end
        if PdxName{j} ~= 'attentionprobsTmerged'
            for w=1:length(summaryFeatures(1,:))
                [partAttentionRho(w), partAttentionPval(w)] = partialcorr(summaryFeatures(:,w),currentPdx',attentionprobsTmergedPdx');
            end
        end
        if PdxName{j} ~= 'sp2fbsumw'
            for w=1:length(summaryFeatures(1,:))
                [partSp2fbsumwRho(w), partSp2fbsumwPval(w)] = partialcorr(summaryFeatures(:,w),currentPdx',sp2fbsumw');
            end
        end
        
        %}
        
        %%
        
        rho = [rho N(j)];
        pval = [pval N(j)];
        %{
        partChildageRho = [partChildageRho N(j)];
        partChildagePval = [partChildagePval N(j)];
        partAnxDepRho = [partAnxDepRho N(j)];
        partAnxDepPval = [partAnxDepPval N(j)];
        partPerRho = [partPerRho N(j)];
        partPerPval = [partPerPval N(j)];
        partAttentionRho = [partAttentionRho N(j)];
        partAttentionPval = [partAttentionPval N(j)];
        partSp2fbsumwRho = [partSp2fbsumwRho N(j)];
        partSp2fbsumwPval = [partSp2fbsumwPval N(j)];
        %}
        
        

        
        Variables{1} = [PdxName{j},'_rho'];
        Variables{2} = [PdxName{j}, '_pValue'];
        
        AllVars{xi} = Variables{1};
        AllVars{xi + 1} = Variables{2};
        
        % Creating Dx specific table of all correlations
        if j == 1
            T{j} = table(rho',pval','VariableNames', Variables, 'RowNames', RowNames);
            %{
            Tchildage{j} = table(partChildageRho',partChildagePval','VariableNames', Variables, 'RowNames', RowNames);
            TAnxDep{j} = table(partAnxDepRho',partAnxDepPval','VariableNames', Variables, 'RowNames', RowNames);
            TPer{j} = table(partPerRho',partPerPval','VariableNames', Variables, 'RowNames', RowNames);
            TAttention{j} = table(partAttentionRho',partAttentionPval','VariableNames', Variables, 'RowNames', RowNames);
            TSp2fbsumw{j} = table(partSp2fbsumwRho',partSp2fbsumwPval','VariableNames', Variables, 'RowNames', RowNames);
            %}
        else
            T{j} = table(rho',pval','VariableNames', Variables);
            %{
            Tchildage{j} = table(partChildageRho',partChildagePval','VariableNames', Variables);
            TAnxDep{j} = table(partAnxDepRho',partAnxDepPval','VariableNames', Variables);
            TPer{j} = table(partPerRho',partPerPval','VariableNames', Variables);
            TAttention{j} = table(partAttentionRho',partAttentionPval','VariableNames', Variables);
            TSp2fbsumw{j} = table(partSp2fbsumwRho',partSp2fbsumwPval','VariableNames', Variables);
            %}
        end
        clearvars -except T matFiles myFolder filePattern PdxIndices PdxName...
            j noPatientEpochs p summaryTableNames speechDetailTableNames pauseDetailTableNames...
            Tpartition g duplicates uniquePvals RowNames xi AllVars fullMVar
        %Tchildage TAnxDep TPer TAttention TSp2fbsumw TchildagePartition TAnxDepPartition
           % TPerPartition TAttentionPartition TSp2fbsumwPartition
           
         xi = xi + 2;
    end
    % Combining all Dx specific tables for specified partition
    T = [T{:}];
    %{
    Tchildage = [Tchildage{:}];
    TAnxDep = [TAnxDep{:}];
    TPer = [TPer{:}];
    TAttention = [TAttention{:}];
    TSp2fbsumw = [TSp2fbsumw{:}];
    %}
    
    Tpartition{p} = T;
    %{
    TchildagePartition{p} = Tchildage;
    TAnxDepPartition{p} = TAnxDep;
    TPerPartition{p} = TPer;
    TAttentionPartition{p} = TAttention;
    TSp2fbsumwPartition{p} = TSp2fbsumw;
    %}
    clear T %Tchildage TAnxDep TPer TAttention TSp2fbsumw
end

% Un-comment for easy table export of all partial correlations
%{
prompt = '[0] for NO spreadsheet write, [1] for YES spreadsheet write: ';
choice = input(prompt);

if choice == 1
writetable(TchildagePartition{1},'TchildageP1.xlsx','WriteRowNames',true)
writetable(TchildagePartition{2},'TchildageP2.xlsx','WriteRowNames',true)
writetable(TchildagePartition{3},'TchildageP3.xlsx','WriteRowNames',true)
writetable(TAnxDepPartition{1},'TAnxDepP1.xlsx','WriteRowNames',true)
writetable(TAnxDepPartition{2},'TAnxDepP2.xlsx','WriteRowNames',true)
writetable(TAnxDepPartition{3},'TAnxDepP3.xlsx','WriteRowNames',true)
writetable(TPerPartition{1},'TPerP1.xlsx','WriteRowNames',true)
writetable(TPerPartition{2},'TPerP2.xlsx','WriteRowNames',true)
writetable(TPerPartition{3},'TPerP3.xlsx','WriteRowNames',true)
writetable(TAttentionPartition{1},'TAttentionP1.xlsx','WriteRowNames',true)
writetable(TAttentionPartition{2},'TAttentionP2.xlsx','WriteRowNames',true)
writetable(TAttentionPartition{3},'TAttentionP3.xlsx','WriteRowNames',true)
writetable(TSp2fbsumwPartition{1},'TSp2fbsumwP1.xlsx','WriteRowNames',true)
writetable(TSp2fbsumwPartition{2},'TSp2fbsumwP2.xlsx','WriteRowNames',true)
writetable(TSp2fbsumwPartition{3},'TSp2fbsumwP3.xlsx','WriteRowNames',true)
end

%}