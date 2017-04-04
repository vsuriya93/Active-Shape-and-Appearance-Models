function [ gtc,dgtc ] = GetProfileAndDerivatives( I,P,N,k )
%
% Gets the derivative and profile
gtc =zeros((k*2+1)*size(I,3),size(P,1));
dgtc=zeros((k*2+1)*size(I,3),size(P,1));
xi=MyLinspace(P(:,1)-N(:,1)*k,P(:,1)+N(:,1)*k,k*2+1);
yi=MyLinspace(P(:,2)-N(:,2)*k,P(:,2)+N(:,2)*k,k*2+1);
xi(xi<1)=1; xi(xi>size(I,1))=size(I,1);
yi(yi<1)=1; yi(yi>size(I,1))=size(I,1);
    % Sample on the normal lines
gt= interp2(I,xi,yi,'cubic')';
%same as I
    %gt is of dim 17*68, 17 interpolated points for the 68 land mark points
gt(isnan(gt))=0;
    % Get the derivatives
dgt=[gt(2,:)-gt(1,:);(gt(3:end,:)-gt(1:end-2,:))/2;gt(end,:)-gt(end-1,:)];
gtc=gt;
%normalize the derivatives sum all column sum and divide
dgtc=dgt./repmat((sum(abs(dgt),1)+eps),(k*2+1),1);

