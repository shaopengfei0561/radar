//*******************************************************
//版本：V1.0
//中储10号库PLC控制
//*******************************************************

/*****************************************************************
*文件名：			PLCController.h
*处理器名：	        -
*编译器名：	        -
*公司名：			中科院无锡物联网产业研究院
*当前版本号：	    v1.0
*
*Copyright? 2009, 中科院无锡物联网产业研究院 All rights reserved.
*
*作者			    时间					备注
*zhaoxianzhong		2015-5-5
*
*说明

******************************************************************/
// AlgClassify.h: interface for the CAlgClassify class.
//
//////////////////////////////////////////////////////////////////////

#if !defined(AFX_PLCCONTROLLOR_H__7C1074B1_C2CC_4B62_B790_5683868007EA__INCLUDED_)
#define AFX_PLCCONTROLLOR_H__7C1074B1_C2CC_4B62_B790_5683868007EA__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

#include "RadarCommunicationBase.h"
#include "AlgBase.h"
#include "StdAfx.h"


//宏定义
#define SLAVE_ID   0x04//PLC从站地址
#define SCAN_RATE  500//单位ms,读取位置周期
#define PRE_POS		300//单位mm,扫描启动距离
#define WAIT4RSP   200//单位ms，指令应答等待时间
#define MAX_SINGLE_SCAN_SIZE 1000//单次扫描最大仓位数

//协议相关定义
#define STORE_NUM_INDEX 6
const int SINGLE_STORE_INFO_BYTES = 9;


//***************************************************************************
//全局常量,PLC控制指令,slaveID:4
const char GET_CUR_POS[8] = {SLAVE_ID,0x03,0x00,0x03,0x00,0x02,0x34,0x5E};//读小车1位置
const char MOV_LEFT[8] = {SLAVE_ID,0x06,0x00,0x09,0x05,0x00,0x5A,0xCD};
const char MOV_RIGHT[8]= {SLAVE_ID,0x06,0x00,0x09,0x06,0x00,0x5A,0x3D};
const char MOV_STOP[8] = {SLAVE_ID,0x06,0x00,0x09,0x00,0x00,0x59,0x9D};

const int RE_CMD_COUNT =3;

extern SOCKET  m_socket_plc;//连接PLC控制器
extern UINT m_nCurPos;//当前雷达位置，通过扫描线程不断更新
extern bool m_bScanCmdFlag;//是否接收到仓位扫描指令
extern bool m_bStopRequested;

extern UINT m_nLastPos;
extern bool m_bStopPermited;
//*********************************************************************

class PLCControllor   
{
public:
	PLCControllor();
	virtual ~PLCControllor();
	int ierr;
	//电机控制主处理函数
	int ScanStorage(int numStore,int* storeID,UINT* startPos,UINT* endPos);//仓位个数，起始位置数组，结束位置数组
	int ScanInfoExtractor(char* recvData,char* storeNum,int* storeID,UINT* startPos,UINT* endPos);//解析函数，其实不应该写在这里面
	
//protected:
//	void ScanPosInfo();					//周期性发送扫描指令
//	void RecvPlcData();                //接收Plc返回数据

private:
	int ScanInitial();             //初始化tcp连接
	int Mov2Pos(UINT pos);//移动到指定位置
	int MovLeft();
	int MovRight();
	int MovStop();
	void StartRadarNotify(int storeID);
	void StopRadarNotify();
	int ScanSingleStorage(int storeID,UINT startPos,UINT endPos);


	CString plcIP;
	int m_nPlcPort;	
};

#endif // !defined(AFX_PLCCONTROLLOR_H__7C1074B1_C2CC_4B62_B790_5683868007EA__INCLUDED_)
