clear all
x=1;
patientDxAndSpeechCode = xlsread('mcginnisdissertation8.2.16.UPDATED.VALUES.xlsx');
%%
[matFilename, pathname, ~] = uigetfile('*.mat', 'Pick mat File', 'MultiSelect', 'on'); % Select all files readable by the function audioread, allow for multiple selections.
while (x ~= (length(matFilename) + 1))
    matFile = char(strcat(pathname,matFilename(x)));
    load(matFile)
    
    
    indPdx = find(patientDxAndSpeechCode(:,1) == str2num(audioName));
    if(isempty(indPdx) == 1)
        patientDx = NaN(1,359);
    else
        patientDx = patientDxAndSpeechCode(indPdx,:);
    end
    
    i=1;
    
    save(matFile, 'patientDx', '-append')
    
    clear matFile analysisTableSummary analysisTablePauseDetails analysisTableSpeechDetails energyMatrix filename audioName indSpeechStart indSpeechStop Fs audioWExt patientDx EpochLabel
    x = x + 1;
end