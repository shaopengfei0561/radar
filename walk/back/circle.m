function [CircleX, CircleY] = circle(center, R) 
% PURPOSE : Բ
% INPUTS   : 
%         center-------Բ������[x y]
%         R-------Բ�İ뾶
% OUTPUTS   : 
%         
% AUTHORS  : Yu Zhi-Jun
% DATE     : 2015/5/17

alpha=0:pi/50:2*pi;%�Ƕ�[0,2*pi] 
CircleX=R*cos(alpha) + center(1); 
CircleY=R*sin(alpha) + center(2); 
% plot(x,y,'r:') 
% axis equal 