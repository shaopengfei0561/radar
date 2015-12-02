function dianyunalg(sj)
global toprenum;
global handles1;
global runstat;
global showEnable;
global paravalue;
global storeconfig;
global deviceID;
global flag_SFMODE;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%�㷨��������%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
deltathrd = str2num(paravalue.alg.trianthreshold);                          % �����α߳���ֵ����������ֵ�������ν������˵�
%% ��������
for i=1:toprenum
    storedata(i).storeid=0;          %���
    storedata(i).seq=0;              %���
    storedata(i).vol=0;              %��λ����������
    storedata(i).filenam1=0;         %��λ���������ļ���
    storedata(i).filenam2=0;         %��λ���������ļ���
end
for sj=1:toprenum
    fname=strcat('oridata_','z',num2str(deviceID),'z',num2str(storeconfig(sj,2)),'.txt');
    m_a=load(fname);
    a=m_a(:,1:3);
%% ����Ӧȥ����
    backgroudThreshold = str2num(paravalue.alg.backgroudthreshold);
%   a = delBackground(a, backgroudThreshold);
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
    %% 3D��ģ&�������
    volumeLength = str2num(paravalue.alg.volumelength);
    volumeRatio = str2num(paravalue.alg.volumeratio);
    v = calVolumeByPnts(a, volumeLength, volumeRatio)/1000000;
    fname=strcat('������������',num2str(v/1e3),'������');
    set(handles1.statetext,'String',fname);
    storedata(sj).storeid=storeconfig(sj,1);                %���
    storedata(sj).seq=storeconfig(sj,2);                    %��λ��
    storedata(sj).vol=v;                                    %��λ����������
    m_clock=fix(clock);
    for i=2:6
        if m_clock(i)<10
           picname(2*i+1:2*i+2)= strcat('0',num2str(m_clock(i)));
        else
           picname(2*i+1:2*i+2)= num2str(m_clock(i));
        end
    end
    picname(1:4) = num2str(m_clock(1));
    if storeconfig(sj,2)*2-1<10
       picname(15:16) = strcat('0',num2str(storeconfig(sj,2)*2-1));
    else
       picname(15:16) = num2str(storeconfig(sj,2)*2-1);
    end
    storedata(sj).filenam1=picname; %��λ���������ļ���1
    if storeconfig(sj,2)*2<10
       picname(15:16) = strcat('0',num2str(storeconfig(sj,2)*2));
    else
       picname(15:16) = num2str(storeconfig(sj,2)*2);
    end
    storedata(sj).filenam2=picname;   %��λ���������ļ���2
    
%     jianmo(a,showEnable,sj,storedata);
    else
        m_clock=fix(clock);
        for i=2:6
            if m_clock(i)<10
               picname(2*i+1:2*i+2)= strcat('0',num2str(m_clock(i)));
            else
               picname(2*i+1:2*i+2)= num2str(m_clock(i));
            end
        end
        picname(1:4) = num2str(m_clock(1));
        if storeconfig(sj,2)*2-1<10
           picname(15:16) = strcat('0',num2str(storeconfig(sj,2)*2-1));
        else
           picname(15:16) = num2str(storeconfig(sj,2)*2-1);
        end
        storedata(sj).filenam1=picname;                         %��λ���������ļ���1
        if storeconfig(sj,2)*2<10
           picname(15:16) = strcat('0',num2str(storeconfig(sj,2)*2));
        else
           picname(15:16) = num2str(storeconfig(sj,2)*2);
        end
        storedata(sj).filenam2=picname;                         %��λ���������ļ���2
        storedata(sj).seq=storeconfig(sj,2);                    %��λ��
        storedata(sj).storeid=storeconfig(sj,1);                %���
        storedata(sj).vol=0;                                    %��λ����������
        fname=strcat('������������',num2str(0),'������');
        set(handles1.statetext,'String',fname);
        savedata(a,1,sj);
        t=[];
        savedata(t,2,sj);  
    end
end
%***********************************************************%
%% ���Ͳ�������
if flag_SFMODE~=1
send_meadata(storedata,1);
disp('֪ͨ��ƽ̨���ݴ������......');
fname='֪ͨ��ƽ̨���ݴ������';
set(handles1.statetext,'String',fname);
end
runstat=0;
end