function [ output_args ] = draw_graph(points,theta,number_of_points )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

x=points(1:68,1);
y=points(69:136,1);
scatter(x,y);
hold on
x_mat=zeros(68,1);
y_mat=zeros(68,1);
k=number_of_points;
for i=1:68
    x_mat=[x(i)];
    y_mat=[y(i)];
    for r=-k:k
        x_mat=[x_mat;x(i)+ r*cos(theta(i))];
        y_mat=[y_mat;y(i)+ r*sin(theta(i))];
    end
    line(x_mat,y_mat);
end
hold off
end

