function [x,y,z] = data_cluster(x,y,z)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%算法参数配置%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
startindex = 2;     
disthrd = 400;          % 点距离阈值
pointnum = 3;           % 点间隔
for i=2:529
    d=distance([x(i-1),y(i-1),z(i-1)],[x(i),y(i),z(i)]);
    if d>disthrd
        stopindex=i-1;
        if (stopindex<startindex)
            startindex=stopindex;
        end
        if stopindex-startindex<pointnum
          x(startindex:stopindex)=0; 
          y(startindex:stopindex)=0;
          z(startindex:stopindex)=0;
        end
        startindex=i;
    end
end
startindex=531;
for i=531:1058
    d=distance([x(i-1),y(i-1),z(i-1)],[x(i),y(i),z(i)]);
    if d>disthrd
        stopindex=i-1;
        if (stopindex<startindex)
            startindex=stopindex;
        end
        if stopindex-startindex<pointnum
          x(startindex:stopindex)=0; 
          y(startindex:stopindex)=0;
          z(startindex:stopindex)=0;
        end
        startindex=i;
    end
end