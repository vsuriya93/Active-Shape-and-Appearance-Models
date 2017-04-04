function [ texture,index ] = TempTransformToMeanShape(image,x,y,base_points,ShapeData)
texture=zeros(ShapeData.textureSize);
base_points=round(base_points);
tri=delaunayTriangulation(base_points(:,1),base_points(:,2));
[m n]=size(texture);
%index=zeros(size(texture));
[image,x,y]=modify_image_details(image,x,y,length(texture));
no_of_triangles=size(tri.ConnectivityList,1);
%s=delaunayTriangulation(x,y);
[texture,index]=warping(image,tri.Points,tri.ConnectivityList,x,y);
%imshow(texture);
% for i=1:m
%     for j=1:n
%         for k=1:no_of_triangles
%             b=cartesianToBarycentric(tri,k,[i j]);
%             if(isempty(find(b<0-.000001 | b>1+0.000001))==1)
%                 index(j,i)=1;
%                 %for image
% %                 figure(1),imshow(image);
% %                 hold on
% %                 triplot(s);
% %                plot(x(tri(k,[1:end 1])),y(tri(k,[1:end 1])),'r');
%                 x1=x(tri(k,:));
%                 y1=y(tri(k,:));
%                 v1=b*x1;
%                 v2=b*y1;
% %                 scatter(v1,v2,'r+');
% %                 figure(2),triplot(s);
% %                 hold on
% %                 scatter(i,j,'+');
%                 texture(j,i)=interp2(image,v1,v2,'bicubic');
% %                 figure(3),imshow(texture')
%                 break
%             end
%         end
%     end
% end
% texture=texture';
end