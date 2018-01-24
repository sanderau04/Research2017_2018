function [analysisTablePauseDetails, analysisTableSpeechDetails, analysisTableSummary, debuggingTable] = speechPauseAnalysis(...
    detectionWTime,... %Matrix of refined speech detection and corresponding sample times
    noiseThresholdWavPos,... %upper threshold of background noise waveform amplitude
    noiseThresholdWavNeg,...
    waveformWithTime,...
    Fs) %lower threshold of background noise waveform amplitude

recordStart = detectionWTime(1,1); %saving start time of recording
recordEnd = detectionWTime(1,length(detectionWTime(1,:))); %saving stop time of recording

%% Performing logical indexing on speech detection to determine speech start and stop times throughout entire recording sample
dx = diff(detectionWTime(2,:));
indSpeechStart = find(dx == 1);
indSpeechStop = find(dx == -1);
timeStartSpeech = detectionWTime(1,indSpeechStart); %assign array of all speech start times
timeStopSpeech = detectionWTime(1,indSpeechStop); %assign array of all speech stop times
wavSpeechpresent = waveformWithTime(1,indSpeechStart);

if((length(timeStartSpeech)) == 0 || (length(timeStopSpeech) == 0))%Debugging for constant speech presence or constant speech non present
    initialSpeechLag = 0;
    finalSpeechLag = 0;
    timeStopPause = 0;
    timeStartPause = 0;
    speechPauseDuration = 0;
    speechPauseNumber = 0;
    averageSpeechPauseLength = 0;
    stdSpeechPauseLength = 0;
    speechPauseOccuranceTotal = 0;
    detectionError = 0;
    thresholdArray = 0;
    
else
%% Assigning Variables for initial speech lag and final speech lag
initialSpeechLag = timeStartSpeech(1) - recordStart;
finalSpeechLag = recordEnd - timeStopSpeech(length(timeStopSpeech));

%% Determining speech pause start, stop and duration
    
for x = 1:length(timeStartSpeech)
    if(x ~= 1)
        timeStopPause(x - 1) = timeStartSpeech(x);
    end
    
    if(x ~= length(timeStopSpeech))
        timeStartPause(x) = timeStopSpeech(x);
    end
x = x + 1;
end

for k = 1:length(timeStartPause)
    speechPauseDuration(k) = timeStopPause(k) - timeStartPause(k);
    speechPauseNumber(k) = k;
    k = k + 1;
end

for w = 1:length(timeStartSpeech)
    speechDuration(w) = timeStopSpeech(w) - timeStartSpeech(w);
    speechNumber(w)= w;
    w = w + 1;
end
    
%% Frequency analysis for speech present Audio
for z = 1:length(indSpeechStart)
    epoch = waveformWithTime(1,indSpeechStart(z):indSpeechStop(z)); %extracting "zth" speech epoch 
    [pxx, f] = pwelch(epoch,[],[],[],Fs); %taking pwelch of speech epoch
    [~,I] = max(pxx); %finding max power density of epoch frequency distribution
    maxF(z) = f(I); %extracting frequency relating to highest power density
   end

%% Calculated overall summary results from recording sample
averageSpeechPauseLength = mean(speechPauseDuration);
stdSpeechPauseLength = std(speechPauseDuration);
speechPauseOccuranceTotal = length(speechPauseNumber);
averageSpeechLength = mean(speechDuration);
stdSpeechLength = std(speechDuration);
speechOccuranceTotal = length(speechNumber);
%% Creating variables to be used in the debugging process
detectionError = zeros(1,length(speechDuration));
thresholdArray = zeros(1,length(speechDuration));
thresholdArray(1) = noiseThresholdWavPos;
thresholdArray(2) = noiseThresholdWavNeg;
ThresholdLow = averageSpeechLength - (2 * stdSpeechLength);
indError = find(speechDuration < ThresholdLow);
detectionError(indError) = speechDuration(indError);
end
%% Assigning tables to be saved in a mat file

debuggingTable = table(thresholdArray', speechNumber', detectionError'); %Table 1 of 4: display of variables to be used in debugging process
analysisTablePauseDetails = table(speechPauseNumber',timeStartPause',timeStopPause',speechPauseDuration'); %Table 2 of 4: detailed information of speech analysis
analysisTableSpeechDetails = table(speechNumber',timeStartSpeech',timeStopSpeech',speechDuration', maxF');
analysisTableSummary = table(initialSpeechLag, finalSpeechLag, averageSpeechPauseLength, stdSpeechPauseLength, speechPauseOccuranceTotal, averageSpeechLength, stdSpeechLength, speechOccuranceTotal); %Table 4 of 4: summary information of speech analysis
analysisTablePauseDetails.Properties.VariableNames = {'SP_Number' 'SP_Start_Time' 'SP_End_Time' 'SP_Duration'};
analysisTableSpeechDetails.Properties.VariableNames = {'Speech_Epoch_Number' 'Speech_Start_Time' 'Speech_End_Time' 'Speech_Epoch_Duration', 'Speech_Epoch_Avg_Frequency'};
analysisTableSummary.Properties.VariableNames = {'Initial_Speech_Lag' 'Final_Speech_Lag' 'Average_SP_Length' 'Standard_Deviation_of_SP_Length' 'SP_Total_Occurance' 'Average_Speech_Epoch_Length', 'Standard_Deviation_of_Speech_Epoch_Length' 'Speech_Epoch_Total_Occurance'};
debuggingTable.Properties.VariableNames = {'Pos_Neg_Noise_Threshold' 'Speech_Epoch_Number' 'Speech_Detection_Error'};



