%% Reading in all mat files
clear all, clc
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
    audioName(i,1) = str2num(matData(i).audioName);
    freq = matData(i).analysisTableSpeechDetails.Speech_Epoch_Max_Frequency;
    freqTime = matData(i).analysisTableSpeechDetails.Speech_Start_Time;
    epochLabel = matData(i).EpochLabel;
    w=1;
    for x=1:length(epochLabel)
        if char(epochLabel{x}) == 'B'
            indBuzzer(w) = x;
            w = w + 1;
        end 
    end
    vlineXVal = freqTime(indBuzzer);
    f(i) = figure('visible', 'off', 'pos', [10 10 1920 1080]);
    %f(i).PaperPosition = [50 250 900 600];
    plot(freqTime,freq,'*')
    hold on
    vline(vlineXVal,'r')
    hold off
    Titlename = ['Individual Dominant Frequency Over Time, PID: ',num2str(audioName(i,1)), ',   IntDx: ', num2str(matData(i).patientDx(73)), ',    Age: ', num2str(matData(i).patientDx(29)), ',    Gender: ', num2str(matData(i).patientDx(80))];
    figName = [num2str(audioName(i,1)),'_Individual_D_FreqOverTime' ];
    title(Titlename)
    xlabel("Speech Epoch Start Times (s)")
    ylabel("Dominant Frequency (Hz)")
    ylim([0 10000])
    saveas(f(i),figName,'png');
    clear name audioName epochLabel indBuzzer freqTime freq Titlename figName
end




