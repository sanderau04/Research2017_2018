clc, clear all

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

audiofile = ['D:\Documents\Research2017\MATLAB\FeatureAnalysis\Gianna_LabeledSpeech_7_9_MEDIATE\Mediated\',matData(1).audioWExt];
[waveform, Fs] = audioread(audiofile);

if(length(waveform(1,:)) ~= 1) % Condition is true when file is a recording in stereo.
    waveform = sum(waveform, 2) / size(waveform,2); % Converts stereo recording to mono.
end