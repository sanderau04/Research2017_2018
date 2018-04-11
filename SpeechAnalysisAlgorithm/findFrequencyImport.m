function [pxxFreq] = findFrequencyImport(filename)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

[audData, Fs] = audioread(filename);

for k = 1:length(audData(:,1))
    time(k) = k/Fs;
    k = k + 1;
end

plot(time,audData);
title('Waveform of Entire Imported Recording');
xlabel('Time (s)');
ylabel('Amplitude');
pause(3)
disp('Please click on two points on the graph enclosing AT LEAST 10 seconds of speech present')
[t, ~] = ginput(6); % Input 4 data points and recieve their timestamps.
t = round(t*Fs); % Convert timestamps to sample numbers.

if(length(t) == 6)
    audData = audData([t(1):t(2) t(3):t(4) t(5):t(6)]); 
end


[pxxFreq, f] = pwelch(audData, [],[], [], Fs);
plot(f,pxxFreq)

end





