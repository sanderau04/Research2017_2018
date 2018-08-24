%% Load data
clear all, close all, clc
tableName = {'FeaturesP2_HIGHQUALITY_8_22.xlsx', 'FeaturesP2_LOWQUALITY_8_22.xlsx'};

N = 8;
dtGood = readtable(tableName{1});
dtBad = readtable(tableName{2});
%%  Build models using leave-one-subject-out and predict on test subjects

featuresGood = [table2array(dtGood(:,1)),table2array(dtGood(:,6:end))];
featuresBad = [table2array(dtBad(:,1)),table2array(dtBad(:,6:end))];

labelsGood = categorical(dtGood.INTdx + 1);
labelsBad = categorical(dtBad.INTdx + 1);
%% Train on good quality data using leave-one-subject-out
[labelsTestLogGood,scoresTestLogGood,selectedFeatsGood] = train_models(featuresGood,labelsGood,N);
%% Test on bad quality data 
dataTrain = featuresGood(:,2:end);
dataTest = featuresBad(:,2:end);

[dataTrain,mu,sigma]=zscore(dataTrain);
db_rank = db_2class(dataTrain,labelsGood);
selectedFeats = db_rank(1:N);
dataTrain = dataTrain(:,db_rank(1:N));
dataTest = get_zscore(dataTest(:,db_rank(1:N)),mu(:,db_rank(1:N)),sigma(:,db_rank(1:N)));
mdl_log = fitclinear(dataTrain,labelsGood,'Learner','logistic');
[pred_label, pred_score] = predict(mdl_log,dataTest);
labelsTestLogBad = pred_label;
scoresTestLogBad = pred_score(:,2);

%% Compute error rate distributions
pdGood = get_error_pd(labelsGood,categorical(labelsTestLogGood));
pdBad = get_error_pd(labelsBad,categorical(labelsTestLogBad));

%% Compute performance metrics (0.5 threshold)
[ACCGood,SPECGood,SENSGood] = get_performance_metrics(labelsGood,categorical(labelsTestLogGood));
[ACCBad,SPECBad,SENSBad] = get_performance_metrics(labelsBad,categorical(labelsTestLogBad));

%% Plot ROC curves for models from each phase
[XpreGood,YpreGood,TpreGood,AUCpreGood,OPTROCPTpreGood] = perfcurve(labelsGood==categorical(2),scoresTestLogGood,'true');
[XpreBad,YpreBad,TpreBad,AUCpreBad,OPTROCPTpreBad] = perfcurve(labelsBad==categorical(2),scoresTestLogBad,'true');

figure(1);
plot(XpreGood,YpreGood,'linewidth',2); hold on;
plot(XpreBad,YpreBad,'linewidth',2)
legend('High Quality Data', 'Low Quality Data', 'Location', 'southeast')
legend('boxoff')

set(gca,'TickDir','out',...
    'Box', 'off', ...
    'fontsize',10);
xlabel('False positive rate'); ylabel('True positive rate');
title('ROC Curves')
