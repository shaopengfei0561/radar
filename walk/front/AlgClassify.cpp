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
	int CAlgClassify::GetResult( SecDataFrame * pfrm, char * buf, int length)
	{
		int len=0;
		int result;

		//��ԭʼ����֡���뵽���ݻ��������
		InputData(pfrm);
		
		//��ȡ��׼���ݳ���
		if( (!m_bHaveStdDataLength)&&(m_DataFrameQueue.curFrameNum<5) )
		{
			return len;
		}
		else if( (!m_bHaveStdDataLength)&&(m_DataFrameQueue.curFrameNum==5) )
		{
			//ȡ������֡�е�dataLength���ֵ��Ϊ��׼����
			m_nStdDataLength = 0;
			for(int i=0;i<5;i++)
			{
				if(m_DataFrameQueue.frame[i].dataLength>m_nStdDataLength)
				{
					m_nStdDataLength = m_DataFrameQueue.frame[i].dataLength;
				}
			}
			m_bHaveStdDataLength = true;
			
			//ȷ����ʼ�ǶȺͽǶȲ�������λ�����ȣ�
			m_fStartAngle=m_pCurDataFrame->startAngle;
			m_fStopAngle=m_pCurDataFrame->stopAngle;
			m_fAngleStep=(m_fStopAngle-m_fStartAngle)/(m_nStdDataLength-1);
			
			//���
			ClearQueue();
			
		}
		
		//Ԥ����ǰ֡��Ԥ����ʧ����ȴ��´�
		if(!PreProcess())
			return len;
			
		result=GetWarningResult();
		return result;
	}
	
	//�ڲ�������ʼ���������㷨������Ϣ��
	void CAlgClassify::InternalInitial()
	{
		//���㷨���ýṹ���ʼ��	
		m_CfgInfo.ValidDistance=GetPrivateProfileInt("ScanRange","ValidDistance",0,".\\LidarConfig.ini");	//��Ч���루�����꣩
		
		char mstring[50]; 
		GetPrivateProfileString("LeadRail","StepValue","",mstring,sizeof(mstring),".\\LidarConfig.ini");	//С���ƶ��ٶ� mm/s
		m_CfgInfo.stepValue = atof(mstring);																//��������

		GetPrivateProfileString("LeadRail","Railspeed","",mstring,sizeof(mstring),".\\LidarConfig.ini");	//С���ƶ��ٶ� mm/s
		m_CfgInfo.railspeed = atof(mstring);
		
		//����������ʼ��
		m_nCurID=0;
		m_nOutFreq=0;
	
		m_DataFrameQueue.curFrameNum=0;
		
		m_bHaveStdDataLength=false;
		m_nRegisterObjNum=0;
		m_FogrdPntSet.wholeNum=0;			//�������ݵ���	
		m_Num=0;
		char c[255];

		char StoreAreaQuantity = GetPrivateProfileInt("RegionCoordinate","StoreAreaQuantity",0,".\\LidarConfig.ini");
		for (int i=0;i<StoreAreaQuantity;i++)
		{
			sprintf(c, "MinX%d", i);
			m_range.MinX[i] = GetPrivateProfileInt("RegionCoordinate",c,0,".\\LidarConfig.ini");
			sprintf(c, "MaxX%d", i);
			m_range.MaxX[i] = GetPrivateProfileInt("RegionCoordinate",c,0,".\\LidarConfig.ini");
			sprintf(c, "MinY%d", i);
			m_range.MinY[i] = GetPrivateProfileInt("RegionCoordinate",c,0,".\\LidarConfig.ini");
			sprintf(c, "MaxY%d", i);
			m_range.MaxY[i] = GetPrivateProfileInt("RegionCoordinate",c,0,".\\LidarConfig.ini");
			sprintf(c, "MinZ%d", i);
			m_range.MinZ[i] = GetPrivateProfileInt("RegionCoordinate",c,0,".\\LidarConfig.ini");
			sprintf(c, "MaxZ%d", i);
			m_range.MaxZ[i] = GetPrivateProfileInt("RegionCoordinate",c,0,".\\LidarConfig.ini");
			
			char mstring[50]; 
			sprintf(c, "Lidar1Anggle%d", i);
			GetPrivateProfileString("RegionCoordinate",c,"",mstring,sizeof(mstring),".\\LidarConfig.ini");
			lidar1angle[i]  = atof(mstring);

			sprintf(c, "Lidar2Anggle%d", i);
			GetPrivateProfileString("RegionCoordinate",c,"",mstring,sizeof(mstring),".\\LidarConfig.ini");
			lidar2angle[i]  = atof(mstring);
			
			sprintf(c, "Lidar1Xshift%d", i);
			lidar1xcoorshift[i]   = GetPrivateProfileInt("CoordinateTransform",c,0,".\\LidarConfig.ini");
			sprintf(c, "Lidar1Yshift%d", i);
			lidar1ycoorshift[i]   = GetPrivateProfileInt("CoordinateTransform",c,0,".\\LidarConfig.ini");
			sprintf(c, "Lidar1Zshift%d", i);
			lidar1zcoorshift[i]   = GetPrivateProfileInt("CoordinateTransform",c,0,".\\LidarConfig.ini");

			sprintf(c, "Lidar2Xshift%d", i);
			lidar2xcoorshift[i]   = GetPrivateProfileInt("CoordinateTransform",c,0,".\\LidarConfig.ini");
			sprintf(c, "Lidar2Yshift%d", i);
			lidar2ycoorshift[i]   = GetPrivateProfileInt("CoordinateTransform",c,0,".\\LidarConfig.ini");
			sprintf(c, "Lidar2Zshift%d", i);
			lidar2zcoorshift[i]   = GetPrivateProfileInt("CoordinateTransform",c,0,".\\LidarConfig.ini");
		}		
	}
	
	
	//��ԭʼ������ӽ�����֡������
	void CAlgClassify::InputData(SecDataFrame * pfrm)
	{
		int length;
		
		//�����������
		if(m_DataFrameQueue.curFrameNum>=MAX_FRAME_NUM_CLA)
		{
			//�������ǰ����֡
			OutQueue(10);
		}
		
		length=m_DataFrameQueue.curFrameNum;
		memcpy( &(m_DataFrameQueue.frame[length]),pfrm,sizeof(DataFrame) );
		m_DataFrameQueue.curFrameNum++;
		
		m_pCurDataFrame=&(m_DataFrameQueue.frame[length]);
		
	}
	
	//�������֡�����е�ǰ����֡
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
	
	//�������֡����
	void CAlgClassify::ClearQueue()
	{
		m_DataFrameQueue.curFrameNum=0;
	}
	
	//Ԥ��������֡�����еĵ�ǰ֡������true������ɹ�
	bool CAlgClassify::PreProcess()
	{
		bool result=false;
		int len,temp,i,maxdist;
		double angle=0;
		int x=0,y=0;
		
		//��ԭʼ֡����Ϊ�գ��򷵻�
		if(m_DataFrameQueue.curFrameNum==0)
			return result;
		
		//��鵱ǰ֡���ȣ������̫Զ��������ǰ֡
		if(m_pCurDataFrame->dataLength != m_nStdDataLength)
		{
			len = m_pCurDataFrame->dataLength;
			//���̫Զ������
			temp=len-m_nStdDataLength;
			temp = temp>=0?temp:-temp;
			if( ((float)temp/m_nStdDataLength)>0.1 )
			{
				m_DataFrameQueue.curFrameNum--;
				m_pCurDataFrame=&(m_DataFrameQueue.frame[m_DataFrameQueue.curFrameNum-1]);
				return result;
			}
			//�������̣��������ݱ任
			else
			{
				//��һ��Ϊ��׼����
				m_pCurDataFrame->dataLength=m_nStdDataLength;
			}
		}
		
		//������Ч��������ƣ���������֡�еĲ��ֵ
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
	
	//��ȡ�������
	int CAlgClassify::GetWarningResult()
	{
		int result=0;
		int i=0;
		
		//��ȡǰ����
		if(m_savFlag==1)GetPointSet();
		//��δ���ǰ���㣬���ֱ�ӷ���

		//��䲢�洢����
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
		//���ļ�
		FILE *p;	
		sprintf(s, "c:\\test\\dat.txt", m_storeNum);
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
		if (x>m_range.MaxX[m_storeNum-1] || x<m_range.MinX[m_storeNum-1]) 
			return true;
		//if (x<m_range.MiddleMaxX && x>m_range.MiddleMinX) 
		//	return true;										//�����м��е�·�Ĳֿ�
		//if (y>m_range.MaxY[m_storeNum-1] || y<m_range.MinY[m_storeNum-1]) 
		//	return true;
		if (z<m_range.MinZ[m_storeNum-1] || z>m_range.MaxZ[m_storeNum-1]) 
			return true;

		return false;
	}
	//��ȡǰ���㣬��������Ӧ�ı���ƫ��������
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
		
		//���ǰ����ռ�
		m_FogrdPntSet.pointNum=0;

		m_nCurID++;
		/***********����ʱ���***************/
		deltime=CmptTimeDifms(initime,m_pCurDataFrame->time);
		/************************************/
		for(i=0;i<m_nStdDataLength;i++)
		{	
			foredistance=m_pCurDataFrame->data[i];			
			//����ǰ����

			if (i<m_nStdDataLength*0.5)   				
			{			
					angle = 0.006283185307180*i-0.087964594300514+0.01745329222*lidar1angle[m_storeNum-1];
					x[i]  = ((float)foredistance)*cos(angle)+lidar1xcoorshift[m_storeNum-1];
					y[i]  = m_nCurID*m_CfgInfo.stepValue+lidar1ycoorshift[m_storeNum-1];
					z[i]  = lidar1zcoorshift[m_storeNum-1]-((float)foredistance)*sin(angle);	
			}
			else 
			{		
					angle = 0.006283185307180*(i-m_nStdDataLength/2)-0.087964594300514+0.01745329222*lidar2angle[m_storeNum-1];
					x[i]  = ((float)foredistance)*cos(angle)+lidar2xcoorshift[m_storeNum-1];
					y[i]  = m_nCurID*m_CfgInfo.stepValue+lidar2ycoorshift[m_storeNum-1];
					z[i]  = lidar2zcoorshift[m_storeNum-1]-((float)foredistance)*sin(angle);;		
			}
			
			if (JudgeCrossBorder(x[i],y[i],z[i]))
			{
				x[i]=0;
				y[i]=0;
				z[i]=0;
			}
			
		}
		
		//���ƾ���
		startindex = 1;     
		disthrd = GetPrivateProfileInt("DataProcess","PointClusterDis",0,".\\LidarConfig.ini");					//�������ֵ
		pointnum = GetPrivateProfileInt("DataProcess","PointNum",0,".\\LidarConfig.ini");					//����
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
		//ȥ���
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
		
		//�����˲�
		neithrd = GetPrivateProfileInt("DataProcess","PointFilterThreshold",0,".\\LidarConfig.ini");											//���ڵ���������ֵ����λ��mm��
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
		distance=sqrt(temp1+temp2);	
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

		distance=sqrt(temp1+temp2+temp3);	
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