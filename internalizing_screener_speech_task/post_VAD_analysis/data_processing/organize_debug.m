%% organize.m used as data processing debug where matFile dimension
% mismatch became an issue when reading in folders of patient mat files.
%   Script REMOVES variables indSpeechStart and indSpeechStop from patient
% mat file if they exist.

clear all
x=1;
%%
% Select all files readable by the function audioread, allow for multiple selections.
[matFilename, pathname, ~] = uigetfile('*.mat', 'Pick mat File', 'MultiSelect', 'on'); 
while (x ~= (length(matFilename) + 1))
    matFile = char(strcat(pathname,matFilename(x)));
    load(matFile)

    if(exist('indSpeechStart','var') == 1)
      save(matFile, 'analysisTablePauseDetails', 'analysisTableSpeechDetails', 'analysisTableSummary', 'audioName', 'audioWExt', 'energyMatrix', 'filename', 'patientDx')
    end
    
    x = x +1;
    
    clear matFile analysisTableSummary analysisTablePauseDetails analysisTableSpeechDetails energyMatrix filename audioName patientDx audioWExt indSpeechStart indSpeechStop
end


