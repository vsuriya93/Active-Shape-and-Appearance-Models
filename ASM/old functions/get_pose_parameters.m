function [ x ] = get_pose_parameters(mean_shape,P, Y )
%Given 2 sets of landmark points mean_shape and Y (need not be aligned or
%centered) we find the best pose parameters.
[m n]=size(mean_shape);
b=zeros(136,1);
b_previous=b;
count =10;
for i=1:10
x=mean_shape+P*b;
%scatter(x(69:136,1),x(1:68,1),'r');  %mean shape
pause(2)
Y=sub_mean(Y);                   %aligning to the origin
inter=x*(Y');          
[U S V]=svd(inter);          
R=V*U';                           %accounting for rotation
x=R'*Y;
%hold on
%scatter(Y(69:136,1),Y(1:68,1),'b');
%scatter(x(69:136,1),x(1:68,1),'g');
%hold off
b_previous=b;            
%a=input('hello');
b=P'*(Y-mean_shape);
%pause(3);
end
%scatter(x(69:136,1),x(1:68,1),'r');
end

