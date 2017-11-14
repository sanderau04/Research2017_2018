clear all, close all, clc

filename = 'frequencySample_2000_1000Hz.wav';
[y, Fs] = audioread(filename);

%%

c = cceps(y); %Taking the complex cepstral of waveform y
dt = 1/Fs; %converting each sample to time domain
t = 0:dt:length(y)*dt - dt; %array of each sample in time domain

%finding value to reshape c and t arrays that maintains same size
for i = 15:40
    if(rem(length(c),i) == 0)
        numSamp = i; %value to reshape t and c arrays
        i = 40;
    else
        i = i + 1;
    end
end
%reshaping  t and c to determine max cepstral values per numSamp number of
%samples
t = reshape(t,[numSamp,(length(t)/numSamp)]);
c = reshape(c,[numSamp,(length(c)/numSamp)]);
[~,I] = max(c,[],1); %finding maximum cepstral value of each column in array c 

%Determining fundamental frequencies of each column in c 
for j = 1:length(c(1,:))
    FundFreq(j,1) = 1/(t(I(j),j));
    FundFreq(j,2) = t(1,j);
end
