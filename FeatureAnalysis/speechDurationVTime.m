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

for i = 1:length(matFiles)
    pDx = extractfield(matData(i),'patientDx');
    
    switch pDx(73)
        case 0
            matData0(x) = matData(i);
            age0(x) = matData0(x).patientDx(29);
            x = x + 1;
        case 1
            matData1(y) = matData(i);
            age1(y) = matData1(y).patientDx(29);
            y = y + 1;
    end
end


w=1;
y=1;
for q=1:length(matData0)
    gender1(q) = matData0(q).patientDx(1);
    if matData0(q).patientDx(29) <= 70
        matDatay0(w) = matData0(q);
        w = w + 1;
    else
        matDataO0(y) = matData0(q);
        y = y + 1;
    end
    
end
f=1;
g=1;
for q=1:length(matData1)
    gender2(q) = matData1(q).patientDx(1);
    if matData1(q).patientDx(29) <= 74
        matDatay1(f) = matData1(q);
        f = f + 1;
    else
        matDataO1 = matData1(q);
        g = g + 1;
    end
end

figfig(1) = figure('pos', [10 10 1920 1080]);

for i = 1:length(matDatay0)
    audioName1(i,1) = str2num(matData0(i).audioName);
    freqYoung1{:,i} = matDatay0(i).analysisTableSpeechDetails.Speech_Epoch_Duration;
    freqTimey1{:,i} = matDatay0(i).analysisTableSpeechDetails.Speech_Start_Time;
    h(1) = plot(freqTimey1{1,i},freqYoung1{1,i},'b*');
    hold on
end

for i=1:length(matDataO0)
     freqOld1{:,i} = matDataO0(i).analysisTableSpeechDetails.Speech_Epoch_Duration;
     freqTimeO1{:,i} = matDataO0(i).analysisTableSpeechDetails.Speech_Start_Time;
     h(2) = plot(freqTimeO1{1,i}, freqOld1{1,i},'r*');
     hold on
end


for i = 1:length(matDatay1)
    freqYoung2{:,i} = matDatay1(i).analysisTableSpeechDetails.Speech_Epoch_Duration;
    freqTimey2{:,i} = matDatay1(i).analysisTableSpeechDetails.Speech_Start_Time;
    h(3) = plot(freqTimey2{1,i}, freqYoung2{1,i},'g*');
    hold on
end
%}
for i = 1:length(matDataO1)
    freqOld2{:,i} = matDataO1(i).analysisTableSpeechDetails.Speech_Epoch_Duration;
    freqTimeO2{:,i} = matDataO1(i).analysisTableSpeechDetails.Speech_Start_Time;
    h(4) = plot(freqTimeO2{1,i}, freqOld2{1,i},'m*');
    hold on 
end

title("Speech Epoch Duration Vs. Time (IntDx and Age Split), Excluding Outliers")
legend(h,{'IntDx=0 Young, M=70','IntDx=0 Old, M=70', 'IntDx=1 Young, M=74', 'IntDx=1 Old, M=74'})
    %'gender=1 Old, M=70.5'})
    %'gender=2 Young, M=70'},)
%'gender=1 Young, M=70.5',
%'gender=2 Old, M=70'

xlabel('Speech Pause Start Time (s)')
ylabel('Speech Pause Duration (s)')
ylim([0 10])
xlim([0 230])

