// HuiTu.h : main header file for the HUITU application
//

#if !defined(AFX_HUITU_H__761C7AA2_9BF0_408A_BB4E_1249F57218AA__INCLUDED_)
#define AFX_HUITU_H__761C7AA2_9BF0_408A_BB4E_1249F57218AA__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

#ifndef __AFXWIN_H__
	#error include 'stdafx.h' before including this file for PCH
#endif

#include "resource.h"		// main symbols

/////////////////////////////////////////////////////////////////////////////
// CHuiTuApp:
// See HuiTu.cpp for the implementation of this class
//

class CHuiTuApp : public CWinApp
{
public:
	CHuiTuApp();

// Overrides
	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CHuiTuApp)
	public:
	virtual BOOL InitInstance();
	//}}AFX_VIRTUAL

// Implementation

	//{{AFX_MSG(CHuiTuApp)
		// NOTE - the ClassWizard will add and remove member functions here.
		//    DO NOT EDIT what you see in these blocks of generated code !
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
};


/////////////////////////////////////////////////////////////////////////////

//{{AFX_INSERT_LOCATION}}
// Microsoft Visual C++ will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_HUITU_H__761C7AA2_9BF0_408A_BB4E_1249F57218AA__INCLUDED_)
