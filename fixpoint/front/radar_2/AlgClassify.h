//*******************************************************
//版本：V3.3
//本版本要嵌入到二期的算法服务器软件中使用
//它采用二期新设计的算法接口和结构体
//它要实现分类识别算法
//本算法尝试加入了输出频度控制
//本算法在分类上尝试实现对人、车和骑行车辆的分类
//*******************************************************

/*****************************************************************
*文件名：			CAlgClassify.h
*处理器名：	        -
*编译器名：	        -
*公司名：			中科院无锡物联网产业研究院
*当前版本号：	    v1.0
*
*Copyright? 2009, 中科院无锡物联网产业研究院 All rights reserved.
*
*作者			时间					备注
*zhangyong		2010-5-6
*
*说明
算法演示---识别算法。
******************************************************************/
// AlgClassify.h: interface for the CAlgClassify class.
//
//////////////////////////////////////////////////////////////////////

#if !defined(AFX_ALGCLASSIFY_H__7C1074B1_C2CC_4B62_B790_5683868007EA__INCLUDED_)
#define AFX_ALGCLASSIFY_H__7C1074B1_C2CC_4B62_B790_5683868007EA__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

#include "AlgBase.h"
	
//***************************************************************************
//一些宏定义
#define MAX_FRAME_NUM_CLA    50     //原始帧队列中的最大帧数量
#define MAX_OBJECT_NUM_CLA    20     //最大目标数量
#define BLDMAP_FRAME_NUM_CLA  15     //建立地图所需帧数
#define MAX_DATA_LENGTH_CLA  2200    //最大数据长度
#define MAX_OBJ_NUM_CLA      100     //最大目标数量

namespace alg_classify
{
	//******************************************************
	//定义一些结构
	typedef struct _ClassifyConfigInfo
	{
		int ValidDistance;    //有效距离
		int offset;           //背景偏移量
		int bldmapPeriod;	  //创建地图周期（分钟）
		int lmsValue;		  //野点剔除阈值
		int stepValue;		  //渐进步长
		float railspeed;		  //渐进步长
	}ClassifyConfigInfo;
		
	//原始数据帧队列结构体：
	typedef struct _DataFrameQueue
	{
		int curFrameNum;    //当前实际存放的数据帧数目
		DataFrame frame[MAX_FRAME_NUM_CLA];  //存放原始数据帧
	}DataFrameQueue;

	//前景点集：
	typedef struct _ForegroundPointSet
	{
		int pointNum;    //点个数
		int lastNum;    //上一帧点个数
		int wholeNum;
		int step;
		SYSPOINT point[MAX_DATA_LENGTH_CLA];  //存放前景点
	}ForegroundPointSet;

	//当前帧目标
	typedef struct _CurObj
	{
		SYSTIME time;    //目标产生的时间
		bool possess;   //是否占用，在目标匹配时使用
		SYSPOINT midPnt;   //中心点座标
		int pointNum;      //目标所含点数
		int width;         //目标宽度
		unsigned int timeid;        //时间id号
	}CurObj; 

	//注册目标
	typedef struct _RegisterObj
	{
		bool possess;   //是否占用，在目标匹配时使用
		SYSPOINT midPnt;   //中心点座标
		float angle;
		int distance;
		int minWidth,maxWidth,curWidth;  //最小宽度，最大宽度,当前宽度
		int minPntNum,maxPntNum,curPntNum;   //最小点数，最大点数，当前点数
		int maxMidPntShake;                  //最大中心点抖动
		unsigned int startID,stopID;              //开始ID，结束ID
		int lastFrmNum;                  //持续帧数
		int type;                        //类型 1：人 2：车   0：不是	
	}RegisterObj; 

	//坐标配准偏移量
	typedef struct _CoordiShift
	{
		float lidar1angle[14];
		float lidar2angle[14];
		int coorshift[14];
	}CoordiShift; 
	
	//***************************************************************************
	//声明一些全局函数
	
