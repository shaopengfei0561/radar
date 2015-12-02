//*******************************************************
//版本：V2.0,中储10号库云台控制
//revision:
//    1、增加云台开始停止位置返回；
//    2、优化0点捕捉机制
//2.0Revision:
//    1、四云台扫描
//Date:2015-8-17
//*******************************************************

// YTController.cpp: implementation of the YTController class.
//
//////////////////////////////////////////////////////////////////////
#include <math.h>
#include "stdafx.h"
#include "stdio.h"
#include "YTController.h"

DWORD   WINAPI RecvDataThread(LPVOID   lParam);
//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////
SOCKET  m_socket_plc;
UINT m_nCurPos;	
HANDLE handle1,handle2;
bool m_bScanCmdFlag;//是否接收到仓位扫描指令
bool m_bStopRequested;
UINT m_nLastPos;
bool m_bStopPermited;

int YTPort[YT_CNT];	
float YTPos[YT_CNT];
unsigned char addr = 0x01;
enum YT_INFO 
{
	MOV_LEFT = 0x04,
	MOV_RIGHT = 0x02,
	MOV_STOP = 0x0,
	//扫描速度
	MOV_SPD_N = 0x0a,
	//归位速度
	MOV_SPD_H = 0x30
};
unsigned char generalCmd[7] ={0xff,addr,0x00,0x00,0x00,0x00,0x01};//原型停止指令 

