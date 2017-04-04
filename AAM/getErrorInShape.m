function E=getErrorInShape(c,x2,CombinedModel,ShapeData)
b=CombinedModel.b_mean+CombinedModel.Evector*c;
b1=b(1:length(CombinedModel.Ws));
b1=inv(CombinedModel.Ws)*b1;
x=ShapeData.meanValue+ShapeData.Evector*b1;
E=x-x2;
end