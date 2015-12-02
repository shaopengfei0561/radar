//Coordinate类头文件
#if !defined(COORDINATE_H)
#define COORDINATE_H
# include "struct.h"
class CCoordinate
{
	CWnd *pWnd;				//坐标所在的窗体指针
	int m_XLimit;			//横坐标界限
	int m_YLimit;			//纵坐标界限
	int m_XResolution;		//横坐标分度值
	int m_YResolution;		//纵坐标分度值
	COLORREF m_XYColor;		//坐标线颜色
	COLORREF m_BackColor;   //坐标平面底色
	
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