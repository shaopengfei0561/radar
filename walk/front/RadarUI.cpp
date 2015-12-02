// RadarUI.cpp : Defines the class behaviors for the application.
//
#include "stdafx.h"
#include "RadarUI.h"
#include "RadarUIDlg.h"
//#pragma comment(lib, "SkinPPWTL.lib")

#ifdef _DEBUG
#define new DEBUG_NEW
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif

/////////////////////////////////////////////////////////////////////////////
// CRadarUIApp

BEGIN_MESSAGE_MAP(CRadarUIApp, CWinApp)
	//{{AFX_MSG_MAP(CRadarUIApp)
		// NOTE - the ClassWizard will add and remove mapping macros here.
		//    DO NOT EDIT what you see in these blocks of generated code!
	//}}AFX_MSG
	ON_COMMAND(ID_HELP, CWinApp::OnHelp)
END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// CRadarUIApp construction

CRadarUIApp::CRadarUIApp()
{
	// TODO: add construction code here,
	// Place all significant initialization in InitInstance
}


/////////////////////////////////////////////////////////////////////////////
// The one and only CRadarUIApp object

CRadarUIApp theApp;
/////////////////////////////////////////////////////////////////////////////
// CRadarUIApp initialization

BOOL CRadarUIApp::InitInstance()
{
	skinppLoadSkin(_T("FauxS-TOON.ssk"));		//blue.ssk为项目下的皮肤文件
	if (!AfxSocketInit())
	{
		AfxMessageBox(IDP_SOCKETS_INIT_FAILED);
		return FALSE;
	}

	AfxEnableControlContainer();

	// Standard initialization
	// If you are not using these features and wish to reduce the size
	//  of your final executable, you should remove from the following
	//  the specific initialization routines you do not need.

#ifdef _AFXDLL
	Enable3dControls();			// Call this when using MFC in a shared DLL
#else
	Enable3dControlsStatic();	// Call this when linking to MFC statically
#endif

	CRadarUIDlg dlg;
	m_pMainWnd = &dlg;
//		SetDialogBkColor(RGB(051,153,204), RGB(0, 0, 0));//天蓝
//	SetDialogBkColor(RGB(255,153,102), RGB(0, 0, 0));//土色
//	SetDialogBkColor(RGB(204,204,153), RGB(0, 0, 0));//土黄色
//	SetDialogBkColor(RGB(255,255,204), RGB(0, 0, 0));//土黄色
//	SetDialogBkColor(RGB(102,204,153), RGB(0, 0, 0));//土黄色
//	SetDialogBkColor(RGB(255,204,204), RGB(0, 0, 0));//土色
	SetDialogBkColor(RGB(204,245,204),RGB(0,0,0));//土色

	int nResponse = dlg.DoModal();



	if (nResponse == IDOK)
	{
		// TODO: Place code here to handle when the dialog is
		//  dismissed with OK
	}
	else if (nResponse == IDCANCEL)
	{
		// TODO: Place code here to handle when the dialog is
		//  dismissed with Cancel
	}

	// Since the dialog has been closed, return FALSE so that we exit the
	//  application, rather than start the application's message pump.
	return FALSE;
}
