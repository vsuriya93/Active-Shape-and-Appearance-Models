%function ApplyModel(TestImage,Data)
 function ApplyModel()
load('data.mat');
 TestImage=im2double(imread('test.png'));
Iterations=40;
ShapeData=Data{1}.ShapeData;
CombinedModel=Data{1}.CombinedModel;
AppearanceData=Data{1}.AppearanceData;
b=CombinedModel.b_mean;
b1=b(1:length(CombinedModel.Ws));
b1=inv(CombinedModel.Ws)*b1;
x=ShapeData.meanValue+ShapeData.Evector*b1;
pos(:,1)=x(1:end/2);
pos(:,2)=x(end/2+1:end);
tform.offsetsx=1; tform.offsetsy=0; tform.offsetr=0; tform.offsetv=[0 0];
[x,y]=SelectPosition(TestImage,pos(:,1),pos(:,2));
tform.offsetv=[-x -y];
pos=AAM_align_data_inverse2D(pos,tform);
for i=length(Data):-1:1
    R=Data{i}.R;
    TrainingData=Data{i}.TrainingData;
    ShapeData=Data{i}.ShapeData;
    AppearanceData=Data{i}.AppearanceData;
    CombinedModel=Data{i}.CombinedModel;
    scale=1/(2^(i-1));
    imTest=imresize(TestImage,scale);
    pos=(pos-.5)*scale+.5;
    [pos_aligned,tform]=AAM_align_data2D(pos,TrainingData(1).Vertices);
    x=[pos_aligned(:,1);pos_aligned(:,2)];
    figure, imshow(imTest); hold on;
    %plot(pos(:,2),pos(:,1),'r.');
    [texture,index]=TempTransformToMeanShape(imTest,pos(:,2),pos(:,1),AppearanceData.base_points,ShapeData);
    g=texture(find(index));
    g=NormalizeAppearance(g);
    b1=CombinedModel.Ws*ShapeData.Evector'*(x-ShapeData.meanValue);
    b2=AppearanceData.Evectors'*(g-AppearanceData.g_mean);
    b=[b1;b2];
    cin=CombinedModel.Evector'*(b-CombinedModel.b_mean);
    x2=x;
    maxc=3*sqrt(CombinedModel.Evalue);
    c=lsqnonlin(@(x)getErrorInShape(x,x2,CombinedModel,ShapeData),cin,-maxc,maxc,optimset('Display','off','MaxIter',10));
    c_old=c;
    tform_old=tform;
    w=1;
    Eold=inf;
    h=plot(1,1);
    for j=1:Iterations
        b=CombinedModel.b_mean+CombinedModel.Evector*c;
        b1=b(1:length(CombinedModel.Ws));
        b1=inv(CombinedModel.Ws)*b1;
        x=ShapeData.meanValue+ShapeData.Evector*b1;
        pos=AAM_align_data_inverse2D([x(1:end/2) x(end/2+1:end)],tform);
        [texture,index]=TempTransformToMeanShape(imTest,pos(:,2),pos(:,1),AppearanceData.base_points,ShapeData);
        g=texture(find(index));
        g=NormalizeAppearance(g);
        b1=CombinedModel.Ws*ShapeData.Evector'*(x-ShapeData.meanValue);
        b2=AppearanceData.Evectors'*(g-AppearanceData.g_mean);
        b=[b1;b2];
        c2=CombinedModel.Evector'*(b-CombinedModel.b_mean);
        b=CombinedModel.b_mean+CombinedModel.Evector*c2;
        b2=b(size(CombinedModel.Ws,1)+1:end);
        g_model=AppearanceData.g_mean+AppearanceData.Evectors*b2;
        E=sum((g-g_model).^2);
        if(E>Eold)
            w=w*0.9;
            c=c_old;
            tform=tform_old;
        else
            w=w*1.1;
            Eold=E;
        end
        c_old=c;
        tform_old=tform;
        c_diff=R*(g-g_model);
        c=c+c_diff(1:end-4).*sqrt(CombinedModel.Evalue)*w;
        tform.offsetv(1)=tform.offsetv(1)+c_diff(end-3)*w;
        tform.offsetv(2)=tform.offsetv(2)+c_diff(end-2)*w;
        tform.offsetsx=tform.offsetsx+c_diff(end-1)*w;
        tform.offsetsy=tform.offsetsy+c_diff(end)*w;
        maxc=3*sqrt(CombinedModel.Evalue);
        c=max(min(c,maxc),-maxc);
        delete(h);
        h=plot(pos(:,2),pos(:,1),'g.');
        pause(.1)
    end
 
    pos=(pos-.5)/scale+.5;
end
        [texture,index]=TempTransformToMeanShape(imTest,pos(:,2),pos(:,1),AppearanceData.base_points,ShapeData);
figure,imshow(texture);
end