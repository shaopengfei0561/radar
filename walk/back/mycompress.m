function count = MyCompress(A,dis)
kk=0;%���ý������ĳ�ʼֵ
a=A;%��ȡ��ǰ����a��ֵ��
count=[];%�洢����count��ֵΪ������ÿ��ѹ���󲻱���ѹ��ǰ����ֵ
m=max(a);%���a��ÿ�е����ֵ��m��1*3����������
n=min(a);%���a��ÿ�е���xiaoֵ��n��1*3����������
xj=m(1)-n(1);%���x�ķ�Χ
yj=m(2)-n(2);%���y�ķ�Χ
%zj=m(3)-n(3);%���z�ķ�Χ�Ա���ά��������
xx=0:dis:xj;%���ɷָ�����
yy=0:dis:yj;%���ɷָ�����
%zz=0:dis:zj;%���ɷָ�����
steps=length(xx)*length(yy);%�������ܳ��ȣ��������ÿ��ѭ���ĵ���
step=steps/100;%������Ĭ�ϰٷֱȻ�����100��׼��Ϊ100�� ����������Ȱٷֱ�
hwait=waitbar(0,'qingshaodeng<<<<<');%��������ʼ��ʾ
for ji=1:length(xx)%0:dis:floor(xj)%�������������
   for ii=1:length(yy)%0:dis:floor(yj)
    %for iii=1:length(zz)%0:dis:floor(zj)
        %�ҳ����ֺ����ά�����еĵ㣬��ű�����p��,p�ǵ�ĵ�ã�Ҳ����ԭʼ��������ţ��ڼ�������ɵ�һ��������
        p=find(n(1)+xx(ji)<=a(:,1)&a(:,1)<=n(1)+xx(ji)+dis&n(2)+yy(ii)<=a(:,2)&a(:,2)<=n(2)+yy(ii)+dis);  
        kk=kk+1;%�����������ã�ÿ��ѭ������ ÿ��ѭ�����½�����
        if steps-kk<=200;%������С��200ʱ  ��ʾ�������
          waitbar(kk/steps,hwait,'������ɣ����ԽСѭ��Խ��Խ��ʱ��');
          pause(0.05);%ÿ��ͣ��0.05����½�����
        else
        perstr=fix(kk/step);%���Ȱٷֱ�����
        str=['����ѹ���������Ҫ�����ӣ������',num2str(perstr),'%'];
        waitbar(kk/steps,hwait,str);%��ʾ���ȱ仯
        pause(0.05);
        end
        if isempty(p)==1%�ж�p�ǲ��ǿվ��󣬼�ѡ�񷽸�����û�е� ���û����һ������Ѱ�� ��ʡʱ��
          continue;%����ѭ�� �´ε���
        else
          avrx=mean(a(p,1));%�����ѡ�����е������ݵ�ƽ��ֵ
          avry=mean(a(p,2));%�����ѡ�����е������ݵ�ƽ��ֵ
          avrz=mean(a(p,3));%�����ѡ�����е������ݵ�ƽ��ֵ
          avr=[avrx avry avrz];%��ÿһ����õĽ����ϳ�����avr
          count=[count;avr];%��ÿ��ѭ���õ���ƽ��ֵ�����ھ���count�У�
        end
   end
end
close(hwait);
msgbox('ѹ���������');
end