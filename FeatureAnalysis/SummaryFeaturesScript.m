
clc, clear all
%% Initial Option

startPrompt = 'Export Excel spreadsheet? [0] for NO, [1] for YES: ';
choice = input(startPrompt);

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

%% Feature Analysis
% Extracting Summary values for each patient on concatenating patient Dx
% and summary features into one matrix

j=1;
w=1;
for i = 1:length(matFiles)
    if width(matData(i).analysisTableSummaryPatient) == 14
        pDx(j,:) = extractfield(matData(i),'patientDx');
        feat(j,:) = extractfield(matData(i),'analysisTableSummaryPatient');
        audioName(j) = extractfield(matData(i),'audioName');
        avgSPDomFreq(j) = mean(matData(i).analysisTableSpeechDetailsPatient.Speech_Epoch_Max_Frequency);
        avgSPMeanFreq(j) = mean(matData(i).analysisTableSpeechDetailsPatient.Speech_Epoch_Mean_Frequency);
        maxSPDomFreq(j) = max(matData(i).analysisTableSpeechDetailsPatient.Speech_Epoch_Max_Frequency);
        maxSPMeanFreq(j) = max(matData(i).analysisTableSpeechDetailsPatient.Speech_Epoch_Mean_Frequency);
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
        
        summaryFeatures(j,1) = feat{j,1}.Initial_Speech_Lag;
        summaryFeatures(j,2) = feat{j,1}.Final_Speech_Lag;
        summaryFeatures(j,3) = feat{j,1}.Average_SP_Length;
        summaryFeatures(j,4) = feat{j,1}.Standard_Deviation_of_SP_Length;
        summaryFeatures(j,5) = feat{j,1}.SP_Total_Occurance;
        summaryFeatures(j,6) = feat{j,1}.Average_Speech_Epoch_Length;
        summaryFeatures(j,7) = feat{j,1}.Standard_Deviation_of_Speech_Epoch_Length;
        summaryFeatures(j,8) = feat{j,1}.Percent_Pause_Present;
        summaryFeatures(j,9) = above200;
        summaryFeatures(j,10) = above500;
        summaryFeatures(j,11) = above700;
        summaryFeatures(j,12) = above1000;
        summaryFeatures(j,13) = above2000;
        summaryFeatures(j,14) = avgSPDomFreq(j);
        summaryFeatures(j,15) = avgSPMeanFreq(j);
        summaryFeatures(j,16) = maxSPDomFreq(j);
        summaryFeatures(j,17) = maxSPMeanFreq(j);
        summaryFeatures(j,18) = feat{j,1}.Standard_Deviation_Max_Frequency;
        summaryFeatures(j,19) = feat{j,1}.Standard_Deviation_Mean_Frequency;
        
        %summaryFeatures(i,15) = audioName{i};
        
        extrPDx(j,1) = pDx(j,1); %PID
        extrPDx(j,2) = pDx(j,29); %childage
        extrPDx(j,3) = pDx(j,41); %NSp2PB
        extrPDx(j,4) = pDx(j,42); %sp2fsumw
        extrPDx(j,5) = pDx(j,46); %internalTmerged
        extrPDx(j,6) = pDx(j,48); %PTSDSX
        extrPDx(j,7) = pDx(j,70); %ExternalTmerged
        extrPDx(j,8) = pDx(j,73); %INTdx
        extrPDx(j,9) = pDx(j,80); %ChildGender
        extrPDx(j,10) = pDx(j,126); %SP2FVsum
        extrPDx(j,11) = pDx(j,225); %NSp2pV
        j = j + 1;
        clear above200 above500 above700 above1000 above2000
    else
        noSpeech{w} = matData(i).audioName;
        w = w + 1;
    end
end
Features = [extrPDx summaryFeatures];
%% 10s Background Noise Debug

%Features(:,12) = Features(:,12) - 10;

%indNegative = find(Features(:,12) < 0);
%PIDDebug = Features(indNegative,1);

