#if !defined(AFX_PEIZDLG_H__599E5C5E_62CB_48D3_A495_F9F4F8E4EBB0__INCLUDED_)
#define AFX_PEIZDLG_H__599E5C5E_62CB_48D3_A495_F9F4F8E4EBB0__INCLUDED_

#define WM_SERVER_ACCEPT WM_USER+99


#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000
// PeizDlg.h : header file

#include "struct.h"
#include <vector>
/////////////////////////////////////////////////////////////////////////////
// CPeizDlg dialog

class CPeizDlg : public CDialog
{
	// Construction
public:
	
	CPeizDlg(CWnd* pParent = NULL);   // standard constructor
	
	void InitStartRadar();
	void StartRail();
	void StartRadar();
    int MaxValue(int a,int b);
	int MinValue(int a,int b);
	void Paint(SYSPOINT vpoint[50000], unsigned long pointnum);
	bool ProcessData(char * recvBuf,int size,RailDataFrame * sData,unsigned long LoadDataNum);
	void SetTagBuffer(unsigned char tag);
	bool CheckStartTag();
	void ReSetTagBuffer();
	bool CheckStopTag();
	bool LoadData(RailDataFrame *pData);
	void ClearRawData();
	bool CheckSum();
	unsigned char CheckFrmSum(char buf[9]);
	std::vector <unsigned char> m_rawDataBuff;
	// Dialog Data
	//{{AFX_DATA(CPeizDlg)
	enum { IDD = IDD_DIALOG1 };
	CListBox	m_data;
	CEdit	m_ctrlSavePath;
	int		m_port;
	int     m_port1;
	int		m_port2;
	int     m_port3;
	//}}AFX_DATA
	
	
	// Overrides
	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CPeizDlg)
protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV support
	//}}AFX_VIRTUAL
	
	// Implementation
protected:
	
	// Generated message map functions
	//{{AFX_MSG(CPeizDlg)
	virtual BOOL OnInitDialog();
	afx_msg void OnCannal();
	afx_msg void OnButtonStartradar();
	afx_msg void OnSetRes();
	virtual void OnOK();
	afx_msg void OnPaint();
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
	HICON m_hIcon;
private:
	void AddData2(CString str);
	void AddData1();
	int  InitWebsocket();
	CString m_strCurInfo;	//��ǰ��Ϣ
	CTime m_CurTime;	//��ǰ���ڡ�ʱ��
	CString m_strCurTime;	//��ǰ���ڡ�ʱ����ַ�������
	int m_nInsertPos;		//�б���еĴ�����λ��
	char revflag;
	char resendnum;
    unsigned long  FitNum;
	unsigned long  LoadDataNum;
	unsigned long  LoadDataNum1;
	unsigned long  LoadDataNum2;
	unsigned long  LoadDataNum3;
	SOCKET m_socket;
	
	SOCKET Client[100];
	int Client_num;
	LRESULT OnAccept(WPARAM   wParam,   LPARAM   lParam);
	
	int stop; //�˳�ָ��
	//Add by Mike
	SOCKADDR_IN m_sockClientAddr;
	BOOL m_IsLink;
	//	BOOL m_bClient;
	//	BOOL m_bInit;
	//	CFile *m_rFile;//�ļ�ָ��
	// SOCKET sockClient;
	//	SOCKET m_socket_Radar;
	bool findStartTag;	//�Ƿ��ҵ���ʼ��־
	bool findStopTag;	//�Ƿ��ҵ�������־
	
	unsigned char tagBuffer[4];
	int tagBufferNumber;
};

//{{AFX_INSERT_LOCATION}}
// Microsoft Visual C++ will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_PEIZDLG_H__599E5C5E_62CB_48D3_A495_F9F4F8E4EBB0__INCLUDED_)
