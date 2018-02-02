clc, clear all
global filename pathname noiseThresholdWavPos noiseThresholdWavNeg check check2;
x = 1;
filename = {1, 1, 1};
pathname = {};
check = 0;
check2 = 0;
%% User Prompt
% Data read for either live recording or imported file and noise threshold.
startPrompt = 'Press [1] to import file, press [2] to live record: ';
choice = input(startPrompt);
startPrompt2 = 'Press [1] for NO figure(s), press [2] for figure(s): ';
choice2 = input(startPrompt2);

%% Initiate Functions
% Call all functions relating to speech detection and analysis. These
% functions include: dataRead, findThresholdImport, findThresholdLive,
% liveRecording, speechAnalysis, and speechDetection
while (x ~= (length(filename) + 1) && (iscell(filename) == 1)) % To be implemented for multi file select.
    clear waveformWithTime;
    [Fs, audioName, myRecording] = dataRead(choice, x);
    dt = 1/Fs;
    t = 0:dt:length(myRecording)*dt - dt; %array of each sample in time domain
    waveformWithTime(1,:) = myRecording;
    waveformWithTime(2,:) = t;
    
    % Return raw speech detection and refined speech detection with
    % respective sample time.
    [detectionWTime, detectionRaw] = speechDetection(myRecording,...
        noiseThresholdWavPos,...
        noiseThresholdWavNeg,...
        Fs);
    % Return all tables pertaining to speech analysis performed in function
    % speechAnalysis
    [analysisTablePauseDetails, analysisTableSpeechDetails,...
        analysisTableSummary] = speechAnalysis(...
        detectionWTime,...
        waveformWithTime,...
        Fs); %return 4 tables of specific speech analysis featurs, save xlsx file of all tables
    
    %% Graphical Information
    % Call function makePlot to create graphical representations of the
    % analysis performed.
    if(choice2 == 2)
        [VisualAnalysis] = makePlot(detectionWTime,myRecording, noiseThresholdWavPos, noiseThresholdWavNeg);
    end
    
    %% Saving features
    % Create timestamped mat file of full speech analysis.
    AnalysisResults = ['ResultsFolder/Results_', audioName,'_',datestr(now, 'dd-mmm-yyyy_HH_MM_SS_'),'.mat'];
    save (AnalysisResults, 'analysisTableSummary', 'analysisTablePauseDetails', 'analysisTableSpeechDetails', 'filename');
    x = x + 1;
end