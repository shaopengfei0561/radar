function S=delauS(x,y)
a=sqrt((x(1)-x(2))^2+(y(1)-y(2))^2);
b=sqrt((x(1)-x(3))^2+(y(1)-y(3))^2);
c=sqrt((x(2)-x(3))^2+(y(2)-y(3))^2);
p=(a+b+c)/2;
S=sqrt(p*(p-a)*(p-b)*(p-c));
end