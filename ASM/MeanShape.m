function x=MeanShape(TrainingData)
s=length(TrainingData);
temp=[];
for i=1:s
    x=TrainingData(i).Vertices(:,1);
    y=TrainingData(i).Vertices(:,2);
    temp=[temp [x;y] ];
end
x=mean(temp,2);
end