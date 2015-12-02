//*******************************************************
//�汾��V3.3
//���汾ҪǶ�뵽���ڵ��㷨�����������ʹ��
//�����ö�������Ƶ��㷨�ӿںͽṹ��
//��Ҫʵ�ַ���ʶ���㷨
//���㷨���Լ��������Ƶ�ȿ���
//���㷨�ڷ����ϳ���ʵ�ֶ��ˡ��������г����ķ���
//*******************************************************

/*****************************************************************
*�ļ�����			CAlgClassify.h
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
�㷨��ʾ---ʶ���㷨��
******************************************************************/
// AlgClassify.h: interface for the CAlgClassify class.
//
//////////////////////////////////////////////////////////////////////

#if !defined(AFX_ALGCLASSIFY_H__7C1074B1_C2CC_4B62_B790_5683868007EA__INCLUDED_)
#define AFX_ALGCLASSIFY_H__7C1074B1_C2CC_4B62_B790_5683868007EA__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

#include "AlgBase.h"
	
//***************************************************************************
//һЩ�궨��
#define MAX_FRAME_NUM_CLA    50     //ԭʼ֡�����е����֡����
#define MAX_OBJECT_NUM_CLA    20     //���Ŀ������
#define BLDMAP_FRAME_NUM_CLA  15     //������ͼ����֡��
#define MAX_DATA_LENGTH_CLA  2200    //������ݳ���
#define MAX_OBJ_NUM_CLA      100     //���Ŀ������

namespace alg_classify
{
	//******************************************************
	//����һЩ�ṹ
	typedef struct _ClassifyConfigInfo
	{
		int ValidDistance;    //��Ч����
		int offset;           //����ƫ����
		int bldmapPeriod;	  //������ͼ���ڣ����ӣ�
		int lmsValue;		  //Ұ���޳���ֵ
		int stepValue;		  //��������
		float railspeed;		  //��������
	}ClassifyConfigInfo;
		
	//ԭʼ����֡���нṹ�壺
	typedef struct _DataFrameQueue
	{
		int curFrameNum;    //��ǰʵ�ʴ�ŵ�����֡��Ŀ
		DataFrame frame[MAX_FRAME_NUM_CLA];  //���ԭʼ����֡
	}DataFrameQueue;

	//ǰ���㼯��
	typedef struct _ForegroundPointSet
	{
		int pointNum;    //�����
		int lastNum;    //��һ֡�����
		int wholeNum;
		int step;
		SYSPOINT point[MAX_DATA_LENGTH_CLA];  //���ǰ����
	}ForegroundPointSet;

	//��ǰ֡Ŀ��
	typedef struct _CurObj
	{
		SYSTIME time;    //Ŀ�������ʱ��
		bool possess;   //�Ƿ�ռ�ã���Ŀ��ƥ��ʱʹ��
		SYSPOINT midPnt;   //���ĵ�����
		int pointNum;      //Ŀ����������
		int width;         //Ŀ����
		unsigned int timeid;        //ʱ��id��
	}CurObj; 

	//ע��Ŀ��
	typedef struct _RegisterObj
	{
		bool possess;   //�Ƿ�ռ�ã���Ŀ��ƥ��ʱʹ��
		SYSPOINT midPnt;   //���ĵ�����
		float angle;
		int distance;
		int minWidth,maxWidth,curWidth;  //��С��ȣ������,��ǰ���
		int minPntNum,maxPntNum,curPntNum;   //��С����������������ǰ����
		int maxMidPntShake;                  //������ĵ㶶��
		unsigned int startID,stopID;              //��ʼID������ID
		int lastFrmNum;                  //����֡��
		int type;                        //���� 1���� 2����   0������	
	}RegisterObj; 

	//������׼ƫ����
	typedef struct _CoordiShift
	{
		float lidar1angle[14];
		float lidar2angle[14];
		int coorshift[14];
	}CoordiShift; 
	
	//***************************************************************************
	//����һЩȫ�ֺ���
	
	//����������ʱ��������λ�����ӣ�
	int CmptTimeDif(SYSTIME time1,SYSTIME time2);
	//����������ʱ��������λ�����ӣ�
	int CmptTimeDifms(SYSTIME time1,SYSTIME time2);
	//�����������������ȫ�ֺ���
	float CmptDistance(SYSPOINT pt1, SYSPOINT pt2);
	//��������ռ����������ȫ�ֺ���
	float CmptSpaceDistance(int x1, int y1, int z1, int x2, int y2, int z2);
	//�����Ƚϴ�С����
	int MinValue(int a,int b); 
	//*********************************************************************	
	class CAlgClassify : public CAlgBase  
	{
	public:
		CAlgClassify();
		virtual ~CAlgClassify();
		
