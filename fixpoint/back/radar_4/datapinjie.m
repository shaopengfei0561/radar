b=load('12.txt');
p=load('13.txt');

% b = delBackground( b, 500);
p = delBackground( p, 500);

% p(:,2)=-p(:,2);
% p(:,1)=-p(:,1); 
p(:,2)=p(:,2);
p(:,1)=p(:,1);
% p(:,3)=p(:,3)+100;

a=[p;b];

% figure(1);
% scatter3(b(:,1),b(:,2),b(:,3),1,b(:,3),'filled');                          %plot della superficie trattata
% axis equal;
% set(gca,'color',[0.1,0.1,0.1]);
% xlabel('x');ylabel('y');zlabel('z');

figure(2);
scatter3(p(:,1),p(:,2),p(:,3),1,p(:,3),'filled');                          %plot della superficie trattata
axis equal;
set(gca,'color',[0.1,0.1,0.1]);
xlabel('x');ylabel('y');zlabel('z');

% figure(3);
% plot3(a(:,1),a(:,2),a(:,3),'g.');
% axis equal;
% a = delBackground( a, 500);

% figure(4);
% scatter3(a(:,1),a(:,2),a(:,3),1,a(:,3),'filled');                          %plot della superficie trattata
% axis equal;
% set(gca,'color',[0.1,0.1,0.1]);
% xlabel('x');ylabel('y');zlabel('z');
% savedatatest(a,1,1);