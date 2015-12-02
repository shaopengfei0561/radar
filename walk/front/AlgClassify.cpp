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
	int CAlgClassify::GetResult( SecDataFrame * pfrm, char * buf, int length)
	{
		int len=0;
		int result;

		//将原始数据帧输入到数据缓存队列中
		InputData(pfrm);
		
		//获取标准数据长度
		if( (!m_bHaveStdDataLength)&&(m_DataFrameQueue.curFrameNum<5) )
		{
			return len;
		}
		else if( (!m_bHaveStdDataLength)&&(m_DataFrameQueue.curFrameNum==5) )
		{
			//取这若干帧中的dataLength最大值作为标准长度
			m_nStdDataLength = 0;
			for(int i=0;i<5;i++)
			{
				if(m_DataFrameQueue.frame[i].dataLength>m_nStdDataLength)
				{
					m_nStdDataLength = m_DataFrameQueue.frame[i].dataLength;
				}
			}
			m_bHaveStdDataLength = true;
			
			//确定起始角度和角度步进（单位：弧度）
			m_fStartAngle=m_pCurDataFrame->startAngle;
			m_fStopAngle=m_pCurDataFrame->stopAngle;
			m_fAngleStep=(m_fStopAngle-m_fStartAngle)/(m_nStdDataLength-1);
			
			//清除
			ClearQueue();
			
		}
		
		//预处理当前帧，预处理失败则等待下次
		if(!PreProcess())
			return len;
			
		result=GetWarningResult();
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
		m_nCurID=0;
		m_nOutFreq=0;
	
		m_DataFrameQueue.curFrameNum=0;
		
		m_bHaveStdDataLength=false;
		m_nRegisterObjNum=0;
		m_FogrdPntSet.wholeNum=0;			//点云数据点数	
		m_Num=0;
	}
	
	
	//将原始数据添加进数据帧队列中
	void CAlgClassify::InputData(SecDataFrame * pfrm)
	{
		int length;
		
		//如果队列已满
		if(m_DataFrameQueue.curFrameNum>=MAX_FRAME_NUM_CLA)
		{
			//清出队列前若干帧
			OutQueue(10);
		}
		
		length=m_DataFrameQueue.curFrameNum;
		memcpy( &(m_DataFrameQueue.frame[length]),pfrm,sizeof(DataFrame) );
		m_DataFrameQueue.curFrameNum++;
		
		m_pCurDataFrame=&(m_DataFrameQueue.frame[length]);
		
	}
	
	//清出数据帧队列中的前若干帧
	void CAlgClassify::OutQueue(int num)
	{
		int i;
		int curFrmNum=m_DataFrameQueue.curFrameNum;
		
		for(i=num;i<curFrmNum;i++)
		{
			memcpy( &(m_DataFrameQueue.frame[i-num]),&(m_DataFrameQueue.frame[i]),sizeof(DataFrame) );	
		}
		
		m_DataFrameQueue.curFrameNum-=num;
	}
	
	//清空数据帧队列
	void CAlgClassify::ClearQueue()
	{
		m_DataFrameQueue.curFrameNum=0;
	}
	
	//预处理数据帧队列中的当前帧，返回true代表处理成功
	bool CAlgClassify::PreProcess()
	{
		bool result=false;
		int len,temp,i,maxdist;
		double angle=0;
		int x=0,y=0;
		
		//如原始帧队列为空，则返回
		if(m_DataFrameQueue.curFrameNum==0)
			return result;
		
		//检查当前帧长度，如相差太远，则丢弃当前帧
		if(m_pCurDataFrame->dataLength != m_nStdDataLength)
		{
			len = m_pCurDataFrame->dataLength;
			//相差太远，丢弃
			temp=len-m_nStdDataLength;
			temp = temp>=0?temp:-temp;
			if( ((float)temp/m_nStdDataLength)>0.1 )
			{
				m_DataFrameQueue.curFrameNum--;
				m_pCurDataFrame=&(m_DataFrameQueue.frame[m_DataFrameQueue.curFrameNum-1]);
				return result;
			}
			//相差可容忍，进行数据变换
			else
			{
				//归一化为标准长度
				m_pCurDataFrame->dataLength=m_nStdDataLength;
			}
		}
		
		//根据有效距离的限制，调整数据帧中的测距值
		maxdist=m_CfgInfo.ValidDistance;
		for(i=0;i<m_nStdDataLength;i++)
		{
			if(m_pCurDataFrame->data[i]>maxdist)
			{
				m_pCurDataFrame->data[i]=ERRDIS;
			}
		}
		result = true;
		return result;
	}
	
	//获取报警结果
	int CAlgClassify::GetWarningResult()
	{
		int result=0;
		int i=0;
		
		//获取前景点
		if(m_savFlag==1)GetPointSet();
		//如未获得前景点，则可直接返回

		//填充并存储数据
		if (m_savState==1&&m_savFlag==0)
		{
			FillPoint();
			m_savState=0;
		}
		return result;
	}
	int CAlgClassify::FillPoint()
	{
		int i=0;
		int result =0;
		char s[255];
		//存文件
		FILE *p;	
		sprintf(s, "D:\\test\\%d.txt", m_storeNum);
		if((p=fopen(s,"wt"))!=NULL)
		{
			for(i=0;i<m_Num;i++) 
			fprintf(p,"%ld %ld %ld \n",m_Vpoint[i].x,m_Vpoint[i].y,m_Vpoint[i].z);
			fclose(p);
		}
		m_Num=0;
		return result;
	}
	bool CAlgClassify::JudgeCrossBorder(int x,int z)
	{
		if (x>RX||x<LX) 
		return true;
		if (z<LZ||z>HZ) 
		return true;

		return false;
	}
	//获取前景点，采用自适应的背景偏移量方法
	void CAlgClassify::GetPointSet()
	{
		int i,j,k;
		int foredistance,neithrd;
		int x[1058] = {0};
		int y[1058] = {0};
		int z[1058] = {0};
		int startindex, disthrd, pointnum, d, stopindex, d1, d2;
		int deltime=0;
		double angle;
		double lidar1angle[14]={0.1,0.2,0,0,0.2,0.5,0.7,0,0,0,0,0,1,0.2};
		double lidar2angle[14]={0.5,0.5,0.2,0,0.2,0.4,0,0,-0.9,-0.9,0.4,0.4,0.5,0};
		int coorshift[14]={18111,18111,18111,18111,18111,18111,18111,18111,18111,18111,18111,18111,18111,18111};
		
		//清空前景点空间
		m_FogrdPntSet.pointNum=0;

		m_nCurID++;
		/***********计算时间差***************/
		deltime=CmptTimeDifms(initime,m_pCurDataFrame->time);
		/************************************/
		for(i=0;i<m_nStdDataLength;i++)
		{	
			foredistance=m_pCurDataFrame->data[i];			
			//产生前景点

			if (i<m_nStdDataLength*0.5)   				
			{			
					angle = 0.006283185307180*i-0.087964594300514+0.01745329222*lidar1angle[m_storeNum-1];
					x[i]  = ((float)foredistance)*cos(angle);
					y[i]  = m_nCurID*m_CfgInfo.stepValue;
					z[i]  = 6800-((float)foredistance)*sin(angle);	
			}
			else 
			{		
					angle = 0.006283185307180*(i-m_nStdDataLength/2)-0.087964594300514+0.01745329222*lidar2angle[m_storeNum-1];
					x[i]  = ((float)foredistance)*cos(angle)+coorshift[m_storeNum-1];
					y[i]  = m_nCurID*m_CfgInfo.stepValue+100;
					z[i]  = 6800-((float)foredistance)*sin(angle);		
			}
			
			if (JudgeCrossBorder(x[i],z[i]))
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
		for (i=1;i<m_nStdDataLength/2;i++)
		{	
			d=CmptSpaceDistance(x[i-1],y[i-1],z[i-1],x[i],y[i],z[i]);
			if (d>disthrd)
			{
				stopindex=i-1;

				if (stopindex<startindex)
					startindex=stopindex;
        
				if (stopindex-startindex<pointnum)
				{
				  for(j=startindex;j<=stopindex;j++) 
				  {
					  x[j]=0; 
					  y[j]=0;
					  z[j]=0;
				  }
				}
				startindex=i;
			}
		}
		startindex=m_nStdDataLength/2+1;
		for (i=m_nStdDataLength/2+1;i<m_nStdDataLength;i++)
		{	
			d=CmptSpaceDistance(x[i-1],y[i-1],z[i-1],x[i],y[i],z[i]);
			if (d>disthrd)
			{
				stopindex=i-1;

				if (stopindex<startindex)
					startindex=stopindex;

				if (stopindex-startindex<pointnum)
				{
				  for(j=startindex;j<=stopindex;j++) 
				  {
					  x[j]=0; 
					  y[j]=0;
					  z[j]=0;
				  }
				}
				startindex=i;
			}
		}
		//去零点
		k=0;
		for(i=0;i<m_nStdDataLength;i++)
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
		for(i=0;i<k;i++)
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
		distance=sqrt(temp1+temp2);	
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

		distance=sqrt(temp1+temp2+temp3);	
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