function [ slope ] = calculate_slope( x, y )
%This function calulates (y2-y1)/(x2-x1) for train and grad matrix
% which returns the slope essentially

x=[x(1:68,1) x(69:136,1)];
y=[y(1:68,1) y(69:136,1)];
slope=(y(:,2)-x(:,2)) ./ (y(:,1)-x(:,1));
%[m,n]=size(slope);
%a=y(32,2);
%b=x(32,2);
%c=y(32,1);
%d=x(32,1);
%(a-b)/(c-d);
end

