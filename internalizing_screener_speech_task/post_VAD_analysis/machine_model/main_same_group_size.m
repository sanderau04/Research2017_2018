%% Code to accompany manuscript by McGinnis et. al, 2018 submitted to PLOS One
%Title: Rapid Detection of Internalizing Diagnosis in Young Children Enabled by Wearable Sensors and Machine Learning 

%% MODIFIED FOR SPEECH TASK STUDY
% Input must be a single partition of speech task features
%% Load data
clear all, clc
dt = readtable('Features_P2_8_7.xlsx');
    
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

newLabels = [categorical(INTdx0(randSet));labels(ind1)];


% number of features to consider
N = 6;

[labelsTestLog,scoresTestLog,selectedFeats] = train_models(featuresetSameGSize,newLabels,N);
%% Compute error rate distributions
pd = get_error_pd(newLabels,categorical(labelsTestLog));

%% Compute performance metrics (0.5 threshold)
[ACC,SPEC,SENS] = get_performance_metrics(newLabels,categorical(labelsTestLog));

%% Plot ROC curves for models from each phase
[Xpre,Ypre,Tpre,AUCpre,OPTROCPTpre] = perfcurve(newLabels==categorical(1),scoresTestLog,'true');

figure; 
plot(Xpre,Ypre,'linewidth',2); hold on;

set(gca,'TickDir','out',...
        'Box', 'off', ...
        'fontsize',12);
xlabel('False positive rate'); ylabel('True positive rate');
thetitle = ['ROC Curves, N= ', num2str(N)]
title(thetitle)


%% Compute performance metrics with different threshold
T = [0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9,1];
for q=1:length(T)
    [ACCpreT(q),SPECpreT(q),SENSpreT(q)] = get_performance_metrics(categorical(newLabels==categorical(1)),categorical(scoresTestLog > T(q)));
end


