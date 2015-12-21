function [] = closematlabpool
%function [] = closematlabpool
nlabs = matlabpool('size');
if nlabs>0
%用户可以根据应用需求调用此函数
%不必每次运行parfor并行程序后运行closematlabpool函数
    matlabpool close;
end
