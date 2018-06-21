function [VisualAnalysis] = makePlot(detectionWTime,dBaudio,audioName,noiseThresholdDb)
% makePlot function produces a figure that shows the entire waveform of the
% audio recording as well as the speech detection and noise thresholds.

%% Create plot and assign to figure VisualAnalysis
% Graph of refined (medfilt1) speech detection superimposed over enveloped
% waveform and noise thresholds.

VisualAnalysis = figure('Name', 'Speech Detection', 'NumberTitle', 'off');
visualDetection = detectionWTime(2,:);
indVisDetection = find(visualDetection == 0);
visualDetection(indVisDetection) = -40;
%subplot(1,2,1)
envelope(dBaudio, 800, 'peak');
hold on
plot(visualDetection);
ylim([-60,5]);
hlinePos = refline([0 noiseThresholdDb]);
hlinePos.Color = 'g';
title(audioName)
legend('signal','envelope','speech detection filtered', 'Location','southwest')
%{
subplot(1,2,2)
envelope(myRecording, 800, 'peak');
hold on
plot(detectFreqFilt);
title('Signal Data with Frequency Filtered Detection')
%}
end