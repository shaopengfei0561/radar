//*******************************************************
//版本：V1.2
//中储10号库PLC控制
//*******************************************************

// PLCController.cpp: implementation of the PLCController class.
//
//////////////////////////////////////////////////////////////////////
#include "stdafx.h"
#include "stdio.h"
#include <math.h>
#include "PLCControllor.h"

DWORD   WINAPI ScanPosThread(LPVOID   lParam);
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
void WriteLog(const char* format, ... )
{
	
    va_list    valist;
    FILE *fp;
	
    fp=fopen("test.log", "a" );	
    va_start( valist, format );
    vfprintf( fp, format, valist );
    va_end( valist );
    fclose(fp);
}
//TODO：在外部，增加异常控制类与长东扫描程序进行异常交互
	PLCControllor::PLCControllor()
	{
		ierr = 0;
		m_bScanCmdFlag = false;
		m_bStopRequested = true;
		plcIP = "10.8.25.120";
		//plcIP = "122.97.244.2";
		m_nPlcPort = 6001;
		ierr = ScanInitial();
		m_nCurPos = 0;
		m_nLastPos = 0;
		m_bStopPermited = true;

		DWORD nThreadId1=0;
		DWORD nThreadId2=0;
		handle1=CreateThread(NULL,0,ScanPosThread,(LPVOID)this,0,&nThreadId1);

		handle2=CreateThread(NULL,0,RecvDataThread,(LPVOID)this,0,&nThreadId2);

	}
	
	PLCControllor::~PLCControllor()
	{
		WriteLog("plc驱动资源被释放，无法继续执行任务.\n");
		m_bStopRequested = true;
		closesocket(m_socket_plc);
		CloseHandle(handle1);
		CloseHandle(handle2);
		WSACleanup();
	}
	int PLCControllor::ScanInitial()
	{
		if (m_socket_plc != NULL)
		{
			closesocket(m_socket_plc);
			WSACleanup();
		}
		//建立Tcp连接
		//检查SOCKET版本
		WORD wVersionRequested;
		WSADATA wsaData;
		int err;

		wVersionRequested = MAKEWORD( 1, 1 );

		err = WSAStartup( wVersionRequested, &wsaData );
		if ( err != 0 ) 
		{
			return -1;
		}

		if ( LOBYTE( wsaData.wVersion ) != 1 ||
			HIBYTE( wsaData.wVersion ) != 1 ) 
		{
			WSACleanup();
			return -1; 
		}


		m_socket_plc = socket(AF_INET,SOCK_STREAM,0);
		int TimeOut=100;//设置接收超时 
		if(::setsockopt(m_socket_plc,SOL_SOCKET,SO_RCVTIMEO,(char *)&TimeOut,sizeof(int))==SOCKET_ERROR)
		{
			WriteLog("PLC初始化失败，请检查网络.\n");
			return -1;

		}	
		SOCKADDR_IN addrSrv;
		addrSrv.sin_addr.S_un.S_addr=inet_addr(plcIP);
		addrSrv.sin_family=AF_INET;
		addrSrv.sin_port=htons(m_nPlcPort);
		int ret=connect(m_socket_plc,(SOCKADDR*)&addrSrv,sizeof(SOCKADDR));
		if(ret == SOCKET_ERROR )
		{
			WriteLog("PLC初始化失败，请检查网络.\n");
			return ret;	
		}
		WriteLog("PLC初始化完成.\n");
		return 0;
	}

	DWORD   WINAPI ScanPosThread(LPVOID   lParam)
	{
		//while (!m_bStopRequested)
		//{
		//	//一次扫描指令
		//	while (m_bScanCmdFlag)
		//	{
		//		send(m_socket_plc,GET_CUR_POS,8,0);
		//		Sleep(SCAN_RATE);
		//	}
		//	Sleep(1000);
		//}	

		//一次扫描指令
		while (1)
		{
			try
			{
				send(m_socket_plc,GET_CUR_POS,8,0);
			}
			catch (CException* e)
			{
				WriteLog("位置扫描发送异常.\n");
			}
			
			Sleep(SCAN_RATE);
		}
		WriteLog("位置扫描线程异常退出.\n");
		return 0;
	}

	DWORD   WINAPI RecvDataThread(LPVOID   lParam)
	{
		//TODO5:时间紧，先做简单的，此处应当做生产者消费者模式
		char recvBuf[1000] = {0};
		int recvCnt=0;
		//while (!m_bStopRequested)
		//{
		//	while (m_bScanCmdFlag)
		//	{
		//		for(;recvCnt<=13;)
		//			recvCnt=recv(m_socket_plc,recvBuf,13,0);
		//		//TODO6:添加校验确认
		//		if (recvCnt>=8 
		//			&&(recvBuf[0] == 0x04)
		//			&&((recvBuf[1] == 0x03)||(recvBuf[1] == 0x06))
		//			)//收到位置信息或者指令应答
		//		{
		//			switch(recvBuf[1])
		//			{
		//			case 0x03:
		//				if (recvBuf[2] == 0x04)//长度符合要求
		//				{
		//					unsigned char tempbuf[4];
		//					//转换char为unsigned char,修复大地址bug
		//					for (int i = 3;i<7;i++)
		//					{
		//						if (recvBuf[i]<0)
		//						{
		//							tempbuf[i-3] = recvBuf[i] +256;
		//						}
		//						else
		//							tempbuf[i-3] = recvBuf[i];
		//					}
		//					m_nCurPos = (UINT32)(tempbuf[0]*16777216 + tempbuf[1]*65536
		//						+ tempbuf[2]*256+tempbuf[3]);
		//				}
		//				break;
		//			default:
		//				break;
		//			}
		//		}
		//		Sleep(SCAN_RATE);
		//	}
		//	Sleep(1000);
		//}
		
		while (1)
		{
			//for(;recvCnt<=13;)
			recvCnt=recv(m_socket_plc,recvBuf,1000,0);
			//TODO6:添加校验确认
			if (recvCnt>=8 
				&&(recvBuf[0] == 0x04)
				&&((recvBuf[1] == 0x03)||(recvBuf[1] == 0x06))
				)//收到位置信息或者指令应答
			{
				m_nLastPos = m_nCurPos;//记录上一次扫描的位置
				switch(recvBuf[1])
				{
				case 0x03:
					if (recvBuf[2] == 0x04)//长度符合要求
					{
						unsigned char tempbuf[4];
						//转换char为unsigned char,修复大地址bug
						for (int i = 3;i<7;i++)
						{
							if (recvBuf[i]<0)
							{
								tempbuf[i-3] = recvBuf[i] +256;
							}
							else
								tempbuf[i-3] = recvBuf[i];
						}
						m_nCurPos = (UINT)(tempbuf[0]*16777216 + tempbuf[1]*65536
							+ tempbuf[2]*256+tempbuf[3]);
					}
					break;
				default:
					break;
				}
			}
			Sleep(SCAN_RATE);
		}
		WriteLog("接收线程异常退出.\n");
		return 0;
	}
	
	void PLCControllor::StartRadarNotify(int storeID)
	{
		m_savFlag = 1;
		m_savNum = storeID;//长东协议定义为char，暂时这样
		WriteLog("通知雷达开始采集.\n");
	}

	void PLCControllor::StopRadarNotify()
	{
		m_savFlag = 0;
		m_savNum = 0;
		WriteLog("通知雷达结束采集.\n");
	}

	//TODO6:Move部分指令的错误处理
	int PLCControllor::MovLeft()
	{
		for(int i = 0;i<RE_CMD_COUNT;i++)
		{
			int recvCnt=send(m_socket_plc,MOV_LEFT,8,0);
			Sleep(200);
		}
		WriteLog("发送左移指令.\n");
		return 0;//增加返回值错误处理，是否移动等（发出指令等待返回值）
	}

	int PLCControllor::MovRight()
	{
		for(int i = 0;i<RE_CMD_COUNT;i++)
		{
			int recvCnt=send(m_socket_plc,MOV_RIGHT,8,0);
			Sleep(200);
		}
		WriteLog("发送右移指令.\n");
		return 0;//增加返回值错误处理，是否移动等（发出指令等待返回值）
	}

	int PLCControllor::MovStop()
	{
		for(int i = 0;i<RE_CMD_COUNT;i++)
		{
			int recvCnt=send(m_socket_plc,MOV_STOP,8,0);
			Sleep(300);
			recvCnt=send(m_socket_plc,MOV_STOP,8,0);
		}
		WriteLog("发送停止指令.\n");
		return 0;//增加返回值错误处理，是否移动等（发出指令等待返回值）
	}

	int PLCControllor::Mov2Pos(UINT32 startPos)
	{
		int movLeftCount = 0;
		int movRightCount = 0;
		int tempCount = 0;

MOV2POS:
		if (m_nCurPos < (startPos- PRE_POS))//当前位置在扫描位置左侧
		{
			MovRight();
		}
		else if (m_nCurPos >= startPos)//右侧
		{
			MovLeft();
		}
		while(!((m_nCurPos>=(startPos-PRE_POS))
			&&(m_nCurPos< startPos))
			)//处于预启动位到启动位之间[)
		{
			if (m_nCurPos == m_nLastPos)//如果位置不动，则假设连接断开，重连，然后重新移动到指定位置
			{
				WriteLog("检测到连接异常，重启连接.\n");
				if (0 != ScanInitial())//无法确认是否断开连接问题，暂且这样
				{
					tempCount++;
					if (tempCount<3)//重连3次，如果还是不动则跳出循环，抛出异常？
					{
						goto MOV2POS;
						WriteLog("重新移动到起始位置.\n");
					}
					else
					{
						WriteLog("重连超过次数，向主程序抛出异常。\n");
						return -1;//如果重连失败则大概率是物理连接断开，返回异常，退出
					}
				}				
			}
			if (m_nCurPos>startPos)
			{
				MovLeft();
			}
			Sleep(POS_READ_RATE);
		}
		MovStop();
		WriteLog("移动到起始位置\n");
		return 0;
	}

	int PLCControllor::ScanSingleStorage(int storeID,UINT startPos,UINT endPos)
	{

		if (-1 == Mov2Pos(startPos) )//执行完到位
		{
			return -1;//执行失败，返回异常
		}
		MovRight();//统一规定从左向右扫描
		StartRadarNotify(storeID);//通知雷达开始扫描
		while(!(m_nCurPos > endPos))//未到结束位置之前
		{
			Sleep(100);
		}
		StopRadarNotify();
		MovStop();
		WriteLog("单个库位扫描完成.\n");
		return 0;
	}
	int PLCControllor::ScanStorage(int numStore,int* storeID,UINT32* startPos,UINT32* endPos)
	{
		int tempCount = 0;
		m_bScanCmdFlag = true;//收到仓位扫描指令
		m_bStopRequested = false;
		Sleep(2*SCAN_RATE);//读取位置信息等待
		for (int i=0;i<numStore;i++)
		{
			if (-1 == ScanSingleStorage(storeID[i],startPos[i],endPos[i]))
			{
				WriteLog("扫描失败，重启扫描.\n");
				i--;//重扫
				tempCount++;
			}
			if (tempCount>3)
			{
				WriteLog("重启扫描超过3次，向主程序抛出异常.\n");
				return -1;
				//break;//单个库三次无法通过扫描，系统故障，返回-1；
			}
			
			Sleep(200);//扫描
		}
		m_bScanCmdFlag = false;//扫描结束复位
		m_sndFlag = true;
		WriteLog("扫描任务完成.\n");
		return 0;
	}
	/****************************************
	输入：pRecvData，收到的matlab扫描指令数据
	输出：指针方式的仓位数、仓位号、起始位置、结束位置
	备注：此处假定在传入是空间已分配好
	****************************************/
	int PLCControllor::ScanInfoExtractor(char* pRecvData,char* pStoreNum,int* pStoreID,UINT* pStartPos,UINT* pEndPos)
	{
		unsigned char tempBuf[SINGLE_STORE_INFO_BYTES] = {0}; 
		try
		{
			*pStoreNum = pRecvData[STORE_NUM_INDEX];//取扫描仓位数
			for (int i=0;i< *pStoreNum;i++)
			{
				for (int j=0;j<SINGLE_STORE_INFO_BYTES;j++)
				{
					if(pRecvData[STORE_NUM_INDEX+1 + j + 3*i] < 0)
					{
						tempBuf[j] = pRecvData[STORE_NUM_INDEX+1 + j + SINGLE_STORE_INFO_BYTES*i] +256;
					}
					else
						tempBuf[j] = pRecvData[STORE_NUM_INDEX+1 + j + SINGLE_STORE_INFO_BYTES*i];
				}
				pStoreID[i] = tempBuf[0];
				pStartPos[i] = (UINT)(tempBuf[4]*16777216 + tempBuf[3]*65536
					+ tempBuf[2]*256+tempBuf[1]);
				pEndPos[i]   = (UINT)(tempBuf[8]*16777216 + tempBuf[7]*65536
					+ tempBuf[6]*256+tempBuf[5]);
			}
			return 1;
		}
		catch (CMemoryException* e)
		{
			return -1;
		}
		catch (CFileException* e)
		{
			return -1;
		}
		catch (CException* e)
		{
			return -1;
		}

	}
