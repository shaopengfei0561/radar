//*******************************************************
//版本：V3.3
//本版本要嵌入到二期的算法服务器软件中使用
//它采用二期新设计的算法接口和结构体
//它要实现分类识别算法
//本算法尝试加入了输出频度控制
//本算法在分类上尝试实现对人、车和骑行车辆的分类
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
	函数说明：获取算法运算结果。算法的调用以此为接口。
	参数说明：pfrm 指向原始数据帧结构体的指针，用于原始数据的输入
	buf  调用者提供的用于算法输出数据的缓存地址
	length 调用者提供的输出缓存的总长度（单位：字节）
	返回值：算法输出的数据的长度（单位：字节）
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
			//产生前景点
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
		
			//点云聚类
			startindex = 1;     
			disthrd = 400;					//点距离阈值
			pointnum = 5;					//点间隔
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
			//去零点
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
			//点云滤波
			neithrd = 200;											//相邻点距离过滤阈值（单位：mm）
			for (i=1;i<k-1;i++)
			{
				d1=CmptSpaceDistance(x[i-1],y[i-1],z[i-1],x[i],y[i],z[i]);
				d2=CmptSpaceDistance(x[i+1],y[i+1],z[i+1],x[i],y[i],z[i]);
				if (MinValue(d1,d2)>neithrd)						//相邻点距离过滤阈值，超过该阈值则将该点滤除
				{   
					x[i]=0; 
					y[i]=0;
					z[i]=0;		
				}
			}			
			//去零点
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
			//产生前景点
			
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
			//去零点
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
				if (MinValue(d1,d2)>neithrd)						//相邻点距离过滤阈值，超过该阈值则将该点滤除
				{   
					x[i]=0; 
					y[i]=0;
					z[i]=0;		
				}
			}			
			//去零点
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
		
		//填充并存储数据
		if(m_Num>0)
			FillPoint();

		m_savState1=0;
		m_savState2=0;

		return result;
	}
	
	//内部变量初始化（除了算法配置信息）
	void CAlgClassify::InternalInitial()
	{
		//对算法配置结构体初始化	
		m_CfgInfo.ValidDistance=25000;	//有效距离（极坐标）
		m_CfgInfo.stepValue=4;			//渐进步长
		m_CfgInfo.railspeed=213.334;	//小车移动速度（mm/s）
		
		//其他变量初始化
		m_nOutFreq=0;
	
		m_DataFrameQueue.curFrameNum=0;
		
		m_bHaveStdDataLength=false;
		m_nRegisterObjNum=0;
		m_FogrdPntSet.wholeNum=0;			//点云数据点数	
		m_Num=0;
	}
	
	int CAlgClassify::FillPoint()
	{
		int i=0;
		int result =0;
		char s[255];
		//存文件
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
	//*******************以下定义一些全局函数*********************************
	
	//声明计算两时间差函数（单位：分钟）
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

	//声明计算两时间差函数（单位：ms）
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
	
	//计算两点间距离的全局函数
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

	//计算两点间空间距离的全局函数
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
	//取两个数的较小值
	int MinValue(int a,int b) 
	{
		int min;
		min=a;
		if (min>b)min=b;
		return min;
	}
}