function drawFigure( vect,c )
p1=[];
figure, hold on
for i=1:17
    p1=[p1 ;[vect(68+i),vect(i)]];
end
plot(p1(:,1),p1(:,2),c)
p1=[];
for i=18:22
    p1=[p1 ;[vect(68+i),vect(i)]];
end
plot(p1(:,1),p1(:,2),c)
p1=[];
for i=23:27
    p1=[p1 ;[vect(68+i),vect(i)]];
end
plot(p1(:,1),p1(:,2),c)
p1=[];
for i=28:31
    p1=[p1 ;[vect(68+i),vect(i)]];
end
plot(p1(:,1),p1(:,2),c)
p1=[];
for i=32:36
    p1=[p1 ;[vect(68+i),vect(i)]];
end
plot(p1(:,1),p1(:,2),c)
p1=[];
for i=37:42
    p1=[p1 ;[vect(68+i),vect(i)]];
end
p1=[p1 ;[vect(68+37),vect(37)]];
plot(p1(:,1),p1(:,2),c)
p1=[];
for i=43:48
    p1=[p1 ;[vect(68+i),vect(i)]];
end
p1=[p1 ;[vect(68+43),vect(43)]];
plot(p1(:,1),p1(:,2),c)
p1=[];
for i=49:68
    p1=[p1 ;[vect(68+i),vect(i)]];
end
x=[vect(68+49);vect(69+60)];
y=[vect(49);vect(60)];
line(x,y)
plot(p1(:,1),p1(:,2),c)
end

