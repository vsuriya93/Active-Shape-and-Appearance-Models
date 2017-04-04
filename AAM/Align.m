function [ RotationMatrix ] = Align(TrainingMatrix)
%To align the matrix, we account here for the 
% rotation component. R=VU' is the rotation matrix from SVD
% align 2nd image to 1st image
RotationMatrix=[TrainingMatrix(:,1)];   %intially it is only x1
[m n]=size(TrainingMatrix);
x1=TrainingMatrix(:,1);
for i=2:n
    x2=TrainingMatrix(:,i);
    inter=x2*(x1');
    [U S V]=svd(inter);
    R=V*U';
    %t=eig(R);
    %[~,k]=max(abs(t-1));
    %angle(t(k))
    x2=R'*x1;
    RotationMatrix=[RotationMatrix x2];
%     scatter(x2(1:68,1),x2(69:136,1))
%     hold on
%     scatter(x1(1:68,1),x1(69:136,1),'r');
%     pause(1)
    if(i<n)
    x1=mean(RotationMatrix,2);
    end
end