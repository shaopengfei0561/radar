function dianyunalg()
global toprestore;
global toprenum;
global hObject1 handles1;
global runstat;
global paravalue;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%�㷨��������%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
deltathrd = str2num(paravalue.alg.trianthreshold);                     % �����α߳���ֵ����������ֵ�������ν������˵�
%% ��������
for i=1:toprenum
    storedata(i).seq=0;              %��λ��
    storedata(i).vol=0;              %��λ����������
    storedata(i).filenam1=0;         %��λ���������ļ���
    storedata(i).filenam2=0;         %��λ���������ļ���
end
for sj=1:toprenum
    fname=strcat(num2str(toprestore(sj)),'.txt');
    a=load(fname);
    %% ����ѹ����ѹ��������
    % dis=5;
    % a=MyCompress(a,dis);
    spaceDownLength = str2num(paravalue.alg.spacedownlength);
    if spaceDownLength~=0
        a=spaceDownSampling(a,'cube3',1,spaceDownLength);
    else
        a=spaceDownSampling(a,'cube3',1);
    end
    %% ����Ӧȥ������
    bgthred = str2num(paravalue.alg.backgroudthreshold); 
    a = delBackground(a, bgthred);
    [r,l]=size(a);
    if r~=0
    %% ���������
    %storeWidth = str2num(paravalue.alg.storewidth); 
    %if max(a(:,2))>storeWidth
    %a(:,2)=a(:,2)*storeWidth/max(a(:,2));
    %end
    %% ��ż�����
    %dis=1:100;
    %disse=find(dis>=(r/60000));   
    %a=CubeCompress(a,dis(disse(1)));
    %% ������ˣ���ȡ��������㣩
    %a=MySelect(a��1��toprestore(sj));                                     %1������y������ˣ�2�����ݿ�λ�����ļ����ˣ����ݿ�λ�ĸ�����������й��ˣ�
    %% �����������
    savedata(a,1,sj);
    %% �����ؽ�
    myCrustPara1 = str2num(paravalue.alg.mycrustpara1);
    myCrustPara2 = str2num(paravalue.alg.mycrustpara2);
    [t]=MyCrust(a,myCrustPara1,myCrustPara2);
    [m,n]=size(t); 
    %% ɾ�������
    [a_m,a_n]=size(a);
    for i=1:m
        for j=1:3    
            if t(i,j)>a_m
               t(i,:)=0;
            end
        end
    end
    row=find(abs(t(:,1))+abs(t(:,2))+abs(t(:,3))>0);
    t=t(row,:);
   %% ��������
    [m,n]=size(t);
    k=1;
    for i=1:m
        for j=1:3    
        x(k)=a(t(i,j),1);
        y(k)=a(t(i,j),2);
        z(k)=a(t(i,j),3);
        k=k+1;
        end
    end
    %% ȥ��ճ��������
    for i=0:(k/3-1)
        maxvalue = Maxline(x(3*i+1:3*i+3),y(3*i+1:3*i+3),z(3*i+1:3*i+3));  % �������������߳�
        if maxvalue>deltathrd                                              % �����α߳���ֵ����������ֵ�������ν������˵�
            t(i+1,:)=0;
        end
    end
    %% ɾ��0��
    row=find(abs(t(:,1))+abs(t(:,2))+abs(t(:,3))>0);
    t=t(row,:);
    %% ���������ؽ�����
    savedata(t,2,sj);
    %***********************************************************%
    %% 3D��ģ&�������
    jianmo(a,t,sj);
    % ����㷨һ�������ʷ�ͶӰ
    % v = vpolyhedron2(a,t,400)/1000000;
    % v = 0.6*vpolyhedron2(a,t,0)/1000000;
    % v = floor(v);
    % disp(['The volume is: ',num2str(v)]);
    
    % ����㷨��������������
    volumeLength = str2num(paravalue.alg.volumelength);
    volumeRatio = str2num(paravalue.alg.volumeratio);
    v = calVolumeByPnts(a, volumeLength, volumeRatio);
    v=floor(v/1000000);
    disp(['The volume2 is: ',num2str((v))]);
    
    fname=strcat('������������',num2str(v),'��������');
    set(handles1.text1,'String',fname);
    storedata(sj).seq=toprestore(sj);                       %��λ��
    storedata(sj).vol=v;                                    %��λ����������
    storedata(sj).filenam1=toprestore(sj)*2-1;              %��λ���������ļ���1
    storedata(sj).filenam2=toprestore(sj)*2;                %��λ���������ļ���2
    else
        storedata(sj).seq=toprestore(sj);                   %��λ��
        storedata(sj).vol=0;                                %��λ����������
        storedata(sj).filenam1=toprestore(sj)*2-1;          %��λ���������ļ���1
        storedata(sj).filenam2=toprestore(sj)*2;            %��λ���������ļ���2   
        savedata(a,1,sj);
        t=[];
        savedata(t,2,sj);
    end
end
%***********************************************************%
%% ���Ͳ������� 
disp('֪ͨ��ƽ̨���ݴ������......');
send_meadata(storedata,1);
runstat=0;
end