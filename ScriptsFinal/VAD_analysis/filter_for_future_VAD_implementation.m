%% Code copied from user Star Strider from the following forum: 
% https://www.mathworks.com/matlabcentral/answers/357022-can-you-help-remove-the-noise-from-this-audio-file

Fs = sample_rate;                                       % Sampling Frequency (Hz)
Fn = Fs/2;                                              % Nyquist Frequency (Hz)
Wp = 1000/Fn;                                           % Passband Frequency (Normalised)
Ws = 1010/Fn;                                           % Stopband Frequency (Normalised)
Rp =   1;                                               % Passband Ripple (dB)
Rs = 150;                                               % Stopband Ripple (dB)
[n,Ws] = cheb2ord(Wp,Ws,Rp,Rs);                         % Filter Order
[z,p,k] = cheby2(n,Rs,Ws,'low');                        % Filter Design
[soslp,glp] = zp2sos(z,p,k);  
filtered_sound = filtfilt(soslp, glp, sample_data);
