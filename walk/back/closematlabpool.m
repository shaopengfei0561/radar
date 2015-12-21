%终止并行计算环境
function [] = closematlabpool
%function [] = closematlabpool
nlabs = matlabpool('size');
if nlabs>0
%用户可以根据应用需求调用此函数
    matlabpool close;
end
