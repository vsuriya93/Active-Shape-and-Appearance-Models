function [ grad ] = get_grad( x )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
grad=zeros(68,2);
input_mat=zeros(68,2);
input_mat=[ x(1:68,1) x(69:136,1)];
p1=[68; [1:67]'];
p2=[[2:68]';1];
%input_mat(p1,:),input_mat(p2,:)
grad=input_mat(p1,:)-input_mat(p2,:);
grad=[ grad(:,2);-grad(:,1)];
%scatter(grad(:,1), grad(:,2),'r')
%grad=[grad(:,1);grad(:,2)];
%pause(.8)
end
