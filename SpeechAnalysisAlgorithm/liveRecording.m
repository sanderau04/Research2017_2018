function [myRecording] = liveRecording(recObj)
% liveRecording function performs a live recording prompting the user when
% to start talking

%% Countdown
fprintf('3\n')
pause(1);
fprintf('2\n')
pause(1);
fprintf('1\n\n')
pause(1);

%% Create audiorecorder object, Recording audio, Playback audio
t = 10;

recObj.StartFcn = 'disp(''Start Speaking. '')'; %prompt user when to start speaking
recObj.StopFcn = 'disp(''End of recording. '')';    %prompt user when recording has finished

record(recObj);
pause(t);
stop(recObj);
play(recObj);

%% Store audiodata and call functions for speech pause detection and analysis
myRecording = getaudiodata(recObj);
end