%% NaN PID files debug

for z = 1:length(Features(:,1))
    if(isnan(Features(z,1)) == 1)
        audioName{z}
    end
end
%}


%% Internal Diagnosis Analysis
ind0 = find(Features(:,8) == 0);
ind1 = find(Features(:,8) == 1);


FeatIntDx0 = Features(ind0,:);
FeatIntDx1 = Features(ind1,:);




x = 1;
for j = 12:25
    avgArray0(x) = mean(FeatIntDx0(:,j));
    avgArray1(x) = mean(FeatIntDx1(:,j));
    x = x + 1;
end
Variables = ["PID", "childage", "NSp2PB", "sp2fsumw", "internalTmerged",...
    "PTSDSX", "ExternalTmerged", "INTdx", "ChildGender", "SP2FVsum",...
    "NSp2pV", "Initial_Speech_Lag", "Final_Speech_Lag", "Average_SPause_Length",...
    "STD_SPause_Length", "SPause_Total_Count", "Avg_Speech_Epoch_Length",...
    "STD_Speech_Epoch_Length",...
    "Percent_Pause_Present", "Percent_Above_200Hz", "Percent_Above_500Hz", "Percent_Above_700Hz", "Percent_Above_1000Hz"...
    "Percent_Above_2000Hz","Avg_Epoch_Dominant_Freq","Avg_Epoch_Mean_Freq",...
    "Max_Epoch_Dominant_Freq","Max_Epoch_Mean_Freq", "STD_Dominant_Freq",...
    "STD_Mean_Freq"];
indFeatSec = [12:18];
indFeatPerc = [19:24];

SecFeatIntDx0 = FeatIntDx0(:,indFeatSec);
PercFeatIntDx0 = FeatIntDx0(:,indFeatPerc);


SecFeatIntDx1 = FeatIntDx1(:,indFeatSec);
PercFeatIntDx1 = FeatIntDx1(:,indFeatPerc);

%normalizing all values within their column
for q=1:length(SecFeatIntDx0(1,:))
    SecFeatIntDx0(:,q) = zscore(SecFeatIntDx0(:,q));
end

for q=1:length(SecFeatIntDx1(1,:))
    SecFeatIntDx1(:,q) = zscore(SecFeatIntDx1(:,q));
end

%SecFeatIntDx0(:,1) = SecFeatIntDx0(:,1) - 10;
%SecFeatIntDx1(:,1) = SecFeatIntDx1(:,1) - 10;

featTitleSec = Variables(indFeatSec);
featTitlePerc = Variables(indFeatPerc);
indForIntDx0Sec = [1:2:2*length(indFeatSec)];
indForIntDx1Sec = [2:2:2*(length(indFeatSec) + 1)];
indForIntDx0Perc = [1:2:2*(length(indFeatPerc))];
indForIntDx1Perc = [2:2:2*(length(indFeatPerc) + 1)];

for r=1:length(indFeatSec)
    featTitleFullSec{indForIntDx0Sec(r)} = char(['intDx0:',Variables(indFeatSec(r))]);
    featTitleFullSec{indForIntDx1Sec(r)} = char(['intDx1:',Variables(indFeatSec(r))]);
end

for r=1:length(indFeatPerc)
    featTitleFullPerc{indForIntDx0Perc(r)} = char(['indDx0:', Variables(indFeatPerc(r))]);
    featTitleFullPerc{indForIntDx1Perc(r)} = char(['indDx1:', Variables(indFeatPerc(r))]);
end

f = 1;
for q = 1:length(indFeatSec)
    BigAssArray(:,q) = [SecFeatIntDx0(:,q); SecFeatIntDx1(:,q)];
    g(:,q) = [(f)*ones(size(SecFeatIntDx0(:,q))); (f+1)*ones(size(SecFeatIntDx1(:,q)))];
    f = f + 2;
end

