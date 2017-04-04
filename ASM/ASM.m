TrainingData=struct;%organizing data into a array of structs
AppearanceData=struct;
res=2;
n=68;
k=8;  % 2*k +1 gives the length of the profile
for i=1:16           %populating the struct
    offset=num2str(i);
    name='input/train';
    name=strcat(name,offset);
    filename=strcat(name,'.png');
    landmark=strcat(name,'.txt');
    Image=im2double(imread(filename));
    TrainingData(i).Image=Image;
    file_ptr=fopen(landmark);
    points=fscanf(file_ptr,'%f %f',[2 n])';
    TrainingData(i).Vertices=[points(:,1) points(:,2)];
    [TrainingData(i).x,TrainingData(i).y,TrainingData(i).x_mean,TrainingData(i).y_mean]=sub_mean(points(:,1),points(:,2));
end
fclose('all');
s=length(TrainingData);
TrainingMatrix=zeros(2*n,s);
for i=1:s                %building the training matrix
    TrainingMatrix(:,i)=[TrainingData(i).x' TrainingData(i).y']';
    %scatter(TrainingData(i).x,TrainingData(i).y,'r');
    %pause(.4);
end;
mean_shape=MeanShape(TrainingData);
Lines=[ [1:n]' [ [2:n] 1 ]' ];
TrainingMatrix=Align(TrainingMatrix);
[Evector,score,Evalue]=pca(TrainingMatrix','Economy',false);
i=find(cumsum(Evalue)>sum(Evalue)*.995,1,'first'); %to get the major EVs
Evector=Evector(:,1:i);
Evalue=Evalue(1:i);
MeanMatrix=mean(TrainingMatrix,2);
ShapeData=struct;
ShapeData.Evector=Evector;
ShapeData.Evalue=Evalue;
ShapeData.Mean=MeanMatrix;
ShapeData.TrainingMatrix=TrainingMatrix;
ShapeData.Lines=Lines;
ShapeData.MeanShape=mean_shape;
%        check for modes variation
%q=[TrainingData(10).x;TrainingData(10).y];
%r=q;
%b=Evector'*(q-MeanMatrix)
%b(1)=-3*sqrt(Evalue(1))
%q=MeanMatrix+Evector*b;
%hold on
%drawFigure(q,'r')
%pause(2)
%figure
%hold on
%drawFigure(r,'b')
for i=1:s    
    P=TrainingData(i).Vertices;    
    TrainingData(i).Normals=GetNormal(TrainingData(i).Vertices,Lines);
    N=TrainingData(i).Normals;
end
for ctr=1:res
    scale=1/(2^(ctr-1));
    PCAData=struct;
    for i=1:s
        P=TrainingData(i).Vertices*scale;
        N=TrainingData(i).Normals;
        myfilter=fspecial('gaussian',[3 3],1/scale);
        I=TrainingData(i).Image;
        I=imfilter(I,myfilter,'replicate');
        I=imresize(TrainingData(i).Image,scale);
        [TrainingData(i).Profile,TrainingData(i).DerivativeProfile]=GetProfileAndDerivatives(I,P,N,k);
    end
% now we will calculate the covariance matrix and store it for each point
    for j=1:n %all those 68 points
        dg=zeros(2*k+1,s);%in our case 17 * 10 
        g=zeros(2*k+1,s);
        %Derivative profile dim 17 * 68 for 1 image
        %the ith column of dg= D_Profile ith coulmn of ith image
        %so dg contains for the ith landmark point all d_profiles
        %of all the 10 images corresponding to the ith landmark pt
        for i=1:s
            dg(:,i)=TrainingData(i).DerivativeProfile(:,j);
            g(:,i)=TrainingData(i).Profile(:,j);
        end
        dg_mean=mean(dg,2); %mean across all colums
        dg=dg-repmat(dg_mean,1,s); %subtracting mean
        temp=cov(dg'); %dg' beacuse row has to be the observations
        AppearanceData(ctr).Landmarks(j).S=temp+0.00000001*eye(size(temp)); %to make sure inverse exits
        AppearanceData(ctr).Landmarks(j).Sinv=inv(AppearanceData(ctr).Landmarks(j).S);
        AppearanceData(ctr).Landmarks(j).dg_mean=dg_mean;
        [Evector,score,Evalue]=pca(g','Economy',false);
        g_mean=mean(g,2);
        i=find(cumsum(Evalue)>sum(Evalue)*0.98,1,'first');
        PCAData(j).Evector= Evector(:,1:i);
        PCAData(j).Evalue = Evalue(1:i);
        PCAData(j).mean =g_mean;
    end
AppearanceData(ctr).PCAData=PCAData;
end
TestImage=im2double(imread('test.png'));
%initially the best approx in mean_shape
ApplyModel(TestImage,ShapeData,AppearanceData,k,res);