//TODO：在外部，增加异常控制类与长东扫描程序进行异常交互
	YTController::YTController()
	{
		ierr = 0;
		m_bScanCmdFlag = false;
		m_bStopRequested = true;

		YTPort[0] = GetPrivateProfileInt("YT","comPort1",0,".\\LidarConfig.ini") - 1;
		YTPort[1] = GetPrivateProfileInt("YT","comPort2",0,".\\LidarConfig.ini") - 1;
		YTPort[2] = GetPrivateProfileInt("YT","comPort3",0,".\\LidarConfig.ini") - 1;
		YTPort[3] = GetPrivateProfileInt("YT","comPort4",0,".\\LidarConfig.ini") - 1;
		baudRate = 2400;
		ierr = ScanInitial();
		m_bStopPermited = true;

		DWORD nThreadId=0;

		handle2=CreateThread(NULL,0,RecvDataThread,(LPVOID)this,0,&nThreadId);

	}
	
	YTController::~YTController()
	{
		m_bStopRequested = true;
		CloseHandle(handle2);
		for (int i = 0;i<YT_CNT;i++)
		{
			RS232_CloseComport(YTPort[i]);
			Sleep(100);
		}
	}
	int YTController::ScanInitial()
	{
		if ((RS232_OpenComport(YTPort[0],baudRate)||RS232_OpenComport(YTPort[1],baudRate) 
			||RS232_OpenComport(YTPort[2],baudRate)||RS232_OpenComport(YTPort[3],baudRate)) == 0)
		{
			//两个串口都打开成功
			return 0;
		}
		else
			return 1;		
	}

	
	DWORD   WINAPI RecvDataThread(LPVOID   lParam)
	{
		//TODO5:时间紧，先做简单的
		int recvCnt[YT_CNT] = {0};
		unsigned char comBuf[YT_CNT][4096];	
		while (1)
		{
			Sleep(QUERY_WAIT_TIME);
			//获取两个串口云台的当前位置
			for(int i = 0;i<YT_CNT;i++)
			{
				recvCnt[i] = RS232_PollComport(YTPort[i], comBuf[i], 4096);
				if(recvCnt[i]>21)
				{
					for(int j = recvCnt[i]-21;j<recvCnt[i];j++)
					{
						if (comBuf[i][j] == 0xff)
						{
							if ((comBuf[i][j+2] == 0x00) &&(comBuf[i][j+3] == 0x59))
							{
								YTPos[i] = (comBuf[i][j+4]*256 + comBuf[i][j+5])/100.0f;
								j = recvCnt[i]-1;
							}
						}
					}
				}
			}
		}
		return 1;
	}
	
	void YTController::StartRadarNotify(int radarNum)
	{
		switch(radarNum)
		{
		case 0:
			m_savFlag1 = 1;
			break;
		case 1:
			m_savFlag2 = 1;
			break;
		case 2:
			m_savFlag3 = 1;
			break;
		case 3:
			m_savFlag4 = 1;
			break;
		default:
			m_savFlag1 = 1;
			m_savFlag2 = 1;
			m_savFlag3 = 1;
			m_savFlag4 = 1;
			break;
		}
		m_savNum = _storeID;//长东协议定义为char，暂时这样
	}

	void YTController::StopRadarNotify(int radarNum)
	{
		switch(radarNum)
		{
			case 0:
				m_savFlag1 = 0;
				break;
			case 1:
				m_savFlag2 = 0;
				break;
			case 2:
				m_savFlag3 = 0;
				break;
			case 3:
				m_savFlag4 = 0;
				break;
			default:
				m_savFlag1 = 0;
				m_savFlag2 = 0;
				m_savFlag3 = 0;
				m_savFlag4 = 0;
				break;
		}
	}

	//TODO6:Move部分指令的错误处理
	int YTController::MovLeft(int YTNum,unsigned char degSpd)
	{
		generalCmd[3] = MOV_LEFT;
		generalCmd[4] = degSpd;
		//计算校验码（sum(cmd[2~6])mod255）
		int temp =0;
		for (int i = 1;i<6;i++)
		{
			temp += generalCmd[i];
		}
		generalCmd[6] = temp%255;
		for( i = 0;i<RE_CMD_COUNT;i++)
		{
			int recvCnt=RS232_SendBuf(YTNum,generalCmd,7);
			Sleep(RESEND_WAIT_TIME);
		}
		return 0;//增加返回值错误处理，是否移动等（发出指令等待返回值）
	}

	int YTController::MovRight(int YTNum,unsigned char degSpd)
	{
		generalCmd[3] = MOV_RIGHT;
		generalCmd[4] = degSpd;
		//计算校验码（sum(cmd[2~6])mod255）
		int temp =0;
		for (int i = 1;i<6;i++)
		{
			temp += generalCmd[i];
		}
		generalCmd[6] = temp%255;
		for( i = 0;i<RE_CMD_COUNT;i++)
		{
			int recvCnt=RS232_SendBuf(YTNum,generalCmd,7);
			Sleep(RESEND_WAIT_TIME);
		}
		return 0;//增加返回值错误处理，是否移动等（发出指令等待返回值）
	}

	int YTController::MovStop(int YTNum)
	{
		generalCmd[3] = 0x0;
		generalCmd[4] = 0x0;
		generalCmd[6] = 0x01;
		for(int i = 0;i<RE_CMD_COUNT;i++)
		{
			int recvCnt=RS232_SendBuf(YTNum,generalCmd,7);
			Sleep(RESEND_WAIT_TIME);
		}
		return 0;//增加返回值错误处理，是否移动等（发出指令等待返回值）
	}

	int YTController::Mov2Pos()
	{
		bool okCnt[YT_CNT] = {false};
		bool rawPosOK[YT_CNT] = {false};
		int queryCnt = 0;

		for (int i = 0;i<YT_CNT;i++)
		{
			if (YTPos[i] < 180 && (YTPos[i] > 0))//0~180
			{
				MovLeft(YTPort[i], MOV_SPD_H);
			}
			else
			{
				MovRight(YTPort[i], MOV_SPD_H);
			}
		}
		while(1)//未到结束位置之前
		{
			for (int i=0;i<YT_CNT;i++)
			{
				//先进行位置粗判断，进入范围后放慢转速
				if (!rawPosOK[i])
				{
					if(YTPos[i] >=320)
					{
						MovRight(YTPort[i],	MOV_SPD_N);
						rawPosOK[i] = true;
					}
				}
				//判断是否到0位置
				if (!okCnt[i])
				{
					if((YTPos[i] >=START_POS) && (YTPos[i]< 360))
					{
						MovStop(YTPort[i]);
						okCnt[i] = true;
					}
				}				
			}
			if (okCnt[0]&&okCnt[1]&&
			okCnt[2]&&okCnt[3])//两个云台都到位
			{
				Sleep(COM_WAIT_TIME);//等待雷达串口数据发送完成
				scanPosInfo[0] = YTPos[0];
				scanPosInfo[1] = YTPos[1];//记录起始位置信息
				scanPosInfo[2] = YTPos[2];
				scanPosInfo[3] = YTPos[3];//记录起始位置信息
				break;
			}
			if (queryCnt++ >QUERY_CNT_HSpd)
			{
				return 1;
			}
			Sleep(QUERY_WAIT_TIME);
		}
		return 0;
	}

	int YTController::Mov2Pos(int YTNum,int pos)
	{
//		int movLeftCount = 0;
//		int movRightCount = 0;
//		int tempCount = 0;
//
//MOV2POS:
//		if (m_nCurPos < (startPos- PRE_POS))//当前位置在扫描位置左侧
//		{
//			MovRight();
//		}
//		else if (m_nCurPos >= startPos)//右侧
//		{
//			MovLeft();
//		}
//		while(!((m_nCurPos>=(startPos-PRE_POS))
//			&&(m_nCurPos< startPos))
//			)//处于预启动位到启动位之间[)
//		{
//			if (m_nCurPos == m_nLastPos)//如果位置不动，则假设连接断开，重连，然后重新移动到指定位置
//			{
//
//				if (1 != ScanInitial())//无法确认是否断开连接问题，暂且这样
//				{
//					tempCount++;
//					if (tempCount<3)//重连3次，如果还是不动则跳出循环，抛出异常？
//					{
//						goto MOV2POS;
//					}
//					else
//					{
//						return -1;//如果重连失败则大概率是物理连接断开，返回异常，退出
//					}
//				}				
//			}
//			Sleep(800);
//		}
		return 0;
	}

	int YTController::ScanStorage(char storeID)
	{
		_storeID = storeID;
		m_bScanCmdFlag = true;//收到仓位扫描指令
		m_bStopRequested = false;
		for (int i = 0;i<2*YT_CNT;i++)
		{
			scanPosInfo[i] = 0;
		}
		Sleep(200);//读取位置信息等待
		if(Mov2Pos()>0) return 1;
		//StartRadarNotify();
		for ( i = 0;i<YT_CNT;i++)
		{
			MovRight(YTPort[i],MOV_SPD_N);//统一规定从左向右扫描
			Sleep(50);
			StartRadarNotify(i);
		}


		bool okCnt[YT_CNT] = {false};
		int queryCnt = 0;
		while(1)//未到结束位置之前
		{
			for (int i=0;i<YT_CNT;i++)
			{
				if (!okCnt[i])
				{
					if((YTPos[i] > 178) && (YTPos[i] <START_POS))
					{
						StopRadarNotify(i);
						MovStop(YTPort[i]);	
						okCnt[i] = true;
					}
				}
			}
			if (okCnt[0]&&okCnt[1]&&
				okCnt[2]&&okCnt[3])//两个云台都到位
			{
				Sleep(COM_WAIT_TIME);//等待雷达串口数据发送完成
				scanPosInfo[4] = YTPos[0];
				scanPosInfo[5] = YTPos[1];//记录起始位置信息
				scanPosInfo[6] = YTPos[2];
				scanPosInfo[7] = YTPos[3];//记录起始位置信息
				break;
			}
			if (queryCnt++ >QUERY_CNT_LSpd)
			{
				StopRadarNotify(-1);
				return 1;
			}
			Sleep(QUERY_WAIT_TIME);
		}
		//StopRadarNotify();
		m_bScanCmdFlag = false;//扫描结束复位
		if (abs(scanPosInfo[4]-scanPosInfo[0])<50 || abs(scanPosInfo[5]-scanPosInfo[1])<50
			||abs(scanPosInfo[6]-scanPosInfo[2])<50 || abs(scanPosInfo[7]-scanPosInfo[3])<50)
		{
			m_sndFlag = false;
			return 1;
		}

		m_sndFlag = true;
		return 0;
		//通知雷达开始扫描
		//for (int i=0;i<2;i++)
		//{
		//	if (-1 == ScanSingleYT(storeID[i],startPos[i],endPos[i]))
		//	{
		//		i--;//重扫
		//		tempCount++;
		//	}
		//	if (tempCount>3)
		//	{
		//		return -1;
		//		break;//单个库三次无法通过扫描，系统故障，返回-1；
		//	}
		//	
		//	Sleep(200);//扫描
		//}
		//m_bScanCmdFlag = false;//扫描结束复位
		//m_sndFlag = true;
		//return 1;
	}
	

