%% plot_frequency_v_time.m plots speech epoch frequency over time of all 
% patient files divided into four different categories. This specific
% example creates a gender and internal diagnosis split and outputs 
% scatter plots accordingly. 

%% Required patient mat file variables:
% patientDx, analysisTableSummaryPatient,
% analysisTableSpeechDetailsPatient, audioName

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
%% Gender division (2 groups)
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

%% INTdx division (4 groups)
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
%% Produce scatter plots

% plot gender = 1 subjects with INTdx = 0
for i = 1:length(matDatay0)
    audioName1(i,1) = str2num(matData0(i).audioName);
    freqint01{:,i} = matDatay0(i).analysisTableSpeechDetailsPatient.Speech_Epoch_Max_Frequency;
    freqTimeint01{:,i} = matDatay0(i).analysisTableSpeechDetailsPatient.Speech_Start_Time;
    figure(1)
    plot(freqTimeint01{1,i},freqint01{1,i},'*')
    lsline
    hold on
end

title(["ChildGender = 1, IntDx = 0 Dominant Frequency PATIENT ONLY MEDIATED  N = ", num2str(length(matDatay0))])
xlabel("time (s)")
ylabel("Frequency (Hz)")
ylim([0 4000])

% plot gender = 1 subjects with INTdx = 1
for i=1:length(matDataO0)
     freqint11{:,i} = matDataO0(i).analysisTableSpeechDetailsPatient.Speech_Epoch_Max_Frequency;
     freqTimeint11{:,i} = matDataO0(i).analysisTableSpeechDetailsPatient.Speech_Start_Time;
     figure(2)
     plot(freqTimeint11{1,i}, freqint11{1,i},'*')
     lsline
     hold on
end

title(["ChildGender = 1, intDx = 1 Dominant Frequency PATIENT ONLY MEDIATED,  N = ", num2str(length(matDataO0))])
xlabel("time (s)")
ylabel("Frequency (Hz)")
ylim([0 4000])


% plot gender = 2 subjects with INTdx = 0
for i = 1:length(matDatay1)
    freqint02{:,i} = matDatay1(i).analysisTableSpeechDetailsPatient.Speech_Epoch_Max_Frequency;
    freqTimeint02{:,i} = matDatay1(i).analysisTableSpeechDetailsPatient.Speech_Start_Time;
    figure(3)
    plot(freqTimeint02{1,i}, freqint02{1,i},'*')
    lsline
    hold on
end

title(["Child Gender = 2, intDx = 0 Dominant Frequency PATIENT ONLY MEDIATED  N = ", num2str(length(matDatay1))])
xlabel("time (s)")
ylabel("Frequency (Hz)")
ylim([0 4000])

% plot gender = 2 subject with INTdx = 1
for i = 1:length(matDataO1)
    freqint12{:,i} = matDataO1(i).analysisTableSpeechDetailsPatient.Speech_Epoch_Max_Frequency;
    freqTimeint12{:,i} = matDataO1(i).analysisTableSpeechDetailsPatient.Speech_Start_Time;
    figure(4)
    plot(freqTimeint12{1,i}, freqint12{1,i},'*')
    lsline
    hold on 
end

title(["Child Gender = 2, intDx = 1 Dominant Frequency PATIENT ONLY MEDIATED  N = ", num2str(length(matDataO1))])
xlabel("time (s)")
ylabel("Frequency (Hz)")
ylim([0 4000])
