%% Code to accompany manuscript by McGinnis et. al, 2018 submitted to PLOS One
%Title: Rapid Detection of Internalizing Diagnosis in Young Children Enabled by Wearable Sensors and Machine Learning 

%% MODIFIED FOR SPEECH TASK STUDY
% Input must be a single partition of speech task features
%% Load data
clear all, clc
dt = readtable('FeaturesP2_HIGHQUALITY_8_22.xlsx');
%%  Build models using leave-one-subject-out and predict on test subjects
indPFeats = contains(dt.Properties.VariableNames,'p2');
features = [table2array(dt(:,1)),table2array(dt(:,indPFeats))];
labels = categorical(dt.INTdx + 1); % INTdx for speech task is 1 and 0

% number of features to consider
N = 8;
[labelsTestLog,scoresTestLog,selectedFeats] = train_models(features,labels,N);

%% Compute error rate distributions
pd = get_error_pd(labelsBad,categorical(labelsTestLog));

%% Compute performance metrics (0.5 threshold)
[ACC,SPEC,SENS] = get_performance_metrics(labelsBad,categorical(labelsTestLog));

%% Plot ROC curves for models from each phase
[Xpre,Ypre,Tpre,AUCpre,OPTROCPTpre] = perfcurve(labelsBad==categorical(2),scoresTestLog,'true');
figure; 
plot(Xpre,Ypre,'linewidth',2); 

set(gca,'TickDir','out',...
        'Box', 'off', ...
        'fontsize',12);
xlabel('False positive rate'); ylabel('True positive rate');
title('ROC Curves')


%% Compute performance metrics with different thresholds
T = [0.3:0.05:0.8];
for q=1:length(T)
    [ACCpreT(q),SPECpreT(q),SENSpreT(q)] = get_performance_metrics(categorical(labels==categorical(2)),categorical(scoresTestLog > T(q)));
end
%% Conduct permuation test

n_iter = 100;
ac_pre = zeros(n_iter,1);
for ind_iter = 1:n_iter
    fprintf(1,'\nRunning permutation test iteration %u/%u\n',ind_iter,n_iter);
    [labelsTestPerm,~,~] = train_models(features,labels(randperm(length(labels)).'),N);
    err_perm(ind_iter,1) = get_error_rate(labels,categorical(labelsTestPerm));
end


% Test if performance of actual model significant different from random chance
% Difference in median
pd_samp = pd.random(n_iter,1);
[p,h,stat] = ranksum(pd_samp, err_perm);

%% Boxplot of error rates from observed data and permutation test
GroupedData = [pd_samp; err_perm;];
groups = [ones(n_iter,1); 2*ones(n_iter,1);];

figure; 
boxplot(GroupedData, groups, 'boxstyle', 'filled', ...
                             'color', [0.3, 0.75, 0.93; 0.5, 0.5, 0.5],...
                             'position', [.9, 1.1], ...
                             'widths',0.2);
set(gca, 'Box', 'off', ...
         'TickDir', 'out', ...
         'xtick',1, ...
         'xticklabels', {'Partition 2'},...
         'fontsize', 12);
ylabel('Error Rate');


%% Examine which features were selected for each iteration of LOSO
feat_labels = feature_vector_script;
selected_feat_labels = feat_labels(selectedFeats);
selected_feat_labels = table(categorical(selected_feat_labels(:,1)), ...
                             'VariableNames',{'P2'});
s = summary(selected_feat_labels);

% Create table displaying selected features
selectedFeaturesTable = table(s.P2.Categories, s.P2.Counts);
selectedFeaturesTable.Properties.VariableNames = {'Selected_Features_N8', 'Feature_Count_40_Iterations'};

%% Create boxplot of 10 most common features (z-scores) during pre phase
[data_plot,mu,sigma]=zscore(features(:,2:end)); %convert features to zscores
sf = summary(table(categorical(selectedFeats(:,1)),'VariableNames',{'P2'}));
dts = sortrows(table(sf.P2.Categories,sf.P2.Counts),2,'descend');
cols = str2double(table2array(dts(1:8,1)));
data_plot = data_plot(:,cols);
plot_grps = [];
for j = 1:8
    plot_grps = [plot_grps; double(labels)+2*(j-1)];
end

figure;
boxplot(data_plot(:),plot_grps,'boxstyle', 'filled', ...
                               'position', [.9, 1.1, 1.9, 2.1, 2.9, 3.1, 3.9, 4.1, 4.9, 5.1, 5.9, 6.1, 6.9, 7.1, 7.9, 8.1],...
                               'color', [0.3, 0.75, 0.93; 0.5, 0.5, 0.5])
xticks(1:9);
xticklabels({'F1','F2','F3','F4','F5','F6','F7','F8'});
xtickangle(45)
set(gca, 'Box', 'off', ...
         'TickDir', 'out',...
         'fontsize',12);
ylabel('Z-Score');

     
%% Run correlations betwen features and CBCL scales
dt_feat = array2table(data_plot,'VariableNames',feat_labels(cols));
dt2 = [dt(:,{'INTdx','CBCL_internal','CBCL_DepProb','CBCL_AnxProb'}) dt_feat];
dt2 = dt2(~any(ismissing(dt2),2),:);
dt2 = dt2(~any(table2array(dt2) == 999,2),:);
[RHO,PVAL] = corr(table2array(dt2(:,feat_labels(cols))),...
                  table2array(dt2(:,{'CBCL_internal','CBCL_DepProb','CBCL_AnxProb'})),...
                  'type','Spearman');  


%% Examine cbcl performance metrics for varying thresholds (based on ASEBA)  
[acc_int55,spec_int55,sens_int55] = get_performance_metrics(categorical(dt2.INTdx==1),categorical(dt2.CBCL_internal>=55));
[acc_anx55,spec_anx55,sens_anx55] = get_performance_metrics(categorical(dt2.INTdx==1),categorical(dt2.CBCL_AnxProb>=55));
[acc_dep55,spec_dep55,sens_dep55] = get_performance_metrics(categorical(dt2.INTdx==1),categorical(dt2.CBCL_DepProb>=55));

[acc_int70,spec_int70,sens_int70] = get_performance_metrics(categorical(dt2.INTdx==1),categorical(dt2.CBCL_internal>=70));
[acc_anx70,spec_anx70,sens_anx70] = get_performance_metrics(categorical(dt2.INTdx==1),categorical(dt2.CBCL_AnxProb>=70));
[acc_dep70,spec_dep70,sens_dep70] = get_performance_metrics(categorical(dt2.INTdx==1),categorical(dt2.CBCL_DepProb>=70));

[XintRAW,YintRAW,TintRAW,AUCintRAW,OPTROCPTintRAW] = perfcurve(dt2.INTdx==1,dt2.CBCL_internal,'true');
[XanxRAW,YanxRAW,TanxRAW,AUCanxRAW,OPTROCPTanxRAW] = perfcurve(dt2.INTdx==1,dt2.CBCL_AnxProb,'true');
[XdepRAW,YdepRAW,TdepRAW,AUCdepRAW,OPTROCPTdepRAW] = perfcurve(dt2.INTdx==1,dt2.CBCL_DepProb,'true');