c = 1;
for s = 1:length(indFeatPerc)
    BigAssArray2(:,s) = [PercFeatIntDx0(:,s); PercFeatIntDx1(:,s)];
    g2(:,s) = [(c)*ones(size(PercFeatIntDx0(:,s))); (c+1)*ones(size(PercFeatIntDx1(:,s)))];
    c = c + 2;
end

x = reshape(BigAssArray,[],1);
gg = reshape(g,[],1);

x2 = reshape(BigAssArray2,[],1);
gg2 = reshape(g2,[],1);

%x = [BigAssArray(:,1);BigAssArray(:,2);BigAssArray(:,3);BigAssArray(:,4);BigAssArray(:,5);BigAssArray(:,6);];%%
%gg = [g(:,1);g(:,2);g(:,3);g(:,4);g(:,5);g(:,6);];

%x2 = [BigAssArray2(:,1);BigAssArray2(:,2);BigAssArray2(:,3);BigAssArray2(:,4)];
%gg2 = [g2(:,1);g2(:,2);g2(:,3);g2(:,4)];

figure
boxplot(x,gg,'Labels',featTitleFullSec)
%{
{'IntDx0: Init Speech Lag', 'IntDx1: Init Speech Lag',...
    'IntDx0: Fin Speech Lag', 'IntDx1: Fin Speech Lag',...
    'IntDx0: Avg SPause Length', 'IntDx1: Avg SPause Length',...
    'IntDx0: Std SPause Length', 'IntDx1: Std SPause Length', ...
    'IntDx0: Avg Epoch Length', 'IntDx1: Avg Epoch Length',...
    'IntDx0: Std Epoch Length', 'IntDx1: Std Epoch Length'})
%}
set(gca,'FontSize',10,'XTickLabelRotation',45)
ylabel('Zscore')
theTitle = ['PATIENT Epoch Filter: IntDx Feature Boxplots (IntDx0 N = ', num2str(length(FeatIntDx0(:,1))),', IntDx1 N = ', num2str(length(FeatIntDx1(:,1))),')'];
title(theTitle)

figure
boxplot(x2,gg2,'Labels',featTitleFullPerc)
%{'IntDx0: % Pause Present', 'IntDx1: % Pause Present', 'IntDx0: % Speech Present', 'IntDx1: % Speech Present', 'IntDx0: % Freq Below 500Hz', 'IntDx1: % Freq Below 500Hz', 'IntDx0: % Above 500Hz', 'IntDx1: % Above 500Hz'})
set(gca,'FontSize',10,'XTickLabelRotation',45)
ylabel('percent')
title(theTitle)


%SecFeatIntDx
%SecFeatIntDx0_1 = NaN(48,12);


%SecFeatIntDx0_1(:,1:2:12) = SecFeatIntDx0(:,1:6);
%SecFeatIntDx0_1(:,2:2:12) = SecFeatIntDx1(:,1:6);
%}
%{
for w=1:length(SecFeatIntDx0(1,:))
    SecFeatIntDx0_1(:,w) = SecFeatIntDx0(:,w);
    SecFeatIntDx0_1(:,w+1) = SecFeatIntDx1(:,w);
end
%}
%{
figure
boxplot([SecFeatIntDx0,SecFeatIntDx1])
title('INTDx = 0')
ylabel('Seconds')
figure
boxplot(SecFeatIntDx1,featTitleSec)
title('INTDx = 1')
ylabel('Seconds')
figure
boxplot(PercFeatIntDx0,featTitlePerc)
title('IntDx = 0')
ylabel('Percent')
figure
boxplot(PercFeatIntDx1,featTitlePerc)
title('IntDx = 1')
ylabel('Percent')
%}

if choice == 1
    XlFeatures = [Variables; Features];
    excelFile = ['exportedSpreadSheets/export_',datestr(now, 'dd-mmm-yyyy_HH_MM_SS_'),'.xlsx'];
    xlswrite(excelFile,XlFeatures)
end

%% Plot time




