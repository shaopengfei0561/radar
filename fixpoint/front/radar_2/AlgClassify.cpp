//*******************************************************
//�汾��V3.3
//���汾ҪǶ�뵽���ڵ��㷨�����������ʹ��
//�����ö�������Ƶ��㷨�ӿںͽṹ��
//��Ҫʵ�ַ���ʶ���㷨
//���㷨���Լ��������Ƶ�ȿ���
//���㷨�ڷ����ϳ���ʵ�ֶ��ˡ��������г����ķ���
//*******************************************************

// AlgClassify.cpp: implementation of the CAlgClassify class.
//
//////////////////////////////////////////////////////////////////////
#include "stdafx.h"
#include "stdio.h"
#include <math.h>
#include "AlgClassify.h"

//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////
namespace alg_classify
{
	
	CAlgClassify::CAlgClassify()
	{
		
	}
	
	CAlgClassify::~CAlgClassify()
	{
		
	}
	
	/*
	����˵������ȡ�㷨���������㷨�ĵ����Դ�Ϊ�ӿڡ�
	����˵����pfrm ָ��ԭʼ����֡�ṹ���ָ�룬����ԭʼ���ݵ�����
	buf  �������ṩ�������㷨������ݵĻ����ַ
	length �������ṩ�����������ܳ��ȣ���λ���ֽڣ�
	����ֵ���㷨��������ݵĳ��ȣ���λ���ֽڣ�
	*/
	int CAlgClassify::GetResult( int m_lidar1Data[2000][529],int m_lidar2Data[2000][529])
	{
		int len=0;
		int result;
		int i,j,k,t;
		int foredistance;
		double angle,m_angle;
		double temp;
		int startindex, disthrd, pointnum, d, stopindex, d1, d2,neithrd;
		int x[529],y[529],z[529];
				
		for (j=0;j<m_lidar1CurID;j++)
		{
			//����ǰ����
			if(scanPosInfo[0]>=300&&scanPosInfo[0]<=360)
			{
				temp=scanPosInfo[0]-360;
			}
			else
				temp=scanPosInfo[0];

			m_angle=(scanPosInfo[2]-temp)/180*3.1415926/m_lidar1CurID*j+temp/180*3.1415926;

			for(i=0;i<529;i++)
			{	
				foredistance=m_lidar1Data[j][i];			
				angle = 0.006283185307180*i-0.087964594300514+0.017453292222222222222222222222222/2;
				x[i]  = ((float)foredistance)*cos(angle)*cos(m_angle);
				y[i]  = -((float)foredistance)*cos(angle)*sin(m_angle);
				z[i]  = -((float)foredistance)*sin(angle)+9000;
				
				if (JudgeCrossBorder(x[i],y[i],z[i]))
				{
					x[i]=0;
					y[i]=0;
					z[i]=0;
				}	
			}
		
			//���ƾ���
			startindex = 1;     
			disthrd = 400;					//�������ֵ
			pointnum = 5;					//����
			for (i=1;i<529;i++)
			{	
				d=CmptSpaceDistance(x[i-1],y[i-1],z[i-1],x[i],y[i],z[i]);
				if (d>disthrd)
				{
					stopindex=i-1;
					
					if (stopindex<startindex)
						startindex=stopindex;
					
					if (stopindex-startindex<pointnum)
					{
						for(t=startindex;t<=stopindex;t++) 
						{
							x[t]=0; 
							y[t]=0;
							z[t]=0;
						}
					}
					startindex=i;
				}
			}
			//ȥ���
			k=0;
			for(i=0;i<529;i++)
			{
				if (abs(x[i])+abs(y[i])+abs(z[i])!=0)
				{
					x[k]=x[i];
					y[k]=y[i];
					z[k]=z[i];
					k++;
				}
			}			
			//�����˲�
			neithrd = 200;											//���ڵ���������ֵ����λ��mm��
			for (i=1;i<k-1;i++)
			{
				d1=CmptSpaceDistance(x[i-1],y[i-1],z[i-1],x[i],y[i],z[i]);
				d2=CmptSpaceDistance(x[i+1],y[i+1],z[i+1],x[i],y[i],z[i]);
				if (MinValue(d1,d2)>neithrd)						//���ڵ���������ֵ����������ֵ�򽫸õ��˳�
				{   
					x[i]=0; 
					y[i]=0;
					z[i]=0;		
				}
			}			
			//ȥ���
			for(i=0;i<529;i++)
			{
				if (abs(x[i])+abs(y[i])+abs(z[i])!=0)
				{
					m_Vpoint[m_Num].x=x[i];
					m_Vpoint[m_Num].y=y[i];
					m_Vpoint[m_Num].z=z[i];			
					m_Num++;
				}
			}	
		}
		
		
		for (j=0;j<m_lidar2CurID;j++)
		{
			//����ǰ����
			
			if(scanPosInfo[1]>=300&&scanPosInfo[1]<=360)
			{
				temp=scanPosInfo[1]-360;
			}
			else
				temp=scanPosInfo[1];

			m_angle=(scanPosInfo[3]-temp)/180*3.1415926/m_lidar2CurID*j+temp/180*3.1415926-1.9/180*3.1415926;		

			for(i=0;i<529;i++)
			{	
				foredistance=m_lidar2Data[j][i];			
				angle = 0.006283185307180*i-0.087964594300514+0.017453292222222222222222222222222/3;
				x[i]  = -((float)foredistance)*cos(angle)*cos(m_angle)+300-124;
				y[i]  = ((float)foredistance)*cos(angle)*sin(m_angle)+17070+140-153;
				z[i]  = -((float)foredistance)*sin(angle)+9100+100;
				
				if (JudgeCrossBorder(x[i],y[i],z[i]))
				{
					x[i]=0;
					y[i]=0;
					z[i]=0;
				}		
			}
			
			for (i=1;i<529;i++)
			{	
				d=CmptSpaceDistance(x[i-1],y[i-1],z[i-1],x[i],y[i],z[i]);
				if (d>disthrd)
				{
					stopindex=i-1;
					
					if (stopindex<startindex)
						startindex=stopindex;
					
					if (stopindex-startindex<pointnum)
					{
						for(t=startindex;t<=stopindex;t++) 
						{
							x[t]=0; 
							y[t]=0;
							z[t]=0;
						}
					}
					startindex=i;
				}
			}
			//ȥ���
			k=0;
			for(i=0;i<529;i++)
			{
				if (abs(x[i])+abs(y[i])+abs(z[i])!=0)
				{
					x[k]=x[i];
					y[k]=y[i];
					z[k]=z[i];
					k++;
				}
			}			
			for (i=1;i<k-1;i++)
			{
				d1=CmptSpaceDistance(x[i-1],y[i-1],z[i-1],x[i],y[i],z[i]);
				d2=CmptSpaceDistance(x[i+1],y[i+1],z[i+1],x[i],y[i],z[i]);
				if (MinValue(d1,d2)>neithrd)						//���ڵ���������ֵ����������ֵ�򽫸õ��˳�
				{   
					x[i]=0; 
					y[i]=0;
					z[i]=0;		
				}
			}			
			//ȥ���
			for(i=0;i<529;i++)
			{
				if (abs(x[i])+abs(y[i])+abs(z[i])!=0)
				{
					
					m_Vpoint[m_Num].x=x[i];
					m_Vpoint[m_Num].y=y[i];
					m_Vpoint[m_Num].z=z[i];			
					m_Num++;
				}
			}
		}
		
		//��䲢�洢����
		if(m_Num>0)
			FillPoint();

		m_savState1=0;
		m_savState2=0;

		return result;
	}
	
