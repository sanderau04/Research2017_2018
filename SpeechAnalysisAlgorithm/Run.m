clc, clear; clear all
global filename pathname check check2  dBaudio noiseThresholdDb waveformWithTime detectWaveform Fs detectdBaudio detectionWTime indSpeechStart indSpeechStop;
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
tic;
while (x ~= (length(filename) + 1) && (iscell(filename) == 1)) % To be implemented for multi file select.
    clear waveformWithTime;
    clear audioName;
    clear patientDx;
    clear analysisTableSummary;
    clear analysisTablePauseDetails;
    clear analysisTableSpeechDetails;
    clear energyMatrix;
    clear indPdx;
    [Fs, audioName,waveformWithTime,waveform,audioWExt] = dataRead(choice, x);
    
    indPdx = find(patientDxAndSpeechCode(:,1) == str2num(audioName));
    if(isempty(indPdx) == 1)
        patientDx = NaN(1,359);
    else
        patientDx = patientDxAndSpeechCode(indPdx,:);
    end
    
    %{
    for i = 1:length(patientDxAndSpeechCode(:,1))
        if(str2num(audioName) == patientDxAndSpeechCode(i,1))
            patientDx = patientDxAndSpeechCode(i,:);
        else
            patientDx = NaN(1,359);
        end
    end
    i=1;
    %}
    %}
    % Return raw speech detection and refined speech detection with
    % respective sample time.
    [detectionWTime, detectionRaw, dBaudio] = speechDetection(dBaudio,...
        Fs,...
        noiseThresholdDb);
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
        [VisualAnalysis] = makePlot(detectionWTime,dBaudio,audioName,noiseThresholdDb);
    end
indDetect = find(detectionWTime(2,:) == 1);
%detectWaveform = waveform(indDetect);
%detectdBaudio = dBaudio(indDetect);
    
    %% Saving features
    % Create timestamped mat file of full speech analysis.
    if(choice3 == 1)
        AnalysisResults = ['SpeechTaskResults/Patient_', audioName,'__',datestr(now, 'dd-mmm-yyyy_HH_MM_SS_'),'.mat'];
        save (AnalysisResults, 'analysisTableSummary', 'analysisTablePauseDetails', 'analysisTableSpeechDetails', 'energyMatrix', 'filename', 'audioName', 'indSpeechStart', 'indSpeechStop', 'audioWExt', 'patientDx');
    end
    x = x + 1;
end


time = toc;
timeSec = mod(time,60);
timeMin = time/60;
msg = 'Your algorithm run analyzed ';
msg2 = ' files in ';
msg3 = ' minutes and ';
msg4 = ' seconds.';
timeMin = num2str(fix(timeMin));
timeSec = num2str(fix(timeSec));
if iscell(filename) == 1
    files = num2str(length(filename));
else
    files = num2str(1);
end
message = [msg files msg2 timeMin msg3 timeSec msg4];

myaddress = 'botmatlab34@gmail.com';
mypassword = 'matlab69';
setpref('Internet','E_mail',myaddress);
setpref('Internet','SMTP_Server','smtp.gmail.com');
setpref('Internet','SMTP_Username',myaddress);
setpref('Internet','SMTP_Password',mypassword);
props = java.lang.System.getProperties;
props.setProperty('mail.smtp.auth','true');
props.setProperty('mail.smtp.socketFactory.class', ...
    'javax.net.ssl.SSLSocketFactory');
props.setProperty('mail.smtp.socketFactory.port','465');

sendmail('sanderau04@gmail.com','Algorithm Run Has Finished',message);