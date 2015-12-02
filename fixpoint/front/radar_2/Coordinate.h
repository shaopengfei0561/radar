//Coordinate��ͷ�ļ�
#if !defined(COORDINATE_H)
#define COORDINATE_H
# include "struct.h"
class CCoordinate
{
	CWnd *pWnd;				//�������ڵĴ���ָ��
	int m_XLimit;			//���������
	int m_YLimit;			//���������
	int m_XResolution;		//������ֶ�ֵ
	int m_YResolution;		//������ֶ�ֵ
	COLORREF m_XYColor;		//��������ɫ
	COLORREF m_BackColor;   //����ƽ���ɫ
	
public:
	CCoordinate(CWnd *pwnd,int x,int y,int xl,int yl,COLORREF XYColor=0XFFFFFF,COLORREF BackColor=0X0)
	{
		pWnd=pwnd;
		m_XLimit=x;
		m_YLimit=y;
		m_XResolution=xl;
		m_YResolution=yl;
		m_XYColor=BackColor;
		m_BackColor=XYColor;

	}
	void DrawCoordinate(SYSPOINT vpoint[50000],unsigned long pointnum);
};


#endif