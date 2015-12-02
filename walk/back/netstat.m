function data=netstat(str)
if strcmp(class(str),'char')
    [m,data]=dos(['netstat ' str]);
else
    disp('Error: the input arguments must be a char.');
end