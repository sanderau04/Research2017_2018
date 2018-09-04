%% filter_speech_pause_duration.m runs a speech pause duration filter
% through all patient speech pauses and appends the filtered data as its 
% own table.

%% Required patient mat file variables: 
% analysisTablePauseDetailsPatient

clear all, clc
%% Read in mat files
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

%% Apply speech pause duration filter, bridging speech pauses with < 180ms
% durations. Append filtered speech pause values via table titles
% 'analysisTableFilteredPauseDetailsPatient'
for i =1:length(matData)
    pauseTable = matData(i).analysisTablePauseDetailsPatient;
    pauseDurations = pauseTable.SP_Duration;
    pauseStartTimes = pauseTable.SP_Start_Time;
    pauseEndTimes = pauseTable.SP_End_Time;
    j = 1;
    for x=1:length(pauseDurations)
       if x == 1 && pauseDurations(x) < 0.180
           newPauseCount(j) = j;
           newPauseDurations(j) = pauseDurations(x) + pauseDurations(x+1);
           newPauseStartTimes(j) = pauseStartTimes(x);
           newPauseEndTimes(j) = pauseEndTimes(x + 1);
           j = j + 1;
       elseif x ~= 1 && pauseDurations(x) < 0.180
           newPauseCount(j) = j;
           newPauseDurations(j) = pauseDurations(x) + pauseDurations(x-1);
           newPauseStartTimes(j) = pauseStartTimes(x-1);
           newPauseEndTimes(j) = pauseEndTimes(x);
           j = j + 1;
       else
           newPauseCount(j) = j;
           newPauseDurations(j) = pauseDurations(x);
           newPauseStartTimes(j) = pauseStartTimes(x);
           newPauseEndTimes(j) = pauseEndTimes(x);
           j = j +1;
       end
    end
    matFilename = [matFiles(i).folder,'\',matFiles(i).name];
    analysisTableFilteredPauseDetailsPatient = table(newPauseCount', newPauseStartTimes', newPauseEndTimes', newPauseDurations');
    analysisTableFilteredPauseDetailsPatient.Properties.VariableNames = {'SP_Number', 'SP_Start_Time', 'SP_End_Time', 'SP_Duration'};
    save(matFilename, 'analysisTableFilteredPauseDetailsPatient', '-append')
    
    clearvars -except myFolder filePattern matFiles fullFileName matData i
end