clear all, clc
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
%% Read in all files with a buzzer count == 2 && patient count > 0

for i=1:length(matData)
    matFilename = [matFiles(i).folder,'\',matFiles(i).name];
    EpochLabel = matData(i).EpochLabel;
    BuzzerCount = 0;
    PatientCount = 0;
    for x=1:length(EpochLabel)
        if EpochLabel{x} == 'B'
            BuzzerCount = BuzzerCount + 1;
        end
        if EpochLabel{x} == 'P'
            PatientCount = PatientCount + 1;
        end
    end
    
    if PatientCount > 0
        SpeechDetailsTable = extractfield(matData(i),'analysisTableSpeechDetailsPatient');
        PauseDetailsTable = extractfield(matData(i),'analysisTablePauseDetailsPatient');
        energyMatrix = matData(i).energyMatrixPatientOnly;
        SpeechStartTime = SpeechDetailsTable{1,1}.Speech_Start_Time;
        PauseStartTime = PauseDetailsTable{1,1}.SP_Start_Time;
        if (BuzzerCount == 2)
            %% Partition 1 (0s-100s)
            indP1Speech = find(SpeechStartTime <=100);
            indP1Pause = find(PauseStartTime <= 100);
            PatientCountP1 = 0;
            ClinicianCountP1 = 0;
            OtherCountP1 = 0;
            for q=1:length(indP1Speech)
                if EpochLabel{indP1Speech(q)} == 'P'
                    PatientCountP1 = PatientCountP1 + 1;
                elseif EpochLabel{indP1Speech(q)} == 'C'
                    ClinicianCountP1 = ClinicianCountP1 + 1;
                elseif EpochLabel{indP1Speech(q)} == 'O'
                    OtherCountP1 = OtherCountP1 + 1;
                end
            end
            
            if PatientCountP1 > 0
                averageSpeechPauseLengthP1 = mean(PauseDetailsTable{1,1}.SP_Duration(indP1Pause));
                stdSpeechPauseLengthP1 = std(PauseDetailsTable{1,1}.SP_Duration(indP1Pause));
                speechPauseOccuranceTotalP1 = length(PauseDetailsTable{1,1}.SP_Number(indP1Pause));
                averageSpeechLengthP1 = mean(SpeechDetailsTable{1,1}.Speech_Epoch_Duration(indP1Speech));
                stdSpeechLengthP1 = std(SpeechDetailsTable{1,1}.Speech_Epoch_Duration(indP1Speech));
                speechOccuranceTotalP1 = length(SpeechDetailsTable{1,1}.Speech_Epoch_Number(indP1Speech));
                percentSpeechPresentP1 = (sum(SpeechDetailsTable{1,1}.Speech_Epoch_Duration(indP1Speech))/ (sum(PauseDetailsTable{1,1}.SP_Duration(indP1Pause)) + sum(SpeechDetailsTable{1,1}.Speech_Epoch_Duration(indP1Speech))))*100;
                percentPausePresentP1 = 100 - percentSpeechPresentP1;
                stdMaxFP1 = std(SpeechDetailsTable{1,1}.Speech_Epoch_Max_Frequency(indP1Speech));
                stdMeanFP1 = std(SpeechDetailsTable{1,1}.Speech_Epoch_Mean_Frequency(indP1Speech));
                domFreqFitP1 = polyfit(SpeechDetailsTable{1,1}.Speech_Start_Time(indP1Speech),SpeechDetailsTable{1,1}.Speech_Epoch_Max_Frequency(indP1Speech),1);
                meanFreqFitP1 = polyfit(SpeechDetailsTable{1,1}.Speech_Start_Time(indP1Speech),SpeechDetailsTable{1,1}.Speech_Epoch_Mean_Frequency(indP1Speech),1);
                PCmeanFitP1 = polyfit(SpeechDetailsTable{1,1}.Speech_Start_Time(indP1Speech),SpeechDetailsTable{1,1}.Mean_Perceptual_Spectral_Centroid(indP1Speech),1);
                PCmaxFitP1 = polyfit(SpeechDetailsTable{1,1}.Speech_Start_Time(indP1Speech),SpeechDetailsTable{1,1}.Max_Perceptual_Spectral_Centroid(indP1Speech),1);
                PCminFitP1 = polyfit(SpeechDetailsTable{1,1}.Speech_Start_Time(indP1Speech),SpeechDetailsTable{1,1}.Min_Perceptual_Spectral_Centroid(indP1Speech),1);
                domFreqSlopeP1 = domFreqFitP1(1);
                meanFreqSlopeP1 = meanFreqFitP1(1);
                PCmeanSlopeP1 = PCmeanFitP1(1);
                PCmaxSlopeP1 = PCmaxFitP1(1);
                PCminSlopeP1 = PCminFitP1(1);
                if ClinicianCountP1 > 0
                    PtoCRatioP1 = PatientCountP1 / ClinicianCountP1;
                else
                    PtoCRatioP1 = NaN;
                end
                if OtherCountP1 > 0
                    PtoORatioP1 = PatientCountP1 / OtherCountP1;
                else
                    PtoORatioP1 = NaN;
                end
                
                
                energyMatrixP1 = energyMatrix(:,indP1Speech);
                if length(energyMatrix) > 1
                    above200rawP1 = energyMatrixP1(3:end,:);
                    above500rawP1 = energyMatrixP1(6:end,:);
                    above700rawP1 = energyMatrixP1(8:end,:);
                    above1000rawP1 = energyMatrixP1(11:end,:);
                    above2000rawP1 = energyMatrixP1(21:end,:);
                    
                    above200colP1=  sum(above200rawP1);
                    above500colP1 = sum(above500rawP1);
                    above700colP1 = sum(above700rawP1);
                    above1000colP1 = sum(above1000rawP1);
                    above2000colP1 = sum(above2000rawP1);
                    
                    above200P1 = mean(above200colP1);
                    above500P1 = mean(above500colP1);
                    above700P1 = mean(above700colP1);
                    above1000P1 = mean(above1000colP1);
                    above2000P1 = mean(above2000colP1);
                else
                    above200P1 = 0;
                    above500P1 = 0;
                    above700P1 = 0;
                    above1000P1 = 0;
                    above2000P1 = 0;
                end
                
                
                analysisTableSummaryPartition1 = table( averageSpeechPauseLengthP1, stdSpeechPauseLengthP1,...
                    speechPauseOccuranceTotalP1, averageSpeechLengthP1, stdSpeechLengthP1, speechOccuranceTotalP1,...
                    percentPausePresentP1, percentSpeechPresentP1, above200P1, above500P1, above700P1, above1000P1,...
                    above2000P1, stdMaxFP1, stdMeanFP1, domFreqSlopeP1, meanFreqSlopeP1, PCmeanSlopeP1, PCmaxSlopeP1,...
                    PCminSlopeP1, PtoCRatioP1, PtoORatioP1);
                analysisTableSpeechDetailsPartition1 = table(SpeechDetailsTable{1,1}.Speech_Epoch_Number(indP1Speech),...
                    SpeechDetailsTable{1,1}.Speech_Start_Time(indP1Speech), SpeechDetailsTable{1,1}.Speech_End_Time(indP1Speech),...
                    SpeechDetailsTable{1,1}.Speech_Epoch_Duration(indP1Speech), SpeechDetailsTable{1,1}.Speech_Epoch_Max_Frequency(indP1Speech),...
                    SpeechDetailsTable{1,1}.Speech_Epoch_Mean_Frequency(indP1Speech), SpeechDetailsTable{1,1}.Mean_Perceptual_Spectral_Centroid(indP1Speech),...
                    SpeechDetailsTable{1,1}.Std_Perceptual_Spectral_Centroid(indP1Speech), SpeechDetailsTable{1,1}.Max_Perceptual_Spectral_Centroid(indP1Speech),...
                    SpeechDetailsTable{1,1}.Min_Perceptual_Spectral_Centroid(indP1Speech), SpeechDetailsTable{1,1}.PSD_Skew(indP1Speech),...
                    SpeechDetailsTable{1,1}.PSD_Kurtosis(indP1Speech), SpeechDetailsTable{1,1}.Mean_ZC_Waveform(indP1Speech),...
                    SpeechDetailsTable{1,1}.Max_ZC_Waveform(indP1Speech), SpeechDetailsTable{1,1}.Min_ZC_Waveform(indP1Speech),...
                    SpeechDetailsTable{1,1}.Std_ZC_Waveform(indP1Speech), SpeechDetailsTable{1,1}.Mean_ZC_normPSD(indP1Speech),...
                    SpeechDetailsTable{1,1}.Max_ZC_normPSD(indP1Speech), SpeechDetailsTable{1,1}.Min_ZC_normPSD(indP1Speech),...
                    SpeechDetailsTable{1,1}.Std_ZC_normPSD(indP1Speech), SpeechDetailsTable{1,1}.Energy_Over_Time_Slope(indP1Speech),...
                    SpeechDetailsTable{1,1}.avg_F1(indP1Speech), SpeechDetailsTable{1,1}.std_F1(indP1Speech),...
                    SpeechDetailsTable{1,1}.slope_F1(indP1Speech), SpeechDetailsTable{1,1}.avg_F2(indP1Speech),...
                    SpeechDetailsTable{1,1}.std_F2(indP1Speech), SpeechDetailsTable{1,1}.slope_F2(indP1Speech),...
                    SpeechDetailsTable{1,1}.avg_F3(indP1Speech), SpeechDetailsTable{1,1}.std_F3(indP1Speech),...
                    SpeechDetailsTable{1,1}.slope_F3(indP1Speech), SpeechDetailsTable{1,1}.avgMeanZCPs(indP1Speech), ...
                    SpeechDetailsTable{1,1}.stdMeanZCPs(indP1Speech), SpeechDetailsTable{1,1}.avgMaxZCPs(indP1Speech),...
                    SpeechDetailsTable{1,1}.stdMaxZCPs(indP1Speech), SpeechDetailsTable{1,1}.avgMinZCPs(indP1Speech), ...
                    SpeechDetailsTable{1,1}.stdMinZCPs(indP1Speech), SpeechDetailsTable{1,1}.avgStdZCPs(indP1Speech),...
                    SpeechDetailsTable{1,1}.sumStdZCPs(indP1Speech), SpeechDetailsTable{1,1}.medMedZCPs(indP1Speech),...
                    SpeechDetailsTable{1,1}.avgMedZCPs(indP1Speech), SpeechDetailsTable{1,1}.stdMedZCPs(indP1Speech),...
                    SpeechDetailsTable{1,1}.medSPF(indP1Speech), SpeechDetailsTable{1,1}.avgSPF(indP1Speech),...
                    SpeechDetailsTable{1,1}.stdSPF(indP1Speech), SpeechDetailsTable{1,1}.rmsEpoch(indP1Speech));
                analysisTablePauseDetailsPartition1 = table(PauseDetailsTable{1,1}.SP_Number(indP1Pause), PauseDetailsTable{1,1}.SP_Start_Time(indP1Pause),...
                    PauseDetailsTable{1,1}.SP_End_Time(indP1Pause), PauseDetailsTable{1,1}.SP_Duration(indP1Pause));
                analysisTableSummaryPartition1.Properties.VariableNames = {'Average_SP_Length' 'Standard_Deviation_of_SP_Length'...
                    'SP_Total_Occurance' 'Average_Speech_Epoch_Length', ...
                    'Standard_Deviation_of_Speech_Epoch_Length' 'Speech_Epoch_Total_Occurance'...
                    'Percent_Pause_Present' 'Percent_Speech_Present' 'Percent_Above_200Hz'...
                    'Percent_Above_500Hz' 'Percent_Above_700Hz' 'Percent_Above_1000Hz'...
                    'Percent_Above_2000Hz' 'Standard_Deviation_Max_Frequency'...
                    'Standard_Deviation_Mean_Frequency' 'Dom_Freq_Slope' 'Mean_Freq_Slope'...
                    'PC_Mean_Slope' 'PC_Max_Slope' 'PC_Min_Slope' 'Patient_To_Clinician_CountRatio'...
                    'Patient_To_Other_CountRatio'};
                analysisTableSpeechDetailsPartition1.Properties.VariableNames = {'Speech_Epoch_Number'...
                    'Speech_Start_Time' 'Speech_End_Time' 'Speech_Epoch_Duration'...
                    'Speech_Epoch_Max_Frequency' 'Speech_Epoch_Mean_Frequency',...
                    'Mean_Perceptual_Spectral_Centroid','Std_Perceptual_Spectral_Centroid', ...
                    'Max_Perceptual_Spectral_Centroid','Min_Perceptual_Spectral_Centroid'...
                    'PSD_Skew' 'PSD_Kurtosis' 'Mean_ZC_Waveform', 'Max_ZC_Waveform',...
                    'Min_ZC_Waveform', 'Std_ZC_Waveform', 'Mean_ZC_normPSD', 'Max_ZC_normPSD',...
                    'Min_ZC_normPSD', 'Std_ZC_normPSD', 'Energy_Over_Time_Slope', ...
                    'avg_F1', 'std_F1', 'slope_F1', 'avg_F2', 'std_F2', 'slope_F2',...
                    'avg_F3', 'std_F3', 'slope_F3', 'avgMeanZCPs', 'stdMeanZCPs',  'avgMaxZCPs',...
                    'stdMaxZCPs', 'avgMinZCPs', 'stdMinZCPs', 'avgStdZCPs', 'sumStdZCPs'...
                    'medMedZCPs', 'avgMedZCPs', 'stdMedZCPs', 'medSPF', 'avgSPF', 'stdSPF'...
                    'rmsEpoch'};
                analysisTablePauseDetailsPartition1.Properties.VariableNames = {'SP_Number' 'SP_Start_Time'...
                    'SP_End_Time' 'SP_Duration'};
            else
                analysisTableSummaryPartition1 = table(0,0,0);
                analysisTableSpeechDetailsPartition1 = table(0,0,0);
                analysisTablePauseDetailsPartition1 = table(0,0,0);
                energyMatrixP1 = 0;
            end
            
            %% Partition 2 (101s - 160s)
            indP2Speech = find(((SpeechStartTime > 100) & (SpeechStartTime <= 160)));
            indP2Pause = find(((PauseStartTime > 100) & (PauseStartTime <= 160)));
            
            PatientCountP2 = 0;
            ClinicianCountP2 = 0;
            OtherCountP2 = 0;
            for q=1:length(indP2Speech)
                if EpochLabel{indP2Speech(q)} == 'P'
                    PatientCountP2 = PatientCountP2 + 1;
                elseif EpochLabel{indP2Speech(q)} == 'C'
                    ClinicianCountP2 = ClinicianCountP2 + 1;
                elseif EpochLabel{indP2Speech(q)} == 'O'
                    OtherCountP2 = OtherCountP2 + 1;
                end
            end
            
            if PatientCountP2 > 0
                averageSpeechPauseLengthP2 = mean(PauseDetailsTable{1,1}.SP_Duration(indP2Pause));
                stdSpeechPauseLengthP2 = std(PauseDetailsTable{1,1}.SP_Duration(indP2Pause));
                speechPauseOccuranceTotalP2 = length(PauseDetailsTable{1,1}.SP_Number(indP2Pause));
                averageSpeechLengthP2 = mean(SpeechDetailsTable{1,1}.Speech_Epoch_Duration(indP2Speech));
                stdSpeechLengthP2 = std(SpeechDetailsTable{1,1}.Speech_Epoch_Duration(indP2Speech));
                speechOccuranceTotalP2 = length(SpeechDetailsTable{1,1}.Speech_Epoch_Number(indP2Speech));
                percentSpeechPresentP2 = (sum(SpeechDetailsTable{1,1}.Speech_Epoch_Duration(indP2Speech))/ (sum(PauseDetailsTable{1,1}.SP_Duration(indP2Pause)) + sum(SpeechDetailsTable{1,1}.Speech_Epoch_Duration(indP2Speech))))*100;
                percentPausePresentP2 = 100 - percentSpeechPresentP2;
                stdMaxFP2 = std(SpeechDetailsTable{1,1}.Speech_Epoch_Max_Frequency(indP2Speech));
                stdMeanFP2 = std(SpeechDetailsTable{1,1}.Speech_Epoch_Mean_Frequency(indP2Speech));
                domFreqFitP2 = polyfit(SpeechDetailsTable{1,1}.Speech_Start_Time(indP2Speech),SpeechDetailsTable{1,1}.Speech_Epoch_Max_Frequency(indP2Speech),1);
                meanFreqFitP2 = polyfit(SpeechDetailsTable{1,1}.Speech_Start_Time(indP2Speech),SpeechDetailsTable{1,1}.Speech_Epoch_Mean_Frequency(indP2Speech),1);
                PCmeanFitP2 = polyfit(SpeechDetailsTable{1,1}.Speech_Start_Time(indP2Speech),SpeechDetailsTable{1,1}.Mean_Perceptual_Spectral_Centroid(indP2Speech),1);
                PCmaxFitP2 = polyfit(SpeechDetailsTable{1,1}.Speech_Start_Time(indP2Speech),SpeechDetailsTable{1,1}.Max_Perceptual_Spectral_Centroid(indP2Speech),1);
                PCminFitP2 = polyfit(SpeechDetailsTable{1,1}.Speech_Start_Time(indP2Speech),SpeechDetailsTable{1,1}.Min_Perceptual_Spectral_Centroid(indP2Speech),1);
                domFreqSlopeP2 = domFreqFitP2(1);
                meanFreqSlopeP2 = meanFreqFitP2(1);
                PCmeanSlopeP2 = PCmeanFitP2(1);
                PCmaxSlopeP2 = PCmaxFitP2(1);
                PCminSlopeP2 = PCminFitP2(1);
                if ClinicianCountP2 > 0
                    PtoCRatioP2 = PatientCountP2 / ClinicianCountP2;
                else
                    PtoCRatioP2 = NaN;
                end
                if OtherCountP2 > 0
                    PtoORatioP2 = PatientCountP2 / OtherCountP2;
                else
                    PtoORatioP2 = NaN;
                end
                
                energyMatrixP2 = energyMatrix(:,indP2Speech);
                if length(energyMatrix) > 1
                    above200rawP2 = energyMatrixP2(3:end,:);
                    above500rawP2 = energyMatrixP2(6:end,:);
                    above700rawP2 = energyMatrixP2(8:end,:);
                    above1000rawP2 = energyMatrixP2(11:end,:);
                    above2000rawP2 = energyMatrixP2(21:end,:);
                    
                    above200colP2=  sum(above200rawP2);
                    above500colP2 = sum(above500rawP2);
                    above700colP2 = sum(above700rawP2);
                    above1000colP2 = sum(above1000rawP2);
                    above2000colP2 = sum(above2000rawP2);
                    
                    above200P2 = mean(above200colP2);
                    above500P2 = mean(above500colP2);
                    above700P2 = mean(above700colP2);
                    above1000P2 = mean(above1000colP2);
                    above2000P2 = mean(above2000colP2);
                else
                    above200P2 = 0;
                    above500P2 = 0;
                    above700P2 = 0;
                    above1000P2 = 0;
                    above2000P2 = 0;
                end
                
                analysisTableSummaryPartition2 = table( averageSpeechPauseLengthP2, stdSpeechPauseLengthP2,...
                    speechPauseOccuranceTotalP2, averageSpeechLengthP2, stdSpeechLengthP2, speechOccuranceTotalP2,...
                    percentPausePresentP2, percentSpeechPresentP2, above200P2, above500P2, above700P2, above1000P2,...
                    above2000P2, stdMaxFP2, stdMeanFP2, domFreqSlopeP2, meanFreqSlopeP2, PCmeanSlopeP2, PCmaxSlopeP2,...
                    PCminSlopeP2, PtoCRatioP2, PtoORatioP2);
                analysisTableSpeechDetailsPartition2 = table(SpeechDetailsTable{1,1}.Speech_Epoch_Number(indP2Speech),...
                    SpeechDetailsTable{1,1}.Speech_Start_Time(indP2Speech), SpeechDetailsTable{1,1}.Speech_End_Time(indP2Speech),...
                    SpeechDetailsTable{1,1}.Speech_Epoch_Duration(indP2Speech), SpeechDetailsTable{1,1}.Speech_Epoch_Max_Frequency(indP2Speech),...
                    SpeechDetailsTable{1,1}.Speech_Epoch_Mean_Frequency(indP2Speech), SpeechDetailsTable{1,1}.Mean_Perceptual_Spectral_Centroid(indP2Speech),...
                    SpeechDetailsTable{1,1}.Std_Perceptual_Spectral_Centroid(indP2Speech), SpeechDetailsTable{1,1}.Max_Perceptual_Spectral_Centroid(indP2Speech),...
                    SpeechDetailsTable{1,1}.Min_Perceptual_Spectral_Centroid(indP2Speech),SpeechDetailsTable{1,1}.PSD_Skew(indP2Speech),...
                    SpeechDetailsTable{1,1}.PSD_Kurtosis(indP2Speech),SpeechDetailsTable{1,1}.Mean_ZC_Waveform(indP2Speech),...
                    SpeechDetailsTable{1,1}.Max_ZC_Waveform(indP2Speech), SpeechDetailsTable{1,1}.Min_ZC_Waveform(indP2Speech),...
                    SpeechDetailsTable{1,1}.Std_ZC_Waveform(indP2Speech), SpeechDetailsTable{1,1}.Mean_ZC_normPSD(indP2Speech),...
                    SpeechDetailsTable{1,1}.Max_ZC_normPSD(indP2Speech), SpeechDetailsTable{1,1}.Min_ZC_normPSD(indP2Speech),...
                    SpeechDetailsTable{1,1}.Std_ZC_normPSD(indP2Speech), SpeechDetailsTable{1,1}.Energy_Over_Time_Slope(indP2Speech),...
                    SpeechDetailsTable{1,1}.avg_F1(indP2Speech), SpeechDetailsTable{1,1}.std_F1(indP2Speech),...
                    SpeechDetailsTable{1,1}.slope_F1(indP2Speech), SpeechDetailsTable{1,1}.avg_F2(indP2Speech),...
                    SpeechDetailsTable{1,1}.std_F2(indP2Speech), SpeechDetailsTable{1,1}.slope_F2(indP2Speech),...
                    SpeechDetailsTable{1,1}.avg_F3(indP2Speech), SpeechDetailsTable{1,1}.std_F3(indP2Speech),...
                    SpeechDetailsTable{1,1}.slope_F3(indP2Speech), SpeechDetailsTable{1,1}.avgMeanZCPs(indP2Speech), ...
                    SpeechDetailsTable{1,1}.stdMeanZCPs(indP2Speech), SpeechDetailsTable{1,1}.avgMaxZCPs(indP2Speech),...
                    SpeechDetailsTable{1,1}.stdMaxZCPs(indP2Speech), SpeechDetailsTable{1,1}.avgMinZCPs(indP2Speech), ...
                    SpeechDetailsTable{1,1}.stdMinZCPs(indP2Speech), SpeechDetailsTable{1,1}.avgStdZCPs(indP2Speech),...
                    SpeechDetailsTable{1,1}.sumStdZCPs(indP2Speech), SpeechDetailsTable{1,1}.medMedZCPs(indP2Speech),...
                    SpeechDetailsTable{1,1}.avgMedZCPs(indP2Speech), SpeechDetailsTable{1,1}.stdMedZCPs(indP2Speech),...
                    SpeechDetailsTable{1,1}.medSPF(indP2Speech), SpeechDetailsTable{1,1}.avgSPF(indP2Speech),...
                    SpeechDetailsTable{1,1}.stdSPF(indP2Speech), SpeechDetailsTable{1,1}.rmsEpoch(indP2Speech));
                analysisTablePauseDetailsPartition2 = table(PauseDetailsTable{1,1}.SP_Number(indP2Pause), PauseDetailsTable{1,1}.SP_Start_Time(indP2Pause),...
                    PauseDetailsTable{1,1}.SP_End_Time(indP2Pause), PauseDetailsTable{1,1}.SP_Duration(indP2Pause));
                analysisTableSummaryPartition2.Properties.VariableNames = {'Average_SP_Length' 'Standard_Deviation_of_SP_Length'...
                    'SP_Total_Occurance' 'Average_Speech_Epoch_Length', ...
                    'Standard_Deviation_of_Speech_Epoch_Length' 'Speech_Epoch_Total_Occurance'...
                    'Percent_Pause_Present' 'Percent_Speech_Present' 'Percent_Above_200Hz'...
                    'Percent_Above_500Hz' 'Percent_Above_700Hz' 'Percent_Above_1000Hz'...
                    'Percent_Above_2000Hz' 'Standard_Deviation_Max_Frequency'...
                    'Standard_Deviation_Mean_Frequency' 'Dom_Freq_Slope' 'Mean_Freq_Slope'...
                    'PC_Mean_Slope' 'PC_Max_Slope' 'PC_Min_Slope' 'Patient_To_Clinician_CountRatio'...
                    'Patient_To_Other_CountRatio'};
                analysisTableSpeechDetailsPartition2.Properties.VariableNames = {'Speech_Epoch_Number'...
                    'Speech_Start_Time' 'Speech_End_Time' 'Speech_Epoch_Duration'...
                    'Speech_Epoch_Max_Frequency' 'Speech_Epoch_Mean_Frequency',...
                    'Mean_Perceptual_Spectral_Centroid','Std_Perceptual_Spectral_Centroid'...
                    ,'Max_Perceptual_Spectral_Centroid','Min_Perceptual_Spectral_Centroid'...
                    'PSD_Skew' 'PSD_Kurtosis'  'Mean_ZC_Waveform', 'Max_ZC_Waveform',...
                    'Min_ZC_Waveform', 'Std_ZC_Waveform', 'Mean_ZC_normPSD', 'Max_ZC_normPSD',...
                    'Min_ZC_normPSD', 'Std_ZC_normPSD', 'Energy_Over_Time_Slope', ...
                    'avg_F1', 'std_F1', 'slope_F1', 'avg_F2', 'std_F2', 'slope_F2',...
                    'avg_F3', 'std_F3', 'slope_F3', 'avgMeanZCPs', 'stdMeanZCPs',  'avgMaxZCPs',...
                    'stdMaxZCPs', 'avgMinZCPs', 'stdMinZCPs', 'avgStdZCPs', 'sumStdZCPs'...
                    'medMedZCPs', 'avgMedZCPs', 'stdMedZCPs', 'medSPF', 'avgSPF', 'stdSPF',...
                    'rmsEpoch'};
                analysisTablePauseDetailsPartition2.Properties.VariableNames = {'SP_Number' 'SP_Start_Time'...
                    'SP_End_Time' 'SP_Duration'};
            else
                analysisTableSummaryPartition2 = table(0,0,0);
                analysisTableSpeechDetailsPartition2 = table(0,0,0);
                analysisTablePauseDetailsPartition2 = table(0,0,0);
                energyMatrixP2 = 0;
            end
            
            
            %% Partition 3 (161s - end)
            indP3Speech = find(SpeechStartTime > 160);
            indP3Pause = find(PauseStartTime > 160);
            
            PatientCountP3 = 0;
            ClinicianCountP3 = 0;
            OtherCountP3 = 0;
            for q=1:length(indP3Speech)
                if EpochLabel{indP3Speech(q)} == 'P'
                    PatientCountP3 = PatientCountP3 + 1;
                elseif EpochLabel{indP3Speech(q)} == 'C'
                    ClinicianCountP3 = ClinicianCountP3 + 1;
                elseif EpochLabel{indP3Speech(q)} == 'O'
                    OtherCountP3 = OtherCountP3 + 1;
                end
            end
            
            if PatientCountP3 > 0
                averageSpeechPauseLengthP3 = mean(PauseDetailsTable{1,1}.SP_Duration(indP3Pause));
                stdSpeechPauseLengthP3 = std(PauseDetailsTable{1,1}.SP_Duration(indP3Pause));
                speechPauseOccuranceTotalP3 = length(PauseDetailsTable{1,1}.SP_Number(indP3Pause));
                averageSpeechLengthP3 = mean(SpeechDetailsTable{1,1}.Speech_Epoch_Duration(indP3Speech));
                stdSpeechLengthP3 = std(SpeechDetailsTable{1,1}.Speech_Epoch_Duration(indP3Speech));
                speechOccuranceTotalP3 = length(SpeechDetailsTable{1,1}.Speech_Epoch_Number(indP3Speech));
                percentSpeechPresentP3 = (sum(SpeechDetailsTable{1,1}.Speech_Epoch_Duration(indP3Speech))/ (sum(PauseDetailsTable{1,1}.SP_Duration(indP3Pause)) + sum(SpeechDetailsTable{1,1}.Speech_Epoch_Duration(indP3Speech))))*100;
                percentPausePresentP3 = 100 - percentSpeechPresentP3;
                stdMaxFP3 = std(SpeechDetailsTable{1,1}.Speech_Epoch_Max_Frequency(indP3Speech));
                stdMeanFP3 = std(SpeechDetailsTable{1,1}.Speech_Epoch_Mean_Frequency(indP3Speech));
                domFreqFitP3 = polyfit(SpeechDetailsTable{1,1}.Speech_Start_Time(indP3Speech),SpeechDetailsTable{1,1}.Speech_Epoch_Max_Frequency(indP3Speech),1);
                meanFreqFitP3 = polyfit(SpeechDetailsTable{1,1}.Speech_Start_Time(indP3Speech),SpeechDetailsTable{1,1}.Speech_Epoch_Mean_Frequency(indP3Speech),1);
                PCmeanFitP3 = polyfit(SpeechDetailsTable{1,1}.Speech_Start_Time(indP3Speech),SpeechDetailsTable{1,1}.Mean_Perceptual_Spectral_Centroid(indP3Speech),1);
                PCmaxFitP3 = polyfit(SpeechDetailsTable{1,1}.Speech_Start_Time(indP3Speech),SpeechDetailsTable{1,1}.Max_Perceptual_Spectral_Centroid(indP3Speech),1);
                PCminFitP3 = polyfit(SpeechDetailsTable{1,1}.Speech_Start_Time(indP3Speech),SpeechDetailsTable{1,1}.Min_Perceptual_Spectral_Centroid(indP3Speech),1);
                domFreqSlopeP3 = domFreqFitP3(1);
                meanFreqSlopeP3 = meanFreqFitP3(1);
                PCmeanSlopeP3 = PCmeanFitP3(1);
                PCmaxSlopeP3 = PCmaxFitP3(1);
                PCminSlopeP3 = PCminFitP3(1);
                if ClinicianCountP3 > 0
                    PtoCRatioP3 = PatientCountP3 / ClinicianCountP3;
                else
                    PtoCRatioP3 = NaN;
                end
                if OtherCountP3 > 0
                    PtoORatioP3 = PatientCountP3 / OtherCountP3;
                else
                    PtoORatioP3 = NaN;
                end
                
                energyMatrixP3 = energyMatrix(:,indP3Speech);
                if length(energyMatrix) > 1
                    above200rawP3 = energyMatrixP3(3:end,:);
                    above500rawP3 = energyMatrixP3(6:end,:);
                    above700rawP3 = energyMatrixP3(8:end,:);
                    above1000rawP3 = energyMatrixP3(11:end,:);
                    above2000rawP3 = energyMatrixP3(21:end,:);
                    
                    above200colP3=  sum(above200rawP3);
                    above500colP3 = sum(above500rawP3);
                    above700colP3 = sum(above700rawP3);
                    above1000colP3 = sum(above1000rawP3);
                    above2000colP3 = sum(above2000rawP3);
                    
                    above200P3 = mean(above200colP3);
                    above500P3 = mean(above500colP3);
                    above700P3 = mean(above700colP3);
                    above1000P3 = mean(above1000colP3);
                    above2000P3 = mean(above2000colP3);
                else
                    above200P3 = 0;
                    above500P3 = 0;
                    above700P3 = 0;
                    above1000P3 = 0;
                    above2000P3 = 0;
                end
                
                analysisTableSummaryPartition3 = table( averageSpeechPauseLengthP3, stdSpeechPauseLengthP3,...
                    speechPauseOccuranceTotalP3, averageSpeechLengthP3, stdSpeechLengthP3, speechOccuranceTotalP3,...
                    percentPausePresentP3, percentSpeechPresentP3, above200P3, above500P3, above700P3, above1000P3,...
                    above2000P3, stdMaxFP3, stdMeanFP3, domFreqSlopeP3, meanFreqSlopeP3, PCmeanSlopeP3, PCmaxSlopeP3,...
                    PCminSlopeP3, PtoCRatioP3, PtoORatioP3);
                analysisTableSpeechDetailsPartition3 = table(SpeechDetailsTable{1,1}.Speech_Epoch_Number(indP3Speech),...
                    SpeechDetailsTable{1,1}.Speech_Start_Time(indP3Speech), SpeechDetailsTable{1,1}.Speech_End_Time(indP3Speech),...
                    SpeechDetailsTable{1,1}.Speech_Epoch_Duration(indP3Speech), SpeechDetailsTable{1,1}.Speech_Epoch_Max_Frequency(indP3Speech),...
                    SpeechDetailsTable{1,1}.Speech_Epoch_Mean_Frequency(indP3Speech), SpeechDetailsTable{1,1}.Mean_Perceptual_Spectral_Centroid(indP3Speech),...
                    SpeechDetailsTable{1,1}.Std_Perceptual_Spectral_Centroid(indP3Speech), SpeechDetailsTable{1,1}.Max_Perceptual_Spectral_Centroid(indP3Speech),...
                    SpeechDetailsTable{1,1}.Min_Perceptual_Spectral_Centroid(indP3Speech),SpeechDetailsTable{1,1}.PSD_Skew(indP3Speech),...
                    SpeechDetailsTable{1,1}.PSD_Kurtosis(indP3Speech),SpeechDetailsTable{1,1}.Mean_ZC_Waveform(indP3Speech),...
                    SpeechDetailsTable{1,1}.Max_ZC_Waveform(indP3Speech), SpeechDetailsTable{1,1}.Min_ZC_Waveform(indP3Speech),...
                    SpeechDetailsTable{1,1}.Std_ZC_Waveform(indP3Speech), SpeechDetailsTable{1,1}.Mean_ZC_normPSD(indP3Speech),...
                    SpeechDetailsTable{1,1}.Max_ZC_normPSD(indP3Speech), SpeechDetailsTable{1,1}.Min_ZC_normPSD(indP3Speech),...
                    SpeechDetailsTable{1,1}.Std_ZC_normPSD(indP3Speech), SpeechDetailsTable{1,1}.Energy_Over_Time_Slope(indP3Speech),...
                    SpeechDetailsTable{1,1}.avg_F1(indP3Speech), SpeechDetailsTable{1,1}.std_F1(indP3Speech),...
                    SpeechDetailsTable{1,1}.slope_F1(indP3Speech), SpeechDetailsTable{1,1}.avg_F2(indP3Speech),...
                    SpeechDetailsTable{1,1}.std_F2(indP3Speech), SpeechDetailsTable{1,1}.slope_F2(indP3Speech),...
                    SpeechDetailsTable{1,1}.avg_F3(indP3Speech), SpeechDetailsTable{1,1}.std_F3(indP3Speech),...
                    SpeechDetailsTable{1,1}.slope_F3(indP3Speech),  SpeechDetailsTable{1,1}.avgMeanZCPs(indP3Speech), ...
                    SpeechDetailsTable{1,1}.stdMeanZCPs(indP3Speech), SpeechDetailsTable{1,1}.avgMaxZCPs(indP3Speech),...
                    SpeechDetailsTable{1,1}.stdMaxZCPs(indP3Speech), SpeechDetailsTable{1,1}.avgMinZCPs(indP3Speech), ...
                    SpeechDetailsTable{1,1}.stdMinZCPs(indP3Speech), SpeechDetailsTable{1,1}.avgStdZCPs(indP3Speech),...
                    SpeechDetailsTable{1,1}.sumStdZCPs(indP3Speech), SpeechDetailsTable{1,1}.medMedZCPs(indP3Speech),...
                    SpeechDetailsTable{1,1}.avgMedZCPs(indP3Speech), SpeechDetailsTable{1,1}.stdMedZCPs(indP3Speech),...
                    SpeechDetailsTable{1,1}.medSPF(indP3Speech), SpeechDetailsTable{1,1}.avgSPF(indP3Speech),...
                    SpeechDetailsTable{1,1}.stdSPF(indP3Speech), SpeechDetailsTable{1,1}.rmsEpoch(indP3Speech));
                analysisTablePauseDetailsPartition3 = table(PauseDetailsTable{1,1}.SP_Number(indP3Pause), PauseDetailsTable{1,1}.SP_Start_Time(indP3Pause),...
                    PauseDetailsTable{1,1}.SP_End_Time(indP3Pause), PauseDetailsTable{1,1}.SP_Duration(indP3Pause));
                analysisTableSummaryPartition3.Properties.VariableNames = {'Average_SP_Length' 'Standard_Deviation_of_SP_Length'...
                    'SP_Total_Occurance' 'Average_Speech_Epoch_Length', ...
                    'Standard_Deviation_of_Speech_Epoch_Length' 'Speech_Epoch_Total_Occurance'...
                    'Percent_Pause_Present' 'Percent_Speech_Present' 'Percent_Above_200Hz'...
                    'Percent_Above_500Hz' 'Percent_Above_700Hz' 'Percent_Above_1000Hz'...
                    'Percent_Above_2000Hz' 'Standard_Deviation_Max_Frequency'...
                    'Standard_Deviation_Mean_Frequency' 'Dom_Freq_Slope' 'Mean_Freq_Slope'...
                    'PC_Mean_Slope' 'PC_Max_Slope' 'PC_Min_Slope' 'Patient_To_Clinician_CountRatio'...
                    'Patient_To_Other_CountRatio'};
                analysisTableSpeechDetailsPartition3.Properties.VariableNames = {'Speech_Epoch_Number'...
                    'Speech_Start_Time' 'Speech_End_Time' 'Speech_Epoch_Duration'...
                    'Speech_Epoch_Max_Frequency' 'Speech_Epoch_Mean_Frequency',...
                    'Mean_Perceptual_Spectral_Centroid','Std_Perceptual_Spectral_Centroid'...
                    ,'Max_Perceptual_Spectral_Centroid','Min_Perceptual_Spectral_Centroid'...
                    'PSD_Skew' 'PSD_Kurtosis'  'Mean_ZC_Waveform', 'Max_ZC_Waveform',...
                    'Min_ZC_Waveform', 'Std_ZC_Waveform', 'Mean_ZC_normPSD', 'Max_ZC_normPSD',...
                    'Min_ZC_normPSD', 'Std_ZC_normPSD', 'Energy_Over_Time_Slope', ...
                    'avg_F1', 'std_F1', 'slope_F1', 'avg_F2', 'std_F2', 'slope_F2',...
                    'avg_F3', 'std_F3', 'slope_F3', 'avgMeanZCPs', 'stdMeanZCPs',  'avgMaxZCPs',...
                    'stdMaxZCPs', 'avgMinZCPs', 'stdMinZCPs', 'avgStdZCPs', 'sumStdZCPs'...
                    'medMedZCPs', 'avgMedZCPs', 'stdMedZCPs', 'medSPF', 'avgSPF', 'stdSPF',...
                    'rmsEpoch'};
                analysisTablePauseDetailsPartition3.Properties.VariableNames = {'SP_Number' 'SP_Start_Time'...
                    'SP_End_Time' 'SP_Duration'};
            else
                analysisTableSummaryPartition3 = table(0,0,0);
                analysisTableSpeechDetailsPartition3 = table(0,0,0);
                analysisTablePauseDetailsPartition3 = table(0,0,0);
                energyMatrixP3 = 0;
            end
        else
            analysisTableSummaryPartition1 = table(0,0,0);
            analysisTableSpeechDetailsPartition1 = table(0,0,0);
            analysisTablePauseDetailsPartition1 = table(0,0,0);
            energyMatrixP1 = 0;
            analysisTableSummaryPartition2 = table(0,0,0);
            analysisTableSpeechDetailsPartition2 = table(0,0,0);
            analysisTablePauseDetailsPartition2 = table(0,0,0);
            energyMatrixP2 = 0;
            analysisTableSummaryPartition3 = table(0,0,0);
            analysisTableSpeechDetailsPartition3 = table(0,0,0);
            analysisTablePauseDetailsPartition3 = table(0,0,0);
            energyMatrixP3 = 0;
        end
    else
        analysisTableSummaryPartition1 = table(0,0,0);
        analysisTableSpeechDetailsPartition1 = table(0,0,0);
        analysisTablePauseDetailsPartition1 = table(0,0,0);
        energyMatrixP1 = 0;
        analysisTableSummaryPartition2 = table(0,0,0);
        analysisTableSpeechDetailsPartition2 = table(0,0,0);
        analysisTablePauseDetailsPartition2 = table(0,0,0);
        energyMatrixP2 = 0;
        analysisTableSummaryPartition3 = table(0,0,0);
        analysisTableSpeechDetailsPartition3 = table(0,0,0);
        analysisTablePauseDetailsPartition3 = table(0,0,0);
        energyMatrixP3 = 0;
    end
    %% Append 9 new tables and 3 new energy matrices
    save(matFilename,'analysisTableSummaryPartition1', 'analysisTableSummaryPartition2', 'analysisTableSummaryPartition3',...
        'analysisTableSpeechDetailsPartition1', 'analysisTableSpeechDetailsPartition2', 'analysisTableSpeechDetailsPartition3',...
        'analysisTablePauseDetailsPartition1', 'analysisTablePauseDetailsPartition2','analysisTablePauseDetailsPartition3',...
        'energyMatrixP1','energyMatrixP2', 'energyMatrixP3', '-append')
    %% Clear goddam everything
    clearvars -except matData baseFileName filePattern fullFileName matFiles myFolder i
end