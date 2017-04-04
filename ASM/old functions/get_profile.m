function [ profile ] = get_profile( landmark_points,train, number_of_points )
% returns profiles along the normal direction
landmark_points=uint32(landmark_points);
train=int32(train);
grad=[];
[m n]=size(train);
for i=1:n
    grad=[grad get_grad(train(:,i)) ];
end
theta_matrix=[];
slope_mat=[];
profile=[];
for i=1:n
    slope=calculate_slope(train(:,i),grad(:,i));
    theta=get_theta(double(slope));
    slope_mat=[slope_mat slope];
    theta_matrix=[theta_matrix theta];
    draw_graph(train(:,i),theta,number_of_points);
    pause(.5);
end
size(theta_matrix);
%all_file=dir('image_input');
%all_file_name={all_file.name}';
%siz=size(all_file_name);
%n=siz(1);
%count=0;

%for i=1:n
%    if(all_file(i).isdir==0)
%        f_name=strcat('image_input/',all_file_name{i});
        %name=fullfile('image_input/',f_name)
%        im_file=imread(f_name);
%        count=count+1;
%        tr=landmark_points(:,count);
%        for j=1:68   
%            im_file(tr(j),tr(j+68) )=255;
%        end
%        imshow(im_file);
%        pause(.5)
%    end
%end
end

