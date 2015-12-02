/*****************************************************************
*�ļ�����			AlgBase.h
*����������	        -
*����������	        -
*��˾����			�п�Ժ������������ҵ�о�Ժ
*��ǰ�汾�ţ�	    v1.0
*
*Copyright? 2009, �п�Ժ������������ҵ�о�Ժ All rights reserved.
*
*����			ʱ��					��ע
*zhangyong		2010-5-6
*
*˵��
	�㷨��ʾ���ࡣ
******************************************************************/
// AlgBase.h: interface for the CAlgBase class.
//
//////////////////////////////////////////////////////////////////////

#if !defined(AFX_ALGBASE_H__3741D831_DB1B_4C1E_9A6D_631658A24879__INCLUDED_)
#define AFX_ALGBASE_H__3741D831_DB1B_4C1E_9A6D_631658A24879__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

#include "struct.h"

#define PI 3.1415926

class CAlgBase  
{
public:
	CAlgBase();
	virtual ~CAlgBase();

public:
	
	//��ʼ���������û��㷨������Ϣ
//	virtual bool Initial( )	;

	/*
		����˵������ȡ�㷨���������㷨�ĵ����Դ�Ϊ�ӿڡ�
		����˵����pfrm ָ��ԭʼ����֡�ṹ���ָ�룬����ԭʼ���ݵ�����
				  buf  �������ṩ�������㷨������ݵĻ����ַ
				  length �������ṩ�����������ܳ��ȣ���λ���ֽڣ�
		����ֵ���㷨��������ݵĳ��ȣ���λ���ֽڣ�
	*/
	virtual int GetResult(int lidar1Data[2000][529], int lidar2Data[2000][529]) =0	;

};

#endif // !defined(AFX_ALGBASE_H__3741D831_DB1B_4C1E_9A6D_631658A24879__INCLUDED_)
