TrainingData=LoadData_Test;
[ShapeData,TrainingData]=ShapeModel(TrainingData);
 AppearanceData=AppearanceModel(TrainingData,ShapeData);
% r=getWeights(ShapeData,AppearanceData);
% Ws=r*eye(size(ShapeData.Evalue,1));
% c=zeros(size(ShapeData.Evalue,1)+size(AppearanceData.Evalues,1),length(TrainingData));
% for i=1:length(TrainingData)
%     b1=Ws*ShapeData.Evector'*(TrainingData(:,i)-ShapeData.meanValue);
%     b2=AppearanceData.Evectors'*(AppearanceData.g(:,i)-AppearanceData.g_mean);
%     c=[b1:b2];
% end
% size(c)