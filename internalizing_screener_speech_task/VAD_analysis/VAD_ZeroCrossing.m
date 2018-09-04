%% Prototype for new VAD implementation using ZCR of waveform and energy 
% over time. Takes much less computing time and works off of two
% significant determining values instead of a single loudness threshold.

%% Required Add-On libraries:
% Short-time Energy and Zero Crossing Rate by Nabin S Sharma

clear all, clc

[filename, pathname, ~] = uigetfile({'*.wav; *.ogg; *.flac; *.au; *.aiff; *.aif; *.aifc; *.mp3; *.m4a; *.mp4', 'All Audio Files';...
    '*.*', 'All Files'}, 'Pick an Audio File');

audioFile = char(strcat(pathname,filename));
[dBaudio,noiseThresholdDb,x,Fs] = findThresholdAuto(audioFile);

if(length(x(1,:)) ~= 1) % Condition is true when file is a recording in stereo.
    x = sum(x, 2) / size(x,2); % Converts stereo recording to mono.
end

%{
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
%}
tic
indNoise = find(dBaudio <= noiseThresholdDb);

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
filtTime = toc;

disp(['Noise Filter Computation Time: ', num2str(filtTime), 's'])
tic
xNoise = x(indNoise);
xNoise = xNoise.';
%%
Nnoise = length(xNoise); % signal length
nNoise = 0:Nnoise-1;
tsnoise = nNoise*(1/Fs); % time for signal

% define the window
wintype = 'hamming';
winlen = 201;
winamp = [0.5,1]*(1/winlen);

% find the zero-crossing rate
zcNoise = zerocross(xNoise,wintype,winamp(1),winlen);

% find the zero-crossing rate
ENoise = energy(xNoise,wintype,winamp(2),winlen);


%{
figure;
plot(ts,x); hold on;
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
%}

ZCThreshold = mean(zcNoise);
energyThreshold = mean(ENoise);
%%
x = x.';
detection = zeros(1,length(x));

N = length(x); % signal length
n = 0:N-1;

% find the zero-crossing rate
zc = zerocross(xFilt,wintype,winamp(1),winlen);

% find the zero-crossing rate
E = energy(xFilt,wintype,winamp(2),winlen);

% time index for the ST-ZCR and STE after delay compensation
out = floor((winlen-1)/2:(N+winlen-1)-(winlen-1)/2);
t = (out-(winlen-1)/2)*(1/Fs);

zcOut = zc(out);
EOut = E(out);

zcOut = zcOut(1:end-1);
EOut = EOut(1:end-1);
%%
indAboveThreshold = find((zcOut < ZCThreshold) & (EOut > energyThreshold));
%%
detection(indAboveThreshold) = 1;
%%
detectionMed = medfilt1(detection,10000);

for xi = 1:length(dBaudio)
    time(xi) = xi/Fs; % Save timestamps to array 'time'.
    xi = xi+1;
end

detection1(1,:) = time;
detection1(2,:) = detectionMed;
% Inserting leading and trailing zero to debug for speechAnalysis.
detectionWTime = zeros(2,(length(detection1(1,:)) + 2));
detectionWTime(:,2:(end - 1)) = detection1;
detectionWTime(1,end) = detection1(1,end);

indPoint5 = find(detectionWTime(2,:) == 0.5);
detectionWTime(2,indPoint5) = 0;

audioName = 'ZCR VAD test';

dx = diff(detectionWTime(2,:)); % Assigning array dx to the difference of each element in speech detection array.
indSpeechStart = find(dx == 1); % Finding the indices in dx where speech is initiated.
indSpeechStop = find(dx == -1); % Finding the indices in dx where speech is concluded.

indPlayDetection = find(detectionWTime(2,:) == 1);
if indPlayDetection(end) == length(out)
   indPlayDetection = indPlayDetection(1:end-1); 
end

detectionTime = toc;

disp(['Detection Computation Time: ', num2str(detectionTime), 's'])

sound(x(indPlayDetection),Fs)
%%
[VisualAnalysis] = makePlot(detectionWTime,audioName,noiseThresholdDb,x);

