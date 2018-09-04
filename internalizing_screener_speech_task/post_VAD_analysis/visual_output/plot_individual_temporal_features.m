%% plot_individual_temporal_Features.m produces temporal feature over time  
% scatter plots for each individual patient. Scatter plots are saved (without being 
% opened) to the current working directory with appropiate filenames.
% Current script implementation displays the difference between raw and  
% filtered patient speech pauses

%% Patient mat file variables required:
% analysisTableSummaryPatient, audioName, 
% analysisTableFilteredPauseDetailsPatient

clear all, clc
%% Reading in all mat files
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

for i = 1:length(matData)
    if width(matData(i).analysisTableSummaryPatient) > 3
        audioName(i,1) = str2num(matData(i).audioName);
        freq = matData(i).analysisTableFilteredPauseDetailsPatient.SP_Duration;
        freqTime = matData(i).analysisTableFilteredPauseDetailsPatient.SP_Start_Time;
        
        freq2 = matData(i).analysisTablePauseDetailsPatient.SP_Duration;
        freqTime2 = matData(i).analysisTablePauseDetailsPatient.SP_Start_Time;
        
        % Commented code may be uncommented to display epochs representing
        % Buzzers as a vertical red line (this would also require
        % extracting feature tables that do not pertain to patient only
        
        %epochLabel = matData(i).EpochLabel;
        w=1;
        %{ 
    for x=1:length(epochLabel)
        if char(epochLabel{x}) == 'B'
            indBuzzer(w) = x;
            w = w + 1;
        end
    end
        %}
        %vlineXVal = freqTime(indBuzzer);
        f(i) = figure('visible', 'off', 'pos', [10 10 1920 1080]);
        %f(i).PaperPosition = [50 250 900 600];
        plot(freqTime,freq,'*')
        hold on
        plot(freqTime2,freq2,'o')
        lsline
        legend('filtered SPause', 'unfiltered SPause', 'filtered SPause LS Line', 'unfiltered Spause LS Line')
        %hold on
        %vline(vlineXVal,'r')
        %hold off
        Titlename = ['PATIENT ONLY MEDIATED, Individual Filtered and Unfiltered SPause Duration Over Time, PID: ',num2str(audioName(i,1)), ',   IntDx: ', num2str(matData(i).patientDx(73)), ',    Age: ', num2str(matData(i).patientDx(29)), ',    Gender: ', num2str(matData(i).patientDx(80))];
        figName = ['IntDx',num2str(matData(i).patientDx(73)),'_',num2str(audioName(i,1)),'_Individual_SPause_OverTime' ];        
        title(Titlename)
        xlabel("SPause Start Times (s)")
        ylabel("SPause Duration (s)")
        ylim([0 30])
    else
        audioName(i,1) = str2num(matData(i).audioName);
        f(i) = figure('visible', 'off', 'pos', [10 10 1920 1080]);
        plot(1,1,'*')
        Titlename = ['PATIENT ONLY MEDIATED, Individual Filtered and Unfiltered SPause Duration Over Time Over Time, PID: ',num2str(audioName(i,1)), ',   IntDx: ', num2str(matData(i).patientDx(73)), ',    Age: ', num2str(matData(i).patientDx(29)), ',    Gender: ', num2str(matData(i).patientDx(80))];
        figName = ['IntDx',num2str(matData(i).patientDx(73)),'_',num2str(audioName(i,1)),'_Individual_SPause_OverTime' ];
        title(Titlename)
        xlabel("SPause Start Times (s)")
        ylabel("SPause Duration (s)")
        ylim([0 30])
    end
    saveas(f(i),figName,'png');
    clear name audioName epochLabel indBuzzer freqTime freq freq2 freqTime2 Titlename figName
end




