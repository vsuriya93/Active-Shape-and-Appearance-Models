function [ AppearanceData ] = AppearanceModel( TrainingData,ShapeData )

%Building the Appearance Data
base_points=reshape(ShapeData.meanValue,68,2);
%now normalize the data so that all points lie in [0,1]
%formula for that is x-min/max-min
base_points=base_points-repmat(min(base_points,[],1),size(base_points,1),1);
base_points=base_points ./ repmat(max(base_points),size(base_points,1),1);
base_points(:,1)=1+(ShapeData.textureSize(1)-1)*base_points(:,1);
base_points(:,2)=1+(ShapeData.textureSize(2)-1)*base_points(:,2);
g=[];
for i=1:length(TrainingData)
    image=TrainingData(i).Image;
    y=TrainingData(i).Vertices(:,1);
    x=TrainingData(i).Vertices(:,2);
    filename =strcat(pwd,'/textures/');
    addr = strcat(filename,TrainingData(i).filename);
    if(i==1)
        [texture,index]=TempTransformToMeanShape(image,x,y,base_points,ShapeData);
        %index=index;
    else
        [texture,~]=TempTransformToMeanShape(image,x,y,base_points,ShapeData);
    end
    %texture=texture';  %making it into column form
    imshow(texture);
    g(:,i)=texture(find(index));
end

%for i=1:length(TrainingData)
%    g(:,i)=NormalizeAppearance(g(:,i));
%end

[Evalues,Evectors,g_mean]=PCA(g);
i=find(cumsum(Evalues)>sum(Evalues)*.99,1,'first');
Evectors=Evectors(:,(1:i));
Evalues=Evalues(1:i,1);
AppearanceData.Evectors=Evectors;
AppearanceData.Evalues=Evalues;
AppearanceData.g_mean=g_mean;
AppearanceData.g=g;
AppearanceData.index=index;
AppearanceData.base_points=base_points;
end

