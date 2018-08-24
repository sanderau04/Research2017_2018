%% Prototype for new VAD implementation using ZCR of waveform and energy 
% over time. Takes much less computing time and works off of two
% significant determining values instead of a single loudness threshold.

%% Required Add-On libraries:
% Short-time Energy and Zero Crossing Rate by Nabin S Sharma

clear all, clc

[filename, pathname, ~] = uigetfile({'*.wav; *.ogg; *.flac; *.au; *.aiff; *.aif; *.aifc; *.mp3; *.m4a; *.mp4', 'All Audio Files';...
    '*.*', 'All Files'}, 'Pick an Audio File');

audioFile = char(strcat(pathname,filename));
[x,Fs] = audioread(audioFile);

if(length(x(1,:)) ~= 1) % Condition is true when file is a recording in stereo.
    x = sum(x, 2) / size(x,2); % Converts stereo recording to mono.
end
tic

Fn = Fs/2;                                              % Nyquist Frequency (Hz)
Wp = 1000/Fn;                                           % Passband Frequency (Normalised)
Ws = 1010/Fn;                                           % Stopband Frequency (Normalised)
Rp =   1;                                               % Passband Ripple (dB)
Rs = 150;                                               % Stopband Ripple (dB)
[n,Ws] = cheb2ord(Wp,Ws,Rp,Rs);                         % Filter Order
[z,p,k] = cheby2(n,Rs,Ws,'low');                        % Filter Design
[soslp,glp] = zp2sos(z,p,k);    
xFilt = filtfilt(soslp, glp, x);

xFilt = xFilt.';

N = length(xFilt); % signal length
n = 0:N-1;
ts = n*(1/Fs); % time for signal

% define the window
wintype = 'hamming';
winlen = 201;
winamp = [0.5,1]*(1/winlen);

% find the zero-crossing rate
zc = zerocross(xFilt,wintype,winamp(1),winlen);

% find the zero-crossing rate
E = energy(xFilt,wintype,winamp(2),winlen);
toc
% time index for the ST-ZCR and STE after delay compensation
out = floor((winlen-1)/2:(N+winlen-1)-(winlen-1)/2);
t = (out-(winlen-1)/2)*(1/Fs);

figure;
plot(ts,xFilt); hold on;
plot(t,zc(out),'r','Linewidth',2); xlabel('t, seconds');
title('Short-time Zero Crossing Rate');
legend('signal','STZCR');

figure(2);
plot(ts,x); hold on;
plot(t,E(out),'r','Linewidth',2); xlabel('t, seconds');
title('Short-time Energy');
legend('signal','STE');
tenSeconds = 10*Fs;
meanEnergy = mean(E(1:tenSeconds));
meanZC = mean(zc(1:tenSeconds));

energyThreshold = meanEnergy + 3*std(E(1:tenSeconds));
ZCThreshold = meanZC; %+ 3*std(zc(1:tenSeconds));

indDetect = zeros(1,length(x));
indAboveThreshold = find((zc(out) < ZCThreshold) & (E(out) > energyThreshold));
indDetect(indAboveThreshold) = 1;
figure(2)
plot(ts,indDetect)

