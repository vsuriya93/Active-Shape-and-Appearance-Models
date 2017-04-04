function [ Normal ] = GetNormal(Vertices,Lines )
%Calculates the normal at every given points
% Lines is the permutation matrix
Dt=Vertices(Lines(:,1),:) - Vertices(Lines(:,2),:); %stors the difference
D1=zeros(size(Vertices));
D2=zeros(size(Vertices));
D1(Lines(:,1),:)=Dt;
D2(Lines(:,2),:)=Dt;
D=D1+D2;
Lines=sqrt(D(:,1).^2+D(:,2).^2);
Normal(:,1)= D(:,2)./Lines;
Normal(:,2)=-D(:,1)./Lines;
end

