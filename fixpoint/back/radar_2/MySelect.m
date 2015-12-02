function data = MySelect(vdata,mod,stnum)
global startpos;
global endpos;
switch mod
    case 1                                      %全库测量
    ymin=startpos;
    ymax=endpos;
    m_data=vdata(find(vdata(:,2)>=ymin),:);
    data=m_data(find(m_data(:,2)<=ymax),:);
    case 2                                      %按照库位配置文件进行坐标过滤
    [r,l]=size(vdata);
    %% 根据库位坐标文件进行坐标过滤
    posdata=load('storeposition.txt');          %库位坐标文件
    zb=posdata(find(posdata(:,1)==stnum),:);
    xv(1)=zb(2);yv(1)=zb(3);
    xv(2)=zb(4);yv(2)=zb(5);
    xv(3)=zb(6);yv(3)=zb(7);
    xv(4)=zb(8);yv(4)=zb(9);
    for i=1:r
        in=inpolygon(vdata(i,1),vdata(i,2),xv,yv);
        if in==0
           vdata(i,:)=0;
        end
    end
    row=find(abs(vdata(:,1))+abs(vdata(:,2))+abs(vdata(:,3))>0);
    data=vdata(row,:);
    otherwise 
end
end