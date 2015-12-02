// RadarUIDlg.h : header file
//

#if !defined(AFX_RADARUIDLG_H__814CCB17_EB92_4F41_AFF7_881DB4FC6E3F__INCLUDED_)
#define AFX_RADARUIDLG_H__814CCB17_EB92_4F41_AFF7_881DB4FC6E3F__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000


/////////////////////////////////////////////////////////////////////////////
// CRadarUIDlg dialog
class CRadarUIDlg : public CDialog
{
// Construction
public:
	CRadarUIDlg(CWnd* pParent = NULL);	// standard constructor

// Dialog Data
	//{{AFX_DATA(CRadarUIDlg)
	enum { IDD = IDD_RADARUI_DIALOG };
		// NOTE: the ClassWizard will add data members here
	//}}AFX_DATA

	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CRadarUIDlg)
	protected:
	virtual void DoDataExchange(CDataExchange* pDX);	// DDX/DDV support
	//}}AFX_VIRTUAL

// Implementation
protected:
	HICON m_hIcon;
	// Generated message map functions
	//{{AFX_MSG(CRadarUIDlg)
	virtual BOOL OnInitDialog();
	afx_msg void OnSysCommand(UINT nID, LPARAM lParam);
	afx_msg void OnPaint();
	afx_msg HCURSOR OnQueryDragIcon();
	afx_msg void OnButton1();
	afx_msg void OnButton3();
	afx_msg void OnCannal();
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
};

//{{AFX_INSERT_LOCATION}}
// Microsoft Visual C++ will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_RADARUIDLG_H__814CCB17_EB92_4F41_AFF7_881DB4FC6E3F__INCLUDED_)
