function [P mean_shape lambda] = build_model( train )
%build_model, function applies PCA on the training set,
% returns the eigen vectors and mean shape
mean_shape=mean(train,2);
[P score lambda]=pca(train','Economy',false);
return ;
end

