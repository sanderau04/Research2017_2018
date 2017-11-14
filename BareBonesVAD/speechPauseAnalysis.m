function [analysisTableDetails, analysisTableSummary, debuggingTable] = speechPauseAnalysis(...
    detectionWTime,... %Matrix of refined speech detection and corresponding sample times
    noiseThresholdWavPos,... %upper threshold of background noise waveform amplitude
    noiseThresholdWavNeg) %lower threshold of background noise waveform amplitude

recordStart = detectionWTime(1,1); %saving start time of recording
recordEnd = detectionWTime(1,length(detectionWTime(1,:))); %saving stop time of recording

%% Performing logical indexing on speech detection to determine speech start and stop times throughout entire recording sample
dx = diff(detectionWTime(2,:));
indSpeechStart = find(dx == 1);
indSpeechStop = find(dx == -1);
timeStartSpeech = detectionWTime(1,indSpeechStart); %assign array of all speech start times
timeStopSpeech = detectionWTime(1,indSpeechStop); %assign array of all speech stop times
if((length(timeStartSpeech)) == 0 || (length(timeStopSpeech) == 0))
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

%% Calculated overall summary results from recording sample
averageSpeechPauseLength = mean(speechPauseDuration);
stdSpeechPauseLength = std(speechPauseDuration);
speechPauseOccuranceTotal = length(speechPauseNumber);
%% Creating variables to be used in the debugging process
detectionError = zeros(1,length(speechPauseDuration));
thresholdArray = zeros(1,length(speechPauseDuration));
thresholdArray(1) = noiseThresholdWavPos;
thresholdArray(2) = noiseThresholdWavNeg;
pauseThresholdLow = averageSpeechPauseLength - (3 * stdSpeechPauseLength);
indError = find(speechPauseDuration < pauseThresholdLow);
detectionError(indError) = speechPauseDuration(indError);
end
%% Assigning tables to be saved in a mat file
debuggingTable = table(thresholdArray',detectionError'); %Table 1 of 3: display of variables to be used in debugging process
analysisTableDetails = table(speechPauseNumber',timeStartPause',timeStopPause',speechPauseDuration'); %Table 2 of 3: detailed information of speech analysis
analysisTableSummary = table(initialSpeechLag, finalSpeechLag, averageSpeechPauseLength, stdSpeechPauseLength, speechPauseOccuranceTotal); %Table 3 of 3: summary information of speech analysis
analysisTableDetails.Properties.VariableNames = {'SP_Number' 'SP_Start_Time' 'SP_End_Time' 'SP_Duration'};
analysisTableSummary.Properties.VariableNames = {'Initial_Speech_Lag' 'Final_Speech_Lag' 'Average_SP_Length' 'Standard_Deviation_of_SP_Length' 'SP_Total_Occurance'};
debuggingTable.Properties.VariableNames = {'Pos_Neg_Noise_Threshold' 'Pause_Detection_Error'};






end

