function r=getWeights(ShapeData,AppearanceData)
r=sum(AppearanceData.Evalues)/sum(ShapeData.Evalue);
end