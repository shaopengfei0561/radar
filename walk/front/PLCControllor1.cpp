//*******************************************************
//�汾��V1.2
//�д�10�ſ�PLC����
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
bool m_bScanCmdFlag;//�Ƿ���յ���λɨ��ָ��
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
//TODO�����ⲿ�������쳣�������볤��ɨ���������쳣����
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
		WriteLog("plc������Դ���ͷţ��޷�����ִ������.\n");
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
		//����Tcp����
		//���SOCKET�汾
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
		int TimeOut=100;//���ý��ճ�ʱ 
		if(::setsockopt(m_socket_plc,SOL_SOCKET,SO_RCVTIMEO,(char *)&TimeOut,sizeof(int))==SOCKET_ERROR)
		{
			WriteLog("PLC��ʼ��ʧ�ܣ���������.\n");
			return -1;

		}	
		SOCKADDR_IN addrSrv;
		addrSrv.sin_addr.S_un.S_addr=inet_addr(plcIP);
		addrSrv.sin_family=AF_INET;
		addrSrv.sin_port=htons(m_nPlcPort);
		int ret=connect(m_socket_plc,(SOCKADDR*)&addrSrv,sizeof(SOCKADDR));
		if(ret == SOCKET_ERROR )
		{
			WriteLog("PLC��ʼ��ʧ�ܣ���������.\n");
			return ret;	
		}
		WriteLog("PLC��ʼ�����.\n");
		return 0;
	}

	DWORD   WINAPI ScanPosThread(LPVOID   lParam)
	{
		//while (!m_bStopRequested)
		//{
		//	//һ��ɨ��ָ��
		//	while (m_bScanCmdFlag)
		//	{
		//		send(m_socket_plc,GET_CUR_POS,8,0);
		//		Sleep(SCAN_RATE);
		//	}
		//	Sleep(1000);
		//}	

		//һ��ɨ��ָ��
		while (1)
		{
			try
			{
				send(m_socket_plc,GET_CUR_POS,8,0);
			}
			catch (CException* e)
			{
				WriteLog("λ��ɨ�跢���쳣.\n");
			}
			
			Sleep(SCAN_RATE);
		}
		WriteLog("λ��ɨ���߳��쳣�˳�.\n");
		return 0;
	}

	DWORD   WINAPI RecvDataThread(LPVOID   lParam)
	{
		//TODO5:ʱ����������򵥵ģ��˴�Ӧ����������������ģʽ
		char recvBuf[1000] = {0};
		int recvCnt=0;
		//while (!m_bStopRequested)
		//{
		//	while (m_bScanCmdFlag)
		//	{
		//		for(;recvCnt<=13;)
		//			recvCnt=recv(m_socket_plc,recvBuf,13,0);
		//		//TODO6:���У��ȷ��
		//		if (recvCnt>=8 
		//			&&(recvBuf[0] == 0x04)
		//			&&((recvBuf[1] == 0x03)||(recvBuf[1] == 0x06))
		//			)//�յ�λ����Ϣ����ָ��Ӧ��
		//		{
		//			switch(recvBuf[1])
		//			{
		//			case 0x03:
		//				if (recvBuf[2] == 0x04)//���ȷ���Ҫ��
		//				{
		//					unsigned char tempbuf[4];
		//					//ת��charΪunsigned char,�޸����ַbug
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
			//TODO6:���У��ȷ��
			if (recvCnt>=8 
				&&(recvBuf[0] == 0x04)
				&&((recvBuf[1] == 0x03)||(recvBuf[1] == 0x06))
				)//�յ�λ����Ϣ����ָ��Ӧ��
			{
				m_nLastPos = m_nCurPos;//��¼��һ��ɨ���λ��
				switch(recvBuf[1])
				{
				case 0x03:
					if (recvBuf[2] == 0x04)//���ȷ���Ҫ��
					{
						unsigned char tempbuf[4];
						//ת��charΪunsigned char,�޸����ַbug
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
		WriteLog("�����߳��쳣�˳�.\n");
		return 0;
	}
	
	void PLCControllor::StartRadarNotify(int storeID)
	{
		m_savFlag = 1;
		m_savNum = storeID;//����Э�鶨��Ϊchar����ʱ����
		WriteLog("֪ͨ�״￪ʼ�ɼ�.\n");
	}

	void PLCControllor::StopRadarNotify()
	{
		m_savFlag = 0;
		m_savNum = 0;
		WriteLog("֪ͨ�״�����ɼ�.\n");
	}

	//TODO6:Move����ָ��Ĵ�����
	int PLCControllor::MovLeft()
	{
		for(int i = 0;i<RE_CMD_COUNT;i++)
		{
			int recvCnt=send(m_socket_plc,MOV_LEFT,8,0);
			Sleep(200);
		}
		WriteLog("��������ָ��.\n");
		return 0;//���ӷ���ֵ�������Ƿ��ƶ��ȣ�����ָ��ȴ�����ֵ��
	}

	int PLCControllor::MovRight()
	{
		for(int i = 0;i<RE_CMD_COUNT;i++)
		{
			int recvCnt=send(m_socket_plc,MOV_RIGHT,8,0);
			Sleep(200);
		}
		WriteLog("��������ָ��.\n");
		return 0;//���ӷ���ֵ�������Ƿ��ƶ��ȣ�����ָ��ȴ�����ֵ��
	}

	int PLCControllor::MovStop()
	{
		for(int i = 0;i<RE_CMD_COUNT;i++)
		{
			int recvCnt=send(m_socket_plc,MOV_STOP,8,0);
			Sleep(300);
			recvCnt=send(m_socket_plc,MOV_STOP,8,0);
		}
		WriteLog("����ָֹͣ��.\n");
		return 0;//���ӷ���ֵ�������Ƿ��ƶ��ȣ�����ָ��ȴ�����ֵ��
	}

	int PLCControllor::Mov2Pos(UINT32 startPos)
	{
		int movLeftCount = 0;
		int movRightCount = 0;
		int tempCount = 0;

MOV2POS:
		if (m_nCurPos < (startPos- PRE_POS))//��ǰλ����ɨ��λ�����
		{
			MovRight();
		}
		else if (m_nCurPos >= startPos)//�Ҳ�
		{
			MovLeft();
		}
		while(!((m_nCurPos>=(startPos-PRE_POS))
			&&(m_nCurPos< startPos))
			)//����Ԥ����λ������λ֮��[)
		{
			if (m_nCurPos == m_nLastPos)//���λ�ò�������������ӶϿ���������Ȼ�������ƶ���ָ��λ��
			{
				WriteLog("��⵽�����쳣����������.\n");
				if (0 != ScanInitial())//�޷�ȷ���Ƿ�Ͽ��������⣬��������
				{
					tempCount++;
					if (tempCount<3)//����3�Σ�������ǲ���������ѭ�����׳��쳣��
					{
						goto MOV2POS;
						WriteLog("�����ƶ�����ʼλ��.\n");
					}
					else
					{
						WriteLog("�����������������������׳��쳣��\n");
						return -1;//�������ʧ�����������������ӶϿ��������쳣���˳�
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
		WriteLog("�ƶ�����ʼλ��\n");
		return 0;
	}

	int PLCControllor::ScanSingleStorage(int storeID,UINT startPos,UINT endPos)
	{

		if (-1 == Mov2Pos(startPos) )//ִ���굽λ
		{
			return -1;//ִ��ʧ�ܣ������쳣
		}
		MovRight();//ͳһ�涨��������ɨ��
		StartRadarNotify(storeID);//֪ͨ�״￪ʼɨ��
		while(!(m_nCurPos > endPos))//δ������λ��֮ǰ
		{
			Sleep(100);
		}
		StopRadarNotify();
		MovStop();
		WriteLog("������λɨ�����.\n");
		return 0;
	}
	int PLCControllor::ScanStorage(int numStore,int* storeID,UINT32* startPos,UINT32* endPos)
	{
		int tempCount = 0;
		m_bScanCmdFlag = true;//�յ���λɨ��ָ��
		m_bStopRequested = false;
		Sleep(2*SCAN_RATE);//��ȡλ����Ϣ�ȴ�
		for (int i=0;i<numStore;i++)
		{
			if (-1 == ScanSingleStorage(storeID[i],startPos[i],endPos[i]))
			{
				WriteLog("ɨ��ʧ�ܣ�����ɨ��.\n");
				i--;//��ɨ
				tempCount++;
			}
			if (tempCount>3)
			{
				WriteLog("����ɨ�賬��3�Σ����������׳��쳣.\n");
				return -1;
				//break;//�����������޷�ͨ��ɨ�裬ϵͳ���ϣ�����-1��
			}
			
			Sleep(200);//ɨ��
		}
		m_bScanCmdFlag = false;//ɨ�������λ
		m_sndFlag = true;
		WriteLog("ɨ���������.\n");
		return 0;
	}
	/****************************************
	���룺pRecvData���յ���matlabɨ��ָ������
	�����ָ�뷽ʽ�Ĳ�λ������λ�š���ʼλ�á�����λ��
	��ע���˴��ٶ��ڴ����ǿռ��ѷ����
	****************************************/
	int PLCControllor::ScanInfoExtractor(char* pRecvData,char* pStoreNum,int* pStoreID,UINT* pStartPos,UINT* pEndPos)
	{
		unsigned char tempBuf[SINGLE_STORE_INFO_BYTES] = {0}; 
		try
		{
			*pStoreNum = pRecvData[STORE_NUM_INDEX];//ȡɨ���λ��
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
