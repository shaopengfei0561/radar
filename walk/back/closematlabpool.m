%��ֹ���м��㻷��
function [] = closematlabpool
%function [] = closematlabpool
nlabs = matlabpool('size');
if nlabs>0
%�û����Ը���Ӧ��������ô˺���
    matlabpool close;
end
