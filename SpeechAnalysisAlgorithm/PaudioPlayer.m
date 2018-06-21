clc, close all
load('D:\Documents\Research2017\MATLAB\SpeechAnalysisAlgorithm\SpeechTaskResults\Patient_35__14-Jun-2018_10_59_08_.mat')
f = figure;
plot(waveformWithTime(2,:), waveformWithTime(1,:))
hold on
plot(detectionWTime(1,:),detectionWTime(2,:))
ylim([-1.2,1.2])
xlim1 = 0;
xlim2 = 20;
xlim([xlim1 xlim2])
h=line([0,0],[-60,5],'color','m','marker', 'o', 'linewidth', 2);

for z = 1:length(indSpeechStart)
    epoch = waveformWithTime(2,indSpeechStart(z):indSpeechStop(z));
    epochGroups(z,1) = epoch(1);
    epochGroups(z,2) = epoch(end);
end
%pause(3)
%xlim([xlim1+10 xlim2+10])


%sound(waveformWithTime(1,indDetect), 48000)
%%
i = 1;

while (i >= 1 && i<= length(indSpeechStart))
    clear startPrompt
    startPrompt = '[0] Previous, [1] Play, [2] Next: ';
    choice = input(startPrompt);
    switch choice 
        case 0
            i = i - 1;
        case 1
            disp('playing...')
        case 2
            i = i + 1;
    end
    
    time = 0;
    sound(waveformWithTime(1,indSpeechStart(i):indSpeechStop(i)), 48000)
    tic % Starts Matlab timer
    t=toc;
    while time<epochGroups(i,2)
        time = epochGroups(i,1) + t; 
        set(h,'xdata',(time)*[1,1])
        drawnow
        t= toc; % get the current time for the next update
        if(h.XData(1) > (xlim1 + 10))
            xlim1 = xlim1 + 5;
            xlim2 = xlim2 + 5;
            xlim([xlim1 xlim2]);ind
        end
    end
end
