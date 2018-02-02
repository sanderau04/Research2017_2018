function [Fs, audioName, myRecording] = dataRead(choice, x)
% dataRead function performs the intial audio processing for a live or
% imported file. Calls upon noise threshold functions within itself.
%   choice == 1 corresponds with imported file(s).
%   choice == 2 corresponds with a live recording.
%   The global files below are respresented in Run.m and are
%   crucial for looping features and general speech detection analysis.
global filename pathname noiseThresholdWavPos noiseThresholdWavNeg check check2;

%% Extracting Imported File(s)
% Determine file name(s) to be used in saving feature, run findThresholdImport
% function to determine non speech present noise threshold, extract
% waveform data from imported file(s).

if(choice == 1)
    
    if (check == 0)
        [filename, pathname, ~] = uigetfile({'*.wav; *.ogg; *.flac; *.au; *.aiff; *.aif; *.aifc; *.mp3; *.m4a; *.mp4', 'All Audio Files';...
            '*.*', 'All Files'}, 'Pick an Audio File', 'MultiSelect', 'on'); % Select all files readable by the function audioread, allow for multiple selections.
        check = 1;
    end
    if(iscell(filename) == 1) % Condition is true if multiple files are imported.
        audioFile = char(strcat(pathname,filename(x)));
        audioName = char(filename(x)); % Extract the name of the file, without extension, to be used in saving feature.
    else % Condition is true if a single file is imported.
        audioFile = strcat(pathname,filename);
        audioName = filename;
    end
    if (check2 == 0) % Condition allows findThresholdImport to run only once
        [noiseThresholdWavPos, noiseThresholdWavNeg] = findThresholdImport(audioFile);
        check2 = 1;
    end
    [myRecording, Fs] = audioread(audioFile); % Extract waveform data from imported file(s)
    if(length(myRecording(1,:)) ~= 1) % Condition is true when file is a recording in stereo.
        myRecording = sum(myRecording, 2) / size(myRecording,2); % Converts stereo recording to mono.
    end
    
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

end

