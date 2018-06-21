function visualDebug()
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
global detectWaveform Fs detectdBaudio noiseThresholdDb detectionWTime

dx = diff(detectionWTime(2,:));
indSpeechStop = find(dx == -1);

time=(0:length(detectdBaudio)-1)/Fs;
%indVisDetection = find(speechDetection == 0);
%speechDetection(indVisDetection) = -40;
figure
plot(time, detectdBaudio)
hold on

%indTime = find(time == detectoinWTime(1,indSpeechStop))

%vline()

%plot(time,speechDetection,'g');
ylim([-60,5]);
hlinePos = refline([0 noiseThresholdDb]);
hlinePos.Color = 'r';
hold off
xlabel('Time (s)')
grid on
end_time = length(detectWaveform)/Fs;

h=line([0,0],[-60,5],'color','m','marker', 'o', 'linewidth', 2);

sound(detectWaveform, Fs) % starts playing the sound
tic % Starts Matlab timer
t=toc; % Gets the time since the timer started
while t<end_time
   set(h, 'xdata', t*[1,1]) % Moves the line to the time indicated by t
   drawnow % necessary to get figure updated
   t=toc; % get the current time for the next update
end

end

