function [centroids] = clusterFunctions(featureMatrix,k,algorName)
%Calculating centroids for given feature matrix and specified clustering algorithm.
%    :param featureMatrix: (shape: [n,w])
%    :param k: number of clusters to be found
%    :param algorName: name/tag of cluster algorithm to be used
%    :return centroids: centroids determined (shape: [k,w])

centroids = 0;
if algorName == "kmeans"
    [~,C] = kmeans(featureMatrix,k);
    centroids = C;
elseif algorName == "agglo"
    %tags = clusterdata(featureMatrix,k);
    tags = clusterdata(featureMatrix,'Criterion','distance','Distance','euclidean','Linkage','ward','MaxClust',k);
    centroids = zeros(k,size(featureMatrix,2));
    counts = zeros(k);
    for i=1:size(tags,1)
        tag = tags(i);
        counts(tag) = counts(tag)+1;
        centroids(tag,:) = centroids(tag,:) + featureMatrix(i,:);
    end
    for i=1:k
        centroids(i,:) = centroids(i,:) / counts(i);
    end
elseif algorName == "gmm"
    options = statset('MaxIter',100,'TolFun',1e-3);
    gmm = fitgmdist(featureMatrix,k,'CovarianceType','full','Options',options,'RegularizationValue',1e-6,'Start','plus');
    centroids = gmm.mu;
end
end