	//�ڲ�������ʼ���������㷨������Ϣ��
	void CAlgClassify::InternalInitial()
	{
		//���㷨���ýṹ���ʼ��	
		m_CfgInfo.ValidDistance=25000;	//��Ч���루�����꣩
		m_CfgInfo.stepValue=4;			//��������
		m_CfgInfo.railspeed=213.334;	//С���ƶ��ٶȣ�mm/s��
		
		//����������ʼ��
		m_nOutFreq=0;
	
		m_DataFrameQueue.curFrameNum=0;
		
		m_bHaveStdDataLength=false;
		m_nRegisterObjNum=0;
		m_FogrdPntSet.wholeNum=0;			//�������ݵ���	
		m_Num=0;
	}
	
	int CAlgClassify::FillPoint()
	{
		int i=0;
		int result =0;
		char s[255];
		//���ļ�
		FILE *p;	
		sprintf(s, "C:\\test\\yt%d.txt", m_storeNum);
		if((p=fopen(s,"wt"))!=NULL)
		{
			for(i=0;i<m_Num;i++) 
			fprintf(p,"%ld %ld %ld \n",m_Vpoint[i].x,m_Vpoint[i].y,m_Vpoint[i].z);
			fclose(p);
		}
		m_Num=0;
		return result;
	}
	bool CAlgClassify::JudgeCrossBorder(int x,int y,int z)
	{
		if(m_storeNum==12)
		{
			if (x>RX1||x<LX1) 
				return true;
			if (z<LZ1||z>HZ1) 
				return true;
			if (y<LY1||y>RY1) 
			return true;
		}
		if(m_storeNum==13)
		{
			if (x>RX2||x<LX2) 
				return true;
			if (z<LZ2||z>HZ2) 
				return true;
			if (y<LY2||y>RY2) 
				return true;
		}

		if(m_storeNum==11)
		{
			if (x>RX3||x<LX3) 
				return true;
			if (z<LZ3||z>HZ3) 
				return true;
			if (y<LY3||y>RY3) 
			return true;
		}

		if(m_storeNum==10)
		{
			if (x>RX4||x<LX4) 
				return true;
			if (z<LZ4||z>HZ4) 
				return true;
			if (y<LY4||y>RY4) 
			return true;
		}

		if(m_storeNum==14)
		{
			if (x>RX5||x<LX5) 
				return true;
			if (z<LZ5||z>HZ5) 
				return true;
			if (y<LY5||y>RY5) 
				return true;
		}

		return false;
	}
	//*******************���¶���һЩȫ�ֺ���*********************************
	
