function maxvalue = Maxline(x,y,z)
    a(1)=distance([x(1),y(1),z(1)],[x(2),y(2),z(2)]);
    a(2)=distance([x(2),y(2),z(2)],[x(3),y(3),z(3)]);
    a(3)=distance([x(1),y(1),z(1)],[x(3),y(3),z(3)]);
    maxvalue=max(a);    
end
