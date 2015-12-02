function [x,y,z] = data_cluster(x,y,z,pointNum)
global paravalue;
global lidarQuantity;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%算法参数配置%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
startindex = 2;     
disthrd = paravalue.alg.pointclusterdis;            % 点距离阈值
pointfilter = paravalue.alg.pointnum;               % 点间隔
for i=startindex:pointNum
    d=distance([x(i-1),y(i-1),z(i-1)],[x(i),y(i),z(i)]);
    if d>disthrd
        stopindex=i-1;
        if (stopindex<startindex)
            startindex=stopindex;
        end
        if stopindex-startindex<pointfilter
            x(startindex:stopindex)=0; 
            y(startindex:stopindex)=0;
            z(startindex:stopindex)=0;
        end
        startindex=i;
    end
end
if lidarQuantity == 2
    startindex=pointNum+2;
    for i=startindex:pointNum*2
        d=distance([x(i-1),y(i-1),z(i-1)],[x(i),y(i),z(i)]);
        if d>disthrd
            stopindex=i-1;
            if (stopindex<startindex)
                startindex=stopindex;
            end
            if stopindex-startindex<pointfilter
                x(startindex:stopindex)=0; 
                y(startindex:stopindex)=0;
                z(startindex:stopindex)=0;
            end
            startindex=i;
        end
    end
end