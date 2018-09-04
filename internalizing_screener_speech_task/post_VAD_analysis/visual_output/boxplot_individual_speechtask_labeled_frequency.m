%% boxplot_individual_speechtask_labeled_frequency.m produces individual 
% box plots of each patient mat file displaying frequency features 
% categorized by INTdx and speech epoch labels

%% Required patient mat file variables:
% patientDx, analysisTableSpeechDetails, EpochLabel, audioName,
% indSpeechStart

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

%% Feature Analysis
% Extracting Summary values for each patient and concatenating patient Dx
% and summary features into one matrix

for i = 1:length(matFiles)
    % initialize all feature variables
    pDx = extractfield(matData(i),'patientDx');
	feat = extractfield(matData(i),'analysisTableSpeechDetails');
    epoch = extractfield(matData(i), 'EpochLabel');
    maxFreq = feat{1,1}.Speech_Epoch_Max_Frequency;
    meanFreq = feat{1,1}.Speech_Epoch_Mean_Frequency;
    audioName = matData(i).audioName;
    indSpeechStart = matData(i).indSpeechStart;
    
    % Create groupings needed for boxplotting
    for x = 1:length(indSpeechStart)
        if char(epoch{1,1}{1,x}) == 'P'
            T(x) = 1;
        elseif char(epoch{1,1}{1,x}) == 'C'
            T(x) = 2;
        elseif char(epoch{1,1}{1,x}) == 'B'
            T(x) = 3;
        elseif char(epoch{1,1}{1,x}) == 'O'
            T(x) = 4;
        end
    end
    temp = 4*ones(1,length(T));
    T2 = T + temp;
    Tall = [T T2];
    freqAll = [maxFreq; meanFreq];
    titles = [audioName, ' IntDx: ', string(pDx(73))];
    
%% Box plot frequency values sectioned by the 4 different Epoch labels 
% Box plot created for every single patient mat file 
    figure
    boxplot(freqAll, Tall,'Labels', {'P: Max Freq','C: Max Freq',...
        'B: Max Freq','O: Max Freq', 'P: Mean Freq', 'C: Mean Freq',...
        'B: Mean Freq', 'O: Mean Freq'})
    title(titles)
    ylabel('Frequency (Hz)')
    
    clear pDx feat epoch audioName T T2 Tall temp maxFreq meanFreq indSpeechStart titles freqAll
end
    

