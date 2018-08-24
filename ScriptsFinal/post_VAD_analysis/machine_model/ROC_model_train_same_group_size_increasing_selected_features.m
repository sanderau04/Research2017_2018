%% ROC_model_train_increasing_selected_features.m creates figure with ROC
% subplots of increasing selected features with same group size between
% INTdx displaying ROC curve for each partition

%% Load data
clear all, close all, clc
tableName = {'Features_P1_8_7.xlsx', 'Features_P2_8_7.xlsx', 'Features_P3_8_7.xlsx'};
for x=1:3
    for N=1:20
        clearvars -except N x tableName ACC AUCpre SPEC SENS
        dt = readtable(tableName{x});
        %%  Build models using leave-one-subject-out and predict on test subjects
        dt_dataRaw = table2array(dt);
        ind0 = find(dt_dataRaw(:,2) == 0);
        ind1 = find(dt_dataRaw(:,2) == 1);
        features = [table2array(dt(:,1)),table2array(dt(:,3:end))];
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
        [ACC(N,x),SPEC(N,x),SENS(N,x)] = get_performance_metrics(newLabels,categorical(labelsTestLog));
        
        %% Plot ROC curves for models from each phase
        [Xpre,Ypre,Tpre,AUCpre(N,x),OPTROCPTpre] = perfcurve(newLabels==categorical(2),scoresTestLog,'true');

        figure(1);
        subplot(4,5,N)
        plot(Xpre,Ypre,'linewidth',2); hold on;
        hold on
        legend('P1', 'P2', 'P3')
        set(gca,'TickDir','out',...
            'Box', 'off', ...
            'fontsize',10);
        xlabel('False positive rate'); ylabel('True positive rate');
        thetitle = ['ROC fitknn, N= ', num2str(N)];
        title(thetitle)
    end
end