function [VisualAnalysis] = makePlot(detectionWTime,myRecording, noiseThresholdWavPos, noiseThresholdWavNeg,detectFreqFilt)
% makePlot function produces a figure that shows the entire waveform of the
% audio recording as well as the speech detection and noise thresholds.

%% Create plot and assign to figure VisualAnalysis
% Graph of refined (medfilt1) speech detection superimposed over enveloped
% waveform and noise thresholds.

VisualAnalysis = figure('Name', 'Speech Detection', 'NumberTitle', 'off');
%subplot(1,2,1)
envelope(myRecording, 800, 'peak');
hold on
plot(detectionWTime(2,:));
hlinePos = refline([0 noiseThresholdWavPos]);
hlinePos.Color = 'g';
hlineNeg = refline([0 noiseThresholdWavNeg]);
hlineNeg.Color = 'g';
title('Signal Data with Envelope and Speech Detection Filtered')
legend('signal','envelope','speech detection filtered', 'Location','southwest')
%{
subplot(1,2,2)
envelope(myRecording, 800, 'peak');
hold on
plot(detectFreqFilt);
title('Signal Data with Frequency Filtered Detection')
%}
end