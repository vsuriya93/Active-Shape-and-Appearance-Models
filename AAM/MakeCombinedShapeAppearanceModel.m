function CombinedModel=MakeCombinedShapeAppearanceModel(TrainingData,ShapeData,AppearanceData)
r=getWeights(ShapeData,AppearanceData);
Ws=r*eye(size(ShapeData.Evalue,1));
b=zeros(size(ShapeData.Evalue,1)+size(AppearanceData.Evalues,1),length(TrainingData));
for i=1:length(TrainingData)
    b1=Ws*ShapeData.Evector'*(ShapeData.TrainingMatrix(:,i)-ShapeData.meanValue);
    b2=AppearanceData.Evectors'*(AppearanceData.g(:,i)-AppearanceData.g_mean);
    b(:,i)=[b1;b2];
end
[Evalue,Evector,b_mean]=PCA(b);
i=find(cumsum(Evalue)>sum(Evalue)*.99,1,'first');
Evector=Evector(:,1:i);
Evalue=Evalue(1:i);
CombinedModel.Evector=Evector;
CombinedModel.Evalue=Evalue;
CombinedModel.b_mean=b_mean;
CombinedModel.b=b;
CombinedModel.Ws=Ws;
end