function [ Y ] = sub_mean( Y )
% SUbtracrs x mean and y mean and returns the mean subtracted vector
x=Y(1:68,1);
y=Y(69:136,1);
x_mean=mean(x);
y_mean=mean(y);
x=x-x_mean;
y=y-y_mean;
Y=[x;y];
return 
end

