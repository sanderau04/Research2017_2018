function [Fs, audioName,waveformWithTime,waveform, audioWExt] = dataRead(choice, x)
% dataRead function performs the intial audio processing for a live or
% imported file. Calls upon noise threshold functions within itself.
%   choice == 1 corresponds with imported file(s).
%   choice == 2 corresponds with a live recording.
%   The global files below are respresented in Run.m and are
%   crucial for looping features and general speech detection analysis.
global filename pathname noiseThresholdDb check check2 dBaudio;

%% Extracting Imported File(s)
% Determine file name(s) to be used in saving feature, run
% findThresholdAuto function to determine non speech present noise 
% threshold, extract waveform data from imported file(s).

if(choice == 1 || choice == 3)
        
    if (check == 0)
        [filename, pathname, ~] = uigetfile({'*.wav; *.ogg; *.flac; *.au; *.aiff; *.aif; *.aifc; *.mp3; *.m4a; *.mp4', 'All Audio Files';...
            '*.*', 'All Files'}, 'Pick an Audio File', 'MultiSelect', 'on'); % Select all files readable by the function audioread, allow for multiple selections.
        check = 1;
    end
    if(iscell(filename) == 1) % Condition is true if multiple files are imported.
        audioFile = char(strcat(pathname,filename(x)));
        audioName = char(filename(x)); % Extract the name of the file, without extension, to be used in saving feature.
        audioWExt = audioName;
    else % Condition is true if a single file is imported.
        audioFile = strcat(pathname,filename);
        audioName = filename;
        audioWExt = audioName;
    end
    [dBaudio,noiseThresholdDb,waveform,Fs] = findThresholdAuto(audioFile);

    idx = find(ismember(audioName,'./\:'),1,'last');
    if audioName(idx) == '.'; audioName(idx:end) = []; end % Extracts file name without the extension
    
end
%% Perform Live Recording
% Ask user for file name, run findThresholdLive function to determine non
% speech present noise threshold, run liveRecording function to extract
% waveform data from a live audio recording.

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
    t = 0:dt:length(waveform)*dt - dt; %array of each sample in time domain
    waveformWithTime = zeros(2,(length(waveform)+2));
    waveformWithTime(1,(2:end - 1)) = waveform;
    waveformWithTime(2,(2:end - 1)) = t;
    waveformWithTime(2,end) = t(end);
    
    
    
end

