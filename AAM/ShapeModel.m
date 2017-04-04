function [ShapeData,TrainingData]=ShapeModel(TrainingData)
%builds the shape model, accounting for the alignment,rotation etc.
ShapeData=struct;
s=length(TrainingData);
n=length(TrainingData(1).Vertices);
TrainingMatrix=zeros(2*n,s);
for i=1:s
    [TrainingData(i).CVertices,TrainingData(i).tform]=AAM_align_data2D(TrainingData(i).Vertices,TrainingData(1).Vertices);
    TrainingData(i).y=TrainingData(i).CVertices(:,1);
    TrainingData(i).x=TrainingData(i).CVertices(:,2);
end
for i=1:s
    TrainingMatrix(:,i)=[TrainingData(i).y;TrainingData(i).x];
end
%TrainingMatrix=Align(TrainingMatrix);
[Evalue,Evector,x_mean]=PCA(TrainingMatrix);
%[Evector,~,Evalue]=pca(TrainingMatrix','Economy','off');
i=find(cumsum(Evalue)>sum(Evalue)*0.99,1,'first');
Evector=Evector(:,1:i);
Evalue=Evalue(1:i);
meanValue=mean(TrainingMatrix,2);
ShapeData.Evector=Evector;
ShapeData.Evalue=Evalue;
ShapeData.TrainingMatrix=TrainingMatrix;
%ShapeData.x_mean=x_mean;
ShapeData.meanValue=meanValue;
ShapeData.Lines=[[1:n]' [ [2:n]';1]];
textureSize=ceil(max(max(ShapeData.meanValue(:)),-min(ShapeData.meanValue(:))))*2;
ShapeData.textureSize=[textureSize textureSize];
ShapeData.Tri=delaunay(meanValue(1:n,1),meanValue(n+1:end,1));
end