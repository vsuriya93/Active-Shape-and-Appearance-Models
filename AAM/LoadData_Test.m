function [TrainingData]=LoadData_Test(Folder)

%loads the image and corresponding landmark points and returns the struct
%training data containing the image and its control points
im_files=dir(fullfile('data set/images/',Folder));
landmark_files=dir(fullfile('data set/points/',Folder));
s=length(im_files);
TrainingData=struct;
count=1;
for i=1:s
    if(im_files(i).isdir~=1)
        filename=fullfile('data set/images',Folder,im_files(i).name);
        TrainingData(count).filename=im_files(i).name;
        TrainingData(count).Image=im2double(imread(filename));
        filename=fullfile('data set/points',Folder,landmark_files(i).name);
        ptr=fopen(filename);
        p=fscanf(ptr,'%f %f',[2 68])';
        TrainingData(count).Vertices=[p(:,2) p(:,1)];
        %imshow(TrainingData(count).Image);
        %hold on
        %scatter(p(:,1),p(:,2),'r.');
        %pause(.05)
        count=count+1;
        %hold off
    end
end
count
% landmark_files=dir(fullfile('data set/points/',Folder));
% s=length(landmark_files);
% count=1;
% for i=1:s
%     if(landmark_files(i).isdir~=1)
%         filename=fullfile('data set/points',Folder,landmark_files(i).name);
%         ptr=fopen(filename);
%         p=fscanf(ptr,'%f %f',[2 68])';
%         TrainingData(count).Vertices=[p(:,2) p(:,1)];
%         %TrainingData(count).Mean=mean([p(:,1) p(:,2)],1);
%         %[TrainingData(count).x,TrainingData(count).y]=sub_mean(p(:,1),p(:,2));
%         %imshow(TrainingData(count).Image);
%         %hold on
%         %scatter(p(:,1),p(:,2));
%         %pause(1);
%         count=count+1;
%     end
% end
% count
% val=TrainingData(1).Vertices;
% for i=1:length(TrainingData)
%     [Temp, tform]=AAM_align_data2D(TrainingData(i).Vertices,val);
%     TrainingData(i).x=Temp(:,1);
%     TrainingData(i).y=Temp(:,2);
%     TrainingData(i).tform=tform;
end