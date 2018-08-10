clear all, clc
%% Reading in all mat files
myFolder = uigetdir('D:\Documents\Research2017\MATLAB','Pick a folder containing mat files');

if ~isdir(myFolder)
    errorMessage = sprintf('Error: The following folder does not exist:\n%s', myFolder);
    uiwait(warndlg(errorMessage));
    return;
end

filePattern = fullfile(myFolder, '*.mat');
matFiles = dir(filePattern);

for k = 1:length(matFiles)
    baseFileName = matFiles(k).name;
    fullFileName = fullfile(myFolder, baseFileName);
    matData(k) = load(fullFileName);
end
%%
for q=1:length(matData)
    indSpeechStartRaw = matData(q).indSpeechStart;
    indSpeechStopRaw = matData(q).indSpeechStop;
    EpochLabel = matData(q).EpochLabel;
    audioWExt = matData(q).audioWExt;
    audioFilename = [matFiles(q).folder,'\',audioWExt];
    Fs = matData(q).Fs;
    
    waveform = audioread(audioFilename);
    
    if(length(waveform(1,:)) ~= 1) % Condition is true when file is a recording in stereo.
        waveform = sum(waveform, 2) / size(waveform,2); % Converts stereo recording to mono.
    end
    
    % Assigning timestamps to each sample taken in myRecording.
    for x = 1:length(waveform)
        time(x) = x/Fs; % Save timestamps to array 'time'.
    end
    
    waveformWithTimeRaw(1,:) = waveform;
    waveformWithTimeRaw(2,:) = time;
    
    % Inserting leading and trailing zero to debug for speechAnalysis.
    waveformWithTime = zeros(2,(length(waveformWithTimeRaw(1,:)) + 2));
    waveformWithTime(:,2:(end - 1)) = waveformWithTimeRaw;
    waveformWithTime(1,end) = waveformWithTimeRaw(2,end);
    
    j=1;
    PCount = 0;
    OCount = 0;
    CCount = 0;
    for x=1:length(indSpeechStartRaw)
        if char(EpochLabel{x}) == 'P'
            indSpeechStart(j) = indSpeechStartRaw(x);
            indSpeechStop(j) = indSpeechStopRaw(x);
            j = j + 1;
            PCount = PCount + 1;
        elseif char(EpochLabel{x}) == 'O'
            OCount = OCount + 1;
        elseif char(EpochLabel{x}) == 'C'
            CCount = CCount + 1;
        end   
    end
    
    
    if (exist('indSpeechStart','var') == 1)
        
        recordStart = waveformWithTime(2,1); % Assigning start time of recording to variable recordStart
        recordEnd = waveformWithTime(2,length(waveformWithTime(2,:)) - 1); % Assigning stop time of recording to variable recordEnd
        
        
        %% Speech Detection
        % Performing logical indexing on speech detection to determine speech start
        % and stop times throughout entire recording sample.
        
        timeStartSpeech = waveformWithTime(2,indSpeechStart); % Assign array of all speech start times
        timeStopSpeech = waveformWithTime(2,indSpeechStop); % Assign array of all speech stop times
        
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
            detectFreqFilt = 0;
            energyMatrixPatientOnly = 0;
            PCmean = 0;
            PCstd = 0;
            PCmax = 0;
            PCmin = 0;
            domFreqSlope = 0;
            meanFreqSlope = 0;
            PCmeanSlope = 0;
            PCmaxSlope = 0;
            PCminSlope = 0;
            pxxSkew = 0;
            pxxKurt = 0;
            PtoCRatio = 0;
            PtoORatio = 0;
            meanZCepoch = 0;
            maxZCepoch = 0;
            minZCepoch = 0;
            stdZCepoch = 0;
            meanZCpxx = 0;
            maxZCpxx = 0;
            minZCpxx = 0;
            stdZCpxx = 0;
            timeEslope = 0;
            shittyFormant1 = 0;
            shittyFormant2 = 0;
            shittyFormant3 = 0;
            stdF1 = 0;
            avgF1 = 0;
            slopeF1 = 0;
            stdF2 = 0;
            avgF2 = 0;
            slopeF2 = 0;
            stdF3 = 0;
            avgF3 = 0;
            slopeF3 = 0;
            avgMeanZCPs = 0;
            stdMeanZCPs = 0;
            avgMaxZCPs = 0;
            stdMaxZCPs = 0;
            avgMinZCPs = 0;
            stdMinZCPs = 0;
            avgStdZCPs = 0;
            sumStdZCPs = 0;
            medMedZCPs = 0;
            avgMedZCPs = 0;
            stdMedZCPs = 0;
            medSPF = 0;
            avgSPF =  0;
            stdSPF = 0;
            
            
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
            detectFreqFilt = zeros(length(waveformWithTime(1,:)),1);
            %fig = figure
            wintype = 'hamming';
            winlen = 201;
            winamp = [0.5,1]*(1/winlen);
            for z = 1:length(indSpeechStart)
                %% Initializing variables used in multiple feature extractions
                epoch = waveformWithTime(1,indSpeechStart(z):indSpeechStop(z)); % Extracting "zth" speech epoch.
                N = length(epoch);
                [pxx, f] = pwelch(epoch,[],[],[],Fs); % Taking pwelch of speech epoch.
                
      
                freq = meanfreq(epoch,Fs); % Taking meanfreq of speech epoch.
                %% Zerocrossing and energy feature extraction
                out = (winlen-1)/2:(N+winlen-1)-(winlen-1)/2;
                t = (out-(winlen-1)/2)*(1/Fs);
                ZcrossEpoch = zerocross(epoch,wintype, winamp(1), winlen);
                timeEnergy = energy(epoch,wintype,winamp(2),winlen);
                timeEpoly = polyfit(t,timeEnergy(out),1);
                normPxx = zscore(pxx);
                dumbNormPxx = normPxx.';
                ZcrossPxx = zerocross(dumbNormPxx,wintype, winamp(1), winlen);
                %{
                NPSD = length(pxx);
                outPSD = (winlen-1)/2:(NPSD+winlen-1)-(winlen-1)/2;
                outPSD = outPSD(1:end-1);
                ampZcrossPxx = 150.*ZcrossPxx;
                f(z) = figure('visible', 'off', 'pos', [10 10 1920 1080]);
                plot(normPxx)
                hold on
                plot(ampZcrossPxx(outPSD),'r','LineWidth',2)
                hold off
                xlim([0 3000]);
                title(num2str(z))
                xlabel('array indices')
                ylabel('ZCR and PSD')
                legend('Normalized (Zscore) PSD', 'Amplified (150X) ZCR')
                figName = num2str(z);
                saveas(f(z),figName,'png');
                %}
                %% Shitty Formants extraction
                %{
                [~,ind3Formants] = maxk(pxx,3);
                shittyFormant1(z) = f(ind3Formants(1));
                shittyFormant2(z) = f(ind3Formants(2));
                shittyFormant3(z) = f(ind3Formants(3));
                %}
                %% Less Shitty Formants extraction
                [~,fSpect,tSpect,psSpect] = spectrogram(epoch,[],[],[],Fs);
                
                for si = 1:length(psSpect(1,:))
                    [~,~,a5,~] = autolpc(psSpect(:,si),5);
                    a5 = a5';
                    pxx5 = filter([0 -a5(2:end)],1,psSpect(:,si));
                    [~,ind3Formants] = maxk(pxx5,3);
                    tempF1(si) = fSpect(ind3Formants(1));
                    tempF2(si) = fSpect(ind3Formants(2));
                    tempF3(si) = fSpect(ind3Formants(3));
                    
                    normPsSpect = zscore(psSpect(:,si));
                    dumbPsSpect = normPsSpect';
                    ZcrossPsSpect = zerocross(dumbPsSpect,wintype, winamp(1), winlen);
                    
                    tempMeanZCPs(si) = mean(ZcrossPsSpect);
                    tempMedZCPs(si) = median(ZcrossPsSpect);
                    tempMinZCPs(si) = min(ZcrossPsSpect);
                    tempMaxZCPs(si) = max(ZcrossPsSpect);
                    tempStdZCPs(si) = std(ZcrossPsSpect);
                    
                    num=geomean(psSpect(:,si));
                    den=mean(psSpect(:,si));
                    spf=num/den;
                    tempSPF(si) =  spf;
                    
                    clear a5 pxx5 ind3Formants ZcrossPsSpect dumbPsSpect normPsSpect num den spf
                end
                
                stdF1(z) = std(tempF1);
                avgF1(z) = mean(tempF1);
                polyF1 = polyfit(tSpect,tempF1,1);
                slopeF1(z) = polyF1(1);
                
                stdF2(z) = std(tempF2);
                avgF2(z) = mean(tempF2);
                polyF2 = polyfit(tSpect,tempF2,1);
                slopeF2(z) = polyF2(1);
                
                stdF3(z) = std(tempF3);
                avgF3(z) = mean(tempF3);
                polyF3 = polyfit(tSpect,tempF3,1);
                slopeF3(z) = polyF3(1);
                
                avgMeanZCPs(z) = mean(tempMeanZCPs);
                stdMeanZCPs(z) = std(tempMeanZCPs);
                
                avgMaxZCPs(z) = mean(tempMaxZCPs);
                stdMaxZCPs(z) = std(tempMaxZCPs);
                
                avgMinZCPs(z) = mean(tempMinZCPs);
                stdMinZCPs(z) = std(tempMinZCPs);
                
                avgStdZCPs(z) = mean(tempStdZCPs);
                sumStdZCPs(z) = sum(tempStdZCPs);
                
                medMedZCPs(z) = median(tempMedZCPs);
                avgMedZCPs(z) = mean(tempMedZCPs);
                stdMedZCPs(z) = std(tempMedZCPs);
                
                medSPF(z) = median(tempSPF);
                avgSPF(z) = mean(tempSPF);
                stdSPF(z) = std(tempSPF);
                
                rmsEpoch(z) = rms(epoch);
               
                
                clear polyF1 polyF2 polyF3 tempF1 tempF2 tempF3 fSpect tSpect psSpect...
                    tempMeanZCPs tempMaxZCPs tempMinZCPs tempStdZCPs tempSPF
                
                
                %{
                [~,delta] = mfcc(epoch',Fs);
                M = max(delta,[],1);
                [~,ind3Largest] = maxk(M,3);
                
                for u=1:length(ind3Largest)
                   switch ind3Largest(u)
                       case 1
                           tempInd = find(f >= 133 & f <= 267);
                       case 2
                           tempInd = find(f >= 200 & f <= 333);
                       case 3
                           tempInd = find(f >= 267 & f <= 400);
                       case 4
                           tempInd = find(f >= 333 & f <= 467);
                       case 5
                           tempInd = find(f >= 400 & f <= 533);
                       case 6 
                           tempInd = find(f >= 467 & f <= 600);
                       case 7
                           tempInd = find(f >= 533 & f <= 667);
                       case 8 
                           tempInd = find(f >= 600 & f <= 733);
                       case 9
                           tempInd = find(f >= 667 & f <= 800);
                       case 10
                           tempInd = find(f >= 733 & f <= 867);
                       case 11
                           tempInd = find(f >= 800 & f <= 933);
                       case 12
                           tempInd = find(f >= 867 & f <= 999);
                       case 13
                           tempInd = find(f >= 933 & f <= 1071);
                       case 14
                           tempInd = find(f >= 999 & f <= 1147);
                   end
                   tempMaxPxx = max(pxx(tempInd));
                   tempIndMaxpxx = find(pxx == tempMaxPxx);
                   shittyFormants(u) = f(tempIndMaxpxx);
                   clear tempInd tempMaxPxx tempIndMaxpxx
                
                end
                %}
                %% skew and kurtosis
                pxxSkew(z) = skewness(pxx);
                pxxKurt(z) = kurtosis(normPxx);
                %% some other shit
                [~,I] = max(pxx); % Finding max power density of epoch frequency distribution.
                [PCmeanTemp,PCstdTemp,PCmaxTemp,PCminTemp] = iosr.auditory.perceptualCentroid(epoch,Fs);
                freqCutOff = find(f <= 8000);
                energySum = sum(pxx(freqCutOff));
                i = 1;
                for y = 100:100:8000 % Finding power within incrementing 100 HZ Buckets
                    freqBand = find((f > y - 100 ) & (f <= y));
                    sumFreqBandEnergy = sum(pxx(freqBand));
                    avgEnergyForBand(i) = (sumFreqBandEnergy / energySum) * 100;
                    i = i + 1;
                end
                
                %%Assigning values
                energyMatrixPatientOnly(:,z) = avgEnergyForBand;
                meanF(z) = freq; % Extracting frequency relating to the average found in each speech epoch.
                maxF(z) = f(I); % Extracting frequency relating to highest power density.
                PCmean(z) = PCmeanTemp;
                PCstd(z) = PCstdTemp;
                PCmax(z) = PCmaxTemp;
                PCmin(z) = PCminTemp;
                meanZCepoch(z) = mean(ZcrossEpoch);
                maxZCepoch(z) = max(ZcrossEpoch);
                minZCepoch(z) = min(ZcrossEpoch);
                stdZCepoch(z) = std(ZcrossEpoch);
                meanZCpxx(z)  = mean(ZcrossPxx);
                maxZCpxx(z) = max(ZcrossPxx);
                minZCpxx(z) = min(ZcrossPxx);
                stdZCpxx(z) = std(ZcrossPxx);
                timeEslope(z) = timeEpoly(1);
                
                indLess500 = find(maxF < 500); % Extracting indices where array maxF is below 500 Hz.
                indGreat500 = find(maxF >= 500); % Extracting indeices where array maxF is above or equal to 500 Hz.
                %loglog(f,pxx)
                %hold on
                %{
        h = kstest2(pxxFreq,pxx,'Alpha',0.0001);
        if(h == 0 || h == 1)
           detectFreqFilt(indSpeechStart(z):indSpeechStop(z)) = 1;
        end
                %}
                clear avgEnergyForBand frqBand SumFreqBandEnergy epoch freq pxx f I PCmeanTemp...
                    PCstdTemp PCmaxTemp PCminTemp freqCutOff energySum ZcrossPxx ZcrossEpoch...
                    timeEpoly shittyFormants ind3Largest ind3Formants outPSD ampZcrossPxx normPxx
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
            domFreqFit = polyfit(timeStartSpeech,maxF,1);
            meanFreqFit = polyfit(timeStartSpeech,meanF,1);
            PCmeanFit = polyfit(timeStartSpeech,PCmean,1);
            PCmaxFit = polyfit(timeStartSpeech,PCmax,1);
            PCminFit = polyfit(timeStartSpeech,PCmin,1);
            domFreqSlope = domFreqFit(1);
            meanFreqSlope = meanFreqFit(1);
            PCmeanSlope = PCmeanFit(1);
            PCmaxSlope = PCmaxFit(1);
            PCminSlope = PCminFit(1);
            PtoCRatio = PCount / CCount;
            PtoORatio = PCount / OCount;
            
        end
        %% Analysis Results
        % Assigning all analysis result variables to tables to be saved in a mat file.
        
        % Table 1 of 3: Detailed information on speech pause analysis.
        analysisTablePauseDetailsPatient = table(speechPauseNumber',timeStartPause',...
            timeStopPause',speechPauseDuration');
        % Table 2 of 3: Detailed information on speech epoch analysis.
        analysisTableSpeechDetailsPatient = table(speechNumber',timeStartSpeech',...
            timeStopSpeech',speechDuration', maxF', meanF',PCmean',PCstd',PCmax',...
            PCmin', pxxSkew', pxxKurt', meanZCepoch', maxZCepoch', minZCepoch', stdZCepoch',...
            meanZCpxx', maxZCpxx', minZCpxx', stdZCpxx', timeEslope', avgF1', stdF1',...
            slopeF1', avgF2', stdF2', slopeF2', avgF3', stdF3', slopeF3', avgMeanZCPs',...
            stdMeanZCPs', avgMaxZCPs', stdMaxZCPs', avgMinZCPs', stdMinZCPs', ...
            avgStdZCPs', sumStdZCPs', medMedZCPs', avgMedZCPs', stdMedZCPs',...
            medSPF', avgSPF', stdSPF', rmsEpoch');
        % Table 3 of 3: Summary of speech pause an epoch analysis and more.
        analysisTableSummaryPatient = table(initialSpeechLag, finalSpeechLag, ...
            averageSpeechPauseLength, stdSpeechPauseLength, speechPauseOccuranceTotal, ...
            averageSpeechLength, stdSpeechLength, speechOccuranceTotal, percentPausePresent,...
            percentSpeechPresent, percentFreqLT500, percentFreqMT500, stdMaxF, stdMeanF,...
            domFreqSlope, meanFreqSlope, PCmeanSlope, PCmaxSlope, PCminSlope, PtoCRatio, PtoORatio);
        
        % Table 1 of 3: Table headers.
        analysisTablePauseDetailsPatient.Properties.VariableNames = {'SP_Number' 'SP_Start_Time'...
            'SP_End_Time' 'SP_Duration'};
        % Table 2 of 3: Table headers.
        analysisTableSpeechDetailsPatient.Properties.VariableNames = {'Speech_Epoch_Number'...
            'Speech_Start_Time' 'Speech_End_Time' 'Speech_Epoch_Duration'...
            'Speech_Epoch_Max_Frequency' 'Speech_Epoch_Mean_Frequency',...
            'Mean_Perceptual_Spectral_Centroid','Std_Perceptual_Spectral_Centroid'...
            ,'Max_Perceptual_Spectral_Centroid','Min_Perceptual_Spectral_Centroid'...
            'PSD_Skew' 'PSD_Kurtosis', 'Mean_ZC_Waveform', 'Max_ZC_Waveform',...
            'Min_ZC_Waveform', 'Std_ZC_Waveform', 'Mean_ZC_normPSD', 'Max_ZC_normPSD',...
            'Min_ZC_normPSD', 'Std_ZC_normPSD', 'Energy_Over_Time_Slope', 'avg_F1',...
            'std_F1', 'slope_F1', 'avg_F2', 'std_F2', 'slope_F2',  'avg_F3', ...
            'std_F3', 'slope_F3', 'avgMeanZCPs', 'stdMeanZCPs',  'avgMaxZCPs',...
            'stdMaxZCPs', 'avgMinZCPs', 'stdMinZCPs', 'avgStdZCPs', 'sumStdZCPs'...
            'medMedZCPs', 'avgMedZCPs', 'stdMedZCPs', 'medSPF', 'avgSPF', 'stdSPF'...
            'rmsEpoch'};
        % Table 3 of 3: Table headers.
        analysisTableSummaryPatient.Properties.VariableNames = {'Initial_Speech_Lag' ...
            'Final_Speech_Lag' 'Average_SP_Length' 'Standard_Deviation_of_SP_Length'...
            'SP_Total_Occurance' 'Average_Speech_Epoch_Length', ...
            'Standard_Deviation_of_Speech_Epoch_Length' 'Speech_Epoch_Total_Occurance'...
            'Percent_Pause_Present' 'Percent_Speech_Present' 'Percent_Freq_Below_500Hz'...
            'Percent_Above_500Hz' 'Standard_Deviation_Max_Frequency' 'Standard_Deviation_Mean_Frequency'...
            'Dom_Freq_Slope' 'Mean_Freq_Slope' 'PC_Mean_Slope' 'PC_Max_Slope' 'PC_Min_Slope'...
            'P_Label_To_C_Ratio' 'P_Label_To_O_Ratio'};
        
        matFilename = [matFiles(q).folder,'\',matFiles(q).name];
        
        
        save(matFilename, 'analysisTablePauseDetailsPatient', 'analysisTableSpeechDetailsPatient', 'analysisTableSummaryPatient','energyMatrixPatientOnly', '-append')
        clearvars -except matData baseFileName filePattern fullFileName matFiles myFolder q
        
    else
        analysisTablePauseDetailsPatient = table(0,0,0);
        analysisTableSpeechDetailsPatient = table(0,0,0);
        analysisTableSummaryPatient = table(0,0,0);
        energyMatrixPatientOnly = 0;
        matFilename = [matFiles(q).folder,'\',matFiles(q).name];

        save(matFilename, 'analysisTablePauseDetailsPatient', 'analysisTableSpeechDetailsPatient', 'analysisTableSummaryPatient','energyMatrixPatientOnly', '-append')
        
        clearvars -except matData baseFileName filePattern fullFileName matFiles myFolder q
    end
end