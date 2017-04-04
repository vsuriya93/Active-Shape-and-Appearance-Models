function [image,x,y ] = modify_image_details(image,x,y,val)
[m,n]=size(image);
r=val/m;
c=val/n;
im=imresize(image,[val val]);
pts=[x y];
pts(:,1)=pts(:,1).*c;
pts(:,2)=pts(:,2).*r;
x=pts(:,1);
y=pts(:,2);
image=im;
end

