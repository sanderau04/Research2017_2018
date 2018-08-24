%% correlation_script.m produces all PDx vs feature spearman correlations 
% with un-partitioned patient mat files. 

%% Required patient mat file variables: 
% patientDx, energyMatrixPatientOnly, analysisTableSpeechDetailsPatient,
% analysisTableSummaryPatient, 

clear all, clc
[~, titles] = xlsread('Excel/mcginnisdissertation8.2.16.UPDATED.VALUES.xlsx');
%% Assign Speech code indices you wish to correlate
PdxIndices = [29, 41, 42, 46, 48, 70, 71, 73, 77, 86, 87, 94:102, 103:118, 119, 126, 225];
for y=1:length(PdxIndices)
    PdxName{y} = titles{1,PdxIndices(y)};
end

%PdxName = {'childage', 'NSp2PB', 'sp2fsumw', 'internalTmerged', 'PTSDSX', 'ExternalTmerged', 'SP2FVsum', 'NSP2PV'};
%% Read in folder with patient mat files
myFolder = uigetdir('D:\Documents\Research2017\MATLAB','Pick a folder containing mat files');

if ~isdir(myFolder)
    errorMessage = sprintf('Error: The following folder does not exist:\n%s', myFolder);
    uiwait(warndlg(errorMessage));
    return;
end

filePattern = fullfile(myFolder, '*.mat');
matFiles = dir(filePattern);

%% Extract features and perform spearman correlations on all PDx

