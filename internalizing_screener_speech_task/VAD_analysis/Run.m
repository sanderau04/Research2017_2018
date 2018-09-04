clc, clear; clear all
global filename pathname check check2  dBaudio noiseThresholdDb waveformWithTime Fs detectionWTime
patientDxAndSpeechCode = xlsread('mcginnisdissertation8.2.16.UPDATED.VALUES.xlsx');

x = 1;
filename = {1, 1, 1};
pathname = {};
check = 0;
check2 = 0;
%% User Prompt
% Data read for either live recording or imported file and noise threshold.
startPrompt = 'Press [1] to IMPORT file with AUTO THREHSOLD, press [2] to LIVE record, press [3] to IMPORT file and use prototype ZCR VAD: ';
choice = input(startPrompt);
startPrompt2 = 'Press [1] for NO FIGURE(S), press [2] for FIGURE(S): ';
choice2 = input(startPrompt2);
startPrompt3 = 'Press [1] to SAVE analysis, press [2] to NOT SAVE analysis: ';
choice3 = input(startPrompt3);

%% Initiate Functions
tic;
while (x ~= (length(filename) + 1) && (iscell(filename) == 1)) % To be implemented for multi file select.
    clear waveformWithTime indPdx audioName patientDx
    [Fs, audioName,waveformWithTime,waveform,audioWExt] = dataRead(choice, x);
    
    indPdx = find(patientDxAndSpeechCode(:,1) == str2num(audioName));
    if(isempty(indPdx) == 1)
        patientDx = NaN(1,359);
    else
        patientDx = patientDxAndSpeechCode(indPdx,:);
    end
    
    %}
    % Return raw speech detection and refined speech detection with
    % respective sample time.
    [detectionWTime, detectionRaw,...
        indSpeechStart, indSpeechStop] = speechDetection(...
        Fs,...
        noiseThresholdDb);
    
    if choice == 3
        [detectionWTime, detectionRaw, indSpeechStart, indSpeechStart] = zcrVAD(waveform);
    end
    
    %% Graphical Information
    % Call function makePlot to create graphical representations of the
    % analysis performed.
    if(choice2 == 2)
        [VisualAnalysis] = makePlot(audioName,waveform,choice);
    end
    % Uncomment for variable to play detected audio (use sound function in
    % command line to play detected audio when ready)
    
    indDetect = find(detectionWTime(2,:) == 1);
    detectionPlay = waveform(indDetect);
    %}
    %% Saving features
    % Create timestamped mat file of full speech analysis.
    if exist('SpeechTaskResults', 'dir') == 0
        mkdir SpeechTaskResults
    end
    
    if(choice3 == 1)
        AnalysisResults = ['SpeechTaskResults/Patient_', audioName,'__',datestr(now, 'dd-mmm-yyyy_HH_MM_SS_'),'.mat'];
        save (AnalysisResults, 'filename', 'audioName', 'indSpeechStart', 'indSpeechStop', 'audioWExt', 'patientDx');
    end
    x = x + 1;
end
time = toc;
%% Bot email for user notification algorithm run finish
emailNotification('sanderau04@gmail.com', time, filename);