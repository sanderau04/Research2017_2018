clear all
x=1;
%%
[matFilename, pathname, ~] = uigetfile('*.mat', 'Pick mat File', 'MultiSelect', 'on'); % Select all files readable by the function audioread, allow for multiple selections.
while (x ~= (length(matFilename) + 1))
    matFile = char(strcat(pathname,matFilename(x)));
    load(matFile)

    if(exist('indSpeechStart','var') == 1)
      save(matFile, 'analysisTablePauseDetails', 'analysisTableSpeechDetails', 'analysisTableSummary', 'audioName', 'audioWExt', 'energyMatrix', 'filename', 'patientDx')
    end
    
    x = x +1;
    
    clear matFile analysisTableSummary analysisTablePauseDetails analysisTableSpeechDetails energyMatrix filename audioName patientDx audioWExt indSpeechStart indSpeechStop
end


