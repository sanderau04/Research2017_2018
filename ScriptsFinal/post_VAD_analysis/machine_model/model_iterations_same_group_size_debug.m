%% model_iterations_same_group_size_debug.m train models on patient 
% features iteratively, ranodomizing the selected PIDs for internal
% diagnosis = 0 each time (due to difference in INTdx group size). Modeling
% values from all iterations are then statistically analyzed.

clear all, close all, clc
N = 6;
i = 1;
for i=1:50
    clearvars -except N x ACC AUCpre SPEC SENS i TopNFeatures
    dt = readtable('FeaturesP2_ALL_POPULATION_8_8.xlsx');
    %{
TF = ismissing(dt_raw);
dt = dt_raw(~any(TF,2),:);
    %}
    
    %%  Build models using leave-one-subject-out and predict on test subjects
    dt_dataRaw = table2array(dt);
    ind0 = find(dt_dataRaw(:,2) == 0);
    ind1 = find(dt_dataRaw(:,2) == 1);
    INTdx0 = table2array(dt(ind0,2));
    features0 = [table2array(dt(ind0,1)),table2array(dt(ind0,3:end))];
    features1 = [table2array(dt(ind1,1)), table2array(dt(ind1,3:end))];
    randSet = randperm(length(features0(:,1)),length(features1(:,1)));
    featuresetSameGSize = [features0(randSet,:); features1];
    
    labels = categorical(dt.INTdx + 1);
    randSetINTdx0 = INTdx0(randSet) + 1;
    newLabels = [categorical(randSetINTdx0); labels(ind1)];
    
    
    [labelsTestLog,scoresTestLog,selectedFeats] = train_models(featuresetSameGSize,newLabels,N);
    
    %% Compute error rate distributions
    pd = get_error_pd(newLabels,categorical(labelsTestLog));
    
    %% Compute performance metrics (0.5 threshold)
    [ACC(i),SPEC(i),SENS(i)] = get_performance_metrics(newLabels,categorical(labelsTestLog));
    
    for w=1:N
        TopNFeatures(w,i) = string(dt.Properties.VariableNames{selectedFeats(w)});
    end
    %% Plot ROC curves for models from each phase
    [Xpre,Ypre,Tpre,AUCpre(i),OPTROCPTpre] = perfcurve(newLabels==categorical(2),scoresTestLog,'true');
    
    %% Compute performance metrics with different threshold
    T = [0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9,1];
    for q=1:length(T)
        [ACCpreT(q),SPECpreT(q),SENSpreT(q)] = get_performance_metrics(categorical(newLabels==categorical(2)),categorical(scoresTestLog > T(q)));
    end
end
%% Statistical analysis on modeling results
stdACC = std(ACC);
meanACC = mean(ACC);
stdAUCpre = std(AUCpre);
meanAUCpre = mean(AUCpre);