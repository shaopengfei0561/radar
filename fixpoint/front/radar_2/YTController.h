//*******************************************************
//�汾��V1.0��������̨��ʼֹͣλ�÷��أ��Ż�0�㲶׽����
//�д�10�ſ���̨����
//*******************************************************

/*****************************************************************
*�ļ�����			YTController.h
*����������	        -
*����������	        -
*��˾����			������������ҵ�о�Ժ
*��ǰ�汾�ţ�	    v1.0
*
*Copyright? 2015, ������������ҵ�о�Ժ All rights reserved.
*
*����			    ʱ��					��ע
*zhaoxianzhong		2015-8-11
*
*˵��

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
const int QUERY_CNT_LSpd = 1500;//���ٵȴ���λ����ʱQUERY_CNT_LSpd/��1000/QUERY_WAIT_TIME),200s
const int QUERY_CNT_HSpd = 1000;//ͬ�ϣ�100s
const int QUERY_WAIT_TIME = 200;
const int RESEND_WAIT_TIME = 25;
const int START_POS = 357;
const int COM_WAIT_TIME = 6000;//�ȴ���̨�������ݷ������ʱ��
extern bool m_bScanCmdFlag;//�Ƿ���յ���λɨ��ָ��
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
	//��̨������������
	int ScanStorage(char storeID);

private:
	int ScanInitial(); //��ʼ����������
	int Mov2Pos(int YTNum,int pos);//�ƶ�λ��
	int Mov2Pos();//�ƶ�λ��
	int MovLeft(int YTNum,unsigned char degSpd);
	int MovRight(int YTNum,unsigned char degSpd);
	int MovStop(int YTNum);
	void StartRadarNotify();
	void StopRadarNotify(int radarNum);

	int baudRate;
	char _storeID;
	
};

#endif // !defined(AFX_YTController_H__7C1074B1_C2CC_4B62_B790_5683868007EA__INCLUDED_)
