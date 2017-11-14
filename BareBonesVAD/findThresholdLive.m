function [noiseThresholdWavPos, noiseThresholdWavNeg] = ...
    findThresholdLive(...
    recObj)% object to save waveform data from live recording
recObj.StartFcn = 'disp(''Do not speak until prompted '')'; %prompt user when to start speaking
record(recObj);
pause(10);
stop(recObj); 

noiseData = getaudiodata(recObj); %10 second audio sample of speech non present background noise
[yUpper, yLower] = envelope(noiseData, 1000, 'peak'); %enveloping 5 second background noise

%% Create statistical noise threshold from given information
stdNoiseWavUp = std(yUpper);
stdNoiseWavLow = std (yLower);
noiseThresholdWavPos = mean(yUpper) + (3 * stdNoiseWavUp); 
noiseThresholdWavNeg = mean(yLower) - (3 * stdNoiseWavLow);

end


    
     


