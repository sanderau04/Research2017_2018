function [analysisTablePauseDetails, analysisTableSpeechDetails,...
    analysisTableSummary, energyMatrix] = speechAnalysis(...
    detectionWTime,... % Matrix of refined speech detection and corresponding sample times.
    waveformWithTime,... % Matrix of raw waveform and corresponding sample times
    Fs)
% speechAnalysis function performs both speech detection and frequency
% analysis on the entire audio recording file. Returns three tables
% enclosing all speech analysis data outcomes.

global indSpeechStart indSpeechStop

recordStart = detectionWTime(1,1); % Assigning start time of recording to variable recordStart
recordEnd = detectionWTime(1,length(detectionWTime(1,:))); % Assigning stop time of recording to variable recordEnd


%% Speech Detection
% Performing logical indexing on speech detection to determine speech start
% and stop times throughout entire recording sample.
dx = diff(detectionWTime(2,:)); % Assigning array dx to the difference of each element in speech detection array.
indSpeechStart = find(dx == 1); % Finding the indices in dx where speech is initiated.
indSpeechStop = find(dx == -1); % Finding the indices in dx where speech is concluded.
timeStartSpeech = detectionWTime(1,indSpeechStart); % Assign array of all speech start times
timeStopSpeech = detectionWTime(1,indSpeechStop); % Assign array of all speech stop times

%% Speech Analysis: Debug
% Debugging for constant speech presence or constant speech non present.

if((length(timeStartSpeech)) == 0 || (isempty(timeStopSpeech) == 1) || (length(indSpeechStop) <= 1) )
    initialSpeechLag = 0;
    finalSpeechLag = 0;
    timeStopPause = 0;
    timeStartPause = 0;
    speechPauseDuration = 0;
    speechPauseNumber = 0;
    averageSpeechPauseLength = 0;
    averageSpeechLength = 0;
    stdSpeechPauseLength = 0;
    speechPauseOccuranceTotal = 0;
    speechNumber = 0;
    speechDuration = 0;
    maxF = 0;
    meanF = 0;
    timeStartSpeech = 0;
    timeStopSpeech = 0;
    stdSpeechLength = 0;
    speechOccuranceTotal = 0;
    percentPausePresent = 0;
    percentSpeechPresent = 0;
    percentFreqLT500 = 0;
    percentFreqMT500 = 0;
    stdMaxF = 0;
    stdMeanF = 0;
    energyMatrix = 0;
    
    
    
    
