#include "stdafx.h"
#include "Coordinate.h"

void CCoordinate::DrawCoordinate(SYSPOINT vpoint[50000],unsigned long pointnum)
{
	CRect rect;
	pWnd->GetClientRect(&rect);
	CDC *pDC=pWnd->GetDC();

	pDC->FillSolidRect(rect,m_BackColor);  //设置坐标平面底色

	pDC->SetMapMode(MM_ANISOTROPIC);
	pDC->SetWindowExt(m_XLimit,m_YLimit);
	pDC->SetViewportExt(rect.right,-rect.bottom);
	pDC->SetViewportOrg(0,rect.bottom);

	CPen* oldpen;
	CPen newpen(PS_DASHDOT,1,m_XYColor);
	oldpen=pDC->SelectObject(&newpen);

	//绘制纵坐标线
	for(int i=0;i<m_XLimit;i+=m_XResolution)
	{
		if(i)
		{
			pDC->MoveTo(i,0);
			pDC->LineTo(i,m_YLimit);
		}
	}
	//绘制横坐标线
	for(int j=0;j<m_YLimit;j+=m_YResolution)
	{
		if(j)
		{
			pDC->MoveTo(0,j);
			pDC->LineTo(m_YLimit,j);
		}
	}
	pDC->SelectObject(oldpen);
	
	for(i=0;i<pointnum;i++) 
	{
		pDC->SetPixel(((float)vpoint[i].x)/2000*1000,((float)vpoint[i].z)/1800*1000-400,RGB(255,0,0));
	}	
}