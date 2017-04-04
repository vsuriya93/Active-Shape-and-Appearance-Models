function [TrainingData]=LoadData()

%loads the image and corresponding landmark points and returns the struct
%training data containing the image and its control points
addpath('mex files')
im_files=dir('image');
s=length(im_files);
TrainingData=struct;
count=1;
for i=1:s
    if(im_files(i).isdir~=1)
        filename=fullfile('image',im_files(i).name);
        TrainingData(count).filename=im_files(i).name;
        TrainingData(count).Image=im2double(imread(filename));
        count=count+1;
    end
end
landmark_files=dir('landmarks');
s=length(landmark_files);
count=1;
for i=1:s
    if(landmark_files(i).isdir~=1)
        filename=fullfile('landmarks',landmark_files(i).name);
        ptr=fopen(filename);
        p=fscanf(ptr,'%f %f',[2 68])';
        TrainingData(count).Vertices=[p(:,2) p(:,1)];
        %TrainingData(count).Mean=mean([p(:,1) p(:,2)],1);
        %[TrainingData(count).x,TrainingData(count).y]=sub_mean(p(:,1),p(:,2));
        %imshow(TrainingData(count).Image);
        %hold on
        %scatter(p(:,1),p(:,2));
        %pause(1);
        count=count+1;
    end
end
% val=TrainingData(1).Vertices;
% for i=1:length(TrainingData)
%     [Temp, tform]=AAM_align_data2D(TrainingData(i).Vertices,val);
%     TrainingData(i).x=Temp(:,1);
%     TrainingData(i).y=Temp(:,2);
%     TrainingData(i).tform=tform;
end