else
    %% Speech Analysis: Speech Lag
    %  Assigning variables for initial speech lag and final speech lag.
    if(timeStartSpeech(1) ~= 0)
        initialSpeechLag = timeStartSpeech(1) - recordStart;
    else
        initialSpeechLag = 0;
    end
    if(timeStopSpeech(length(timeStopSpeech)) ~= recordEnd)
        finalSpeechLag = recordEnd - timeStopSpeech(length(timeStopSpeech));
    else
        finalSpeechLag = 0;
    end
    
    %% Speech Analysis: Speech Pause
    % Determining speech pause start, stop and duration.
    for x = 1:length(timeStartSpeech)
        if(x ~= 1)
            timeStopPause(x - 1) = timeStartSpeech(x); % Assigning all audio speech pause conlcusions to array timeStopPause.
        end
        
        if(x ~= length(timeStopSpeech))
            timeStartPause(x) = timeStopSpeech(x); % Assigning all audio speech pause initiations to array timeStartPause.
        end
    end
    
    for k = 1:length(timeStartPause)
        speechPauseDuration(k) = timeStopPause(k) - timeStartPause(k); % Determining speech pause durations.
        speechPauseNumber(k) = k; % Assigning each speech pause to its respective sequential occurrence.
    end
    %% Speech Analysis: Speech Epoch
    % Determing speech epoch duration and occurence number.
    for w = 1:length(timeStartSpeech)
        speechDuration(w) = timeStopSpeech(w) - timeStartSpeech(w); % Determining speech epoch durations.
        speechNumber(w)= w; % Assigning each speech epoch to its respective sequential occurrence.
    end
    %% Speech Analysis: Frequency
    % Frequency analysis for speech present audio.
    %fig = figure
    for z = 1:length(indSpeechStart)
        epoch = waveformWithTime(1,indSpeechStart(z):indSpeechStop(z)); % Extracting "zth" speech epoch.
        freq = meanfreq(epoch,Fs); % Taking meanfreq of speech epoch.
        [pxx, f] = pwelch(epoch,[],[],[],Fs); % Taking pwelch of speech epoch.
        [~,I] = max(pxx); % Finding max power density of epoch frequency distribution.
        freqCutOff = find(f <= 8000);
        energySum = sum(pxx(freqCutOff));
        i = 1;
        for y = 100:100:8000 % Finding power within incrementing 100 HZ
            freqBand = find((f > y - 100 ) & (f <= y));
            sumFreqBandEnergy = sum(pxx(freqBand));
            avgEnergyForBand(i) = (sumFreqBandEnergy / energySum) * 100;
            i = i + 1;
        end
        energyMatrix(:,z) = avgEnergyForBand;
        meanF(z) = freq; % Extracting frequency relating to the average found in each speech epoch.
        maxF(z) = f(I); % Extracting frequency relating to highest power density.
        indLess500 = find(maxF < 500); % Extracting indices where array maxF is below 500 Hz.
        indGreat500 = find(maxF >= 500); % Extracting indeices where array maxF is above or equal to 500 Hz.
        loglog(f,pxx)
        hold on
        %{
        h = kstest2(pxxFreq,pxx,'Alpha',0.0001);
        if(h == 0 || h == 1)
           detectFreqFilt(indSpeechStart(z):indSpeechStop(z)) = 1; 
        end
        %}
    end
    %% Speech Analysis: Summary
    % Calculated overall summary results from recording sample.
    averageSpeechPauseLength = mean(speechPauseDuration);
    stdSpeechPauseLength = std(speechPauseDuration);
    speechPauseOccuranceTotal = length(speechPauseNumber);
    averageSpeechLength = mean(speechDuration);
    stdSpeechLength = std(speechDuration);
    speechOccuranceTotal = length(speechNumber);
    percentSpeechPresent = (sum(speechDuration)/ (sum(speechPauseDuration) + sum(speechDuration)))*100;
    percentPausePresent = 100 - percentSpeechPresent;
    percentFreqLT500 = (length(indLess500) / (length(indLess500) + length(indGreat500))) * 100;
    percentFreqMT500 = 100 - percentFreqLT500;
    stdMaxF = std(maxF);
    stdMeanF = std(meanF);
end
%% Analysis Results
% Assigning all analysis result variables to tables to be saved in a mat file.

% Table 1 of 3: Detailed information on speech pause analysis.
analysisTablePauseDetails = table(speechPauseNumber',timeStartPause',...
    timeStopPause',speechPauseDuration');
% Table 2 of 3: Detailed information on speech epoch analysis.
analysisTableSpeechDetails = table(speechNumber',timeStartSpeech',...
    timeStopSpeech',speechDuration', maxF', meanF');
% Table 3 of 3: Summary of speech pause an epoch analysis and more.
analysisTableSummary = table(initialSpeechLag, finalSpeechLag, ...
    averageSpeechPauseLength, stdSpeechPauseLength, speechPauseOccuranceTotal, ...
    averageSpeechLength, stdSpeechLength, speechOccuranceTotal, percentPausePresent,...
    percentSpeechPresent, percentFreqLT500, percentFreqMT500, stdMaxF, stdMeanF);

% Table 1 of 3: Table headers.
analysisTablePauseDetails.Properties.VariableNames = {'SP_Number' 'SP_Start_Time'...
    'SP_End_Time' 'SP_Duration'};
% Table 2 of 3: Table headers.
analysisTableSpeechDetails.Properties.VariableNames = {'Speech_Epoch_Number'...
    'Speech_Start_Time' 'Speech_End_Time' 'Speech_Epoch_Duration'...
    'Speech_Epoch_Max_Frequency' 'Speech_Epoch_Mean_Frequency'};
% Table 3 of 3: Table headers.
analysisTableSummary.Properties.VariableNames = {'Initial_Speech_Lag' ...
    'Final_Speech_Lag' 'Average_SP_Length' 'Standard_Deviation_of_SP_Length'...
    'SP_Total_Occurance' 'Average_Speech_Epoch_Length', ...
    'Standard_Deviation_of_Speech_Epoch_Length' 'Speech_Epoch_Total_Occurance'...
    'Percent_Pause_Present' 'Percent_Speech_Present' 'Percent_Freq_Below_500Hz'...
    'Percent_Above_500Hz' 'Standard_Deviation_Max_Frequency' 'Standard_Deviation_Mean_Frequency'};
end