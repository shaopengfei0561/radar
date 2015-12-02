#if !defined(AFX_CHAKDLG_H__32D9FF74_900F_4ED7_83BE_EC3F2CD08A68__INCLUDED_)
#define AFX_CHAKDLG_H__32D9FF74_900F_4ED7_83BE_EC3F2CD08A68__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000
// ChakDlg.h : header file
//

/////////////////////////////////////////////////////////////////////////////
// CChakDlg dialog

class CChakDlg : public CDialog
{
// Construction
public:
	CChakDlg(CWnd* pParent = NULL);   // standard constructor

// Dialog Data
	//{{AFX_DATA(CChakDlg)
	enum { IDD = IDD_DIALOG2 };
		// NOTE: the ClassWizard will add data members here
	//}}AFX_DATA


// Overrides
	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CChakDlg)
	protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV support
	//}}AFX_VIRTUAL

// Implementation
protected:

	// Generated message map functions
	//{{AFX_MSG(CChakDlg)
	virtual BOOL OnInitDialog();
	afx_msg void OnOk();
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
};

//{{AFX_INSERT_LOCATION}}
// Microsoft Visual C++ will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_CHAKDLG_H__32D9FF74_900F_4ED7_83BE_EC3F2CD08A68__INCLUDED_)
