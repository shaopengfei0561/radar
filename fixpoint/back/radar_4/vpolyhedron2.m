function volume = vpolyhedron2(m_a,tri,h)
[m,n]=size(tri);
k=1;
for i=1:m
    for j=1:3    
    x(k)=m_a(tri(i,j),1);
    y(k)=m_a(tri(i,j),2);
    z(k)=m_a(tri(i,j),3)+h;
    k=k+1;
    end
end
%% 计算三角形面积
sum=0;
for i=0:(k/3-1)
S(i+1)=delauS(x(3*i+1:3*i+3),y(3*i+1:3*i+3));
%% 计算三角形体积
V(i+1)=mean(z(3*i+1:3*i+3))*S(i+1)/3;
sum=sum+V(i+1);
end
volume=sum;
