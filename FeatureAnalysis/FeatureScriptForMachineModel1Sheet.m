clc, clear all, close all
%% Initial Option
%{
startPrompt = 'Export Excel spreadsheet? [0] for NO, [1] for YES: ';
choice = input(startPrompt);
%}
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

%% Feature Analysis
% Extracting Summary values for each patient on concatenating patient Dx
% and summary features into one matrix
for p=1:3
    u = 1;
    for i = 1:length(matFiles)
        pDx(i,:) = extractfield(matData(i),'patientDx');
        summaryFeat = extractfield(matData(i), summaryTableNames{p});
        speechFeat = extractfield(matData(i), speechDetailTableNames{p});
        pauseFeat = extractfield(matData(i), pauseDetailTableNames{p});
        
        if (width(summaryFeat{1,1}) > 3) && (width(speechFeat{1,1}) > 3) && (width(pauseFeat{1,1}) > 3) && isnan(pDx(i,73)) == 0
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
            
            finalInd = 119 + length(initialSpeechVars);
            
            
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
            summaryFeatures(u,120:finalInd) = initialSpeechVars;
            
            
            extrPDx(u,1) = pDx(i,1); %PID
            extrPDx(u,2) = pDx(i,73); %INTdx
            u = u + 1;
        end
        clearvars -except summaryFeatures matFiles...
            myFolder filePattern matData i extrPDx choice...
            u p summaryTableNames speechDetailTableNames...
            pauseDetailTableNames T initialSpeechVarNames
    end
        Variables = [{'PID','INTdx','Avg_SPause_Length','STD_SPause_Length',...
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
            'initAvgSpecCentroid', 'initMeanZCPSD', 'initPauseDuration'},...
            initialSpeechVarNames];
        
        for w=1:length(Variables)
            if p ==1 && w > 2
                Variables{w} = char(['p1_',Variables{w}]);
            elseif p == 2 && w > 2
                Variables{w} = char(['p2_',Variables{w}]);
            elseif p == 3 && w > 2
                Variables{w} = char(['p3_',Variables{w}]);
            end
        end

    Features = [extrPDx, summaryFeatures];
        
    
    T{p} = array2table(Features, 'VariableNames', Variables);
    
        clearvars -except T matFiles myFolder filePattern...
            j noPatientEpochs p summaryTableNames speechDetailTableNames pauseDetailTableNames...
            Tpartition g duplicates uniquePvals matData
end





