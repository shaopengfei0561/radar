function dianyunalg2() % created by YZJ
global toprestore;
global toprenum;
global hObject1 handles1;
global runstat;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%�㷨��������%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
deltathrd = 250;                   % �����α߳���ֵ����������ֵ�������ν������˵�
%% ��������
for i=1:20
    storedata(i).seq=0;             %��λ��
    storedata(i).vol=0;             %��λ����������
    storedata(i).filenam=0;         %��λ���������ļ���
end
for sj=1:toprenum
    % fname=strcat('oridata_',num2str(toprestore(sj)),'.txt');
    fname=strcat(num2str(toprestore(sj)),'.txt');
    a=load(fname);
    [r,l]=size(a);
    if r~=0
    v = calVolumeByPnts(a, 30, 0.85);
    v=floor(v/1000000);
    
    %% ----------------�����׼�������������
    load('dataOneTape.mat');
    dataOneTape=unique(dataOneTape,'rows');
    nTapes = floor(v/standardVolume);
    disp(['The simulated target number is: ' num2str(nTapes)]);
    
    %% ----------------�õ�����Щ�����񴦷��ñ�׼�־�
    cubeLen = (1+0.2)*standardLen;
    len = 30; % �������������߳�
    aTemp = spaceDownSampling( a, 'cube3', 1, len);
    % [a1Out, ind1, ind2] = spaceMapping2( aTemp, 'cube3', 1, cubeLen);
    [a1Out, ind1, ind2] = spaceMapping2( aTemp, 'cube3', 1, cubeLen, cubeLen, 5000/2, 0 );  % �޶�Ϊ���ŵ�Ч���������д�Ŀǰ�Ķѷŷ�ʽ20150617
    nTapesVec = [];
    for ii=1:size(a1Out,1)
      tempInd = find(ind2==ii);
      tempHigh = max(aTemp(tempInd,3));
      nTapesVec = [nTapesVec; floor(tempHigh/cubeLen)+1];
    end
    nTapesCur = sum(nTapesVec);
    if(nTapesCur>nTapes)
      n1 = length(ind1);
      % ӳ����Ŀ���ܱ���Ҫ����Ŀ�࣬ĩλ��̭
      nHist = histc(ind2,1:n1);
      [B,IX] = sort(nHist,'descend');
      a1Out = a1Out(IX,:);
      nTapesVec = nTapesVec(IX,:);
      for j=1:n1
        nTapesCur = sum(nTapesVec(1:n1-j));
        if(nTapesCur<=nTapes)
          break;
        end
      end
      a1Out = a1Out(1:n1-j,:);
      nTapesVec = nTapesVec(1:n1-j);
    end
    a2 = [];
    for i=1:size(a1Out,1)
      for j=1:nTapesVec(i)
        tempdata = [a1Out(i,1:2) cubeLen*(j-1)];
        a2 = [a2; tempdata];
      end
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
    %dis=1:100;
    %disse=find(dis>=(r/60000));
    %a=CubeCompress(a,dis(disse(1)));
    %% ������ˣ���ȡ��������㣩
    %a=MySelect(a��1��toprestore(sj));                                   %1������y������ˣ�2�����ݿ�λ�����ļ����ˣ����ݿ�λ�ĸ�����������й��ˣ�
    %% �����������
    savedata(a,1,sj);
    %% �����ؽ�
    disp('/\/\/\/\/\/\/\/\/\/\/\/\/\/round 2\/\/\/\/\/\/\/\/\/\/\/\/\/');
    [t]=MyCrust(a,500,0.05);
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
    jianmo(a,t,sj);
    disp(['The volume is: ',num2str(v)]);
    fname=strcat('������������',num2str(v),'��������');
    set(handles1.text1,'String',fname);
    storedata(sj).seq=toprestore(sj);                   %��λ��
    storedata(sj).vol=v;                                %��λ����������
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
send_meadata(storedata,1);
runstat=1;
end