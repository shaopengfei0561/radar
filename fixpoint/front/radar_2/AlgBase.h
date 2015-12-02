/*****************************************************************
*文件名：			AlgBase.h
*处理器名：	        -
*编译器名：	        -
*公司名：			中科院无锡物联网产业研究院
*当前版本号：	    v1.0
*
*Copyright? 2009, 中科院无锡物联网产业研究院 All rights reserved.
*
*作者			时间					备注
*zhangyong		2010-5-6
*
*说明
	算法演示基类。
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
	
	//初始化，根据用户算法配置信息
//	virtual bool Initial( )	;

	/*
		函数说明：获取算法运算结果。算法的调用以此为接口。
		参数说明：pfrm 指向原始数据帧结构体的指针，用于原始数据的输入
				  buf  调用者提供的用于算法输出数据的缓存地址
				  length 调用者提供的输出缓存的总长度（单位：字节）
		返回值：算法输出的数据的长度（单位：字节）
	*/
	virtual int GetResult(int lidar1Data[2000][529], int lidar2Data[2000][529]) =0	;

};

#endif // !defined(AFX_ALGBASE_H__3741D831_DB1B_4C1E_9A6D_631658A24879__INCLUDED_)
