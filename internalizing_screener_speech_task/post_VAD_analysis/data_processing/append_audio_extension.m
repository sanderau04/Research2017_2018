%% append_audio_extension.m used for debugging during speech epoch labeling 
% appending audio file extensions manually, served as a 
% data processing step for epoch labeler GUI input.

%% Required patient mat file variables:
% audioName

clear all
x=1;
%%
% Select all patient mat files, allow for multiple selections.
[matFilename, pathname, ~] = uigetfile('*.mat', 'Pick mat File', 'MultiSelect', 'on'); 
while (x ~= (length(matFilename) + 1))
    matFile = char(strcat(pathname,matFilename(x)));
    load(matFile)

    if(exist('audioWExt','var') == 0)
        audioWExt = [audioName '.wav']; %manually change to original audio file extension (i.e. '.wav', '.m4a')
        save(matFile, 'audioWExt', '-append') %append character variable audioWExt to current patient mat file
    end
    
    clear matFile analysisTableSummary analysisTablePauseDetails...
        analysisTableSpeechDetails energyMatrix filename audioName ...
        patientDx audioWExt
    x = x + 1;
end
