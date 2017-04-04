function [ texture ] = TransformToMeanShape(image,x,y,base_points,ShapeData)
% Generates the texture on the mean control points
texture=zeros(ShapeData.textureSize);
base_points=round(base_points);
tri=delaunayTriangulation(base_points(:,1),base_points(:,2));
[m n]=size(texture);
[image,x,y]=modify_image_details(image,x,y,length(texture));
no_of_triangles=size(tri.ConnectivityList,1);
% figure(1)         
% imshow(texture);
% hold on
% triplot(tri,tri.Points(:,1),tri.Points(:,2));
% figure(2)
% hold on
% imshow(image);
% for k=1:no_of_triangles
%     tr1=tri(k,[1:end 1])
%     figure(1)
%     plot(tri.Points(tr1,1),tri.Points(tr1,2),'r');
%     figure(2)
%     imshow(image)
%     hold on
%     plot(x(tr1),y(tr1),'r');    
% end
%figure(1)
%hold on
%imshow(image);
%figure(2)
%hold on
%imshow(texture);
for i=1:m
   for j=1:n
        cood=[i j];
        for k=1:no_of_triangles
            B=cartesianToBarycentric(tri,k,cood);
            if(isempty(find(B<0 | B>1))==1)
%                 figure(1)
%                 imshow(texture);
%                 hold on
%                 triplot(tri,tri.Points(:,1),tri.Points(:,2));
                tr=tri(k,[1:end 1]);
%                 plot(tri.Points(tr,1),tri.Points(tr,2),'r');
%                 figure(2)
%                 imshow(image);
%                 hold on
%                 plot(x(tr),y(tr),'r');
                temp=delaunayTriangulation(x(tr),y(tr));
                val=barycentricToCartesian(temp,1,B);
                texture(j,i)=interp2(image,val(1),val(2),'linear');
                break;
                %pause(.3)    
            end
        end
    end
end
% im_tri=delaunayTriangulation(x,y);
% m=min(size(im_tri.ConnectivityList,1),size(tri.ConnectivityList,1));
% figure(1);
% %imshow(image);
% hold on
% triplot(im_tri,im_tri.Points(:,1),im_tri.Points(:,2));
% figure(2)
% hold on
% triplot(tri,tri.Points(:,1),tri.Points(:,2));
% for i=1:m
%    t1=[tri.ConnectivityList(i,:) tri.ConnectivityList(i,1)];
%    t2=[im_tri.ConnectivityList(i,:) im_tri.ConnectivityList(i,1)];
%    figure(1)
%    plot(im_tri.Points(t2,1),im_tri.Points(t2,2),'r');
%    figure(2)
%    h2=plot(tri.Points(t1,1),tri.Points(t1,2),'r');
%    pause(3)
% end
% figure(1)
% return
% imshow(texture)
% hold on
% triplot(tri,tri.Points(:,1),tri.Points(:,2));
% %pause(2)
% [m,n]=size(texture);
% no_of_triangles=size(tri.ConnectivityList,1);
% %tform=fitgeotrans(base_points,[x y],'affine')
% %b=imwarp(image);
% %imshow(b)
% for i=1:m
%     for j=1:n
%         cood=[i j];
%         for k=1:no_of_triangles
%             B=cartesianToBarycentric(tri,k,cood);
%             if(isempty(find(B<0 | B>1))==1)
%                 val=barycentricToCartesian(im_tri,k,B)
%                 texture(j,i)=image(floor(val(2)),floor(val(1)));
%                 break 
%             end
%          end
%     end
% end
 imshow(texture)
% return 
end