% Itereate through each patient diagnosis initialized above
for j =1:length(PdxIndices)
    
    q = 1;
    % Read in patient mat files with valid, non missing PDx values for
    % specific correlation
    for k = 1:length(matFiles)
        baseFileName = matFiles(k).name;
        fullFileName = fullfile(myFolder, baseFileName);
        tempMatData(k) = load(fullFileName);
        if ((isnan(tempMatData(k).patientDx(PdxIndices(j))) == 0) && (tempMatData(k).patientDx(PdxIndices(j))~= 999))
            matData(q) = tempMatData(k);
            q = q + 1;
        end
        clear tempMatData
    end
    u = 1;
    s = 1;
    for i = 1:length(matData)
        % Only include a patient file if patient epochs with respective
        % features exist
        if width(matData(i).analysisTableSummaryPatient) >= 14
            currentPdx(u) = matData(i).patientDx(PdxIndices(j));
            audioName{u,j} = str2num(matData(i).audioName);
            feat = extractfield(matData(i),'analysisTableSummaryPatient');
            avgSPDomFreq(u) = mean(matData(i).analysisTableSpeechDetailsPatient.Speech_Epoch_Max_Frequency);
            avgSPMeanFreq(u) = mean(matData(i).analysisTableSpeechDetailsPatient.Speech_Epoch_Mean_Frequency);
            maxSPDomFreq(u) = max(matData(i).analysisTableSpeechDetailsPatient.Speech_Epoch_Max_Frequency);
            maxSPMeanFreq(u) = max(matData(i).analysisTableSpeechDetailsPatient.Speech_Epoch_Mean_Frequency);
            energyMatrix = matData(i).energyMatrixPatientOnly;
        if length(energyMatrix) > 1
            above200raw = energyMatrix(3:end,:);
            above500raw = energyMatrix(6:end,:);
            above700raw = energyMatrix(8:end,:);
            above1000raw = energyMatrix(11:end,:);
            above2000raw = energyMatrix(21:end,:);
            
            
            above200col=  sum(above200raw);
            above500col = sum(above500raw);
            above700col = sum(above700raw);
            above1000col = sum(above1000raw);
            above2000col = sum(above2000raw);
            
            above200 = mean(above200col);
            above500 = mean(above500col);
            above700 = mean(above700col);
            above1000 = mean(above1000col);
            above2000 = mean(above2000col);
        else
            above200 = 0;
            above500 = 0;
            above700 = 0;
            above1000 = 0;
            above2000 = 0;
        end

            summaryFeatures(u,1) = feat{1,1}.Initial_Speech_Lag;
            summaryFeatures(u,2) = feat{1,1}.Final_Speech_Lag;
            summaryFeatures(u,3) = feat{1,1}.Average_SP_Length;
            summaryFeatures(u,4) = feat{1,1}.Standard_Deviation_of_SP_Length;
            summaryFeatures(u,5) = feat{1,1}.SP_Total_Occurance;
            summaryFeatures(u,6) = feat{1,1}.Average_Speech_Epoch_Length;
            summaryFeatures(u,7) = feat{1,1}.Standard_Deviation_of_Speech_Epoch_Length;
            summaryFeatures(u,8) = feat{1,1}.Percent_Pause_Present;
            summaryFeatures(u,9) = above200;
            summaryFeatures(u,10) = above500;
            summaryFeatures(u,11) = above700;
            summaryFeatures(u,12) = above1000;
            summaryFeatures(u,13) = above2000;
            summaryFeatures(u,14) = avgSPDomFreq(u);
            summaryFeatures(u,15) = avgSPMeanFreq(u);
            summaryFeatures(u,16) = maxSPDomFreq(u);
            summaryFeatures(u,17) = maxSPMeanFreq(u);
            summaryFeatures(u,18) = mean(matData(i).analysisTableSpeechDetailsPatient.Mean_Perceptual_Spectral_Centroid);
            summaryFeatures(u,19) = mean(matData(i).analysisTableSpeechDetailsPatient.Max_Perceptual_Spectral_Centroid);
            summaryFeatures(u,20) = mean(matData(i).analysisTableSpeechDetailsPatient.Min_Perceptual_Spectral_Centroid);
            summaryFeatures(u,21) = feat{1,1}.Standard_Deviation_Max_Frequency;
            summaryFeatures(u,22) = feat{1,1}.Standard_Deviation_Mean_Frequency;
            summaryFeatures(u,23) = mean(matData(i).analysisTableSpeechDetailsPatient.Std_Perceptual_Spectral_Centroid);
            summaryFeatures(u,24) = feat{1,1}.Dom_Freq_Slope;
            summaryFeatures(u,25) = feat{1,1}.Mean_Freq_Slope;
            summaryFeatures(u,26) = feat{1,1}.PC_Mean_Slope;
            summaryFeatures(u,27) = feat{1,1}.PC_Max_Slope;
            summaryFeatures(u,28) = feat{1,1}.PC_Min_Slope;
            
            u = u + 1;
        else
            noPatientEpochs(j,s) = str2num(matData(i).audioName);
            s = s + 1;
        end
        clearvars -except summaryFeatures currentPdx audioName...
            avgSPDomFreq avgSPMeanFreq maxSPDomFreq maxSPMeanFreq...
            T matFiles myFolder filePattern PdxIndices PdxName j...
            noPatientEpochs matData i u s 
    end
    N(j) = length(summaryFeatures(:,1));
    
    % Perform spearman correlations on all summaryFeatures
    for w=1:length(summaryFeatures(1,:))
        [rho(w), pval(w)] = corr(summaryFeatures(:,w),currentPdx','type','spearman');
    end
    
    rho = [rho N(j)];
    pval = [pval N(j)];
    
    RowNames = {'Initial_Speech_Lag', 'Final_Speech_Lag', 'Avg_SPause_Length','STD_SPause_Length',...
        'SPause_Total_Count', 'Avg_Speech_Epoch_Length', 'Std_of_Speech_Epoch_Length',...
        'Percent_Pause_Present', 'Percent_Freq_Above_200Hz', 'Percent_Above_500Hz','Percent_Above_700Hz',...
        'Percent_Above_1000Hz','Percent_Above_2000Hz','Avg_Epoch_Dominant_Freq','Avg_Epoch_Mean_Freq',...
        'Max_Epoch_Dominant_Freq','Max_Epoch_Mean_Freq','Avg_Epoch_Mean_Spectral_Centroid',...
        'Avg_Epoch_Max_Spectral_Centroid','Avg_Epoch_Min_Spectral_Centroid' ...
        'Std_Max_Frequency','Std_Mean_Frequency','Std_SpectralCentroid',...
        'Dom_Freq_Slope', 'Mean_Freq_Slope', 'Mean_Spectral_Centroid_Slope',...
        'Max_Spectral_Centroid_Slope', 'Min_Spectral_Centroid_Slope','N'};
    

    Variables{1} = [PdxName{j},'_rho'];
    Variables{2} = [PdxName{j}, '_pValue'];
    
    % Display all correlations in table T
    if j == 1
        T{j} = table(rho',pval','VariableNames', Variables, 'RowNames', RowNames);
        
    else
        T{j} = table(rho',pval','VariableNames', Variables);
    end
    clearvars -except T matFiles myFolder filePattern PdxIndices PdxName j noPatientEpochs
end

T = [T{:}];