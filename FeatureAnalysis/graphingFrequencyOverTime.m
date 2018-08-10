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
    
    if width(matData(i).analysisTableSummaryPatient) == 14
        switch pDx(80)
            case 1
                matData0(x) = matData(i);
                x = x + 1;
            case 2
                matData1(y) = matData(i);
                y = y + 1;
        end
    end
end


w=1;
y=1;
for q=1:length(matData0)
    gender1(q) = matData0(q).patientDx(1);
    if matData0(q).patientDx(73) == 0
        matDatay0(w) = matData0(q);
        w = w + 1;
    elseif matData0(q).patientDx(73) == 1
        matDataO0(y) = matData0(q);
        y = y + 1;
    end
end
f=1;
g=1;
for q=1:length(matData1)
    gender2(q) = matData1(q).patientDx(1);
    if matData1(q).patientDx(73) == 0
        matDatay1(f) = matData1(q);
        f = f + 1;
    elseif matData1(q).patientDx(73) == 1
        matDataO1(g) = matData1(q);
        g = g + 1;
    end
end


for i = 1:length(matDatay0)
    audioName1(i,1) = str2num(matData0(i).audioName);
    freqYoung1{:,i} = matDatay0(i).analysisTableSpeechDetailsPatient.Speech_Epoch_Max_Frequency;
    freqTimey1{:,i} = matDatay0(i).analysisTableSpeechDetailsPatient.Speech_Start_Time;
    figure(1)
    plot(freqTimey1{1,i},freqYoung1{1,i},'*')
    lsline
    hold on
end

title(["ChildGender = 1, IntDx = 0 Dominant Frequency PATIENT ONLY MEDIATED  N = ", num2str(length(matDatay0))])
xlabel("time (s)")
ylabel("Frequency (Hz)")
ylim([0 4000])


for i=1:length(matDataO0)
     freqOld1{:,i} = matDataO0(i).analysisTableSpeechDetailsPatient.Speech_Epoch_Max_Frequency;
     freqTimeO1{:,i} = matDataO0(i).analysisTableSpeechDetailsPatient.Speech_Start_Time;
     figure(2)
     plot(freqTimeO1{1,i}, freqOld1{1,i},'*')
     lsline
     hold on
end

title(["ChildGender = 1, intDx = 1 Dominant Frequency PATIENT ONLY MEDIATED,  N = ", num2str(length(matDataO0))])
xlabel("time (s)")
ylabel("Frequency (Hz)")
ylim([0 4000])



for i = 1:length(matDatay1)
    freqYoung2{:,i} = matDatay1(i).analysisTableSpeechDetailsPatient.Speech_Epoch_Max_Frequency;
    freqTimey2{:,i} = matDatay1(i).analysisTableSpeechDetailsPatient.Speech_Start_Time;
    figure(3)
    plot(freqTimey2{1,i}, freqYoung2{1,i},'*')
    lsline
    hold on
end

title(["Child Gender = 2, intDx = 0 Dominant Frequency PATIENT ONLY MEDIATED  N = ", num2str(length(matDatay1))])
xlabel("time (s)")
ylabel("Frequency (Hz)")
ylim([0 4000])




for i = 1:length(matDataO1)
    freqOld2{:,i} = matDataO1(i).analysisTableSpeechDetailsPatient.Speech_Epoch_Max_Frequency;
    freqTimeO2{:,i} = matDataO1(i).analysisTableSpeechDetailsPatient.Speech_Start_Time;
    figure(4)
    plot(freqTimeO2{1,i}, freqOld2{1,i},'*')
    lsline
    hold on 
end

title(["Child Gender = 2, intDx = 1 Dominant Frequency PATIENT ONLY MEDIATED  N = ", num2str(length(matDataO1))])
xlabel("time (s)")
ylabel("Frequency (Hz)")
ylim([0 4000])







