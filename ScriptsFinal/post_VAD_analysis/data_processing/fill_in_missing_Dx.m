%% fill_in_missing_Dx.m cross examines excel spreadsheets
% 'mcginnisdissertation8.2.16.xlsx' and 'EllenData_6.19.18.xlsx'
% inputting values in the empty cells or missing information
% in 'mcginnisdissertation8.2.16.xlsx' that are present 
% in 'EllenData_6.19.18.xlsx'. Requires both spreadsheets as input to run.

clear all, clc
%% Read in both spreadsheets

%PdxIndices = [29, 41, 42, 46, 48, 70, 71, 77, 86, 87, 94:102, 103:118, 119, 126, 225];
[disValue, disHeader] = xlsread('mcginnisdissertation8.2.16.xlsx');
[missValue, missHeader] = xlsread('EllenData_6.19.18.xlsx');

%% Assign variables pertaining to spreadsheet headers
% cast variables to correct var type
for y=1:length(disHeader)
    DissertationHeaders{y} = disHeader{1,y};
end
strValsToExtract = string(DissertationHeaders);
missHeader = string(missHeader);
%% Determine equivalent header locations and save their indices
k=1;
for x=1:length(strValsToExtract)
    for j=1:length(missHeader(1,:))
        if missHeader(1,j) == strValsToExtract(x)
            indMisVal(k) = j;
            k = k + 1;
        end
    end
end

oldDisValue = disValue;
indMisVal = [2, indMisVal];
MisVal = missValue(:,indMisVal);
headerMisVal = missHeader(1,indMisVal);
%% Perform search through each cell in disValue and fill empty cells with 
% equivalent cell value found in MisVal
for i=1:length(disValue(:,1))
    PID = disValue(i,1);
    for j=1:length(disValue(1,:))
        if(isnan(disValue(i,j)) == 1)
            Header = strValsToExtract(j); %extract header title in disValue
            row = find(MisVal(:,1) == PID); %extract equivalent PID row in MisVal
            column = find(headerMisVal == Header); %extract equivale header column in MisVal
            if ((isempty(row) == 0) && (isempty(column) == 0))
                disValue(i,j) = MisVal(row,column); %if value exists in MisVal, assing to disValue
            end
            clear Header row column
        end
    end
    clear PID
end
%% Create and save table to current directory
T = table(disValue);

writetable(T, 'mcginnisdissertation8.2.16.UPDATED.VALUES.xlsx')