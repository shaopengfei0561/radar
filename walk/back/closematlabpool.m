function [] = closematlabpool
%function [] = closematlabpool
nlabs = matlabpool('size');
if nlabs>0
%�û����Ը���Ӧ��������ô˺���
%����ÿ������parfor���г��������closematlabpool����
    matlabpool close;
end
