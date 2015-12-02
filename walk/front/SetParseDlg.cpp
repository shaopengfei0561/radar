// SetParseDlg.cpp : implementation file
//

#include "stdafx.h"
#include "RadarUI.h"
#include "SetParseDlg.h"
#include "struct.h"
#ifdef _DEBUG
#define new DEBUG_NEW
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif
 extern unsigned char g_config[100]; //外部变量传递页面的设置参数
/////////////////////////////////////////////////////////////////////////////
// CSetParseDlg dialog


CSetParseDlg::CSetParseDlg(CWnd* pParent /*=NULL*/)
	: CDialog(CSetParseDlg::IDD, pParent)
{
	//{{AFX_DATA_INIT(CSetParseDlg)
	m_minRange = _T("");
	m_maxRange = _T("");
	m_minAngle = _T("");
	m_maxAngle = _T("");
	m_mappingTime = _T("");
	m_remappingPeriod = _T("");
	m_backgroundOffset = _T("");
	m_adjacentJump = _T("");
	m_minWidth = _T("");
	m_maxStride = _T("");
	m_angleDeviation = _T("");
	m_lidarHeight = _T("");
	m_sensitivity = _T("");
	m_fusionWidth = _T("");
	m_fusionDeviation = _T("");
	m_carfusionfn = _T("");
	m_humanfusionfn = _T("");
	m_mincarwidth = _T("");
	m_flowinterval = _T("");
	m_fusionstep = _T("");
	m_minhumanwidth = _T("");
	//}}AFX_DATA_INIT
}


void CSetParseDlg::DoDataExchange(CDataExchange* pDX)
{
	CDialog::DoDataExchange(pDX);
	//{{AFX_DATA_MAP(CSetParseDlg)
	DDX_Text(pDX, IDC_EDIT_ALG_MORE_DETECT_MINRANGE, m_minRange);
	DDX_Text(pDX, ORE_DETECT_MAXRANGE, m_maxRange);
	DDX_Text(pDX, IDC_EDIT_ALG_MORE_DETECT_MINANGLE, m_minAngle);
	DDX_Text(pDX, IDC_EDIT_ALG_MORE_DETECT_MAXANGLE, m_maxAngle);
	DDX_Text(pDX, IDC_EDIT_ALG_MORE_DETECT_MAPPINGTIME, m_mappingTime);
	DDX_Text(pDX, IDC_EDIT_ALG_MORE_DETECT_MAPPINGPREIOD, m_remappingPeriod);
	DDX_Text(pDX, IDC_EDIT_ALG_MORE_DETECT_BACKGROUNDOFFSET, m_backgroundOffset);
	DDX_Text(pDX, IDC_EDIT_ALG_MORE_DETECT_ADJACENTJUMP, m_adjacentJump);
	DDX_Text(pDX, IDC_EDIT_ALG_MORE_DETECT_MINWIDTH, m_minWidth);
	DDX_Text(pDX, IDC_EDIT_ALG_MORE_DETECT_MAXSTRDE, m_maxStride);
	DDX_Text(pDX, IDC_EDIT_ALG_MORE_DETECT_ANGLEDEVIATION, m_angleDeviation);
	DDX_Text(pDX, IDC_EDIT_ALG_MORE_DETECT_LIDARHEIGHT, m_lidarHeight);
	DDX_Text(pDX, IDC_EDIT_ALG_MORE_DETECT_SENSITIVITY, m_sensitivity);
	DDX_Text(pDX, IDC_EDIT_ALG_MORE_DETECT_FUSHIONWIDTH, m_fusionWidth);
	DDX_Text(pDX, IDC_EDIT_ALG_MORE_DETECT_FUSIONDISTANCE, m_fusionDeviation);
	DDX_Text(pDX, IDC_EDIT_ALG_MORE_DETECT_CARFUSIONFN, m_carfusionfn);
	DDX_Text(pDX, IDC_EDIT_ALG_MORE_DETECT_HUMANFUSHIONFN, m_humanfusionfn);
	DDX_Text(pDX, IDC_EDIT_ALG_MORE_DETECT_MINCARWIDTH, m_mincarwidth);
	DDX_Text(pDX, IDC_EDIT_ALG_MORE_DETECT_FLOWINTERVAL, m_flowinterval);
	DDX_Text(pDX, IDC_EDIT_ALG_MORE_DETECT_FUSHIONSTEP, m_fusionstep);
	DDX_Text(pDX, IDC_EDIT_ALG_MORE_DETECT_MINHUMANWIDTH, m_minhumanwidth);
	//}}AFX_DATA_MAP
}


