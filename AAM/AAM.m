tic
addpath('mex files/')
TrainingData=LoadData;
resolution=3;
Data=cell(1,resolution);
i=1;
for i=1:resolution
    [ShapeData,TrainingData]=ShapeModel(TrainingData);
    AppearanceData=AppearanceModel(TrainingData,ShapeData);
    CombinedModel=MakeCombinedShapeAppearanceModel(TrainingData,ShapeData,AppearanceData);
    R=TrainModel(ShapeData,AppearanceData,CombinedModel,TrainingData);
    Data{i}.R=R;
    Data{i}.ShapeData=ShapeData;
    Data{i}.AppearanceData=AppearanceData;
    Data{i}.CombinedModel=CombinedModel;
    Data{i}.TrainingData=TrainingData;
    if(i<resolution)
        for j=1:length(TrainingData)
            TrainingData(j).Vertices=(TrainingData(j).Vertices-.5)/2 + 0.5;
             TrainingData(j).Image=imresize(TrainingData(j).Image,1/2);
%             imshow(TrainingData(j).Image)
%             hold on
%             scatter(TrainingData(j).Vertices(:,2),TrainingData(j).Vertices(:,1),'r.');
        end
    end
end
TestImage=im2double(imread('test.png'));
ApplyModel(TestImage,Data);
toc