	//����������ʱ��������λ�����ӣ�
	int CmptTimeDif(SYSTIME time1,SYSTIME time2)
	{
		if(time1.nYear!=time2.nYear)
			return 255;
		
		if(time1.nMonth!=time2.nMonth)
			return 255;
		
		if(time1.nDay!=time2.nDay)
			return 255;
		
		int result=(time2.nHour-time1.nHour)*60
			+time2.nMinute-time1.nMinute;
		
		return result;
	}

	//����������ʱ��������λ��ms��
	int CmptTimeDifms(SYSTIME time1,SYSTIME time2)
	{
		if(time1.nYear!=time2.nYear)
			return 255;
		
		if(time1.nMonth!=time2.nMonth)
			return 255;
		
		if(time1.nDay!=time2.nDay)
			return 255;
		
		int result=((time2.nHour-time1.nHour)*3600
			+(time2.nMinute-time1.nMinute)*60+time2.nSecond-time1.nSecond)*1000+time2.nMilliseconds-time1.nMilliseconds;
		
		return result;
	}
	
	//�������������ȫ�ֺ���
	float CmptDistance(SYSPOINT pt1, SYSPOINT pt2)
	{
		int temp1,temp2;
		float distance;
		
		temp1=pt1.x-pt2.x; 
		temp1=temp1*temp1;
		temp2=pt1.y-pt2.y; 
		temp2=temp2*temp2;	
		distance=sqrt((float)(temp1+temp2));	
		return distance;
	}	

	//���������ռ�����ȫ�ֺ���
	float CmptSpaceDistance(int x1, int y1, int z1, int x2, int y2, int z2)
	{
		int temp1,temp2,temp3;
		float distance;
		
		temp1=x1-x2; 
		temp1=temp1*temp1;
		temp2=y1-y2; 
		temp2=temp2*temp2;
		temp3=z1-z2; 
		temp3=temp3*temp3;

		distance=sqrt((float)(temp1+temp2+temp3));	
		return distance;
	}
	//ȡ�������Ľ�Сֵ
	int MinValue(int a,int b) 
	{
		int min;
		min=a;
		if (min>b)min=b;
		return min;
	}
}