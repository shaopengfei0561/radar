function [CircleX, CircleY] = circle(center, R) 
% PURPOSE : Ô²
% INPUTS   : 
%         center-------Ô²ÐÄ×ø±ê[x y]
%         R-------Ô²µÄ°ë¾¶
% OUTPUTS   : 
%         
% AUTHORS  : Yu Zhi-Jun
% DATE     : 2015/5/17

alpha=0:pi/50:2*pi;%½Ç¶È[0,2*pi] 
CircleX=R*cos(alpha) + center(1); 
CircleY=R*sin(alpha) + center(2); 
% plot(x,y,'r:') 
% axis equal 