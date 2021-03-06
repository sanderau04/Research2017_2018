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
x = 1;
filename = {1, 1, 1};
check = 0;
check2 = 0;

while (x ~= (length(filename) + 1) && (iscell(filename) == 1))
clear waveformWithTime;
if(choice == 1)
   
    if (check == 0)
    [filename, pathname, filterindex] = uigetfile({'*.wav; *.ogg; *.flac; *.au; *.aiff; *.aif; *.aifc; *.mp3; *.m4a; *.mp4', 'All Audio Files';...
    '*.*', 'All Files'}, 'Pick an Audio File', 'MultiSelect', 'on');
    check = 1;
    end
    if(iscell(filename) == 1)
        audioFile = char(strcat(pathname,filename(x)));
        audioName = char(filename(x));
    else
        audioFile = strcat(pathname,filename);
        audioName = filename;
    end
    if (check2 == 0)
    [noiseThresholdWavPos, noiseThresholdWavNeg] = findThresholdImport(audioFile);
    check2 = 1;
    end
    [myRecording, Fs] = audioread(audioFile);
    if(length(myRecording(1,:)) ~= 1)
        myRecording = sum(myRecording, 2) / size(myRecording,2);
    end
    
    idx = find(ismember(audioName,'./\:'),1,'last');
if audioName(idx) == '.'; audioName(idx:end) = []; end
    
end
if(choice ==2)
    prompt = 'Input filename for recording: ';
    audioName = input(prompt, 's');
    filename = audioName;
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
[analysisTablePauseDetails, analysisTableSpeechDetails, analysisTableSummary] = speechAnalysis(detectionWTime,...
    noiseThresholdWavPos,...
    noiseThresholdWavNeg,...
    waveformWithTime,...
    Fs); %return 4 tables of specific speech analysis featurs, save xlsx file of all tables
AnalysisResults = ['ResultsFolder/Results_', audioName,'_',datestr(now, 'dd-mmm-yyyy_HH_MM_SS_'),'.mat'];


%% Graphical Information
VisualAnalysis = figure('Name', 'Speech Detection', 'NumberTitle', 'off');


%graph of refined (medfilt1) speech detection superimposed over enveloped
%waveform and noise thresholds
envelope(myRecording, 800, 'peak');
hold on 
plot(detectionWTime(2,:));
hlinePos = refline([0 noiseThresholdWavPos]);
hlinePos.Color = 'g';
hlineNeg = refline([0 noiseThresholdWavNeg]);
hlineNeg.Color = 'g';
title('Signal Data with Envelope and Speech Detection Filtered')
legend('signal','envelope','speech detection filtered', 'Location','southwest')

save (AnalysisResults, 'analysisTableSummary', 'analysisTablePauseDetails', 'analysisTableSpeechDetails', 'filename');
x = x + 1;
end