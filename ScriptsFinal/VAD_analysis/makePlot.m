function [VisualAnalysis] = makePlot(detectionWTime,audioName,noiseThresholdDb,waveform)
% makePlot function produces a figure that shows the entire waveform of the
% audio recording as well as the speech detection and noise thresholds.

%% Create plot and assign to figure VisualAnalysis
% Graph of refined (medfilt1) speech detection superimposed over enveloped
% waveform and noise thresholds.

VisualAnalysis = figure('Name', 'Speech Detection', 'NumberTitle', 'off');
visualDetection = detectionWTime(2,:);
%indVisDetection = find(visualDetection == 0);
%visualDetection(indVisDetection) = -40;
%subplot(1,2,1)
plot(detectionWTime(1,2:end-1),waveform,detectionWTime(1,:),visualDetection)
[yup, ylow] = envelope(waveform, 800, 'peak');
hold on
plot(detectionWTime(1,2:end-1),yup,'b',detectionWTime(1,2:end-1),ylow,'b')
ylim([-1.2,1.2]);
noiseThresholdWav = db2mag(noiseThresholdDb);
hlinePos = refline([0 noiseThresholdDb]);
hlinePos.Color = 'g';
name = [num2str(audioName), " intDx1, Gender1"]
title(name)
%legend('signal','envelope','speech detection filtered','detection', 'Location','southwest')
%{
subplot(1,2,2)
envelope(myRecording, 800, 'peak');
hold on
plot(detectFreqFilt);
title('Signal Data with Frequency Filtered Detection')
%}
end