%% Cluster Analysis
% This script provides example implementation of k-means cluster analysis
% in matlab  
% Written by Ryan S. McGinnis - ryan.mcginis14@gmail.com - July 9, 2016

% Copyright (C) 2016  Ryan S. McGinnis
% 
% This program is free software: you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
% 
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
% 
% You should have received a copy of the GNU General Public License
% along with this program.  If not, see <http://www.gnu.org/licenses/>.

%% MODIFIED FOR FEATURE CLUSTERING
% reads in CSVs pertaining to different combinations of features for each
% PID. Combinations can hold up to 8 different features and are
% automatically grouped


%% Load CSV of data - clomuns = features, rows = observations
clear all
close all
clc
filename = 'sumFeatForCluster1.csv';
dt_raw = readtable(filename, 'ReadVariableNames', false);
groupSize = 5;

prompt = '[0] DONT SAVE, [1] SAVE: ';
choice = input(prompt);

%% Clean observation with missing data
%{
TF = ismissing(dt_raw);
dt = dt_raw(~any(TF,2),:);
%}

%% Extract labels from variables
labels = dt_raw(1,:);
PID_raw = dt_raw(2:end,1);
dt = dt_raw(2:end,2:end);

%% ID number of clusters to consider for k-means

% Extract data to array
X = table2array(dt);
X = str2double(X);
PID = table2array(PID_raw);
PID = str2double(PID);

%%


% % Normalize
%X = (X - ones(size(X,1),1) * mean(X,1))./(ones(size(X,1),1) * std(X,1));
X = zscore(X);

% Plot correlations between each variable
%figure;
%plotmatrix(X,X)

% Generate scree plot

num_clust = 20;
total_d = zeros(num_clust,1);
for i=1:num_clust
    [~,~,sumd] = kmeans(X,i,'Distance','sqeuclidean');
    total_d(i) = sum(sumd);
end

f1 = figure;
set(f1, 'Position', [50 250 600 500]);
set(gcf,'name','total distance vs number of clusters');
plot(1:num_clust,total_d);
xlabel('Number of Clusters K');
ylabel('Total Within-Cluster Distance');
%}

%% Run k-means for the appropriate number of clusters
T = kmeans(X,groupSize,'Distance','sqeuclidean');
%Tmanual = [ones(1,62) 2*ones(1,13) 3*ones(1,3) 4*ones(1,7)]';

f2 = figure;
set(f2, 'Position', [650 250 600 500])
set(gcf,'name','silhouette plot of clusters');
[silh3,h] = silhouette(X,T,'sqeuclidean');
xlabel('Silhouette Value','fontsize',16);
ylabel('Cluster','fontsize',16);

indG1 = find(T == 1);
indG2 = find(T == 2);
indG3 = find(T == 3);
indG4 = find(T == 4);
indG5 = find(T == 5);
indG6 = find(T == 6);
indG7 = find(T == 7);
indG8 = find(T == 8);

groupedPID{:,1} = PID(indG1);
groupedPID{:,2} = PID(indG2);
groupedPID{:,3} = PID(indG3);
groupedPID{:,4} = PID(indG4);
groupedPID{:,5} = PID(indG5);
groupedPID{:,6} = PID(indG6);
groupedPID{:,7} = PID(indG7);
groupedPID{:,8} = PID(indG8);

groupedPID = groupedPID(~cellfun('isempty',groupedPID)); 

%%  Plot of first two principal components in feature space
[coeff,score,latent,tsquared,explained] = pca(X);

f3 = figure;
set(f3, 'Position', [1250 250 600 500])
gscatter(score(:,1),score(:,2),T)
ylabel('Component 2');
xlabel('Component 1');

%% Saving PID groups
if choice == 1 
    uisave('groupedPID')
end


