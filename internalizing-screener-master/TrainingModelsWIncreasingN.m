%% Load data
clear all, close all, clc
tableName = {'FeaturesP1_8_10.xlsx', 'FeaturesP2_8_10.xlsx', 'FeaturesP3_8_10.xlsx'};
for x=1:3
    w=1;
    for N=1:15
        clearvars -except N x tableName w
        dt = readtable(tableName{x});
        %{
TF = ismissing(dt_raw);
dt = dt_raw(~any(TF,2),:);
        %}
        
        %%  Build models using leave-one-subject-out and predict on test subjects
        dt_dataRaw = table2array(dt);
        ind0 = find(dt_dataRaw(:,2) == 0);
        ind1 = find(dt_dataRaw(:,2) == 1);
        features = [table2array(dt(:,1)),table2array(dt(:,3:end))];
        %{
features0 = [table2array(dt(ind0,1)),table2array(dt(ind0,3:end))];
features1 = [table2array(dt(ind1,1)), table2array(dt(ind1,3:end))];

randSet = randi(length(features1(:,1)),1,length(features1(:,1)));
featuresetSmall = [features0(randSet,:); features1];
        %}
        %{
features_startle = [table2array(dt(:,1)), table2array(dt(:,ind_startle))];
features_post = [table2array(dt(:,1)), table2array(dt(:,ind_post))];
        %}
        labels = categorical(dt.INTdx + 1);
        %newLabels = [labels(ind1); labels(randSet)];
        [labelsTestLog,scoresTestLog,selectedFeats] = train_models(features,labels,N);
        
        %% Compute error rate distributions
        pd = get_error_pd(labels,categorical(labelsTestLog));
        %{
pd_startle = get_error_pd(labels,categorical(labelsTestLog(:,2)));
pd_post = get_error_pd(labels,categorical(labelsTestLog(:,3)));
        %}
        
        %% Compute performance metrics (0.5 threshold)
        [ACC,SPEC,SENS] = get_performance_metrics(labels,categorical(labelsTestLog));
        %{
[ACCstartle,SPECstartle,SENSstartle] = get_performance_metrics(labels,categorical(labelsTestLog(:,2)));
[ACCpost,SPECpost,SENSpost] = get_performance_metrics(labels,categorical(labelsTestLog(:,3)));
        %}
        
        %% Plot ROC curves for models from each phase
        [Xpre,Ypre,Tpre,AUCpre,OPTROCPTpre] = perfcurve(labels==categorical(2),scoresTestLog,'true');
        %{
[Xstartle,Ystartle,Tstartle,AUCstartle,OPTROCPTstartle] = perfcurve(labels==categorical(2),scoresTestLog(:,2),'true');
[Xpost,Ypost,Tpost,AUCpost,OPTROCPTpost] = perfcurve(labels==categorical(2),scoresTestLog(:,3),'true');
        %}
        figure(1);
        subplot(3,5,w)
        plot(Xpre,Ypre,'linewidth',2); hold on;
        hold on
        legend('P1', 'P2', 'P3')
        %{
plot(Xstartle,Ystartle,'linewidth',2)
plot(Xpost,Ypost,'linewidth',2)
        %}
        set(gca,'TickDir','out',...
            'Box', 'off', ...
            'fontsize',10);
        xlabel('False positive rate'); ylabel('True positive rate');
        thetitle = ['ROC fitctree, N= ', num2str(N)];
        title(thetitle)
        w = w + 1;
    end
end