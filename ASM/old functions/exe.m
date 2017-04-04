%This script constructs mean subtracted training matrix

all_file=dir('input');
all_file_name={all_file.name}';
siz=size(all_file_name);
n=siz(1);
column_no=1;
train=[];
landmark_points=[];
%figure,imshow('S014_005_02405904.png');
% hold on
for i=1:n
    if(all_file(i).isdir==0)
        f_name=all_file(i).name;
        name=fullfile('input/',f_name);
        file_pointer=fopen(name,'r');
        %train=[train get_feature_vector(file_pointer)];
        temp=get_feature_vector(file_pointer);
        landmark_points=[landmark_points temp];
        temp=sub_mean(temp);
        train=[train temp];
        %plot(train(69:136,column_no),train(1:68,column_no),'*');
        column_no=column_no+1;
        %hold on;
        %pause(.2);
        fclose(file_pointer);
    end
    
end
%train=normalize(train);
train=align(train);
[P mean_shape lambda]=build_model(train);
train;
%train=uint64(train);
threshold=98;
%key_feature_selection(P,lambda,threshold);
%t=fopen('S032_005_00000016_landmarks.txt','r');
%Y=get_feature_vector(t);
%t=sub_mean(Y);
%y=[ [1:68]' ; [1:68]'];
%y=sub_mean(y);
%scatter(y(69:136,1),y(1:68,1),'b');  %test for pose parameters
%hold on
%b=get_pose_parameters(mean_shape,P,y);   
%scatter(b(1:68,1),b(69:136));
profile=get_profile(landmark_points,train,5);