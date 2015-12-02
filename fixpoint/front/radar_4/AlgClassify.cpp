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
	int CAlgClassify::GetResult( int m_lidar1Data[2000][529],int m_lidar2Data[2000][529],int m_lidar3Data[2000][529],int m_lidar4Data[2000][529])
	{
		int len=0;
		int result=0;
		int i,j,k,t;
		int foredistance;
		double angle,m_angle;
		double temp;
		int startindex, disthrd, pointnum, d, stopindex, d1, d2,neithrd;
		int x[529],y[529],z[529];
		
		int Xshift = GetPrivateProfileInt("CoordinateTransform","Xshift1",0,".\\LidarConfig.ini");
		int Yshift = GetPrivateProfileInt("CoordinateTransform","Yshift1",0,".\\LidarConfig.ini");
		int Zshift = GetPrivateProfileInt("CoordinateTransform","Zshift1",0,".\\LidarConfig.ini");

		char mstring[50];

		GetPrivateProfileString("YT","LidarRotation1","",mstring,sizeof(mstring),".\\LidarConfig.ini");
		float LidarRotation = atof(mstring);

		GetPrivateProfileString("YT","YTRotation1","",mstring,sizeof(mstring),".\\LidarConfig.ini");
		float YTRotation = atof(mstring);

		for (j=0;j<m_lidar1CurID;j++)
		{
			//产生前景点
			if(scanPosInfo[0]>=300&&scanPosInfo[0]<=360)
			{
				temp=scanPosInfo[0]-360;
			}
			else
				temp=scanPosInfo[0];

			m_angle=(scanPosInfo[2]-temp)/180*3.1415926/m_lidar1CurID*j+temp/180*3.1415926+YTRotation;

			for(i=0;i<529;i++)
			{	
				foredistance=m_lidar1Data[j][i];			
				angle = 0.006283185307180*i-0.087964594300514+LidarRotation/180*3.1415926;
				x[i]  = ((float)foredistance)*cos(angle)*cos(m_angle)+Xshift;
				y[i]  = -((float)foredistance)*cos(angle)*sin(m_angle)+Yshift;
				z[i]  = -((float)foredistance)*sin(angle)+Zshift;
				
				if (JudgeCrossBorder(x[i],y[i],z[i]))
				{
					x[i]=0;
					y[i]=0;
					z[i]=0;
				}	
			}
		
			//点云聚类
			startindex = 1; 
			disthrd = GetPrivateProfileInt("DataProcess","PointClusterDis",0,".\\LidarConfig.ini");					//点距离阈值
			pointnum = GetPrivateProfileInt("DataProcess","PointNum",0,".\\LidarConfig.ini");					//点间隔
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
			neithrd = GetPrivateProfileInt("DataProcess","PointFilterThreshold",0,".\\LidarConfig.ini");											//相邻点距离过滤阈值（单位：mm）
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
		
		Xshift = GetPrivateProfileInt("CoordinateTransform","Xshift2",0,".\\LidarConfig.ini");
		Yshift = GetPrivateProfileInt("CoordinateTransform","Yshift2",0,".\\LidarConfig.ini");
		Zshift = GetPrivateProfileInt("CoordinateTransform","Zshift2",0,".\\LidarConfig.ini");

		GetPrivateProfileString("YT","LidarRotation2","",mstring,sizeof(mstring),".\\LidarConfig.ini");
		LidarRotation = atof(mstring);
		GetPrivateProfileString("YT","YTRotation2","",mstring,sizeof(mstring),".\\LidarConfig.ini");
		YTRotation = atof(mstring);

		for (j=0;j<m_lidar2CurID;j++)
		{
			//产生前景点
			
			if(scanPosInfo[1]>=300&&scanPosInfo[1]<=360)
			{
				temp=scanPosInfo[1]-360;
			}
			else
				temp=scanPosInfo[1];

			m_angle=(scanPosInfo[3]-temp)/180*3.1415926/m_lidar2CurID*j+temp/180*3.1415926+YTRotation/180*3.1415926;		
			
			for(i=0;i<529;i++)
			{	
				foredistance=m_lidar2Data[j][i];			
				angle = 0.006283185307180*i-0.087964594300514+LidarRotation/180*3.1415926;
				x[i]  = -((float)foredistance)*cos(angle)*cos(m_angle)+Xshift;
				y[i]  = ((float)foredistance)*cos(angle)*sin(m_angle)+Yshift;
				z[i]  = -((float)foredistance)*sin(angle)+Zshift;
				
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
		
		Xshift = GetPrivateProfileInt("CoordinateTransform","Xshift3",0,".\\LidarConfig.ini");
		Yshift = GetPrivateProfileInt("CoordinateTransform","Yshift3",0,".\\LidarConfig.ini");
		Zshift = GetPrivateProfileInt("CoordinateTransform","Zshift3",0,".\\LidarConfig.ini");
		
		GetPrivateProfileString("YT","LidarRotation3","",mstring,sizeof(mstring),".\\LidarConfig.ini");
		LidarRotation = atof(mstring);
		GetPrivateProfileString("YT","YTRotation3","",mstring,sizeof(mstring),".\\LidarConfig.ini");
		YTRotation = atof(mstring);

		for (j=0;j<m_lidar3CurID;j++)
		{
			//产生前景点
			
			if(scanPosInfo[4]>=300&&scanPosInfo[4]<=360)
			{
				temp=scanPosInfo[4]-360;
			}
			else
				temp=scanPosInfo[4];
			
			m_angle=(scanPosInfo[6]-temp)/180*3.1415926/m_lidar3CurID*j+temp/180*3.1415926+YTRotation/180*3.1415926;		
			
			for(i=0;i<529;i++)
			{	
				foredistance=m_lidar3Data[j][i];			
				angle = 0.006283185307180*i-0.087964594300514+LidarRotation/180*3.1415926;
				x[i]  = -((float)foredistance)*cos(angle)*cos(m_angle)+Xshift;
				y[i]  = ((float)foredistance)*cos(angle)*sin(m_angle)+Yshift;
				z[i]  = -((float)foredistance)*sin(angle)+Zshift;
				
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


		Xshift = GetPrivateProfileInt("CoordinateTransform","Xshift4",0,".\\LidarConfig.ini");
		Yshift = GetPrivateProfileInt("CoordinateTransform","Yshift4",0,".\\LidarConfig.ini");
		Zshift = GetPrivateProfileInt("CoordinateTransform","Zshift4",0,".\\LidarConfig.ini");
		
		GetPrivateProfileString("YT","LidarRotation4","",mstring,sizeof(mstring),".\\LidarConfig.ini");
		LidarRotation = atof(mstring);
		GetPrivateProfileString("YT","YTRotation4","",mstring,sizeof(mstring),".\\LidarConfig.ini");
		YTRotation = atof(mstring);

		for (j=0;j<m_lidar4CurID;j++)
		{
			//产生前景点
			
			if(scanPosInfo[5]>=300&&scanPosInfo[5]<=360)
			{
				temp=scanPosInfo[5]-360;
			}
			else
				temp=scanPosInfo[5];
			
			m_angle=(scanPosInfo[7]-temp)/180*3.1415926/m_lidar4CurID*j+temp/180*3.1415926+YTRotation/180*3.1415926;		
			
			for(i=0;i<529;i++)
			{	
				foredistance=m_lidar4Data[j][i];			
				angle = 0.006283185307180*i-0.087964594300514+LidarRotation/180*3.1415926;
				x[i]  = -((float)foredistance)*cos(angle)*cos(m_angle)+Xshift;
				y[i]  = ((float)foredistance)*cos(angle)*sin(m_angle)+Yshift;
				z[i]  = -((float)foredistance)*sin(angle)+Zshift;
				
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
		m_CfgInfo.ValidDistance=GetPrivateProfileInt("ScanRange","ValidDistance",0,".\\LidarConfig.ini");	//有效距离（极坐标）
		m_CfgInfo.stepValue=GetPrivateProfileInt("LeadRail","StepValue",0,".\\LidarConfig.ini");			//渐进步长

		char mstring[50]; 
		GetPrivateProfileString("LeadRail","Railspeed","",mstring,sizeof(mstring),".\\LidarConfig.ini");
		m_CfgInfo.railspeed = atof(mstring);																//小车移动速度（mm/s）
		
		//其他变量初始化
		m_nOutFreq=0;
	
		m_DataFrameQueue.curFrameNum=0;
		
		m_bHaveStdDataLength=false;
		m_nRegisterObjNum=0;
		m_FogrdPntSet.wholeNum=0;			//点云数据点数	
		m_Num=0;
		char c[255];
		char StoreAreaQuantity = GetPrivateProfileInt("RegionCoordinate","StoreAreaQuantity",0,".\\LidarConfig.ini");
		for (int i=0;i<StoreAreaQuantity;i++)
		{
			sprintf(c, "MinX%d", i+1);
			m_range.MinX[i] = GetPrivateProfileInt("RegionCoordinate",c,0,".\\LidarConfig.ini");
			sprintf(c, "MaxX%d", i+1);
			m_range.MaxX[i] = GetPrivateProfileInt("RegionCoordinate",c,0,".\\LidarConfig.ini");
			sprintf(c, "MinY%d", i+1);
			m_range.MinY[i] = GetPrivateProfileInt("RegionCoordinate",c,0,".\\LidarConfig.ini");
			sprintf(c, "MaxY%d", i+1);
			m_range.MaxY[i] = GetPrivateProfileInt("RegionCoordinate",c,0,".\\LidarConfig.ini");
			sprintf(c, "MinZ%d", i+1);
			m_range.MinZ[i] = GetPrivateProfileInt("RegionCoordinate",c,0,".\\LidarConfig.ini");
			sprintf(c, "MaxZ%d", i+1);
			m_range.MaxZ[i] = GetPrivateProfileInt("RegionCoordinate",c,0,".\\LidarConfig.ini");
		}		
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
		if (x>m_range.MaxX[m_storeNum-1]||x<m_range.MinX[m_storeNum-1]) 
			return true;
		if (z<m_range.MinZ[m_storeNum-1]||z>m_range.MaxZ[m_storeNum-1]) 
			return true;
		if (y<m_range.MinY[m_storeNum-1]||y>m_range.MaxY[m_storeNum-1]) 
			return true;

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