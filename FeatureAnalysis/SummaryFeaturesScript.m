clc, clear all, close all
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


for i = 1:length(matFiles)
    pDx(i,:) = extractfield(matData(i),'patientDx');
	feat(i,:) = extractfield(matData(i),'analysisTableSummary');
    audioName(i) = extractfield(matData(i),'audioName');
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
    %summaryFeatures(i,15) = audioName{i};
    
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
%% 10s Background Noise Debug

%Features(:,12) = Features(:,12) - 10;

%indNegative = find(Features(:,12) < 0);
%PIDDebug = Features(indNegative,1);

%% NaN PID files debug
%{
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
Variables = ["PID", "childage", "NSp2PB", "sp2fsumw", "internalTmerged", "PTSDSX", "ExternalTmerged", "INTdx", "ChildGender", "SP2FVsum", "NSp2pV", "Initial Speech Lag", "Final Speech Lag", "Average SP Length", "Standard Deviation of SP Length", "SP Total Occurance", "Average Speech Epoch Length", "Standard Deviation of Speech Epoch Length", "Speech Epoch Total Occurance", "Percent Pause Present", "Percent Speech Present", "Percent Freq Below 500Hz", "Percent Above 500Hz", "Standard Deviation Max Frequency", "Standard Deviation Mean Frequency"];
indFeatSec = [12:15 17 18];
indFeatPerc = [20:23];

SecFeatIntDx0 = FeatIntDx0(:,indFeatSec);
PercFeatIntDx0 = FeatIntDx0(:,indFeatPerc);


SecFeatIntDx1 = FeatIntDx1(:,indFeatSec);
PercFeatIntDx1 = FeatIntDx1(:,indFeatPerc);

%SecFeatIntDx0(:,1) = SecFeatIntDx0(:,1) - 10;
%SecFeatIntDx1(:,1) = SecFeatIntDx1(:,1) - 10;

featTitleSec = Variables(indFeatSec);
featTitlePerc = Variables(indFeatPerc);
f = 1;
for q = 1:6
    
    BigAssArray(:,q) = [SecFeatIntDx0(:,q); SecFeatIntDx1(:,q)];
    g(:,q) = [(f)*ones(size(SecFeatIntDx0(:,q))); (f+1)*ones(size(SecFeatIntDx1(:,q)))];
    f = f + 2;
end

c = 1;
for s = 1:4
    
    BigAssArray2(:,s) = [PercFeatIntDx0(:,s); PercFeatIntDx1(:,s)];
    g2(:,s) = [(c)*ones(size(PercFeatIntDx0(:,s))); (c+1)*ones(size(PercFeatIntDx1(:,s)))];
    c = c + 2;
end



x = [BigAssArray(:,1);BigAssArray(:,2);BigAssArray(:,3);BigAssArray(:,4);BigAssArray(:,5);BigAssArray(:,6);];
gg = [g(:,1);g(:,2);g(:,3);g(:,4);g(:,5);g(:,6);];

x2 = [BigAssArray2(:,1);BigAssArray2(:,2);BigAssArray2(:,3);BigAssArray2(:,4)];
gg2 = [g2(:,1);g2(:,2);g2(:,3);g2(:,4)];

figure
boxplot(x,gg,'Labels',{'IntDx0: Init Speech Lag', 'IntDx1: Init Speech Lag', 'IntDx0: Fin Speech Lag', 'IntDx1: Fin Speech Lag', 'IntDx0: Avg SP Length', 'IntDx1: Avg SP Length', 'IntDx0: Std SP Length', 'IntDx1: Std SP Length', 'IntDx0: Avg Epoch Length', 'IntDx1: Avg Epoch Length', 'IntDx0: Std Epoch Length', 'IntDx1: Std Epoch Length'})
set(gca,'FontSize',10,'XTickLabelRotation',45)
ylabel('seconds')

figure
boxplot(x2,gg2,'Labels',{'IntDx0: % Pause Present', 'IntDx1: % Pause Present', 'IntDx0: % Speech Present', 'IntDx1: % Speech Present', 'IntDx0: % Freq Below 500Hz', 'IntDx1: % Freq Below 500Hz', 'IntDx0: % Above 500Hz', 'IntDx1: % Above 500Hz'})
set(gca,'FontSize',10,'XTickLabelRotation',45)
ylabel('percent')

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


    