BEGIN_MESSAGE_MAP(CSetParseDlg, CDialog)
	//{{AFX_MSG_MAP(CSetParseDlg)
	ON_BN_CLICKED(IDC_OK, OnOk)
	ON_BN_CLICKED(IDC_CANNAL, OnCannal)
	//}}AFX_MSG_MAP
END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// CSetParseDlg message handlers
BOOL CSetParseDlg::OnInitDialog()
{    
	CDialog::OnInitDialog();
    m_minRange="1234";
    m_maxRange="50";
	m_minAngle="50";
	m_maxAngle="50";
	m_mappingTime="50";
	m_remappingPeriod="0";
	m_backgroundOffset="0";
	m_adjacentJump="50";
	m_minWidth="14564";
	m_maxStride="50";
	m_angleDeviation="50";
	m_lidarHeight="50";
	m_sensitivity="50";
	m_fusionWidth="50";
	m_fusionDeviation="50";
	m_carfusionfn="50";
	m_humanfusionfn="50";
	m_mincarwidth="50";
	m_flowinterval="50";
	m_fusionstep="50";
	m_minhumanwidth="50";
	UpdateData(FALSE);
   
	return TRUE;  
}
///////////////////////////////////////////////////////////////////////////////
void CSetParseDlg::OnOk() 
{
	// TODO: Add your control notification handler code here
   DetailedConfigInfo Configres; 
   UpdateData(TRUE);	
   int a[21];
   char end[2]="\0";
   a[0]=strlen(m_minRange);
   a[1]=strlen(m_maxRange);
   a[2]=strlen(m_minAngle);
   a[3]=strlen(m_maxAngle);
   a[4]=strlen(m_mappingTime);
   a[5]=strlen(m_remappingPeriod);
   a[6]=strlen(m_backgroundOffset);
   a[7]=strlen(m_adjacentJump);
   a[8]=strlen(m_minWidth);
   a[9]=strlen(m_maxStride);
   a[10]=strlen(m_angleDeviation);
   a[11]=strlen(m_lidarHeight);
   a[12]=strlen(m_sensitivity);
   a[13]=strlen(m_fusionWidth); 
   a[14]=strlen(m_fusionDeviation);
   a[15]=strlen(m_carfusionfn); 
   a[16]=strlen(m_humanfusionfn);
   a[17]=strlen(m_mincarwidth);
   a[18]=strlen(m_flowinterval);
   a[19]=strlen(m_fusionstep);
   a[20]=strlen(m_minhumanwidth);

   memcpy(Configres.parabuf,m_minRange,a[0]);
   memcpy(Configres.parabuf+a[0],m_maxRange,a[1]);
   memcpy(Configres.parabuf+a[0]+a[1],m_minAngle,a[2]);
   memcpy(Configres.parabuf+a[0]+a[1]+a[2],m_maxAngle,a[3]);
   memcpy(Configres.parabuf+a[0]+a[1]+a[2]+a[3],m_mappingTime,a[4]);
   memcpy(Configres.parabuf+a[0]+a[1]+a[2]+a[3]+a[4],m_remappingPeriod,a[5]);
   memcpy(Configres.parabuf+a[0]+a[1]+a[2]+a[3]+a[4]+a[5],m_backgroundOffset,a[6]);
   memcpy(Configres.parabuf+a[0]+a[1]+a[2]+a[3]+a[4]+a[5]+a[6],m_adjacentJump,a[7]);
   memcpy(Configres.parabuf+a[0]+a[1]+a[2]+a[3]+a[4]+a[5]+a[6]+a[7],m_minWidth,a[8]);
   memcpy(Configres.parabuf+a[0]+a[1]+a[2]+a[3]+a[4]+a[5]+a[6]+a[7]+a[8],m_maxStride,a[9]);
   memcpy(Configres.parabuf+a[0]+a[1]+a[2]+a[3]+a[4]+a[5]+a[6]+a[7]+a[8]+a[9],m_angleDeviation,a[10]);
   memcpy(Configres.parabuf+a[0]+a[1]+a[2]+a[3]+a[4]+a[5]+a[6]+a[7]+a[8]+a[9]+a[10],m_lidarHeight,a[11]);
   memcpy(Configres.parabuf+a[0]+a[1]+a[2]+a[3]+a[4]+a[5]+a[6]+a[7]+a[8]+a[9]+a[10]+a[11],m_sensitivity,a[12]);
   memcpy(Configres.parabuf+a[0]+a[1]+a[2]+a[3]+a[4]+a[5]+a[6]+a[7]+a[8]+a[9]+a[10]+a[11]+a[12],m_fusionWidth,a[13]);
   memcpy(Configres.parabuf+a[0]+a[1]+a[2]+a[3]+a[4]+a[5]+a[6]+a[7]+a[8]+a[9]+a[10]+a[11]+a[12]+a[13],m_fusionDeviation,a[14]);
   memcpy(Configres.parabuf+a[0]+a[1]+a[2]+a[3]+a[4]+a[5]+a[6]+a[7]+a[8]+a[9]+a[10]+a[11]+a[12]+a[13]+a[14],m_carfusionfn,a[15]);
   memcpy(Configres.parabuf+a[0]+a[1]+a[2]+a[3]+a[4]+a[5]+a[6]+a[7]+a[8]+a[9]+a[10]+a[11]+a[12]+a[13]+a[14]+a[15],m_humanfusionfn,a[16]);
   memcpy(Configres.parabuf+a[0]+a[1]+a[2]+a[3]+a[4]+a[5]+a[6]+a[7]+a[8]+a[9]+a[10]+a[11]+a[12]+a[13]+a[14]+a[15]+a[16],m_mincarwidth,a[17]);
   memcpy(Configres.parabuf+a[0]+a[1]+a[2]+a[3]+a[4]+a[5]+a[6]+a[7]+a[8]+a[9]+a[10]+a[11]+a[12]+a[13]+a[14]+a[15]+a[16]+a[17],m_flowinterval,a[18]);
   memcpy(Configres.parabuf+a[0]+a[1]+a[2]+a[3]+a[4]+a[5]+a[6]+a[7]+a[8]+a[9]+a[10]+a[11]+a[12]+a[13]+a[14]+a[15]+a[16]+a[17]+a[18],m_fusionstep,a[19]);
   memcpy(Configres.parabuf+a[0]+a[1]+a[2]+a[3]+a[4]+a[5]+a[6]+a[7]+a[8]+a[9]+a[10]+a[11]+a[12]+a[13]+a[14]+a[15]+a[16]+a[17]+a[18]+a[19],m_minhumanwidth,a[20]);
   memcpy(Configres.parabuf+a[0]+a[1]+a[2]+a[3]+a[4]+a[5]+a[6]+a[7]+a[8]+a[9]+a[10]+a[11]+a[12]+a[13]+a[14]+a[15]+a[16]+a[17]+a[18]+a[19]+a[20],end,1);
    memcpy(g_config,Configres.parabuf,sizeof(Configres.parabuf));
   // this->OnOk();
  AfxMessageBox("算法参数保存成功");
  delete this;
  CDialog::PostNcDestroy();
}
void CSetParseDlg::OnCannal() 
{
	// TODO: Add your control notification handler code here
		CSetParseDlg::OnCancel();
}
