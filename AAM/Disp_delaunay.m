function Disp_delaunay(ShapeData)
% Display the del tri part by part
s=delaunayTriangulation(ShapeData.meanValue(1:68),ShapeData.meanValue(69:136));
m=size(s.ConnectivityList,1);
hold on;
triplot(s,s.Points(:,1),s.Points(:,2));
for i=1:m
    t=[s.ConnectivityList(i,:) s.ConnectivityList(i)];
    plot(s.Points(t,1),s.Points(t,2),'r');  
end

end

