function [dBaudio,noiseThresholdDb,waveform,Fs]...
    = findThresholdAuto(filename)

% findThresholdAuto function extracts first 10 seconds of each unique audio
% sample imported to create a waveform magnitude threshold

[dBaudio, Fs] = audioread(filename); % Extract waveform and sampling frequency.
if(length(dBaudio(1,:)) ~= 1) % Condition is true when file is a recording in stereo.
    dBaudio = sum(dBaudio, 2) / size(dBaudio,2); % Converts stereo recording to mono.
end
waveform = dBaudio;
[~,noiseThresholdDb] = snr(dBaudio,Fs);
dBaudio = mag2db(abs(dBaudio));

%indNoise = find(dBaudio <= noiseThresholdDb);
%% Noise Threshold
% Create statistical noise threshold from given information.
%[yUpper,~] = envelope(audio(indNoise), 1000, 'peak');
%stdNoiseWavUp = std(yUpper);
%stdNoiseWavLow = std (yLower);
%noiseThresholdDb = mean(yUpper) %+ (2 * stdNoiseWavUp); % Upper waveform magnitude noise threshold.
%noiseThresholdWavNeg = mean(yLower) %- (2 * stdNoiseWavLow); % Lower waveform magnitude noise threshold.


end