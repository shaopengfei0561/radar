#if !defined(AFX_SETPARSEDLG_H__8DAB7706_A459_4C7A_A9E8_391415F35EF4__INCLUDED_)
#define AFX_SETPARSEDLG_H__8DAB7706_A459_4C7A_A9E8_391415F35EF4__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000
// SetParseDlg.h : header file
//

/////////////////////////////////////////////////////////////////////////////
// CSetParseDlg dialog

class CSetParseDlg : public CDialog
{
// Construction
public:
	BOOL OnInitDialog();
	CSetParseDlg(CWnd* pParent = NULL);   // standard constructor

// Dialog Data
	//{{AFX_DATA(CSetParseDlg)
	enum { IDD = IDD_DIALOG_ALG_MORE_DETECT };
	CString	m_minRange;
	CString	m_maxRange;
	CString	m_minAngle;
	CString	m_maxAngle;
	CString	m_mappingTime;
	CString	m_remappingPeriod;
	CString	m_backgroundOffset;
	CString	m_adjacentJump;
	CString	m_minWidth;
	CString	m_maxStride;
	CString	m_angleDeviation;
	CString	m_lidarHeight;
	CString	m_sensitivity;
	CString	m_fusionWidth;
	CString	m_fusionDeviation;
	CString	m_carfusionfn;
	CString	m_humanfusionfn;
	CString	m_mincarwidth;
	CString	m_flowinterval;
	CString	m_fusionstep;
	CString	m_minhumanwidth;
	//}}AFX_DATA


// Overrides
	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CSetParseDlg)
	protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV support
	//}}AFX_VIRTUAL

// Implementation
protected:

	// Generated message map functions
	//{{AFX_MSG(CSetParseDlg)
	afx_msg void OnOk();
	afx_msg void OnCannal();
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
};

//{{AFX_INSERT_LOCATION}}
// Microsoft Visual C++ will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_SETPARSEDLG_H__8DAB7706_A459_4C7A_A9E8_391415F35EF4__INCLUDED_)
