function [detectionWTime, detectionRaw,...
    indSpeechStart, indSpeechStop] = speechDetection(...% Raw waveform data from live recording % Lower waveform magnitude threshold.
    Fs,...
    noiseThresholdDb)
% speechDetection function determines where speech is present in the
% entire audio file using the waveform magnitude noise thresholds.
global dBaudio
%% Waveform Augmenting
% Peforming envelopes and timestamps to create optimal speech detection.

% Assigning two arrays for upper and lower envelope of myRecording data.
indNegInf = find(isinf(dBaudio) == 1);
dBaudio(indNegInf) = -100;
[yUpper, yLower] = envelope(dBaudio, 800, 'peak');

% Assigning timestamps to each sample taken in myRecording.
for x = 1:length(dBaudio)
    time(x) = x/Fs; % Save timestamps to array 'time'.
    x = x+1;
end

%% Speech Detection
% Implementing noise thresholds and conditionals to create speech
% detection array.

% Assigning array detectionRaw to speech detection.
for s = 1:length(yUpper)
    if ((yUpper(s) > noiseThresholdDb)||(yLower(s) > noiseThresholdDb))
        detectionRaw(s) = 1; % If speech is detected assign value of 1 to specific sample index.
    else
        detectionRaw(s) = 0; % If speech is not detected assign value of 0 to specific sample index.
    end
end

% Filter speech detection  to get rid of false detection using median
% filter.
detectionMed = medfilt1(detectionRaw,10000);

% Assign filtered detection and sample timestamps to detectionWTime matrix.
detection1(1,:) = time;
detection1(2,:) = detectionMed;
% Inserting leading and trailing zero to debug for speechAnalysis.
detectionWTime = zeros(2,(length(detection1(1,:)) + 2));
detectionWTime(:,2:(end - 1)) = detection1;
detectionWTime(1,end) = detection1(1,end);

% Due to median filter, certain values of speech detection are 0.5 (at 0
% to 1 transitions). Reassign these 0.5 values to 0 with for loop below.
for x = 1:length(detectionWTime(1,:))
    if(detectionWTime(2,x) == 0.5)
        detectionWTime(2,x) = 0;
    end
    x = x + 1;
end

dx = diff(detectionWTime(2,:)); % Assigning array dx to the difference of each element in speech detection array.
indSpeechStart = find(dx == 1); % Finding the indices in dx where speech is initiated.
indSpeechStop = find(dx == -1); % Finding the indices in dx where speech is concluded.

end