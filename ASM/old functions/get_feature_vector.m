function [ c_vector] = get_feature_vector( file_pointer )
% given file_pointer input this function
% this returns column vector
form='%f %f';
sizeA=[2 68];
A=fscanf(file_pointer,form,sizeA);
A=A';
y=A(:,1);
x=A(:,2);
%x_mean=mean(x);
%y_mean=mean(y);
%x=x-x_mean;
%y=y-y_mean;
%c_vector=[x;y];
%c_vector=sub_mean([x;y]);
c_vector=[x;y];
return
end