	//声明计算两时间差函数（单位：分钟）
	int CmptTimeDif(SYSTIME time1,SYSTIME time2);
	//声明计算两时间差函数（单位：分钟）
	int CmptTimeDifms(SYSTIME time1,SYSTIME time2);
	//声明计算两点间距离的全局函数
	float CmptDistance(SYSPOINT pt1, SYSPOINT pt2);
	//声明计算空间两点间距离的全局函数
	float CmptSpaceDistance(int x1, int y1, int z1, int x2, int y2, int z2);
	//声明比较大小函数
	int MinValue(int a,int b); 
	//*********************************************************************	
	class CAlgClassify : public CAlgBase  
	{
	public:
		CAlgClassify();
		virtual ~CAlgClassify();
		
		void InternalInitial();             //内部变量初始化（除了算法配置信息）
		int jianditu;
		bool JudgeCrossBorder(int x,int y,int z);
		long int m_Num;
		SYSPOINT m_Vpoint[3000000];				//点云点集
		
		ForegroundPointSet m_FogrdPntSet;		//前景点集
		/*
		函数说明：获取算法运算结果。算法的调用以此为接口。
		参数说明：pfrm 指向原始数据帧结构体的指针，用于原始数据的输入
		buf  调用者提供的用于算法输出数据的缓存地址
		length 调用者提供的输出缓存的总长度（单位：字节）
		返回值：算法输出的数据的长度（单位：字节）
		*/
		int GetResult(int lidar1Data[2000][529], int lidar2Data[2000][529]);

	protected:
		int m_nOutFreq;                 //输出频度
		unsigned int m_nCurAlarmID;     //当前报警帧ID
		unsigned int m_nPastAlarmID;    //过去报警帧ID

		CoordiShift lidarshift;			//坐标配准偏移量

		int m_BackOffset[MAX_DATA_LENGTH_CLA];                     //背景偏移量数组

		ClassifyConfigInfo m_CfgInfo;   //算法所需的配置信息
		
		DataFrameQueue m_DataFrameQueue;  //原始数据帧队列
		DataFrame * m_pCurDataFrame;          //指向当前数据帧的指针
		
		int m_nStdDataLength;                //标准数据长度
		bool m_bHaveStdDataLength;             //是否获取了标准数据长度
		
		float m_fStartAngle;					//起始角度（单位：弧度）
		float m_fStopAngle;						//终止角度（单位：弧度）
		float m_fAngleStep;						//角度步进
		
		int m_nSplitIndex[MAX_DATA_LENGTH_CLA];    //对前景点集的分割索引
		int m_nSplitNum;                        //分割索引的个数，表征有多少个初级目标点集

		CurObj m_CurObj[MAX_OBJ_NUM_CLA];             //当前帧目标数组
		int m_nCurObjNum;								//当前帧目标数目

		RegisterObj m_RegisterObj[MAX_OBJ_NUM_CLA];   //注册目标数组
		int m_nRegisterObjNum;                        //注册目标数目
		int m_volume;						//流量
		//******************************************************************		
		void InputData(SecDataFrame * pfrm);		 //将原始数据添加进数据帧队列中
		void OutQueue(int num);						 //清出数据帧队列中的前若干帧
		void ClearQueue();							 //清空数据帧队列
		
		bool PreProcess();							 //预处理数据帧队列中的当前帧

		int GetWarningResult();						//获取报警结果
				
		void SplitObject();							//从前景点分割出目标
		void GetCurObj();							//产生当前帧目标
		bool JudgeObj(CurObj *);					//判断是目标
		int  FillPoint();

		void UpdateRegisterObj();						  //更新注册目标
		void FirstRegister(RegisterObj *,CurObj *);       //第一次生成注册目标
		void AddRegister(RegisterObj *,CurObj *);         //更新生成注册目标
		bool JudgeSameObj(RegisterObj *,CurObj *);	 //判断为同目标
		
		void ClassifyRObj();						//对注册目标进行分类识别
		int JudgeObjType(RegisterObj *);			//判断目标类型
				
		void RemoveExpiredRObj();					//将过期的注册目标去除

		/*用于两台雷达坐标配准的参量*/
		int lengtha1;
		int lengthb1;
		
		/*用于目标线段帧内融合*/
		int fusionwidth;			
	};
}
#endif // !defined(AFX_ALGCLASSIFY_H__7C1074B1_C2CC_4B62_B790_5683868007EA__INCLUDED_)
