function [dBaudio,noiseThresholdDb,waveform,Fs]...
    = findThresholdAuto(filename)

% findThresholdAuto function extracts non harmonic noiseof each unique 
% audio sample imported to create a decibel threshold

[dBaudio, Fs] = audioread(filename); % Extract waveform and sampling frequency.
if(length(dBaudio(1,:)) ~= 1) % Condition is true when file is a recording in stereo.
    dBaudio = sum(dBaudio, 2) / size(dBaudio,2); % Converts stereo recording to mono.
end
waveform = dBaudio;
[~,noiseThresholdDb] = snr(dBaudio,Fs);
dBaudio = mag2db(abs(dBaudio));
end