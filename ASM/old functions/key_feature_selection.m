function [  ] = key_feature_selection( P ,lambda ,threshold )
%Selects the no of eigen vector to retain, based on threshold
temp=[];
val=0;
sum_var=sum(lambda);
for i=1:136
    temp=lambda(1:i,1);    
    if((sum(temp)/sum_var)*100 >=threshold)
        (sum(temp)/sum_var)*100
        P=P(1:i,1);
        lambda=temp;
        n=i;
        return
    end
end
end

