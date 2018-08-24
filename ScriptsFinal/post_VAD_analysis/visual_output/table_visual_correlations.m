%% table_visual_correlations.m creates an "article ready" table 
% Cells will have rho values with their respective significant p-values in
% parentheses. Insignificant p-values will not be displayed. Requires input
% of a spreadsheet with output from correlation_script_tri_partition.m

clc, clear all
dt = readtable('corr8_20_Just8Feats_AllDx.xlsx');
[~, titles] = xlsread('Excel/mcginnisdissertation8.2.16.UPDATED.VALUES.xlsx');
%% Assign Speech code indices for table headers
PdxIndices = [29, 41, 42, 46, 48, 70, 71, 73, 77, 86, 87, 94:102, 103:118, 119, 126, 225];
for y=1:length(PdxIndices)
    PdxName{y} = titles{1,PdxIndices(y)};
end

% Extract rho and pvalues 
indRho = contains(dt.Properties.VariableNames,'rho');
indPval = contains(dt.Properties.VariableNames, 'pValue');

rhoVals = table2array(dt(:,indRho));
pVals = table2array(dt(:,indPval));

roundRhoVals = round(rhoVals,3);
roundPVals = round(pVals,3);

% Create new table with specified display of rho and p-value
for i = 1:length(rhoVals(:,1))
    for j = 1:length(rhoVals(1,:))
        if roundPVals(i,j) > 0.10
            rhoThenP{i,j} = [num2str(roundRhoVals(i,j)),' (N.S.)'];
        else
            rhoThenP{i,j} = [num2str(roundRhoVals(i,j)),' (', num2str(roundPVals(i,j)),')'];
        end
    end
end