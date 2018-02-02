function [detectionWTime, detectionRaw] = speechDetection(myRecording,...% Raw waveform data from live recording
    noiseThresholdWavPos,... % Upper waveform magnitude threshold.
    noiseThresholdWavNeg,... % Lower waveform magnitude threshold.
    Fs)
% speechDetection function determines where speech is present in the
% entire audio file using the waveform magnitude noise thresholds.

%% Waveform Augmenting
% Peforming envelopes and timestamps to create optimal speech detection.

% Assigning two arrays for upper and lower envelope of myRecording data.
[yUpper, yLower] = envelope(myRecording, 800, 'peak');

% Assigning timestamps to each sample taken in myRecording.
for x = 1:length(myRecording)
    time(x) = x/Fs; % Save timestamps to array 'time'.
    x = x+1;
end

%% Speech Detection
% Implementing noise thresholds and conditionals to create speech
% detection array.

% Assigning array detectionRaw to speech detection.
for s = 1:length(yLower)
    if ((yUpper(s) > noiseThresholdWavPos) || (yLower(s) < noiseThresholdWavNeg))
        detectionRaw(s) = 1; % If speech is detected assign value of 1 to specific sample index.
    else
        detectionRaw(s) = 0; % If speech is not detected assign value of 0 to specific sample index.
    end
    s = s + 1;
end

% Filter speech detection  to get rid of false detection using median
% filter.
detectionMed = medfilt1(detectionRaw,10000);

% Assign filtered detection and sample timestamps to detectionWTime matrix.
detectionWTime(1,:) = time;
detectionWTime(2,:) = detectionMed;

% Due to median filter, certain values of speech detection are 0.5 (at 0
% to 1 transitions). Reassign these 0.5 values to 0 with for loop below.
for x = 1:length(detectionWTime(1,:))
    if(detectionWTime(2,x) == 0.5)
        detectionWTime(2,x) = 0;
    end
    x = x + 1;
end
end