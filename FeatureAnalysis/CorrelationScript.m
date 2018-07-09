clear all, clc
[~, titles] = xlsread('Excel\mcginnisdissertation8.2.16.UPDATED.VALUES.xlsx');
%% Assign Speech code values you wish to correlate
PdxIndices = [29, 41, 42, 46, 48, 70, 71, 73, 77, 86, 87, 94:102, 103:118, 119, 126, 225];
for y=1:length(PdxIndices)
    PdxName{y} = titles{1,PdxIndices(y)};
end

%PdxName = {'childage', 'NSp2PB', 'sp2fsumw', 'internalTmerged', 'PTSDSX', 'ExternalTmerged', 'SP2FVsum', 'NSP2PV'};

myFolder = uigetdir('D:\Documents\Research2017\MATLAB','Pick a folder containing mat files');

if ~isdir(myFolder)
    errorMessage = sprintf('Error: The following folder does not exist:\n%s', myFolder);
    uiwait(warndlg(errorMessage));
    return;
end

filePattern = fullfile(myFolder, '*.mat');
matFiles = dir(filePattern);

%%
for j =1:length(PdxIndices)
    
    q = 1;
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
    
    for i = 1:length(matData)
        currentPdx(i) = matData(i).patientDx(PdxIndices(j));
        audioName{i,j} = str2num(matData(i).audioName);
        feat = extractfield(matData(i),'analysisTableSummaryPatient');
        avgSPDomFreq(i) = mean(matData(i).analysisTableSpeechDetailsPatient.Speech_Epoch_Max_Frequency);
        stdSPDomFreq(i) = std(matData(i).analysisTableSpeechDetailsPatient.Speech_Epoch_Max_Frequency);
        avgSPMeanFreq(i) = mean(matData(i).analysisTableSpeechDetailsPatient.Speech_Epoch_Mean_Frequency);
        stdSPMeanFreq(i) = std(matData(i).analysisTableSpeechDetailsPatient.Speech_Epoch_Mean_Frequency);
        maxSPDomFreq(i) = max(matData(i).analysisTableSpeechDetailsPatient.Speech_Epoch_Max_Frequency);
        maxSPMeanFreq(i) = max(matData(i).analysisTableSpeechDetailsPatient.Speech_Epoch_Mean_Frequency);
        
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
        summaryFeatures(i,13) = avgSPDomFreq(i);
        summaryFeatures(i,14) = avgSPMeanFreq(i);
        summaryFeatures(i,15) = maxSPDomFreq(i);
        summaryFeatures(i,16) = maxSPMeanFreq(i);
        summaryFeatures(i,17) = feat{1,1}.Standard_Deviation_Max_Frequency;
        summaryFeatures(i,18) = feat{1,1}.Standard_Deviation_Mean_Frequency;
        
    end
    N(j) = length(summaryFeatures(:,1));
    
    for w=1:18
        [rho(w), pval(w)] = corr(summaryFeatures(:,w),currentPdx','type','spearman');
    end
    
    rho = [rho N(j)];
    pval = [pval N(j)];
    
    RowNames = {'Initial_Speech_Lag', 'Final_Speech_Lag', 'Average_SP_Length','Standard_Deviation_of_SP_Length',...
        'SpeechPause_Total_Occurance', 'Average_Speech_Epoch_Length', 'Std_of_Speech_Epoch_Length', 'Speech_Epoch_Total_Occurance',...
        'Percent_Pause_Present', 'Percent_Speech_Present', 'Percent_Freq_Below_500Hz', 'Percent_Above_500Hz',...
        'Avg_Epoch_Dominant_Freq','Avg_Epoch_Mean_Freq','Max_Epoch_Dominant_Freq','Max_Epoch_Mean_Freq',...
        'Standard_Deviation_Max_Frequency','Standard_Deviation_Mean_Frequency', 'N'};
    

    Variables{1} = [PdxName{j},'_rho'];
    Variables{2} = [PdxName{j}, '_pValue'];
    
    if j == 1
        T{j} = table(rho',pval','VariableNames', Variables, 'RowNames', RowNames);
        
    else
        T{j} = table(rho',pval','VariableNames', Variables);
    end
    clear Variables rho pval summaryFeatures feat avgSPDomFreq stdSPDomFreq avgSPMeanFreq stdSPMeanFreq currentPdx matData
end

T = [T{:}];