function [noiseThresholdWavPos,noiseThresholdWavNeg]...
    = findThresholdAuto(filename)
% findThresholdAuto function extracts first 10 seconds of each unique audio
% sample imported to create a waveform magnitude threshold

[~, Fs] = audioread(filename); % Extract waveform and sampling frequency.
noiseSample = [1, 10*Fs];
noise = audioread(filename,noiseSample);

if(length(noise(1,:)) ~= 1) % Condition is true when file is a recording in stereo.
    noise = sum(noise, 2) / size(noise,2); % Converts stereo recording to mono.
end

%% Noise Threshold
% Create statistical noise threshold from given information.
[yUpper, yLower] = envelope(noise, 1000, 'peak');
stdNoiseWavUp = std(yUpper);
stdNoiseWavLow = std (yLower);
noiseThresholdWavPos = mean(yUpper) + (3 * stdNoiseWavUp); % Upper waveform magnitude noise threshold.
noiseThresholdWavNeg = mean(yLower) - (3 * stdNoiseWavLow); % Lower waveform magnitude noise threshold.

end