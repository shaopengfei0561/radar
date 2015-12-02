function [rectangleX, rectangleY] = rectData(center, len1, len2) 
% PURPOSE : 长方形
% INPUTS   : 
%         center-------中心点坐标[x y]
%         len1-------长
%         len2-------宽
% OUTPUTS   : 
%         
% AUTHORS  : Yu Zhi-Jun
% DATE     : 2015/5/18

n = 48;
rectangleX = [];
rectangleY = [];

tempdata = linspace(center(1)-len1/2,center(1)+len1/2,1+n/4);
rectangleX = [rectangleX, tempdata(1:end-1)];
rectangleX = [rectangleX, ones(1,n/4)*(center(1)+len1/2)];
tempdata = linspace(center(1)+len1/2,center(1)-len1/2,1+n/4);
rectangleX = [rectangleX, tempdata(1:end-1)];
rectangleX = [rectangleX, ones(1,n/4)*(center(1)-len1/2)];

rectangleY = [rectangleY, ones(1,n/4)*(center(2)-len2/2)];
tempdata = linspace(center(2)-len2/2,center(2)+len2/2,1+n/4);
rectangleY = [rectangleY, tempdata(1:end-1)];
rectangleY = [rectangleY, ones(1,n/4)*(center(2)+len2/2)];
tempdata = linspace(center(2)+len2/2,center(2)-len2/2,1+n/4);
rectangleY = [rectangleY, tempdata(1:end-1)];
% plot(rectangleX,rectangleY,'r*') 
% axis equal 