function [ x,y,x_mean,y_mean ] = sub_mean( x,y )
% SUbtracrs x mean and y mean and returns the mean subtracted vector
x_mean=mean(x);
y_mean=mean(y);
x=x-x_mean;
y=y-y_mean;
end

