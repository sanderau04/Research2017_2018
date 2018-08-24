%% 

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
    features = [table2array(dt(:,1)),table2array(dt(:,3:end))];
    INTdx0 = table2array(dt(ind0,2));
    features0 = [table2array(dt(ind0,1)),table2array(dt(ind0,3:end))];
    features1 = [table2array(dt(ind1,1)), table2array(dt(ind1,3:end))];
    
    
    randSet = randperm(length(features0(:,1)),length(features1(:,1)));
    
    
    %featuresetSmall = [features0(randSet,:); features1];
    
    labels = categorical(dt.INTdx + 1);
    randSetINTdx0 = INTdx0(randSet) + 1;
    newLabels = [categorical(randSetINTdx0); labels(ind1)];
    
    
    [labelsTestLog,scoresTestLog,selectedFeats] = train_models(features,labels,N);
    
    %% Compute error rate distributions
    pd = get_error_pd(labels,categorical(labelsTestLog));
    %{
pd_startle = get_error_pd(labels,categorical(labelsTestLog(:,2)));
pd_post = get_error_pd(labels,categorical(labelsTestLog(:,3)));
    %}
    
    %% Compute performance metrics (0.5 threshold)
    [ACC(i),SPEC(i),SENS(i)] = get_performance_metrics(labels,categorical(labelsTestLog));
    %{
[ACCstartle,SPECstartle,SENSstartle] = get_performance_metrics(labels,categorical(labelsTestLog(:,2)));
[ACCpost,SPECpost,SENSpost] = get_performance_metrics(labels,categorical(labelsTestLog(:,3)));
    %}
    
    for w=1:N
        TopNFeatures(w,i) = string(dt.Properties.VariableNames{selectedFeats(w)});
    end
    
    
    
    %% Plot ROC curves for models from each phase
    [Xpre,Ypre,Tpre,AUCpre(i),OPTROCPTpre] = perfcurve(labels==categorical(2),scoresTestLog,'true');
    
    %% Compute performance metrics with different threshold
    T = [0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9,1];
    for q=1:length(T)
        [ACCpreT(q),SPECpreT(q),SENSpreT(q)] = get_performance_metrics(categorical(labels==categorical(2)),categorical(scoresTestLog > T(q)));
    end
    %{
[Xstartle,Ystartle,Tstartle,AUCstartle,OPTROCPTstartle] = perfcurve(labels==categorical(2),scoresTestLog(:,2),'true');
[Xpost,Ypost,Tpost,AUCpost,OPTROCPTpost] = perfcurve(labels==categorical(2),scoresTestLog(:,3),'true');
    %}
    %{
    figure(1);
    subplot(4,5,i)
    plot(Xpre,Ypre,'linewidth',2); hold on;
    hold on
    %{
plot(Xstartle,Ystartle,'linewidth',2)
plot(Xpost,Ypost,'linewidth',2)
    %}
    set(gca,'TickDir','out',...
        'Box', 'off', ...
        'fontsize',10);
    xlabel('False positive rate'); ylabel('True positive rate');
    thetitle = ['ROC fitctree N = 6 P1, i= ', num2str(i)];
    title(thetitle)
    %}
end
stdACC = std(ACC);
meanACC = mean(ACC);

stdAUCpre = std(AUCpre);
meanAUCpre = mean(AUCpre);