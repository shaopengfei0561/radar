b=load('1246.txt');
b = delBackground( b, 500);

figure(1);
% scatter3(b(:,1),b(:,2),b(:,3),1,b(:,3),'filled');                          %plot della superficie trattata
plot3(b(:,1),b(:,2),b(:,3),'g.'); 
axis equal;
set(gca,'color',[0.1,0.1,0.1]);
xlabel('x');ylabel('y');zlabel('z');

b=load('1236.txt');
b = delBackground( b, 500);

figure(2);
% scatter3(b(:,1),b(:,2),b(:,3),1,b(:,3),'filled');                          %plot della superficie trattata
plot3(b(:,1),b(:,2),b(:,3),'g.'); 
axis equal;
set(gca,'color',[0.1,0.1,0.1]);
xlabel('x');ylabel('y');zlabel('z');