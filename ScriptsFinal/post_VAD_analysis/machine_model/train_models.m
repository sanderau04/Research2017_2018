function [labelsTestLog,scoresTestLog,selectedFeats,pred_label, mdl_logAll] = train_models(features,labels,N)

subjects = unique(features(:,1)); %guaranteed to have same subjects as startle and post
labelsTestLog = zeros(size(labels,1),1);
scoresTestLog = zeros(size(labels,1),1);
selectedFeats = zeros(N*length(subjects),1);
for sub_ind = 1:length(subjects)
    % Partition train and test data
    ind = features(:,1)==subjects(sub_ind);
    dataTrain = features(~ind,2:end); 
    labelsTrain = labels(~ind);
    dataTest = features(ind,2:end);
    % Convert training features to z-scores
    [dataTrain,mu,sigma]=zscore(dataTrain); %convert features to zscores
    
    % Rank training features using DB index
    db_rank = db_2class(dataTrain,labelsTrain);
    selectedFeats(sub_ind*N-(N-1):sub_ind*N) = db_rank(1:N);
    
    % Reduce dimensionality of training data by taking first N db-ranked features
    dataTrain = dataTrain(:,db_rank(1:N));
    
    % Convert test data to zscores and reduce dimensionality using info from training data
    dataTest = get_zscore(dataTest(:,db_rank(1:N)),mu(:,db_rank(1:N)),sigma(:,db_rank(1:N)));
    
    % Train model
    %MdlES = ExhaustiveSearcher(dataTrain);
    
    % Un-comment specific model you wish to train 
    
    %mdl_log = fitctree(dataTrain,labelsTrain);
    mdl_log = fitclinear(dataTrain,labelsTrain,'Learner','logistic');
    %template = templateTree('MinLeafSize', 1);
    %mdl_log = fitcensemble(dataTrain,labelsTrain,'Method','Bag',...
                         % 'NumLearningCycles',100,'Learners', template);
    %mdl_log = fitcknn(dataTrain,labelsTrain,'NumNeighbors',5,'Standardize',1);
    %mdl_log = fitcsvm(dataTrain,labelsTrain,'KernelFunction','polynomial');
    
    %dataTestKnn = [min(dataTrain); mean(dataTrain); max(dataTrain)];
    
    % Predict on test data
    [pred_label, pred_score] = predict(mdl_log,dataTest);
    %[pred_label, pred_score] = predict(mdl_log,dataTestKnn); %for fitknn
    labelsTestLog(ind) = pred_label;
    scoresTestLog(ind) = pred_score(1,2); %probability of having diagnosis    
    fprintf(1,'Tested model on subject %u, %u/%u\n',subjects(sub_ind),sub_ind,length(subjects));
end
end