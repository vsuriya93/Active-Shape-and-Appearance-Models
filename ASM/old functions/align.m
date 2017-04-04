function [ rotate_train_mat ] = align( norm_train_mat )
% To align the matrix, I account here for the 
% rotation component. R=VU' is the rotation matrix from SVD
% align 2nd image to 1st image
rotate_train_mat=[ norm_train_mat(:,1) ];   %intially it is only x1
[m n]=size(norm_train_mat);
x1=norm_train_mat(:,1);
for i=2:n
    x2=norm_train_mat(:,i);
    inter=x2*(x1');
    [U S V]=svd(inter);
    R=V*U';
    x2=R'*x1;
    rotate_train_mat=[rotate_train_mat x2];
    %scatter(x2(1:68,1),x2(69:136,1))
    %hold on
    %scatter(x1(1:68,1),x1(69:136,1),'r');
    %pause(1)
    if(i<n)
    x1=mean(rotate_train_mat,2);
end

end

