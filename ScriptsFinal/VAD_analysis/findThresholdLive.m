function [noiseThresholdWavPos, noiseThresholdWavNeg] = ...
    findThresholdLive(recObj)
% findThresholdLive function performs a 10 second recording of non speech
% present noise to create a waveform magnitude threshold.

%% Perform Recording
% Prompt user not to speak and extract 10 seconds of non speech present
% noise use the record function.

recObj.StartFcn = 'disp(''Do not speak until prompted '')'; % Prompt user to not speak during function run.
record(recObj);
pause(10);
stop(recObj);

noiseData = getaudiodata(recObj); % 10 second audio sample of speech non present background noise.
[yUpper, yLower] = envelope(noiseData, 1000, 'peak'); % Enveloping 5 second background noise

%% Noise Threshold
% Create statistical noise threshold from given information.

stdNoiseWavUp = std(yUpper);
stdNoiseWavLow = std (yLower);
noiseThresholdWavPos = mean(yUpper) + (3 * stdNoiseWavUp); % Upper waveform magnitude noise threshold.
noiseThresholdWavNeg = mean(yLower) - (3 * stdNoiseWavLow); % Lower waveform magnitude noise threshold.
end