%% Conduct permuation test
n_iter = 100;
ac_pre = zeros(n_iter,1);
for ind_iter = 1:n_iter
    fprintf(1,'\nRunning permutation test iteration %u/%u\n',ind_iter,n_iter);
    [labelsTestPerm,~,~] = train_models(features,labels(randperm(length(labels)).'),N);
    err_pre_perm(ind_iter,1) = get_error_rate(labels,categorical(labelsTestPerm));
end


% Test if performance of actual model significant different from random chance
% Difference in median
pd_pre_samp = pd_pre.random(n_iter,1);
pd_startle_samp = pd_startle.random(n_iter,1);
pd_post_samp = pd_post.random(n_iter,1);
[p_pre,h_pre,stat_pre] = ranksum(pd_pre_samp,err_pre_perm);
[p_startle,h_startle,stat_startle] = ranksum(pd_startle_samp,err_startle_perm);
[p_post,h_post,stat_post] = ranksum(pd_post_samp,err_post_perm);


% Boxplot of error rates from observed data and permutation test
GroupedData = [pd_pre_samp; err_pre_perm; pd_startle_samp; err_startle_perm; pd_post_samp; err_post_perm];
groups = [ones(n_iter,1); 2*ones(n_iter,1); 3*ones(n_iter,1); 4*ones(n_iter,1); 5*ones(n_iter,1); 6*ones(n_iter,1)];

figure; 
boxplot(GroupedData, groups, 'boxstyle', 'filled', ...
                             'color', [0.3, 0.75, 0.93; 0.5, 0.5, 0.5],...
                             'position', [.9, 1.1, 1.9, 2.1, 2.9, 3.1], ...
                             'widths',0.2);
set(gca, 'Box', 'off', ...
         'TickDir', 'out', ...
         'xtick',[1, 2, 3], ...
         'xticklabels', {'Potential Threat','Startle','Response Modulation'},...
         'fontsize', 12);
ylabel('Error Rate');


%% Examine which features were selected for each iteration of LOSO
feat_labels = feature_vector_script;
selected_feat_labels = feat_labels(selectedFeats);
selected_feat_labels = table(categorical(selected_feat_labels(:,1)), ...
                             categorical(selected_feat_labels(:,2)), ...
                             categorical(selected_feat_labels(:,3)), ...
                             'VariableNames',{'Pre','Startle','Post'});
s = summary(selected_feat_labels);


%% Create boxplot of 10 most common features (z-scores) during pre phase
[data_plot,mu,sigma]=zscore(features_pre(:,2:end)); %convert features to zscores
sf = summary(table(categorical(selectedFeats(:,1)),'VariableNames',{'Pre'}));
dts = sortrows(table(sf.Pre.Categories,sf.Pre.Counts),2,'descend');
cols = str2double(table2array(dts(1:10,1)));
data_plot = data_plot(:,cols);
plot_grps = [];
for j = 1:10
    plot_grps = [plot_grps; double(labels)+2*(j-1)];
end

figure;
boxplot(data_plot(:),plot_grps,'boxstyle', 'filled', ...
                               'position', [.9, 1.1, 1.9, 2.1, 2.9, 3.1, 3.9, 4.1, 4.9, 5.1, 5.9, 6.1, 6.9, 7.1, 7.9, 8.1, 8.9, 9.1, 9.9, 10.1], ...
                               'color', [0.3, 0.75, 0.93; 0.5, 0.5, 0.5],...
                               'widths',0.2)
xticks(1:10);
xticklabels(feat_labels(cols));
xtickangle(45)
set(gca, 'Box', 'off', ...
         'TickDir', 'out',...
         'fontsize',12);
ylabel('Z-Score');

     
%% Run correlations betwen features and CBCL scales
dt_feat = array2table(data_plot,'VariableNames',feat_labels(cols));
dt2 = [dt(:,{'INTdx','CBCL_internal','CBCL_DepProb','CBCL_AnxProb'}) dt_feat];
dt2 = dt2(~any(ismissing(dt2),2),:);
[RHO,PVAL] = corr(table2array(dt2(:,feat_labels(cols))),...
                  table2array(dt2(:,{'CBCL_internal','CBCL_DepProb','CBCL_AnxProb'})),...
                  'type','Spearman');  


%% Examine cbcl performance metrics for varying thresholds (based on ASEBA)  
[acc_int55,spec_int55,sens_int55] = get_performance_metrics(categorical(dt2.INTdx==2),categorical(dt2.CBCL_internal>=55));
[acc_anx55,spec_anx55,sens_anx55] = get_performance_metrics(categorical(dt2.INTdx==2),categorical(dt2.CBCL_AnxProb>=55));
[acc_dep55,spec_dep55,sens_dep55] = get_performance_metrics(categorical(dt2.INTdx==2),categorical(dt2.CBCL_DepProb>=55));

[acc_int70,spec_int70,sens_int70] = get_performance_metrics(categorical(dt2.INTdx==2),categorical(dt2.CBCL_internal>=70));
[acc_anx70,spec_anx70,sens_anx70] = get_performance_metrics(categorical(dt2.INTdx==2),categorical(dt2.CBCL_AnxProb>=70));
[acc_dep70,spec_dep70,sens_dep70] = get_performance_metrics(categorical(dt2.INTdx==2),categorical(dt2.CBCL_DepProb>=70));

[XintRAW,YintRAW,TintRAW,AUCintRAW,OPTROCPTintRAW] = perfcurve(dt2.INTdx==2,dt2.CBCL_internal,'true');
[XanxRAW,YanxRAW,TanxRAW,AUCanxRAW,OPTROCPTanxRAW] = perfcurve(dt2.INTdx==2,dt2.CBCL_AnxProb,'true');
[XdepRAW,YdepRAW,TdepRAW,AUCdepRAW,OPTROCPTdepRAW] = perfcurve(dt2.INTdx==2,dt2.CBCL_DepProb,'true');





