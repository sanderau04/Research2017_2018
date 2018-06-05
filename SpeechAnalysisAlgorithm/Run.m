clc, clear;
global filename pathname noiseThresholdWavPos noiseThresholdWavNeg check check2;
patientDxAndSpeechCode = xlsread('mcginnisdissertation8.2.16.xlsx');
x = 1;
filename = {1, 1, 1};
pathname = {};
check = 0;
check2 = 0;
%% User Prompt
% Data read for either live recording or imported file and noise threshold.
startPrompt = 'Press [1] to IMPORT file, press [2] to LIVE record, press [3] to IMPORT file with AUTO THRESHOLD: ';
choice = input(startPrompt);
startPrompt2 = 'Press [1] for NO FIGURE(S), press [2] for FIGURE(S): ';
choice2 = input(startPrompt2);
startPrompt3 = 'Press [1] to SAVE analysis, press [2] to NOT SAVE analysis: ';
choice3 = input(startPrompt3);

%% Initiate Functions

while (x ~= (length(filename) + 1) && (iscell(filename) == 1)) % To be implemented for multi file select.
    clear waveformWithTime;
    [Fs, audioName, waveformWithTime, myRecording] = dataRead(choice, x);
    for i = 1:length(patientDxAndSpeechCode(:,1))
        if(str2double(audioName) == patientDxAndSpeechCode(i,1))
            patientDx = patientDxAndSpeechCode(i,:);
        end
    end
    % Return raw speech detection and refined speech detection with
    % respective sample time.
    [detectionWTime] = speechDetection(myRecording,...
        noiseThresholdWavPos,...
        noiseThresholdWavNeg,...
        Fs);
    % Return all tables pertaining to speech analysis performed in
    % function
    % speechAnalysis
    [analysisTablePauseDetails, analysisTableSpeechDetails,...
        analysisTableSummary, detectFreqFilt, energyMatrix] = speechAnalysis(...
        detectionWTime,...
        waveformWithTime,...
        Fs); %return 3 tables of specific speech analysis featurs, save xlsx file of all tables
    
    %% Graphical Information
    % Call function makePlot to create graphical representations of the
    % analysis performed.
    if(choice2 == 2)
        [VisualAnalysis] = makePlot(detectionWTime,myRecording, noiseThresholdWavPos, noiseThresholdWavNeg, detectFreqFilt);
    end
    
    %% Saving features
    % Create timestamped mat file of full speech analysis.
    if(choice3 == 1)
        AnalysisResults = ['SpeechTaskResults/Patient_', audioName,'__',datestr(now, 'dd-mmm-yyyy_HH_MM_SS_'),'.mat'];
        save (AnalysisResults, 'analysisTableSummary', 'analysisTablePauseDetails', 'analysisTableSpeechDetails', 'energyMatrix', 'patientDx', 'filename');
    end
    x = x + 1;
end