%% display_PID_cluster_groupings.m performs data processing and analysis on grouped   
% PID mat files from feature combination cluster analysis. Spreadsheet
% 'mcginnisdissertation8.2.16.UPDATED.VALUES.xlsx' required, as well as
% mat file containing grouped features from
% cluster_analysis_feature_combinations.m output

clc, clear all
%% Read in groupedPID mat file
%{
prompt = ('NAME YOUR SPREADSHEET: ');
spreadName = input(prompt, 's');
sheetNames = {'group1', 'group2', 'group3', 'group4', 'group5', 'group6', 'group7', 'group8'};
%}

[file, pathname] = uigetfile('*mat','Choose PID group mat file');
filename = strcat(pathname,file);
load(filename);
directory = 'D:\Documents\Research2017\MATLAB\FeatureAnalysis\PIDGroups\';
[vals, titles] = xlsread('Excel\mcginnisdissertation8.2.16.UPDATED.VALUES.xlsx');
%% Assign Speech code indices for table headers
PdxIndices = [1, 29, 41, 42, 46, 48, 70, 71, 73, 77, 80, 86, 87, 94:102, 103:118, 119, 126, 225];
for y=1:length(PdxIndices)
    PdxName{y} = titles{1,PdxIndices(y)};
end

vals = vals(:,PdxIndices);
%% Assign PDx values to respective groupings 

for i=1:length(groupedPID)
    tempPIDGroup = groupedPID{1,i};
    for x=1:length(groupedPID{1,i})
        indFind(x) = find(vals(:,1) == tempPIDGroup(x));
    end
    group = vals(indFind, :);
    
    T{i} = array2table(group,'VariableNames', PdxName);
    clear tempPIDGroup group indFind
end

%% Save groupings to spreadsheet 
% each group is assigned its own sheet within xlsx file
%{
for j=1:length(groupedPID)
    filename = [directory,spreadName,'.xlsx'];
    tempT = table2array(T{1,j});
    xlswrite(filename, PdxName,sheetNames{j},'A1'); 
    xlswrite(filename, tempT, sheetNames{j},'A2');
    clear filename tempT
end
%}

%% Perform statistcal analysis on PDx values within each group
for x=1:length(T)
    tempArrayTable = table2array(T{1,x});
    for i=1:length(tempArrayTable(1,:))
        % Extract mean, median and std from each applicable PDx for each 
        % group
        if (i > 1) && (i ~= 9) && (i ~= 11)
            % Condition: Pdx valuse = 999 are not included
            indNot999 = find(tempArrayTable(:,i) ~= 999);
            statsMean(i,x) = nanmean(tempArrayTable(indNot999,i));
            statsMed(i,x) = nanmedian(tempArrayTable(indNot999,i));
            statsSTD(i,x) = nanstd(tempArrayTable(indNot999,i));
        % Condition: @ i = 9 PDx is INTdx, compute percentages due to
        % binary nature of INTdx
        elseif i == 9 
            indNot999 = find(tempArrayTable(:,i) ~= 999);
            not999ArrayTable = tempArrayTable(indNot999,i);
            statsMean(i,x) = (nansum(tempArrayTable(indNot999,i)) / length(not999ArrayTable(~isnan(not999ArrayTable)))) * 100;
            statsMed(i,x) = 0;
            statsSTD(i,x) = 0;
        % Condition: @ i = 11 PDx is childage, compute percentages due to
        % binary nature of childage
        elseif i ==11
            indNot999 = find(tempArrayTable(:,i) ~= 999);
            not999ArrayTable = tempArrayTable(indNot999,i);
            indG1 = find(tempArrayTable(:,i) == 1);
            statsMean(i,x) = (nansum(tempArrayTable(indG1,i)) / length(not999ArrayTable(~isnan(not999ArrayTable)))) * 100;
            statsMed(i,x) = 0;
            statsSTD(i,x) = 0;
        end
        clear indNot999 not999ArrayTable indG1
    end
    clear tempArrayTable
    % Assign table variables and group sizes
    varNames{x} = ['group_',num2str(x),'_MEAN'];
    varNames2{x} = ['group_',num2str(x),'_MED'];
    varNames3{x} = ['group_',num2str(x),'_STD'];
    gSize(x) = length(T{1,x}.PID);
    gSize2(x) = length(T{1,x}.PID);
    gSize3(x) = length(T{1,x}.PID);
end
%% Create statistical grouped PDx table
varNames  = [varNames,varNames2, varNames3];
gSize = [gSize, gSize2, gSize3];
stats = [statsMean,statsMed,statsSTD];
stats(1,:) = gSize;
rowNames = PdxName';
rowNames{9,1} = [rowNames{9,1},'_percent=1'];
rowNames{11,1} = [rowNames{11,1},'_percent=1'];
rowNames{1,1} = 'GroupSize';

summaryStatsTable = array2table(stats,'VariableNames', varNames,'RowNames', rowNames);

%% BoxPlot specific PDx values

boxVal = [zscore(T{1,1}.childage); zscore(T{1,2}.childage); zscore(T{1,1}.InternalTmerged);...
    zscore(T{1,2}.InternalTmerged); zscore(T{1,1}.INTdx); zscore(T{1,2}.INTdx); ];
groups = [ones(length(T{1,1}.childage),1); 2*ones(length(T{1,2}.childage),1);...
    3*ones(length(T{1,1}.InternalTmerged),1); 4*ones(length(T{1,2}.InternalTmerged),1);...
    5*ones(length(T{1,1}.INTdx),1); 6*ones(length(T{1,2}.INTdx),1)];

boxplot(boxVal, groups, 'Labels', {'g1_childage', 'g2_childage', 'g1_IntTmerged', 'g2_IntTmerged',...
    'g1_INTdx', 'g2_INTdx'})

