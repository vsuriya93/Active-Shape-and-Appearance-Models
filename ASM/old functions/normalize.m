function [ norm_train_mat scale ] = normalize( train )
%This brings all shape vectors to uniform shape
%   we divide all elements by its 2-norm
[m,n]=size(train);
norm_train_mat=[];
column_no=1;
%hold on
for i=1:n
    z=train(:,i);
    scale=norm(z);
    z=z/norm(z);
    norm_train_mat=[norm_train_mat z];
    %plot(norm_train_mat(69:136,column_no),norm_train_mat(1:68,column_no),'.')
    %hold on
    column_no=column_no+1;
    %pause(1)
end

end

