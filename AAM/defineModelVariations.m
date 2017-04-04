function [texture_vector,g] = defineModelVariations(TrainingData,i,pos,AppearanceData,ShapeData,CombinedModel )
[texture_new,index]=TempTransformToMeanShape(TrainingData(i).Image,pos(:,2),pos(:,1),AppearanceData.base_points,ShapeData);
%figure,imshow(texture_new);
pause(.2)
texture_new(find(index))=NormalizeAppearance(texture_new(find(index)));
texture_vector=texture_new(find(index));
b1=CombinedModel.Ws*ShapeData.Evector'*([TrainingData(i).x;TrainingData(i).y]-ShapeData.meanValue);
b2=AppearanceData.Evectors'*(texture_vector-AppearanceData.g_mean);
b=[b1;b2];
c_new=CombinedModel.Evector'*(b-CombinedModel.b_mean);
b=CombinedModel.b_mean+CombinedModel.Evector*c_new;
b2=b(size(CombinedModel.Ws)+1:end);
g=AppearanceData.g_mean+AppearanceData.Evectors*b2;
end

