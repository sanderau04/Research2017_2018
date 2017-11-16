clc, clear all
%{
 % launch GUI
GUIobj = GUI_InfoAndRecord;
 % get the handle to the GUI and wait for it to be closed
waitfor(GUIobj);
%}
%% Data read for either live recording or imported file and noise threshold
startPrompt = 'Press [1] to import file, press [2] to live record: ';
choice = input(startPrompt);
if(choice == 1)
    filename = uigetfile;
    [noiseThresholdWavPos, noiseThresholdWavNeg] = findThresholdImport(filename);
    [myRecording, Fs] = audioread(filename);
else
    Fs = 48000; %sampling frequency
    recObj = audiorecorder(Fs, 16 , 1); %create recording object to save audio data
    [noiseThresholdWavPos, noiseThresholdWavNeg] = findThresholdLive(recObj); %return noise thresholds from 10 seconds of speech absent audio recording
    myRecording = liveRecording(recObj);
end
dt = 1/Fs;
t = 0:dt:length(myRecording)*dt - dt; %array of each sample in time domain
waveformWithTime(1,:) = myRecording;
waveformWithTime(2,:) = t;
%% Speech Detection Analysis

[detectionWTime, detectionRaw] = speechDetectionFunction(myRecording,...
    noiseThresholdWavPos,...
    noiseThresholdWavNeg,...
    Fs); %return raw speech detection and refined speech detection with respective sample time
[analysisTableDetails, analysisTableSummary, debuggingTable, wavSpeechPresent] = speechPauseAnalysis(detectionWTime,...
    noiseThresholdWavPos,...
    noiseThresholdWavNeg,...
    waveformWithTime,...
    Fs); %return 3 tables of specific speech analysis featurs, save xlsx file of all tables
%AnalysisResults = ['AnalysisResults_',datestr(now, 'HH_MM_SS_dd-mmm-yyyy'),'.mat'];


%% Graphical Information
VisualAnalysis = figure('Name', 'Speech Detection', 'NumberTitle', 'off');

%graph of raw speech detection superimposed over enveloped waveform and
%noise thresholds
subplot(2,1,1);
envelope(myRecording, 800, 'peak');
hold on 
plot(detectionRaw);
hlinePos = refline([0 noiseThresholdWavPos]);
hlinePos.Color = 'g';
hlineNeg = refline([0 noiseThresholdWavNeg]);
hlineNeg.Color = 'g';
title('Signal Data with Envelope and Speech Detection Unfiltered')
legend('signal','envelope','speech detection unfiltered', 'Location','southwest')

%graph of refined (medfilt1) speech detection superimposed over enveloped
%waveform and noise thresholds
subplot(2,1,2);
envelope(myRecording, 800, 'peak');
hold on 
plot(detectionWTime(2,:));
hlinePos = refline([0 noiseThresholdWavPos]);
hlinePos.Color = 'g';
hlineNeg = refline([0 noiseThresholdWavNeg]);
hlineNeg.Color = 'g';
title('Signal Data with Envelope and Speech Detection Filtered')
legend('signal','envelope','speech detection filtered', 'Location','southwest')

%save (AnalysisResults, 'analysisTableSummary', 'analysisTableDetails', 'debuggingTable', 'VisualAnalysis');
