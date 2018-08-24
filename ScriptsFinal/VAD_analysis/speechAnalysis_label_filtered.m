%% speechAnalysis_label_filtered performs signal feature extraction 
% based on speech epeoch labeled patient mat files. Substantial increase in
% number of signal features extracted. Multiple 'Patient' epoch specific
% feature tables appended

%% Required patient mat file variables:
% indSpeechStart, indSpeechStop, EpochLabel, audioWExt, Fs  

%% Required Add-On libraries:
% Perceptual spectral centroid by Christopher Hummersone
% Formant Estimation by Speech Processing
% Audio Systems Toolbox by Matlab (Costs money but can get 30-day trial) 
% Short-time Energy and Zero Crossing Rate

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
%% Extract all signal features
for q=1:length(matData)
    % Assign all mat file variables needed
    indSpeechStartRaw = matData(q).indSpeechStart;
    indSpeechStopRaw = matData(q).indSpeechStop;
    EpochLabel = matData(q).EpochLabel;
    audioWExt = matData(q).audioWExt;
    audioFilename = [matFiles(q).folder,'\',audioWExt];
    Fs = matData(q).Fs;
    
    % Respective patient audio file must exist in mat file directory 
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
        % Debugging for constant speech presence or constant speech non
        % present. UPDATE WHAT THIS MEANS
        
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
            rmsEpoch = 0;
            rmsTimeEnergy = 0;
            maxM1 = 0;
            maxM2 = 0;
            maxM3 = 0;
            maxM4 = 0;
            maxM5 = 0;
            maxM6 = 0;
            maxM7 = 0;
            maxM8 = 0;
            maxM9 = 0;
            maxM10 = 0;
            maxM11 = 0;
            maxM12 = 0;
            maxM13 = 0;
            maxM14 = 0;
            slopeM1 = 0;
            slopeM2 = 0;
            slopeM3 = 0;
            slopeM4 = 0;
            slopeM5 = 0;
            slopeM6 = 0;
            slopeM7 = 0;
            slopeM8 = 0;
            slopeM9 = 0;
            slopeM10 = 0;
            slopeM11 = 0;
            slopeM12 = 0;
            slopeM13 = 0;
            slopeM14 = 0;
            stdpSpectSkew = 0;
            medpSpectSkew = 0;
            stdpSpectKurt = 0;
            medpSpectKurt = 0;
            
            
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
            % Iterate through each epoch 
            for z = 1:length(indSpeechStart)
                %% Initializing variables used in multiple feature extractions
                epoch = waveformWithTime(1,indSpeechStart(z):indSpeechStop(z)); % Extracting "zth" speech epoch.
                N = length(epoch);
                [pxx, f] = pwelch(epoch,[],[],[],Fs); % Taking pwelch of speech epoch
                freq = meanfreq(epoch,Fs); % Taking meanfreq of speech epoch.
                %% Zerocrossing (ZCR) and energy feature extraction
                out = (winlen-1)/2:(N+winlen-1)-(winlen-1)/2;
                t = (out-(winlen-1)/2)*(1/Fs);
                % ZCR of specific epoch waveform
                ZcrossEpoch = zerocross(epoch,wintype, winamp(1), winlen);
                % Waveform energy over time
                timeEnergy = energy(epoch,wintype,winamp(2),winlen);
                timeEpoly = polyfit(t,timeEnergy(out),1);
                % RMS of energy over time
                rmsEnergy = rms(timeEnergy);
                % Normalized power spectral density (PSD) using zscore
                normPxx = zscore(pxx);
                dumbNormPxx = normPxx.';
                % ZCR of normalized PSD of entire epoch
                ZcrossPxx = zerocross(dumbNormPxx,wintype, winamp(1), winlen);
                
                % un-comment this section of code for visual representation
                % of ZCR of a normalized PSD
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

                %% Epoch windowing features
                
                % Extract PSD over time of specific epoch
                [~,fSpect,tSpect,psSpect] = spectrogram(epoch,[],[],[],Fs);
                
                % Iterate through each PSD frame created for specific epoch
                for si = 1:length(psSpect(1,:))
                    % Linear prediction coefficient fitler to PSD frame
                    [~,~,a5,~] = autolpc(psSpect(:,si),5);
                    a5 = a5';
                    pxx5 = filter([0 -a5(2:end)],1,psSpect(:,si));
                    [~,ind3Formants] = maxk(pxx5,3);
                    % Extract 3 formants from PSD frame
                    tempF1(si) = fSpect(ind3Formants(1));
                    tempF2(si) = fSpect(ind3Formants(2));
                    tempF3(si) = fSpect(ind3Formants(3));
                    
                    % Normalized power spectral density frame using zscore
                    normPsSpect = zscore(psSpect(:,si));
                    ZcrossPsSpect = zerocross(normPsSpect',wintype, winamp(1), winlen);
                    
                    % Perform statistical analyis on ZCR of norm PSD
                    tempMeanZCPs(si) = mean(ZcrossPsSpect);
                    tempMedZCPs(si) = median(ZcrossPsSpect);
                    tempMinZCPs(si) = min(ZcrossPsSpect);
                    tempMaxZCPs(si) = max(ZcrossPsSpect);
                    tempStdZCPs(si) = std(ZcrossPsSpect);
                    
                    % Extract spectral flatness of each PSD frame
                    num=geomean(psSpect(:,si));
                    den=mean(psSpect(:,si));
                    spf=num/den;
                    tempSPF(si) =  spf;
                    
                    clear a5 pxx5 ind3Formants ZcrossPsSpect dumbPsSpect normPsSpect num den spf
                end
                
                % Reducing dimensionality to provide single values per epoch
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
                
                % RMS of waveform speech epoch
                rmsEpoch(z) = rms(epoch);
                
                % skew and kurtosis of 
                tempWinSkew = skewness(psSpect);
                tempWinKurt = kurtosis(psSpect);
                
                stdpSpectSkew(z) = std(tempWinSkew);
                medpSpectSkew(z) = median(tempWinSkew);
                
                stdpSpectKurt(z) = std(tempWinKurt);
                medpSpectKurt(z) = median(tempWinKurt);
               
                
                clear polyF1 polyF2 polyF3 tempF1 tempF2 tempF3 fSpect tSpect psSpect...
                    tempMeanZCPs tempMaxZCPs tempMinZCPs tempStdZCPs tempSPF tempWinSkew...
                    tempWinKurt
                
                
                % Extract Mel Frequency Cepstral Coefficents (14 bins)
                [~,delta,~,tmfcc] = mfcc(epoch',Fs);
                tempM = max(delta,[],1);
                for zi=1:length(delta(1,:))
                    tempPolyP = polyfit(tmfcc,delta(:,zi),1);
                    MPoly(zi,1) = tempPolyP(1);
                    MPoly(zi,2) = tempPolyP(2);
                    clear tempPolyP
                end
                %% skew and kurtosis of entire epoch
                pxxSkew(z) = skewness(pxx);
                pxxKurt(z) = kurtosis(normPxx);
                %% some other shit
                [~,I] = max(pxx); % Finding max power density of epoch frequency distribution.
                
                % extract perceptual spectral centroid
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
                rmsTimeEnergy(z) = rmsEnergy;
                maxM1(z) = tempM(1);
                maxM2(z) = tempM(2);
                maxM3(z) = tempM(3);
                maxM4(z) = tempM(4);
                maxM5(z) = tempM(5);
                maxM6(z) = tempM(6);
                maxM7(z) = tempM(7);
                maxM8(z) = tempM(8);
                maxM9(z) = tempM(9);
                maxM10(z) = tempM(10);
                maxM11(z) = tempM(11);
                maxM12(z) = tempM(12);
                maxM13(z) = tempM(13);
                maxM14(z) = tempM(14);
                slopeM1(z) = MPoly(1,1);
                slopeM2(z) = MPoly(2,1);
                slopeM3(z) = MPoly(3,1);
                slopeM4(z) = MPoly(4,1);
                slopeM5(z) = MPoly(5,1);
                slopeM6(z) = MPoly(6,1);
                slopeM7(z) = MPoly(7,1);
                slopeM8(z) = MPoly(8,1);
                slopeM9(z) = MPoly(9,1);
                slopeM10(z) = MPoly(10,1);
                slopeM11(z) = MPoly(11,1);
                slopeM12(z) = MPoly(12,1);
                slopeM13(z) = MPoly(13,1);
                slopeM14(z) = MPoly(14,1);
                
                
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
                    timeEpoly shittyFormants ind3Largest ind3Formants outPSD ampZcrossPxx normPxx...
                    rmsEnergy tempM MPoly
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
            medSPF', avgSPF', stdSPF', rmsEpoch', rmsTimeEnergy', maxM1', maxM2',...
            maxM3', maxM4', maxM5', maxM6', maxM7', maxM8', maxM9', maxM10',...
            maxM11', maxM12', maxM13', maxM14', slopeM1', slopeM2', slopeM3',...
            slopeM4', slopeM5', slopeM6', slopeM7', slopeM8', slopeM9', slopeM10',...
            slopeM11', slopeM12', slopeM13', slopeM14',stdpSpectSkew', medpSpectSkew',...
            stdpSpectKurt', medpSpectKurt');
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
            'rmsEpoch','rmsEnergy','maxM1', 'maxM2', 'maxM3', 'maxM4', 'maxM5','maxM6',...
            'maxM7', 'maxM8', 'maxM9', 'maxM10', 'maxM11', 'maxM12', 'maxM13', 'maxM14',...
            'slopeM1', 'slopeM2', 'slopeM3', 'slopeM4', 'slopeM5', 'slopeM6', 'slopeM7',...
            'slopeM8', 'slopeM9', 'slopeM10', 'slopeM11', 'slopeM12', 'slopeM13', 'slopeM14',...
            'stdpSpectSkew', 'medpSpectSkew', 'stdpSpectKurt', 'medpSpectKurt'};
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