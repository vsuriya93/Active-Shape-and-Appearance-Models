function [ Vector ] = MyLinspace( Vector1, Vector2, NumberOfPts )
%emulates linspace for a vector instead of a point
[m,n]=size(Vector1);
Vector=zeros((m*n),NumberOfPts);
count=1;
for i=1:m*n   
    Vector(i,:)=linspace(Vector1(i),Vector2(i),NumberOfPts)';
end

