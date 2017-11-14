function [noiseThresholdWavPos,noiseThresholdWavNeg] = ...
    findThresholdImport(filename)%import the filename selected be the user

    [y, Fs] = audioread(filename); %extract waveform and sample rate from .wav recording
    samples = [1,5*Fs]; %assign a variable that extracts waveform data of the first 5 seconds of imported recording 
    [noiseDataPlay, Fs] = audioread(filename, samples); %extract waveform data of the first 5 seconds of imported recording
    [noiseData, Fs] = audioread(filename);
    %Create array of sample timestamps of first 5 second of imported
    %recording
    for k = 1:length(noiseData(:,1))
        time(k) = k/Fs;
        k = k + 1;
    end
    
    %% Prompt user for first 5 second imported recording information
    fprintf('The following is the first 5 seconds of your recording\n\n')
    pause(2);
    sound(noiseDataPlay,Fs);
    fprintf('This figure represents the waveform of the entire recording');
    f1 = figure('Name', 'Full Recording Waveform', 'NumberTitle', 'off'); 
    plot(time,noiseData);
    title('Waveform of Entire Imported Recording');
    xlabel('Time (s)');
    ylabel('Amplitude');
    pause(3)
    disp('please click on two points on the graph enclosing AT LEAST 10 seconds of the recording where speech is NOT PRESENT')
    [t, amp] = ginput(2);
    
    t = round(t*Fs);
   
    
    if(length(t) == 2)
        noiseData = noiseData(t(1):t(2));
    end
    
[yUpper, yLower] = envelope(noiseData, 1000, 'peak');

%% Create statistical noise threshold from given information
stdNoiseWavUp = std(yUpper);
stdNoiseWavLow = std (yLower);
noiseThresholdWavPos = mean(yUpper) + (3 * stdNoiseWavUp); 
noiseThresholdWavNeg = mean(yLower) - (3 * stdNoiseWavLow);
    
    


end

