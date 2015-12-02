//*******************************************************
//�汾��V1.0
//�д�10�ſ�PLC����
//*******************************************************

/*****************************************************************
*�ļ�����			PLCController.h
*����������	        -
*����������	        -
*��˾����			�п�Ժ������������ҵ�о�Ժ
*��ǰ�汾�ţ�	    v1.0
*
*Copyright? 2009, �п�Ժ������������ҵ�о�Ժ All rights reserved.
*
*����			    ʱ��					��ע
*zhaoxianzhong		2015-5-5
*
*˵��

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


//�궨��
#define SLAVE_ID   0x04//PLC��վ��ַ
#define SCAN_RATE  500//��λms,��ȡλ������
#define PRE_POS		300//��λmm,ɨ����������
#define WAIT4RSP   200//��λms��ָ��Ӧ��ȴ�ʱ��
#define MAX_SINGLE_SCAN_SIZE 1000//����ɨ������λ��

//Э����ض���
#define STORE_NUM_INDEX 6
const int SINGLE_STORE_INFO_BYTES = 9;


//***************************************************************************
//ȫ�ֳ���,PLC����ָ��,slaveID:4
const char GET_CUR_POS[8] = {SLAVE_ID,0x03,0x00,0x03,0x00,0x02,0x34,0x5E};//��С��1λ��
const char MOV_LEFT[8] = {SLAVE_ID,0x06,0x00,0x09,0x05,0x00,0x5A,0xCD};
const char MOV_RIGHT[8]= {SLAVE_ID,0x06,0x00,0x09,0x06,0x00,0x5A,0x3D};
const char MOV_STOP[8] = {SLAVE_ID,0x06,0x00,0x09,0x00,0x00,0x59,0x9D};

const int RE_CMD_COUNT =3;

extern SOCKET  m_socket_plc;//����PLC������
extern UINT m_nCurPos;//��ǰ�״�λ�ã�ͨ��ɨ���̲߳��ϸ���
extern bool m_bScanCmdFlag;//�Ƿ���յ���λɨ��ָ��
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
	//���������������
	int ScanStorage(int numStore,int* storeID,UINT* startPos,UINT* endPos);//��λ��������ʼλ�����飬����λ������
	int ScanInfoExtractor(char* recvData,char* storeNum,int* storeID,UINT* startPos,UINT* endPos);//������������ʵ��Ӧ��д��������
	
//protected:
//	void ScanPosInfo();					//�����Է���ɨ��ָ��
//	void RecvPlcData();                //����Plc��������

private:
	int ScanInitial();             //��ʼ��tcp����
	int Mov2Pos(UINT pos);//�ƶ���ָ��λ��
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
