function dianyunalg()
global toprestore;
global toprenum;
global hObject1 handles1;
global runstat;
global showEnable;
global paravalue;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%�㷨��������%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
deltathrd = str2num(paravalue.alg.trianthreshold);                          % �����α߳���ֵ����������ֵ�������ν������˵�
%% ��������
for i=1:toprenum
    storedata(i).seq=0;              %��λ��
    storedata(i).vol=0;              %��λ����������
    storedata(i).filenam1=0;         %��λ���������ļ���
    storedata(i).filenam2=0;         %��λ���������ļ���
end
for sj=1:toprenum
    fname=strcat('yt',num2str(toprestore(sj)),'.txt');
    a=load(fname);
%% ����Ӧȥ����
    backgroudThreshold = str2num(paravalue.alg.backgroudthreshold);
    a = delBackground(a, backgroudThreshold);
    [r,l]=size(a);
    if r~=0
%% ���������
    spaceDownLength = str2num(paravalue.alg.spacedownlength);
    if spaceDownLength~=0
        a=spaceDownSampling(a,'cube3',1,spaceDownLength);
    else
        a=spaceDownSampling(a,'cube3',1);
    end
    %% ������ˣ���ȡ��������㣩
%   a=MySelect(a��1��toprestore(sj));                                   %1������y������ˣ�2�����ݿ�λ�����ļ����ˣ����ݿ�λ�ĸ�����������й��ˣ�
    %% �����������
    savedata(a,1,sj);
    %% 3D��ģ&�������
    jianmo(a,showEnable,sj);
%   v = calVolumeByPnts(a, 150, 0.57);
%   v = calVolumeByPnts(a, 150, 0.6709);
    volumeLength = str2num(paravalue.alg.volumelength);
    volumeRatio = str2num(paravalue.alg.volumeratio);
    v = calVolumeByPnts(a, volumeLength, volumeRatio)/1000000;
    fname=strcat('������������',num2str(v/1e3),'������');
    set(handles1.text1,'String',fname);
    storedata(sj).seq=toprestore(sj);                       %��λ��
    storedata(sj).vol=v;                                    %��λ����������
    storedata(sj).filenam1=toprestore(sj)*2-1+100;          %��λ���������ļ���1
    storedata(sj).filenam2=toprestore(sj)*2+100;            %��λ���������ļ���2
    else
        storedata(sj).seq=toprestore(sj);                   %��λ��
        storedata(sj).vol=0;                                %��λ����������
        storedata(sj).filenam1=toprestore(sj)*2-1+100;          %��λ���������ļ���1
        storedata(sj).filenam2=toprestore(sj)*2+100;            %��λ���������ļ���2
        fname=strcat('������������',num2str(0),'������');
        set(handles1.text1,'String',fname);
        savedata(a,1,sj);
        t=[];
        savedata(t,2,sj);  
    end
end
%***********************************************************%
%% ���Ͳ������� 
send_meadata(storedata,1);
disp('֪ͨ��ƽ̨���ݴ������......');
% fname='֪ͨ��ƽ̨���ݴ������';
% set(handles1.statetext,'String',fname);
runstat=0;
end