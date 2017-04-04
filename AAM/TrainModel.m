function R=TrainModel(ShapeData,AppearanceData,CombinedModel,TrainingData)
experience=size(CombinedModel.Evector,2)+4;
deltaP=zeros(experience,6,length(TrainingData),length(AppearanceData.g_mean));
for i=1:length(TrainingData)
    for j=1:experience
        pertubation=[-.5:.2:.5];
        if(j<=size(CombinedModel.Evector,2))
            c=CombinedModel.Evector'*(CombinedModel.b(:,i)-CombinedModel.b_mean);
            sigma=sqrt(CombinedModel.Evalue(j));
            for k=1:length(pertubation)
                c_perturbed=c;
                c_perturbed(j)=c_perturbed(j)+sigma*pertubation(k);
                b_perturbed=CombinedModel.b_mean+CombinedModel.Evector*c_perturbed;
                Shape_b=b_perturbed(1:length(CombinedModel.Ws));
                Shape_b=inv(CombinedModel.Ws)*Shape_b;
                x=ShapeData.meanValue+ShapeData.Evector*Shape_b;
                pos(:,1)=x(1:end/2);
                pos(:,2)=x(end/2+1:end);
                pos=AAM_align_data_inverse2D(pos,TrainingData(i).tform);
%                 imshow(TrainingData(i).Image);
%                 hold on
%                 scatter(pos(:,2),pos(:,1),'r.');
%                 pause(3)
%                 pos(:,1)=pos(:,1)+repmat(TrainingData(i).Mean(1),size(pos(:,1),1),1);
%                 pos(:,2)=pos(:,2)+repmat(TrainingData(i).Mean(2),size(pos(:,2),1),1);
                 [texture_vector,g]=defineModelVariations(TrainingData,i,pos,AppearanceData,ShapeData,CombinedModel);
%                 [texture_new,index]=TempTransformToMeanShape(TrainingData(i).Image,pos(:,1),pos(:,2),AppearanceData.base_points,ShapeData);
%                 %texture_new(find(index))=NormalizeAppearance(texture_new(find(index)));
%                 texture_vector=texture_new(find(index));
%                 b1=CombinedModel.Ws*ShapeData.Evector'*([TrainingData(i).x;TrainingData(i).y]-ShapeData.meanValue);
%                 b2=AppearanceData.Evectors'*(texture_vector-AppearanceData.g_mean);
%                 b=[b1;b2];
%                 c_new=CombinedModel.Evector'*(b-CombinedModel.b_mean);
%                 b=CombinedModel.b_mean+CombinedModel.Evector*c_new;
%                 b2=b(size(CombinedModel.Ws)+1:end);
%                 g=AppearanceData.g_mean+AppearanceData.Evectors*b2;
               w =exp ((-pertubation(k)^2) / (2*sigma^2))/pertubation(k);
                deltaP(j,k,i,:)=(g-texture_vector)*w;
            end
        else
           j2=j-size(CombinedModel.Evector,2);
           switch(j2)
               case 1
                   pertubation=[-2 -1.2 -0.4 0.4 1.2 2]/2;
               case 2
                   pertubation=[-2 -1.2 -0.4 0.4 1.2 2]/2;
               case 3
                   pertubation=[-0.2 -.12 -0.04 0.04 0.12 0.2]/2;
               case 4
                   pertubation=[-0.2 -.12 -0.04 0.04 0.12 0.2]/2;
           end
           for k=1:length(pertubation)
              tform=TrainingData(i).tform;
               switch(j2)
                   case 1
                       tform.offsetv(1)=tform.offsetv(1)+pertubation(k);
                   case 2
                       tform.offsetv(2)=tform.offsetv(2)+pertubation(k);
                   case 3
                       tform.offsetsx=tform.offsetsx+pertubation(k);
                   case 4
                       tform.offsetsy=tform.offsetsy+pertubation(k);
               end
               pos=AAM_align_data_inverse2D(TrainingData(i).CVertices,tform);
               %[texture_new,index]=TempTransformToMeanShape(TrainingData(i).Image,pos(:,1),pos(:,2),AppearanceData.base_points,ShapeData);
               [texture_vector,g]=defineModelVariations(TrainingData,i,pos,AppearanceData,ShapeData,CombinedModel);
               w =exp ((-pertubation(k)^2) / (2*sigma^2))/pertubation(k);
               deltaP(j,k,i,:)=(g-texture_vector)*w;
           end
        end
    end
end
deltaPt=squeeze(mean(mean(deltaP,3),2));
R=pinv(deltaPt)';
end