		void InternalInitial();             //�ڲ�������ʼ���������㷨������Ϣ��
		int jianditu;
		bool JudgeCrossBorder(int x,int y,int z);
		long int m_Num;
		SYSPOINT m_Vpoint[3000000];				//���Ƶ㼯
		
		ForegroundPointSet m_FogrdPntSet;		//ǰ���㼯
		/*
		����˵������ȡ�㷨���������㷨�ĵ����Դ�Ϊ�ӿڡ�
		����˵����pfrm ָ��ԭʼ����֡�ṹ���ָ�룬����ԭʼ���ݵ�����
		buf  �������ṩ�������㷨������ݵĻ����ַ
		length �������ṩ�����������ܳ��ȣ���λ���ֽڣ�
		����ֵ���㷨��������ݵĳ��ȣ���λ���ֽڣ�
		*/
		int GetResult(int lidar1Data[2000][529], int lidar2Data[2000][529]);

	protected:
		int m_nOutFreq;                 //���Ƶ��
		unsigned int m_nCurAlarmID;     //��ǰ����֡ID
		unsigned int m_nPastAlarmID;    //��ȥ����֡ID

		CoordiShift lidarshift;			//������׼ƫ����

		int m_BackOffset[MAX_DATA_LENGTH_CLA];                     //����ƫ��������

		ClassifyConfigInfo m_CfgInfo;   //�㷨�����������Ϣ
		
		DataFrameQueue m_DataFrameQueue;  //ԭʼ����֡����
		DataFrame * m_pCurDataFrame;          //ָ��ǰ����֡��ָ��
		
		int m_nStdDataLength;                //��׼���ݳ���
		bool m_bHaveStdDataLength;             //�Ƿ��ȡ�˱�׼���ݳ���
		
		float m_fStartAngle;					//��ʼ�Ƕȣ���λ�����ȣ�
		float m_fStopAngle;						//��ֹ�Ƕȣ���λ�����ȣ�
		float m_fAngleStep;						//�ǶȲ���
		
		int m_nSplitIndex[MAX_DATA_LENGTH_CLA];    //��ǰ���㼯�ķָ�����
		int m_nSplitNum;                        //�ָ������ĸ����������ж��ٸ�����Ŀ��㼯

		CurObj m_CurObj[MAX_OBJ_NUM_CLA];             //��ǰ֡Ŀ������
		int m_nCurObjNum;								//��ǰ֡Ŀ����Ŀ

		RegisterObj m_RegisterObj[MAX_OBJ_NUM_CLA];   //ע��Ŀ������
		int m_nRegisterObjNum;                        //ע��Ŀ����Ŀ
		int m_volume;						//����
		//******************************************************************		
		void InputData(SecDataFrame * pfrm);		 //��ԭʼ������ӽ�����֡������
		void OutQueue(int num);						 //�������֡�����е�ǰ����֡
		void ClearQueue();							 //�������֡����
		
		bool PreProcess();							 //Ԥ��������֡�����еĵ�ǰ֡

		int GetWarningResult();						//��ȡ�������
				
		void SplitObject();							//��ǰ����ָ��Ŀ��
		void GetCurObj();							//������ǰ֡Ŀ��
		bool JudgeObj(CurObj *);					//�ж���Ŀ��
		int  FillPoint();

		void UpdateRegisterObj();						  //����ע��Ŀ��
		void FirstRegister(RegisterObj *,CurObj *);       //��һ������ע��Ŀ��
		void AddRegister(RegisterObj *,CurObj *);         //��������ע��Ŀ��
		bool JudgeSameObj(RegisterObj *,CurObj *);	 //�ж�ΪͬĿ��
		
		void ClassifyRObj();						//��ע��Ŀ����з���ʶ��
		int JudgeObjType(RegisterObj *);			//�ж�Ŀ������
				
		void RemoveExpiredRObj();					//�����ڵ�ע��Ŀ��ȥ��

		/*������̨�״�������׼�Ĳ���*/
		int lengtha1;
		int lengthb1;
		
		/*����Ŀ���߶�֡���ں�*/
		int fusionwidth;			
	};
}
#endif // !defined(AFX_ALGCLASSIFY_H__7C1074B1_C2CC_4B62_B790_5683868007EA__INCLUDED_)
