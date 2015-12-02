/*****************************************************************
*�ļ�����			RadarCommunicationBase.h
*����������	        -
*����������	        -
*��˾����			�п�Ժ������������ҵ�о�Ժ
*��ǰ�汾�ţ�	    v1.0
*
*Copyright? 2009, �п�Ժ������������ҵ�о�Ժ All rights reserved.
*
*����			ʱ��					��ע
*zhangyong		2009-12-28			
*
*˵��
	�����״�ͨ��ģ��ͨ�Ų�Ʒ���ࡣ�����ࡣ��������ͨ�ŵĳ���ӿڣ�
	����Ĳ�Ʒ��ͨ�������Ӹ���̳С�
******************************************************************/

// RadarCommunicationBase.h: interface for the CRadarCommunicationBase class.
//
//////////////////////////////////////////////////////////////////////

#if !defined(AFX_RADARCOMMUNICATIONBASE_H__04E7987A_6DB4_4E78_8BD6_C4EE3E525421__INCLUDED_)
#define AFX_RADARCOMMUNICATIONBASE_H__04E7987A_6DB4_4E78_8BD6_C4EE3E525421__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000
#include "struct.h"

class CRadarCommunicationBase  
{
public:
	CRadarCommunicationBase();
	virtual ~CRadarCommunicationBase();
	float		m_startAngle;		//��ʼ�Ƕȣ�����
	float		m_stopAngle;		//�����Ƕȣ�ͬ��
	
	int		m_bitRate;			
	char	m_comDevice[50];	//com��
	char	m_ip[50];			//IP��ַ
	int		m_port;				//�˿ں�
	int     m_port1;
	EnumRadar m_radar;			//�״��Ʒ


	 int  StartRadar(void)			;
	 int  CloseRadar(void)			;
	 bool GetRawData(DataFrame * pData)	;
};

#endif // !defined(AFX_RADARCOMMUNICATIONBASE_H__04E7987A_6DB4_4E78_8BD6_C4EE3E525421__INCLUDED_)
