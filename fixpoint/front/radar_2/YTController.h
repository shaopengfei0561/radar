//*******************************************************
//版本：V1.0，增加云台开始停止位置返回：优化0点捕捉机制
//中储10号库云台控制
//*******************************************************

/*****************************************************************
*文件名：			YTController.h
*处理器名：	        -
*编译器名：	        -
*公司名：			无锡物联网产业研究院
*当前版本号：	    v1.0
*
*Copyright? 2015, 无锡物联网产业研究院 All rights reserved.
*
*作者			    时间					备注
*zhaoxianzhong		2015-8-11
*
*说明

******************************************************************/

//////////////////////////////////////////////////////////////////////

#if !defined(AFX_YTController_H__7C1074B1_C2CC_4B62_B790_5683868007EA__INCLUDED_)
#define AFX_YTController_H__7C1074B1_C2CC_4B62_B790_5683868007EA__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

#include "rs232.h"
#include "RadarCommunicationBase.h"
#include "AlgBase.h"
//***************************************************************************
const int RE_CMD_COUNT =2;
const int QUERY_CNT_LSpd = 1500;//低速等待到位，超时QUERY_CNT_LSpd/（1000/QUERY_WAIT_TIME),200s
const int QUERY_CNT_HSpd = 1000;//同上，100s
const int QUERY_WAIT_TIME = 200;
const int RESEND_WAIT_TIME = 25;
const int START_POS = 357;
const int COM_WAIT_TIME = 6000;//等待云台串口数据发送完成时间
extern bool m_bScanCmdFlag;//是否接收到仓位扫描指令
extern bool m_bStopRequested;

extern UINT m_nLastPos;
extern bool m_bStopPermited;
extern int YTPort[2];	
extern float YTPos[2];
//*********************************************************************

class YTController   
{
public:
	YTController();
	virtual ~YTController();
	int ierr;
	//云台控制主处理函数
	int ScanStorage(char storeID);

private:
	int ScanInitial(); //初始化串口连接
	int Mov2Pos(int YTNum,int pos);//移动位置
	int Mov2Pos();//移动位置
	int MovLeft(int YTNum,unsigned char degSpd);
	int MovRight(int YTNum,unsigned char degSpd);
	int MovStop(int YTNum);
	void StartRadarNotify();
	void StopRadarNotify(int radarNum);

	int baudRate;
	char _storeID;
	
};

#endif // !defined(AFX_YTController_H__7C1074B1_C2CC_4B62_B790_5683868007EA__INCLUDED_)
