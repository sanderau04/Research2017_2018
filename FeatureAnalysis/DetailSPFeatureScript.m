clc, clear all, close all
%% Initial Option
%startPrompt = 'Export Excel spreadsheet? [0] for NO, [1] for YES: ';
%choice = input(startPrompt);

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
%% Feature Extraction

k = 1;
j = 1;
SPStartTime0 = NaN(300,48);
SPDuration0 = NaN(300,48);
SPStartTime1 = NaN(300,31);
SPDuration1 = NaN(300,31);
q = 1;
w = 1;
for i = 1:length(matFiles)
    clear SPStartTime
    clear SPDuration
    pDx(i,:) = extractfield(matData(i),'patientDx');
    feat(i,:) = extractfield(matData(i),'analysisTablePauseDetails');
    SPStartTime = feat{i,1}.SP_Start_Time;
    SPDuration = feat{i,1}.SP_Duration;

    
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
   
    %{
        if(extrPDx(i,8) == 0)
        for x = 1:length(feat{i,1}.SP_Start_Time)
            SPStartTime0(x,q) = feat{i,1}.SP_Start_Time(x);
        end
  
        for y = 1: length(feat{i,1}.SP_Duration)
            SPDuration0(y,q) = feat{i,1}.SP_Duration(y);
        end
    
        %SPStartTime0(:,i) = zscore(SPStartTime0(:,i));
        %SPDuration0(:,i) = zscore(SPDuration0(:,i));
        PID0(q) = extrPDx(i,1);
        q = q + 1;
    else
        for x = 1:length(feat{i,1}.SP_Start_Time)
            SPStartTime1(x,w) = feat{i,1}.SP_Start_Time(x);
        end
  
        for y = 1: length(feat{i,1}.SP_Duration)
            SPDuration1(y,w) = feat{i,1}.SP_Duration(y);
        end
    
        %SPStartTime1(:,i) = zscore(SPStartTime1(:,i));
        %SPDuration1(:,i) = zscore(SPDuration1(:,i));
        PID1(w) = extrPDx(i,1);
        w = w + 1;
    end
%}
   
    if (extrPDx(i,8) == 0)
        figure0 = figure(1);
        %title('Speech Pause Duration Over 3min Speech Task INTDX = 0')
        
        xlabel('SP Start Time (s)')
        ylabel('Sp Duration (s)')
        s0(j) = scatter(SPStartTime,SPDuration, '*');
        xlim([0 250])
        ylim([0 90])
        legendInfo0{j} = ['PID: ' num2str(extrPDx(i,1))];
        legend(legendInfo0);
        
        %boxplot(SPDuration, extrPDx(i,1))
        hold on
        j = j + 1;
    else
        figure1 = figure(2);
        
        title('Speech Pause Duration Over 3min Speech Task INTDX = 1')
        xlabel('SP Start Time')
        ylabel('Sp Duration')
        s1(k) = scatter(SPStartTime,SPDuration, '*');
        xlim([0 250])
        ylim([0 90])
        legendInfo1{k} = ['PID: ' num2str(extrPDx(i,1))];
        legend(legendInfo1);
        
        %boxplot(SPDuration, extrPDx(i,1))
        hold on
        k = k + 1;
    end
    
    
end

%legend(s0,legendInfo0);
%legend(s1,legendInfo1);
