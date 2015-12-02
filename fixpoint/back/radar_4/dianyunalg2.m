function dianyunalg2() % created by YZJ
global toprestore;
global toprenum;
global hObject1 handles1;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%�㷨��������%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
deltathrd = 100;                   % �����α߳���ֵ����������ֵ�������ν������˵�
%% ��������
for i=1:21
    storedata(i).seq=0;             %��λ��
    storedata(i).vol=0;             %��λ����������
    storedata(i).filenam=0;         %��λ���������ļ���
end
for sj=1:toprenum
    fname=strcat('oridata_',num2str(toprestore(sj)),'.txt');
    a=load(fname);
    [r,l]=size(a);
    if r~=0
    %***********************************************************%
    %% ����ѹ����ѹ��������
    % dis=5;
    % a=MyCompress(a,dis);
    %% ���������
    % [a] = spaceDownSampling( a, 'cube', 1, 25  );
    a=spaceDownSampling(a,'cube3',1);
    %% ��ż�����
%     dis=1:100;
%     disse=find(dis>=(r/60000));   
%     a=CubeCompress(a,dis(disse(1)));
    %% ������ˣ���ȡ��������㣩
    % a=MySelect(a��1��toprestore(sj));                                   %1������y������ˣ�2�����ݿ�λ�����ļ����ˣ����ݿ�λ�ĸ�����������й��ˣ�
    %% �����������
    % savedata(a,1,sj);
    %% �����ؽ�
    [t]=MyCrust(a);
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
        maxvalue = Maxline(x(3*i+1:3*i+3),y(3*i+1:3*i+3),z(3*i+1:3*i+3));       % �������������߳�
        if maxvalue>deltathrd                                                   % �����α߳���ֵ����������ֵ�������ν������˵�
            t(i+1,:)=0;
        end
    end
    %% ɾ��0��
    row=find(abs(t(:,1))+abs(t(:,2))+abs(t(:,3))>0);
    t=t(row,:);
    %% ���������ؽ�����
    % savedata(t,2,sj);
    %***********************************************************%
    %% 3D��ģ&�������
    % jianmo(a,t);
    v = vpolyhedron2(a,t)/1000000;
    v = floor(v);
    
    %% ----------------�����׼�������������
    load('dataOneTape.mat');
    dataOneTape=unique(dataOneTape,'rows');
    nTapes = floor(v/standardVolume);
    disp(['The simulated target number is: ' num2str(nTapes)]);
    
    %% ----------------�õ�����Щ�����񴦷��ñ�׼�־�
    [a2,ind1,ind2] = spaceMapping( a, 'cube3', 1, (1+0.2)*standardLen ); %
    n1 = length(ind1);
    if(n1>nTapes)
      nHist = histc(ind2,1:n1);
      [B,IX] = sort(nHist,'descend');
      a2 = a2(IX(1:nTapes),:);
    end 
    
    %% ----------------����Ŀ������
    rawData = [];
    for i=1:length(a2)
      tempdata1 = dataOneTape(:,1)+a2(i,1)+standardLen*0.2*rand;
      tempdata2 = dataOneTape(:,2)+a2(i,2)+standardLen*0.2*rand;
      tempdata3 = dataOneTape(:,3)+a2(i,3)+standardLen*0.2*rand;
      tempdata = [tempdata1,tempdata2,tempdata3];
      rawData = [rawData;tempdata];
    end
    dlmwrite('simulatedData.txt', rawData, 'delimiter', '\t','precision', 6);
    
    %% ----------------�ٴλ��ڱ�׼���ݽ����ʷּ���ʾ
    a = rawData;
    %% ���������
    % [a] = spaceDownSampling( a, 'cube', 1, 25  );
    a=spaceDownSampling(a,'cube3',1);
    %% ��ż�����
    %     dis=1:100;
    %     disse=find(dis>=(r/60000));
    %     a=CubeCompress(a,dis(disse(1)));
    %% ������ˣ���ȡ��������㣩
    % a=MySelect(a��1��toprestore(sj));                                   %1������y������ˣ�2�����ݿ�λ�����ļ����ˣ����ݿ�λ�ĸ�����������й��ˣ�
    %% �����������
    savedata(a,1,sj);
    %% �����ؽ�
    disp('/\/\/\/\/\/\/\/\/\/\/\/\/\/round 2\/\/\/\/\/\/\/\/\/\/\/\/\/');
    [t]=MyCrust(a);
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
      maxvalue = Maxline(x(3*i+1:3*i+3),y(3*i+1:3*i+3),z(3*i+1:3*i+3));       % �������������߳�
      if maxvalue>deltathrd                                                   % �����α߳���ֵ����������ֵ�������ν������˵�
        t(i+1,:)=0;
      end
    end
    %% ɾ��0��
    row=find(abs(t(:,1))+abs(t(:,2))+abs(t(:,3))>0);
    t=t(row,:);
    %% ���������ؽ�����
    savedata(t,2,sj);
    %% 3D��ʾ
    jianmo(a,t);
    
    disp(['The volume is: ',num2str(v)]);
    fname=strcat('������������',num2str(v),'��������');
    set(handles1.text1,'String',fname);
    storedata(sj).seq=toprestore(sj);                   %��λ��
    storedata(sj).vol=v;                        %��λ����������
    storedata(sj).filenam=toprestore(toprenum);         %��λ���������ļ���
    else
        storedata(sj).seq=toprestore(sj);                   %��λ��
        storedata(sj).vol=0;                                %��λ����������
        storedata(sj).filenam=toprestore(toprenum);         %��λ���������ļ���
        savedata(a,1,sj);
        t=[];
        savedata(t,2,sj);
    end
end
storedata(21).vol=0;                                    %������������������
storedata(21).filenam=21;                               %�����������������ļ���
%***********************************************************%
%% ���Ͳ������� 
data_send(storedata,1);
end