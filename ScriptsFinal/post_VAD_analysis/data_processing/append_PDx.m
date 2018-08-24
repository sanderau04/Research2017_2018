%% appendPDx.m updates patient diagnoses after filling in 
% missing values from 'mcginnisdissertation8.2.16.xlsx'.
% updated values are appended to patient mat file variable 
% patientDx.

%% Required patient mat file variables: 
% audioName

clear all
x=1;
patientDxAndSpeechCode = xlsread('mcginnisdissertation8.2.16.UPDATED.VALUES.xlsx');
%% Read in mat files and append updated
% values from 'mcginnisdissertation8.2.16.UPDATED.VALUES.xlsx'

% Select all files, allow for multiple selections.
[matFilename, pathname, ~] = uigetfile('*.mat', 'Pick mat File', 'MultiSelect', 'on'); 
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
    
    clear matFile analysisTableSummary analysisTablePauseDetails analysisTableSpeechDetails...
        energyMatrix filename audioName indSpeechStart indSpeechStop Fs audioWExt patientDx EpochLabel
    x = x + 1;
end