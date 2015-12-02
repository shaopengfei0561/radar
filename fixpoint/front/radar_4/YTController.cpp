//*******************************************************
//�汾��V2.0,�д�10�ſ���̨����
//revision:
//    1��������̨��ʼֹͣλ�÷��أ�
//    2���Ż�0�㲶׽����
//2.0Revision:
//    1������̨ɨ��
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
bool m_bScanCmdFlag;//�Ƿ���յ���λɨ��ָ��
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
	//ɨ���ٶ�
	MOV_SPD_N = 0x0a,
	//��λ�ٶ�
	MOV_SPD_H = 0x30
};
unsigned char generalCmd[7] ={0xff,addr,0x00,0x00,0x00,0x00,0x01};//ԭ��ָֹͣ�� 

//TODO�����ⲿ�������쳣�������볤��ɨ���������쳣����
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
			//�������ڶ��򿪳ɹ�
			return 0;
		}
		else
			return 1;		
	}

	
	DWORD   WINAPI RecvDataThread(LPVOID   lParam)
	{
		//TODO5:ʱ����������򵥵�
		int recvCnt[YT_CNT] = {0};
		unsigned char comBuf[YT_CNT][4096];	
		while (1)
		{
			Sleep(QUERY_WAIT_TIME);
			//��ȡ����������̨�ĵ�ǰλ��
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
		m_savNum = _storeID;//����Э�鶨��Ϊchar����ʱ����
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

	//TODO6:Move����ָ��Ĵ�����
	int YTController::MovLeft(int YTNum,unsigned char degSpd)
	{
		generalCmd[3] = MOV_LEFT;
		generalCmd[4] = degSpd;
		//����У���루sum(cmd[2~6])mod255��
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
		return 0;//���ӷ���ֵ�������Ƿ��ƶ��ȣ�����ָ��ȴ�����ֵ��
	}

	int YTController::MovRight(int YTNum,unsigned char degSpd)
	{
		generalCmd[3] = MOV_RIGHT;
		generalCmd[4] = degSpd;
		//����У���루sum(cmd[2~6])mod255��
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
		return 0;//���ӷ���ֵ�������Ƿ��ƶ��ȣ�����ָ��ȴ�����ֵ��
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
		return 0;//���ӷ���ֵ�������Ƿ��ƶ��ȣ�����ָ��ȴ�����ֵ��
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
		while(1)//δ������λ��֮ǰ
		{
			for (int i=0;i<YT_CNT;i++)
			{
				//�Ƚ���λ�ô��жϣ����뷶Χ�����ת��
				if (!rawPosOK[i])
				{
					if(YTPos[i] >=320)
					{
						MovRight(YTPort[i],	MOV_SPD_N);
						rawPosOK[i] = true;
					}
				}
				//�ж��Ƿ�0λ��
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
			okCnt[2]&&okCnt[3])//������̨����λ
			{
				Sleep(COM_WAIT_TIME);//�ȴ��״ﴮ�����ݷ������
				scanPosInfo[0] = YTPos[0];
				scanPosInfo[1] = YTPos[1];//��¼��ʼλ����Ϣ
				scanPosInfo[2] = YTPos[2];
				scanPosInfo[3] = YTPos[3];//��¼��ʼλ����Ϣ
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
//		if (m_nCurPos < (startPos- PRE_POS))//��ǰλ����ɨ��λ�����
//		{
//			MovRight();
//		}
//		else if (m_nCurPos >= startPos)//�Ҳ�
//		{
//			MovLeft();
//		}
//		while(!((m_nCurPos>=(startPos-PRE_POS))
//			&&(m_nCurPos< startPos))
//			)//����Ԥ����λ������λ֮��[)
//		{
//			if (m_nCurPos == m_nLastPos)//���λ�ò�������������ӶϿ���������Ȼ�������ƶ���ָ��λ��
//			{
//
//				if (1 != ScanInitial())//�޷�ȷ���Ƿ�Ͽ��������⣬��������
//				{
//					tempCount++;
//					if (tempCount<3)//����3�Σ�������ǲ���������ѭ�����׳��쳣��
//					{
//						goto MOV2POS;
//					}
//					else
//					{
//						return -1;//�������ʧ�����������������ӶϿ��������쳣���˳�
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
		m_bScanCmdFlag = true;//�յ���λɨ��ָ��
		m_bStopRequested = false;
		for (int i = 0;i<2*YT_CNT;i++)
		{
			scanPosInfo[i] = 0;
		}
		Sleep(200);//��ȡλ����Ϣ�ȴ�
		if(Mov2Pos()>0) return 1;
		//StartRadarNotify();
		for ( i = 0;i<YT_CNT;i++)
		{
			MovRight(YTPort[i],MOV_SPD_N);//ͳһ�涨��������ɨ��
			Sleep(50);
			StartRadarNotify(i);
		}


		bool okCnt[YT_CNT] = {false};
		int queryCnt = 0;
		while(1)//δ������λ��֮ǰ
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
				okCnt[2]&&okCnt[3])//������̨����λ
			{
				Sleep(COM_WAIT_TIME);//�ȴ��״ﴮ�����ݷ������
				scanPosInfo[4] = YTPos[0];
				scanPosInfo[5] = YTPos[1];//��¼��ʼλ����Ϣ
				scanPosInfo[6] = YTPos[2];
				scanPosInfo[7] = YTPos[3];//��¼��ʼλ����Ϣ
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
		m_bScanCmdFlag = false;//ɨ�������λ
		if (abs(scanPosInfo[4]-scanPosInfo[0])<50 || abs(scanPosInfo[5]-scanPosInfo[1])<50
			||abs(scanPosInfo[6]-scanPosInfo[2])<50 || abs(scanPosInfo[7]-scanPosInfo[3])<50)
		{
			m_sndFlag = false;
			return 1;
		}

		m_sndFlag = true;
		return 0;
		//֪ͨ�״￪ʼɨ��
		//for (int i=0;i<2;i++)
		//{
		//	if (-1 == ScanSingleYT(storeID[i],startPos[i],endPos[i]))
		//	{
		//		i--;//��ɨ
		//		tempCount++;
		//	}
		//	if (tempCount>3)
		//	{
		//		return -1;
		//		break;//�����������޷�ͨ��ɨ�裬ϵͳ���ϣ�����-1��
		//	}
		//	
		//	Sleep(200);//ɨ��
		//}
		//m_bScanCmdFlag = false;//ɨ�������λ
		//m_sndFlag = true;
		//return 1;
	}
	

