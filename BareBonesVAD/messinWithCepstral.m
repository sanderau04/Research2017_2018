 % get a section of vowel
[x,fs]=audioread('frequencySample_2000_1000Hz.wav');
ms1=fs/5000;                 % maximum speech Fx at 1000Hz
ms20=fs/50;                  % minimum speech Fx at 50Hz
%
% plot waveform
t=(0:length(x)-1)/fs;        % times of sampling instants
subplot(3,1,1);
plot(t,x);
legend('Waveform');
xlabel('Time (s)');
ylabel('Amplitude');
%
% do fourier transform of windowed signal
Y=fft(x.*hamming(length(x)));
%
% plot spectrum of bottom 5000Hz
hz5000=5000*length(Y)/fs;
f=(0:hz5000)*fs/length(Y);
subplot(3,1,2);
plot(f,20*log10(abs(Y(1:length(f)))+eps));
legend('Spectrum');
xlabel('Frequency (Hz)');
ylabel('Magnitude (dB)');
%
% cepstrum is DFT of log spectrum
C=fft(log(abs(Y)+eps));
%
% plot between 1ms (=1000Hz) and 20ms (=50Hz)
q=(ms1:ms20)/fs;
subplot(3,1,3);
plot(q,abs(C(ms1:ms20)));
legend('Cepstrum');
xlabel('Quefrency (s)');
ylabel('Amplitude');
[~,I] = max(abs(C(ms1:ms20)));
1/q(I)
