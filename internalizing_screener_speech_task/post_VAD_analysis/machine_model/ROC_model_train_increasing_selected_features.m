%% ROC_model_train_increasing_selected_features.m creates figure with ROC
% subplots of increasing selected features displaying ROC curve for each
% partition

%% Load data
clear all, close all, clc
tableName = {'FeaturesP1_8_19.xlsx', 'FeaturesP2_8_19.xlsx', 'FeaturesP3_8_19.xlsx'};
for x=1:3
    w=1;
    for N=1:15
        clearvars -except N x tableName w ACC AUCpre SENS SPEC
        dt = readtable(tableName{x});
        %%  Build models using leave-one-subject-out and predict on test subjects
        dt_dataRaw = table2array(dt);
        features = [table2array(dt(:,1)),table2array(dt(:,6:end))];
        labels = categorical(dt.INTdx + 1);
        [labelsTestLog,scoresTestLog,selectedFeats] = train_models(features,labels,N);
        
        %% Compute error rate distributions
        pd = get_error_pd(labels,categorical(labelsTestLog));
        %% Compute performance metrics (0.5 threshold)
        [ACC(N,x),SPEC(N,x),SENS(N,x)] = get_performance_metrics(labels,categorical(labelsTestLog));
        
        %% Plot ROC curves for models from each phase
        [Xpre,Ypre,Tpre,AUCpre(N,x),OPTROCPTpre] = perfcurve(labels==categorical(2),scoresTestLog,'true');

        figure(1);
        subplot(3,5,N)
        plot(Xpre,Ypre,'linewidth',2); hold on;
        hold on
        legend('P1', 'P2', 'P3')

        set(gca,'TickDir','out',...
            'Box', 'off', ...
            'fontsize',10);
        xlabel('False positive rate'); ylabel('True positive rate');
        thetitle = ['ROC fitcsvm ', num2str(N)];
        title(thetitle)
        w = w + 1;
    end
end