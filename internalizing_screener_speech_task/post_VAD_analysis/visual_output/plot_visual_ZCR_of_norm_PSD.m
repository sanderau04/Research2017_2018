%% plot_visual_ZCR_of_norm_PSD.m creates a "article ready" plot visual
% of the zero crossing rate of a normalized power spectral density of an
% audio waveform.

%% Required Add-On Libraries:
% Short-time Energy and Zero Crossing Rate by Nabin S Sharma

[x,Fs] = audioread('Misc_Audio/sampleKidTalkin.wav');
x = sum(x, 2) / size(x,2);
[pxx,f] = pwelch(x,[],[],[],Fs);
normPxx = zscore(pxx);
wintype = 'hamming'
winlen = 201;
winamp = [0.5,1]*(1/winlen);
zc = zerocross(normPxx',wintype,winamp(1),winlen);
N = length(pxx);
out = (winlen-1)/2:(N+winlen-1)-(winlen-1)/2;
f(16386) = f(16385);
normPxx(16386) = normPxx(16385);
figure
subplot(2,1,1)
plot(f,normPxx)
xlabel('Frequency (Hz)')
ylabel('Normalized Power')
ylim([-1,38])
xlim([0 5000])
set(gca,'TickDir','out');
set(gca,'box','off')
ylim([-2,38])
subplot(2,1,2)
plot(f,zc(out))
xlabel('Frequency (Hz)')
ylabel('Zero Crossing Rate')
plot(f,zc(out),'r')
xlabel('Frequency (Hz)')
ylabel('Zero Crossing Rate')
ylim([-.0055,.042])
xlim([0 5000])
set(gca,'TickDir','out');
set(gca,'box','off')