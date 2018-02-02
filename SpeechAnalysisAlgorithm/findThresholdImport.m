function [noiseThresholdWavPos,noiseThresholdWavNeg] = ...
    findThresholdImport(filename)
% findThresholdImport function extracts a non speech present epoch of audio
% to create a waveform magnitude threshold

[noiseData, Fs] = audioread(filename); % Extract waveform and sampling frequency.
samples = [1,5*Fs]; % Assign a variable that extracts waveform data of the first 5 seconds of imported recording.
noiseDataPlay = audioread(filename, samples); % Extract waveform data of the first 5 seconds of imported recording.
% Create array of sample timestamps of entire audio file.
for k = 1:length(noiseData(:,1))
    time(k) = k/Fs;
    k = k + 1;
end
%% User Input for Noise
% Prompt user for at least 10 seconds of non speech present noise from
% imported recording information.

fprintf('The following is the first 5 seconds of your recording\n\n')
pause(2);
sound(noiseDataPlay,Fs);
fprintf('This figure represents the waveform of the entire recording\n');
f1 = figure('Name', 'Full Recording Waveform', 'NumberTitle', 'off');
plot(time,noiseData);
title('Waveform of Entire Imported Recording');
xlabel('Time (s)');
ylabel('Amplitude');
pause(3)
disp('Please click on two points on the graph enclosing AT LEAST 10 seconds of the recording where speech is NOT PRESENT')
[t, ~] = ginput(4); % Input 4 data points and recieve their timestamps.
t = round(t*Fs); % Convert timestamps to sample numbers.

if(length(t) == 4)
    noiseData = noiseData([t(1):t(2) t(3):t(4)]); % Create noise data from 4 data point inputs.
end
close(f1)

%% Noise Threshold
% Create statistical noise threshold from given information.

[yUpper, yLower] = envelope(noiseData, 1000, 'peak'); % Perform an envelope on the noise data waveform.
stdNoiseWavUp = std(yUpper);
stdNoiseWavLow = std (yLower);
noiseThresholdWavPos = mean(yUpper) + (3 * stdNoiseWavUp); % Upper waveform magnitude noise threshold.
noiseThresholdWavNeg = mean(yLower) - (3 * stdNoiseWavLow); % Lower waveform magnitude noise threshold.
end