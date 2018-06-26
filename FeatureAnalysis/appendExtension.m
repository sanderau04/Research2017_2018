clear all
x=1;
%%
[matFilename, pathname, ~] = uigetfile('*.mat', 'Pick mat File', 'MultiSelect', 'on'); % Select all files readable by the function audioread, allow for multiple selections.
while (x ~= (length(matFilename) + 1))
    matFile = char(strcat(pathname,matFilename(x)));
    load(matFile)

    if(exist('audioWExt','var') == 0)
        audioWExt = [audioName '.wav']
        save(matFile, 'audioWExt', '-append')
    end
    
    clear matFile analysisTableSummary analysisTablePauseDetails analysisTableSpeechDetails energyMatrix filename audioName patientDx audioWExt
    x = x + 1;
end
