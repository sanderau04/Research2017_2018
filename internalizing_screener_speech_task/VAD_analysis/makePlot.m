function [VisualAnalysis] = makePlot(audioName,waveform,choice)
% makePlot function produces a figure that shows the entire waveform of the
% audio recording as well as the speech detection and noise thresholds.

%% Create plot and assign to figure VisualAnalysis
% Graph of refined (medfilt1) speech detection superimposed over enveloped
% waveform and noise thresholds.

global detectionWTime noiseThresholdDb

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
hlinePos = refline([0 noiseThresholdWav]);
hlinePos.Color = 'g';

switch choice
    case 1
        name = ['PID: ', audioName, ' loudness threshold VAD, import file'];
    case 2
        name = ['PID: ', audioName, ' loudness threshold VAD, live recording'];
    case 3
        name = ['PID: ', audioName, ' ZCR and time energy thresholds prototype VAD, import file'];
end
title(name)
%legend('signal','envelope','speech detection filtered','detection', 'Location','southwest')
end