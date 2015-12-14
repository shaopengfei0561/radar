// ChakDlg.cpp : implementation file
//

#include "stdafx.h"
#include "RadarUI.h"
#include "ChakDlg.h"
#include "SetParseDlg.h"
#ifdef _DEBUG
#define new DEBUG_NEW
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif

/////////////////////////////////////////////////////////////////////////////
// CChakDlg dialog


CChakDlg::CChakDlg(CWnd* pParent /*=NULL*/)
	: CDialog(CChakDlg::IDD, pParent)
{
	//{{AFX_DATA_INIT(CChakDlg)
		// NOTE: the ClassWizard will add member initialization here
	//}}AFX_DATA_INIT
}


void CChakDlg::DoDataExchange(CDataExchange* pDX)
{
	CDialog::DoDataExchange(pDX);
	//{{AFX_DATA_MAP(CChakDlg)
		// NOTE: the ClassWizard will add DDX and DDV calls here
	//}}AFX_DATA_MAP
}


BEGIN_MESSAGE_MAP(CChakDlg, CDialog)
	//{{AFX_MSG_MAP(CChakDlg)
	ON_BN_CLICKED(IDC_OK, OnOk)
	//}}AFX_MSG_MAP
END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// CChakDlg message handlers

BOOL CChakDlg::OnInitDialog() 
{
	CDialog::OnInitDialog();
	
	// TODO: Add extra initialization here
		// TODO: Add extra initialization here
	   SetDlgItemText(IDC_IPADDRESS1,"10.13.13.165");	
	   SetDlgItemText(IDC_PORT,"3003");
	   SetDlgItemText(IDC_SAVEPATH,"c:\\Radar.zip");
	   SetDlgItemText(IDC_EDIT_ALG_MORE_DETECT_MINRANGE,"1234");
	   SetDlgItemText(ORE_DETECT_MAXRANGE,"50");
	   SetDlgItemText(IDC_EDIT_ALG_MORE_DETECT_MINANGLE,"50");
	   SetDlgItemText(IDC_EDIT_ALG_MORE_DETECT_MAXANGLE,"50");
	   SetDlgItemText(IDC_EDIT_ALG_MORE_DETECT_MAPPINGTIME,"50");
	   SetDlgItemText(IDC_EDIT_ALG_MORE_DETECT_MAPPINGPREIOD,"0");
	   SetDlgItemText(IDC_EDIT_ALG_MORE_DETECT_BACKGROUNDOFFSET,"0");
	   SetDlgItemText(IDC_EDIT_ALG_MORE_DETECT_ADJACENTJUMP,"50");
	   SetDlgItemText(IDC_EDIT_ALG_MORE_DETECT_MINWIDTH,"14564");
	   SetDlgItemText(IDC_EDIT_ALG_MORE_DETECT_MAXSTRDE,"50");
	   SetDlgItemText(IDC_EDIT_ALG_MORE_DETECT_MINHUMANWIDTH,"50");
	   SetDlgItemText(IDC_EDIT_ALG_MORE_DETECT_ANGLEDEVIATION,"50");
	   SetDlgItemText(IDC_EDIT_ALG_MORE_DETECT_LIDARHEIGHT,"50");
	   SetDlgItemText(IDC_EDIT_ALG_MORE_DETECT_SENSITIVITY,"50");
	     SetDlgItemText(IDC_EDIT_ALG_MORE_DETECT_FUSHIONWIDTH,"50");
	   SetDlgItemText(IDC_EDIT_ALG_MORE_DETECT_FUSIONDISTANCE,"50");
	   SetDlgItemText(IDC_EDIT_ALG_MORE_DETECT_CARFUSIONFN,"50");
	   SetDlgItemText(IDC_EDIT_ALG_MORE_DETECT_HUMANFUSHIONFN,"50");
	   SetDlgItemText(IDC_EDIT_ALG_MORE_DETECT_MINCARWIDTH,"50");
	   SetDlgItemText(IDC_EDIT_ALG_MORE_DETECT_FLOWINTERVAL,"50");
	   SetDlgItemText(IDC_EDIT_ALG_MORE_DETECT_FUSHIONSTEP,"50");
	return TRUE;  
	// return TRUE unless you set the focus to a control
    // EXCEPTION: OCX Property Pages should return FALSE
}

void CChakDlg::OnOk() 
{
	// TODO: Add your control notification handler code here
	CChakDlg::OnCancel();
}



