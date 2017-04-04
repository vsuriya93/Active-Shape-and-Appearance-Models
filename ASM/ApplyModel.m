function [ ] = ApplyModel(TestImage,ShapeData,AppearanceData,lengthOfProfile,res )
%Test phase
num=40;%no of iterations to check for convergence
value=4;
imshow(TestImage);
hold on;
%initially the shape is just mean_shape of the model
h=[];
h2=[];   
n=length(ShapeData.MeanShape)/2;
pos(:,1)=ShapeData.MeanShape(1:n,:)';
pos(:,2)=ShapeData.MeanShape(n+1:end,:)';
h=plot(pos(:,1),pos(:,2),'r.'); 
pause(3)
for ctr=res:-1:1
    scale=1/(2^(ctr-1));
    for check=1:num    
        if(ishandle(h))
            delete(h);
        end
        PCAData=AppearanceData(ctr).PCAData;
        N=GetNormal(pos,ShapeData.Lines);
        LengthOfProfile=lengthOfProfile+value;
        myfilter=fspecial('gaussian',[5 5],1/scale);
        I=imfilter(TestImage,myfilter,'replicate');
        [~,dgt]=GetProfileAndDerivatives(I,pos*scale,N,LengthOfProfile);
        f=zeros(value*2+1,n);
        for j=1:n
            for i=1:value*2+1
                gi(:,1)=dgt(i:lengthOfProfile*2+i,j);
                v=gi-AppearanceData(ctr).Landmarks(j).dg_mean;
                f(i,j)=v'*AppearanceData(ctr).Landmarks(j).Sinv*v;
            end
        end
        [~,j]=min(f);
        movement=((j-1)-value)';
        % Move the points to there new optimal positions
        pos(:,1)=pos(:,1)+(1/scale)*movement.*N(:,1);
        pos(:,2)=pos(:,2)+(1/scale)*movement.*N(:,2);
        if(ishandle(h2)) 
            delete(h2);
        end
        h2=plot(pos(:,1),pos(:,2),'b.');
        drawnow('expose');
        temp=[pos(:,1);pos(:,2)]*ShapeData.MeanShape';
        [U S V]=svd(temp);
        R=V*U';
        pos=R'*ShapeData.MeanShape;
        pos=[pos(1:68,1) pos(69:136,1)];
        mean_pos=mean(pos,1);
        pos=pos-repmat(mean_pos,68,1);
        x_search=[pos(:,1);pos(:,2)];
        b = ShapeData.Evector'*(x_search-ShapeData.Mean);
        maxb=3*sqrt(ShapeData.Evalue);
        b=max(min(b,maxb),-maxb);
        x_search = ShapeData.Mean + ShapeData.Evector*b;
        pos(:,1)=x_search(1:n)';
        pos(:,2)=x_search(n+1:end)';
        pos(:,1)=pos(:,1) + mean_pos(1);
        pos(:,2)=pos(:,2) + mean_pos(2);
        pause(.01)
    end
end

end