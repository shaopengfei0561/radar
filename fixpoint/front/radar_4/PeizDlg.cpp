// PeizDlg.cpp : implementation file
//
//#include <winsock.h>
#include "stdafx.h"
#include "RadarUI.h"
#include "RadarEnumMap.h"
#include "LeuzeSocketComm.h"
#include "AlgClassify.h"
#include "RadarCommunicationBase.h"
#include "PeizDlg.h"
#include "Coordinate.h"
#include "math.h"
//     #include <Afxsock.h>
#include "io.h"
#include "SetParseDlg.h"
#include "YTController.h"
#ifdef _DEBUG
#define new DEBUG_NEW
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif
using namespace alg_classify;
int ret1,ret2,ret3,ret4;
int Wbeset;
int sendflag;
/////////////////////////////////////////////////////////////////////////////
// CPeizDlg dialog
unsigned char g_config[100];
YTController ytControllor;
typedef struct _RECVPARAM
{
	SOCKET sock;
	HWND hwnd;
}RECVPARAM;

CPeizDlg::CPeizDlg(CWnd* pParent /*=NULL*/)
	: CDialog(CPeizDlg::IDD, pParent)
{
	//{{AFX_DATA_INIT(CPeizDlg)
	m_port = 0;
	m_port1 = 0;
	m_port2 = 0;
	m_port3 = 0;
	//}}AFX_DATA_INIT
	m_nInsertPos = 0;
}

void CPeizDlg::DoDataExchange(CDataExchange* pDX)
{
	CDialog::DoDataExchange(pDX);
	//{{AFX_DATA_MAP(CPeizDlg)
	DDX_Control(pDX, IDC_LIST1, m_data);
	DDX_Control(pDX, IDC_EDIT6, m_ctrlSavePath);
	DDX_Text(pDX, IDC_PORT, m_port);
	DDX_Text(pDX, IDC_PORT1, m_port1);
	DDX_Text(pDX, IDC_PORT2, m_port2);
	DDX_Text(pDX, IDC_PORT3, m_port3);
	//}}AFX_DATA_MAP
}

BEGIN_MESSAGE_MAP(CPeizDlg, CDialog)
	//{{AFX_MSG_MAP(CPeizDlg)
	ON_BN_CLICKED(IDC_BUTTON2, OnCannal)
	ON_BN_CLICKED(IDC_BUTTON_STARTRADAR, OnButtonStartradar)
	ON_BN_CLICKED(IDC_BUTTON1, OnSetRes)
	ON_MESSAGE(WM_SERVER_ACCEPT,OnAccept) 
	ON_WM_PAINT()
	//}}AFX_MSG_MAP
END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// CPeizDlg message handlers
CString CRadarEnumMap::m_appErrorArray[10]={"�ɹ�"
											,"����δ֪����"	
											,"�״�û�г�ʼ��"
											,"�״�����ʧ��"
											,"���ݿ��ʼ������"
											,"ini�ļ�δ����"			//5
											,"�������"
											,"ͨ��ģ���ʼ������"
											,"��INI�ļ������״�ʧ��"
											,"��ʼ���㷨ʧ��"
											}; 

BOOL CPeizDlg::OnInitDialog() 
{
	CDialog::OnInitDialog();
	m_port=GetPrivateProfileInt("LidarIp","LidarPort1",0,".\\LidarConfig.ini"); 
	m_port1=GetPrivateProfileInt("LidarIp","LidarPort2",0,".\\LidarConfig.ini"); 
	m_port2=GetPrivateProfileInt("LidarIp","LidarPort3",0,".\\LidarConfig.ini");
	m_port3=GetPrivateProfileInt("LidarIp","LidarPort4",0,".\\LidarConfig.ini");
    UpdateData(FALSE); 

	char strip[16];
	GetPrivateProfileString("LidarIp","LidarIP1","", strip,sizeof(strip), ".\\LidarConfig.ini");
	char strip1[16];
	GetPrivateProfileString("LidarIp","LidarIP2","", strip1,sizeof(strip1), ".\\LidarConfig.ini");
	char strip2[16];
	GetPrivateProfileString("LidarIp","LidarIP3","", strip2,sizeof(strip2), ".\\LidarConfig.ini");
	char strip3[16];
	GetPrivateProfileString("LidarIp","LidarIP4","", strip3,sizeof(strip3), ".\\LidarConfig.ini");

	CString savepath="C:\\Radar\\YTdata.txt";
	SetDlgItemText(IDC_SavaPath,savepath);
	SetDlgItemText(IDC_IPADDRESS,strip); 
	SetDlgItemText(IDC_IPADDRESS1,strip1);
	SetDlgItemText(IDC_IPADDRESS2,strip2); 
	SetDlgItemText(IDC_IPADDRESS3,strip3);

    FitNum=1;								//����ʱ����֡��
	LoadDataNum=1;							//�״�����֡����
	LoadDataNum1=1;							//�״�����֡����
	stop=-1;								//��ʼ��ָֹͣ��
	tagBufferNumber=0;
	findStartTag=0;
	revflag=0;
	resendnum=0;
	m_lidar1CurID=0;
	m_lidar2CurID=0;
	m_lidar3CurID=0;
	m_lidar4CurID=0;
	//һ������
	//OnButtonStartradar();
/*
		if (ytControllor.ierr == 0)
		{
			m_strCurInfo="������̨���ӳɹ�";
			AddData1();
			if (ytControllor.ScanStorage(1) == 0)
			{
				m_strCurInfo="��λɨ��ɹ�";
				AddData1();
			}
			else
			{
				m_strCurInfo="��λɨ��ʧ��";
				AddData1();
			}
		}
		else
		{
			m_strCurInfo="������̨����ʧ�ܣ����鴮������";
			AddData1();
		}
*/
	return TRUE; 
}

void CPeizDlg::OnCannal() 
{   
	if(ret1==-1||ret2==-1||stop==0||stop==-1)
	{
		CPeizDlg::OnCancel();
		closesocket(m_socket); 
	}
    stop=1;
}
void CPeizDlg::OnSetRes() 
{
	// TODO: Add your control notification handler code here
    CSetParseDlg *pDlg=new CSetParseDlg;
    pDlg->Create(IDD_DIALOG_ALG_MORE_DETECT,this);
	pDlg->ShowWindow(SW_SHOW);	

}

DWORD   WINAPI mythread(LPVOID   lParam);
DWORD   WINAPI mythread1(LPVOID   lParam);

//int TTT��
void CPeizDlg::StartRadar() 
{  
	Wbeset=InitWebsocket();				//������������socket������matlab�ͻ���
	if(Wbeset==1)
	{
		HANDLE handle1;
		DWORD nThreadId1=0;
		handle1=CreateThread(NULL,0,mythread1,(LPVOID)this,0,&nThreadId1);
		CloseHandle(handle1);
		Sleep(1000);

		HANDLE handle;
		DWORD nThreadId=0;
		handle=CreateThread(NULL,0,mythread,(LPVOID)this,0,&nThreadId);
		CloseHandle(handle);
		Sleep(1000);
	}	
}

void CPeizDlg::OnButtonStartradar() 
{   
	Wbeset=InitWebsocket();				//������������socket������matlab�ͻ���
	if(Wbeset==1)
	{
		HANDLE handle1;
		DWORD nThreadId1=0;
		handle1=CreateThread(NULL,0,mythread1,(LPVOID)this,0,&nThreadId1);
		CloseHandle(handle1);
		Sleep(1000);

		HANDLE handle;
		DWORD nThreadId=0;
		handle=CreateThread(NULL,0,mythread,(LPVOID)this,0,&nThreadId);
		CloseHandle(handle);
		Sleep(1000);
	}	
}
int CPeizDlg::MaxValue(int a,int b) 
{
	int max;
	max=a;
	if (max<b)max=b;
	return max;
}
int CPeizDlg::MinValue(int a,int b) 
{
	int min;
	min=a;
	if (min>b)min=b;
	return min;
}
void CPeizDlg::StartRail() 
{
	char recvBuf[256];
	RailDataFrame  *sData= new RailDataFrame;	//��������
	int clientlength;
	while(1)
	{
	  redata: 
		for(int i=0;i<Client_num;i++)
		{
			clientlength=recv(Client[i], (char*)recvBuf,256,0);
			if(clientlength>0)
			{
				ProcessData(recvBuf,clientlength, sData,LoadDataNum);
				goto redata;
			}
		}
	}
}
void CPeizDlg::InitStartRadar() 
{
	//    DetailedConfigInfo Configres;
	
	SYSTEMTIME startime;
	HardConfigInfo *cfgInfo=new HardConfigInfo;
	CLeuzeSocketComm app;
	CAlgClassify *Alg=new CAlgClassify;
	SecDataFrame  *pData= new SecDataFrame;		//4̨�״�����
    DataFrame  *pData1= new DataFrame;			//�����״�1������
	DataFrame  *pData2= new DataFrame;			//�����״�2������
	DataFrame  *pData3= new DataFrame;			//�����״�3������
	DataFrame  *pData4= new DataFrame;			//�����״�4������
	int lidar1Data[2000][529];
	int lidar2Data[2000][529];
	int lidar3Data[2000][529];
	int lidar4Data[2000][529];
	RailDataFrame  *sData= new RailDataFrame;	//��������
	char buf[1100];
	char mbuf[9];
	int k,lenpet;

	//ytControllor.ScanStorage(1);
	
	//��ȡ�Ի����ip�Ͷ˿ں�
    CString ip1,ip2,ip3,ip4,SavePath;
    int port1;
	int port2;
	int port3;
	int port4;
    GetDlgItemText(IDC_IPADDRESS,ip1);			//��ȡ�Ի���1IP
    port1=GetDlgItemInt(IDC_PORT);				//��ȡ�Ի���1port

	GetDlgItemText(IDC_IPADDRESS1,ip2);			//��ȡ�Ի���2IP
    port2=GetDlgItemInt(IDC_PORT1);				//��ȡ�Ի���2port

	GetDlgItemText(IDC_IPADDRESS2,ip3);			//��ȡ�Ի���3IP
    port3=GetDlgItemInt(IDC_PORT2);				//��ȡ�Ի���3port

	GetDlgItemText(IDC_IPADDRESS3,ip4);			//��ȡ�Ի���4IP
    port4=GetDlgItemInt(IDC_PORT3);				//��ȡ�Ի���4port

    GetDlgItemText(IDC_SavaPath,SavePath);		//��ȡ�Ի������ݱ����ַ
recv:
	m_strCurInfo="���������״�";
	AddData1();
	ret1=app.StartRadar(1,SavePath,ip1,port1);
	ret2=app.StartRadar(2,SavePath,ip2,port2);
	ret3=app.StartRadar(3,SavePath,ip3,port3);
	ret4=app.StartRadar(4,SavePath,ip4,port4);
	
    //����������Ŀ¼��
	Alg->InternalInitial();
	if(ret1==-1 || ret2==-1 || ret3==-1 || ret4==-1)
	{      
		if(ret1==-1)
		{
			m_strCurInfo.Format("����"+ip1+"�״����������Ϣ��%s",CRadarEnumMap::m_appErrorArray[-ret1]);	
			AddData1();
			Sleep(1000);
			goto recv;
		}
		else if (ret2==-1)
		{
			m_strCurInfo.Format("����"+ip2+"�״����������Ϣ��%s",CRadarEnumMap::m_appErrorArray[-ret2]);	
			AddData1();
			Sleep(1000);
			goto recv;
		}
		else if (ret3==-1)
		{
			m_strCurInfo.Format("����"+ip3+"�״����������Ϣ��%s",CRadarEnumMap::m_appErrorArray[-ret3]);	
			AddData1();
			Sleep(1000);
			goto recv;
		}
		else if (ret4==-1)
		{
			m_strCurInfo.Format("����"+ip4+"�״����������Ϣ��%s",CRadarEnumMap::m_appErrorArray[-ret4]);	
			AddData1();
			Sleep(1000);
			goto recv;
		}
		
	}
	else if(ret1==-2||ret2==-2||ret3==-2||ret4==-2)
	{
		m_strCurInfo="�����������ݵ��ļ���C:\\Radar";
		AddData1();
			Sleep(1000);
		goto recv;
	}
	else if(ret1 ==1&&ret2==1&&ret3==1&&ret4==1)
	{
		m_strCurInfo="�״������ɹ�";
		AddData1();	
	}
	else if (ret1==0||ret2==0||ret3==0||ret4==0)
	{
		m_strCurInfo="û���ҵ��״����";
		AddData1();	
		Sleep(1000);
		goto recv;
	}
	int  length=0;
	int flag=0;
	CString DataNum,Fnum;
    stop=2;//�ܿ�����ʱ������Ϊ�ر�ֵ-1��
	Alg->jianditu=1;
	while(1)
	{
	  redata:

		app.GetRawData(1,pData1,LoadDataNum++);  //��ȡ�״�1ԭʼ����
		app.GetRawData(2,pData2,LoadDataNum1++); //��ȡ�״�2ԭʼ����
		app.GetRawData(3,pData3,LoadDataNum2++); //��ȡ�״�3ԭʼ����
		app.GetRawData(4,pData4,LoadDataNum3++); //��ȡ�״�4ԭʼ����
		
		if(pData2->time.nMilliseconds<0)
		{
			m_strCurInfo="�״�"+ip2+"��ȡ���ݳ��������״�";
			AddData1();
			Sleep(1000);
			goto redata;
		}
		else if(pData3->time.nMilliseconds<0)
		{
			m_strCurInfo="�״�"+ip3+"��ȡ���ݳ��������״�";
			AddData1();
			Sleep(1000);
			goto redata;
		}
		else if(pData4->time.nMilliseconds<0)
		{
			m_strCurInfo="�״�"+ip4+"��ȡ���ݳ��������״�";
			AddData1();
			Sleep(1000);
			goto redata;
		}
		else if(pData1->time.nMilliseconds<0)
		{
			m_strCurInfo="�״�"+ip1+"��ȡ���ݳ��������״�";
			AddData1();
			Sleep(1000);
			goto redata;
		}
		
		flag++;
		if(flag % 1 !=0)
		{
			LoadDataNum--;
			LoadDataNum1--;
			LoadDataNum2--;
			LoadDataNum3--;
			goto redata;
		}

		length=0;
 
		if(m_savFlag1==1||m_savState1==1||m_savFlag2==1||m_savState2==1
		||m_savFlag3==1||m_savState3==1||m_savFlag4==1||m_savState4==1)	
		{
			if(m_savState1==0||m_savState2==0||m_savState3==0||m_savState4==0)
			{
				m_nCurID=0;
				m_storeNum=m_savNum;
				m_savState1=1;
				m_savState2=1;
				m_savState3=1;
				m_savState4=1;
				m_lidar1CurID=0;
				m_lidar2CurID=0;
				m_lidar3CurID=0;
				m_lidar4CurID=0;

				//���Ϳ�ʼɨ���λ��Ϣ
				mbuf[0]=0xdf;
				mbuf[1]=0xdf;
				mbuf[2]=0xdf;
				mbuf[3]=0xdf;
				mbuf[4]=0x03;
				mbuf[5]=0x09;
				mbuf[6]=0x00;
				mbuf[7]=m_storeNum;
				mbuf[8]=CheckFrmSum(mbuf);
				lenpet=mbuf[5]+mbuf[6]*256;
				for(int i=0;i<Client_num;i++)
				k=send(Client[i],mbuf,lenpet,0);

				GetLocalTime(&startime);
				initime.nYear=startime.wYear;
				initime.nMonth=startime.wMonth;
				initime.nDayOfWeek=startime.wDayOfWeek;
				initime.nDay=startime.wDay;
				initime.nHour=startime.wHour;
				initime.nMinute=startime.wMinute;
				initime.nSecond=startime.wSecond;
				initime.nMilliseconds=startime.wMilliseconds;					
			}

			m_nCurID++;
			
			if(m_savFlag1==1)
			{				
				for(int i=0;i<528;i++)
				{					
					lidar1Data[m_lidar1CurID][i]=pData1->data[i];									
				}
				m_lidar1CurID++;
			}
			
			if(m_savFlag2==1)
			{			
				for(int i=0;i<528;i++)
				{					
					lidar2Data[m_lidar2CurID][i]=pData2->data[i];									
				}
				m_lidar2CurID++;
			}

			if(m_savFlag3==1)
			{			
				for(int i=0;i<528;i++)
				{					
					lidar3Data[m_lidar3CurID][i]=pData3->data[i];									
				}
				m_lidar3CurID++;
			}

			if(m_savFlag4==1)
			{			
				for(int i=0;i<528;i++)
				{					
					lidar4Data[m_lidar4CurID][i]=pData4->data[i];									
				}
				m_lidar4CurID++;
			}
		}
		/*	
		DataNum.Format("%d",m_nCurID);
	    m_strCurInfo=DataNum+"֡����";
		AddData1();	
		*/
		if(m_sndFlag==1)
		{    
			//��ʼ���ݴ���
			length=Alg->GetResult(lidar1Data,lidar2Data,lidar3Data,lidar4Data);		//������������

			DataNum.Format("%f %f",scanPosInfo[0],scanPosInfo[1]);
			m_strCurInfo=DataNum+"ɨ��Ƕ�";
			AddData1();	
			DataNum.Format("%f %f",scanPosInfo[2],scanPosInfo[3]);
			m_strCurInfo=DataNum+"ɨ��Ƕ�";
			AddData1();	

			DataNum.Format("%f %f",scanPosInfo[4],scanPosInfo[5]);
			m_strCurInfo=DataNum+"ɨ��Ƕ�";
			AddData1();	

			DataNum.Format("%f %f",scanPosInfo[6],scanPosInfo[7]);
			m_strCurInfo=DataNum+"ɨ��Ƕ�";
			AddData1();	

			m_lidar1CurID=0;
			m_lidar2CurID=0;
			m_lidar3CurID=0;
			m_lidar4CurID=0;
			

			//���Ϳ�ʼ�㷨��������
			buf[0]=0xdf;
			buf[1]=0xdf;
			buf[2]=0xdf;
			buf[3]=0xdf;
			buf[4]=0x02;
			buf[5]=0x08;
			buf[6]=0x00;
			buf[7]=0x0a;
		
			lenpet=buf[5]+buf[6]*256;
			for(int i=0;i<Client_num;i++)
			k=send(Client[i],buf,lenpet,0);
			
			/*
			Sleep(500);
			while(revflag!=1&&resendnum<3)		//���û���յ�matlab�ķ������ط�����
			{
				for(int i=0;i<Client_num;i++)
				k=send(Client[i],buf,lenpet,0);
				Sleep(100);
				resendnum++;
			}
			*/
			
			revflag=0;							//�յ�matlab�ķ�����־λ					
			resendnum=0;						//�ط�������־
			m_sndFlag=0;						//ɨ����ϱ�־
		}
		
		if(stop==1)
		{
			stop=0;
			break;
		}//�ر�����
	}
	OnCannal();
}
DWORD   WINAPI mythread(LPVOID   lParam)
{
	CPeizDlg *pMyClass=(CPeizDlg *)lParam; 
	pMyClass->InitStartRadar();
	return 0;
}

DWORD   WINAPI mythread1(LPVOID   lParam)
{
	CPeizDlg *pMyClass=(CPeizDlg *)lParam; 
	pMyClass->StartRail();
	return 0;
}

DWORD   WINAPI ReadThreadProc(LPVOID   pParam);
int CPeizDlg::InitWebsocket()
{
 //��ʼ����󶨷����� 
	WSADATA   wsaData; 
	Client_num=0;

	int   iErrorCode; 
	if   (WSAStartup(MAKEWORD(2,2),&wsaData))   //����Windows   Sockets   DLL 
	{   
		m_strCurInfo="��ʼ�׽���ʧ��";
		AddData1();
		WSACleanup(); 
		return 0;
	} 
	else
	{
		m_strCurInfo="��������ʼ����SOCKET";
		AddData1();
	}
	m_socket=WSASocket(PF_INET,SOCK_STREAM,0,NULL,0,0);//������������Socket������ΪSOCK_STREAM���������ӵ�ͨ�� 
	if(m_socket==INVALID_SOCKET) 
	{ 
		m_strCurInfo="�޷�����������SOCKET";
		AddData1();
		WSACleanup(); 
		return 0;
	} 
	SOCKADDR_IN sockServerAddr;
	sockServerAddr.sin_family =AF_INET; 
	sockServerAddr.sin_addr.s_addr=htonl(INADDR_ANY);   //INADDR_ANY;       //�����е�IP��ַ������Ϣ 
	sockServerAddr.sin_port= htons(7009); 
	
	if(bind(m_socket,(LPSOCKADDR)&sockServerAddr,sizeof(sockServerAddr))   ==   SOCKET_ERROR)   //��ѡ���Ķ˿ڰ� 
	{ 
		m_strCurInfo="�޷��󶨷�����";
		AddData1();
		closesocket(m_socket); 
		WSACleanup(); 
		return 0;
	} 
	else
	{
		m_strCurInfo="�������˿�:7009";
		AddData1();
	}

	if (listen(m_socket,100)==SOCKET_ERROR)   
	{ 
		m_strCurInfo="����������ʧ��";
		AddData1();
		return 0;
	} 
	else
	{
		m_strCurInfo="�������󶨼����ɹ�";
		AddData1();
	}
	iErrorCode=WSAAsyncSelect(m_socket,m_hWnd,WM_SERVER_ACCEPT,FD_ACCEPT); //������Ӧ���ݸ����ڵ���ϢΪWM_SERVER_ACCEPT   �������Զ�����Ϣ 
	  if (iErrorCode == SOCKET_ERROR)   
	{ 
		m_strCurInfo="ע���������������¼�ʧ��";
		AddData1();
		 return 0;
	}
	  
	GetDlgItem(IDC_BUTTON1)-> EnableWindow(FALSE); 
	GetDlgItem(IDC_BUTTON_STARTRADAR)->EnableWindow(FALSE); 
	return 1;
}


DWORD   WINAPI RecvProc(LPVOID lpParameter);

LRESULT CPeizDlg::OnAccept(WPARAM wParam, LPARAM lParam)
{
    if  (WSAGETSELECTERROR(lParam)) 
	{ 
		m_strCurInfo="Error   detected   on   entry   into   OnServerAccept.";
		return   0L; 
	} 
	
	if(WSAGETSELECTEVENT(lParam) == FD_ACCEPT)//���� 
	{ 

		Client[Client_num]   =   accept(m_socket,(LPSOCKADDR)&m_sockClientAddr,0); 
		m_IsLink=TRUE;
		RECVPARAM   *pRecvParam=new   RECVPARAM; 
		pRecvParam-> sock=Client[Client_num]; 

		Client_num++;
		pRecvParam->hwnd=m_hWnd;   
	} 

    return   0L; 
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////

void CPeizDlg::AddData1()
{
CString str;
	//����ʱ���
	m_CurTime = CTime::GetCurrentTime();
	m_strCurTime = m_CurTime.Format("%Y-%m-%d %H:%M:%S  ");
    str = m_strCurTime + m_strCurInfo;
		AddData2(str);
}

void CPeizDlg::AddData2(CString str)
{
	int MaxPos = 100;		//��󳤶�λ��
	int DelNum = 50;		//һ��ɾ��ʱ������
	int i;
	//�����ַ���
		m_data.InsertString(m_nInsertPos,str);
		//ѡ���²�����ַ���
		m_data.SetCurSel(m_nInsertPos);
	//����
	m_nInsertPos++;

	//����Ѵﵽ��󳤶�
	if(m_nInsertPos>MaxPos)
	{
		//ɾ��ǰͷ��DelNum��
		for(i = 0;i<DelNum;i++)
		{    			
				m_data.DeleteString(0);//ɾ���ַ���
			
		}
		//����
		m_nInsertPos -= DelNum;	
		m_data.SetCurSel(m_nInsertPos-1);
	}
}

void CPeizDlg::Paint(SYSPOINT vpoint[50000],unsigned long pointnum) 
{
	unsigned long i=0;
	CWnd *pwnd=GetDlgItem(IDC_STATIC1);	//���ش�����ָ������ID����Ԫ�صľ��������ͨ�����صľ���Դ����ڵ���Ԫ�ؽ��в�����CWnd��MFC������Ļ���,�ṩ��΢�������������д�����Ļ������ܡ�
	CCoordinate cor(pwnd,1000,1000,200,200);
	cor.DrawCoordinate(vpoint,pointnum);
	if (IsIconic())				//���������С��
	{
		CPaintDC dc(this); // device context for painting

		SendMessage(WM_ICONERASEBKGND, (WPARAM) dc.GetSafeHdc(), 0);

		// Center icon in client rectangle
		int cxIcon = GetSystemMetrics(SM_CXICON);
		int cyIcon = GetSystemMetrics(SM_CYICON);
		CRect rect;
		GetClientRect(&rect);
		int x = (rect.Width() - cxIcon + 1) / 2;
		int y = (rect.Height() - cyIcon + 1) / 2;

		// Draw the icon
		dc.DrawIcon(x, y, m_hIcon);
	}
	else		//���û����С��
	{
		CDialog::OnPaint();
	}
}

void CPeizDlg::OnOK() 
{
	// TODO: Add extra validation here
	CWnd *pwnd=GetDlgItem(IDC_STATIC1);
	CCoordinate cor(pwnd,1000,1000,200,200);
	//cor.DrawCoordinate(vpoint,pointnum);
}

void CPeizDlg::OnPaint() 
{
	CPaintDC dc(this); // device context for painting
	
	// TODO: Add your message handler code here
	
	// Do not call CDialog::OnPaint() for painting messages
}
bool CPeizDlg::ProcessData(char * recvBuf,int size,RailDataFrame * pData,unsigned long LoadDataNum)
{
	char * ptr=recvBuf;
	bool rettag=false,rettag1=false,rettag2=false,rettag3=false,rettag4=false;
	char * p;
	unsigned char recv[256];
	char buf[1100];
	int k,lenpet;


	if (size>=22)
	{
		for(int i=0;i<size;i+=1,ptr+=1)
		{
			p=ptr;
			recv[i]=*p;
		}
		
		if(recv[0]==0xdf&&recv[1]==0xdf&&recv[2]==0xdf&&recv[3]==0xdf)
			rettag1=true;
		if(recv[size-1]==0xef&&recv[size-2]==0xef&&recv[size-3]==0xef&&recv[size-4]==0xef)
			rettag2=true;

		if(rettag1==true&&rettag2==true)
			rettag3=true;

		if(rettag3==true)
		{
			for(int i=4;i<size-4;i++)
			m_rawDataBuff.push_back(recv[i]);
			rettag4=true;
		}

		if(rettag4==true)
		{
			rettag=LoadData(pData);	
			//�������ݣ����ԭʼ����
			if (rettag)
			{
				//�յ�matlab��ϢӦ��
				buf[0]=0xdf;
				buf[1]=0xdf;
				buf[2]=0xdf;
				buf[3]=0xdf;
				buf[4]=0x01;
				buf[5]=0x09;
				buf[6]=0x00;
				buf[7]=0x01;
				buf[8]=0x09;
			
				lenpet=buf[5]+buf[6]*256;
				for(int i=0;i<Client_num;i++)
				k=send(Client[i],buf,lenpet,0);

				/*��̨����*/
				int storeID;
				UINT startPos[MAX_STORE_NUM] = {0};
				UINT endPos[MAX_STORE_NUM] = {0};
				for ( i = 0;i<pData->num;i++)
				{
					storeID = pData->strdata[i].storeno;
					int mtemp = 1;
					int reScanCnt = 0;
					while(mtemp == 1)
					{
						mtemp = ytControllor.ScanStorage(storeID);
						reScanCnt++;
						if (reScanCnt>2)
						{
							break;
						}
					}		
				}
			}
		}
	}
	else 
		ClearRawData();

	return rettag;
}

void CPeizDlg::SetTagBuffer(unsigned char tag)
{
	if (tagBufferNumber<4)
	tagBuffer[tagBufferNumber]=tag;
	tagBufferNumber++;
}

bool CPeizDlg::CheckStartTag()
{
	if(tagBufferNumber!=4)
		return false;

	if(tagBuffer[0]==0xdf
		&& tagBuffer[1]==0xdf
		&& tagBuffer[2]==0xdf
		&& tagBuffer[3]==0xdf)
	{
		return true;
	}
	else
		return false;
}

void CPeizDlg::ReSetTagBuffer()
{
	tagBuffer[0]=0xff;
	tagBuffer[1]=0xff;
	tagBuffer[2]=0xff;
	tagBuffer[3]=0xff;
	tagBufferNumber=0;
}

bool CPeizDlg::CheckStopTag()
{
	if(tagBufferNumber!=4)
		return false;

	if(tagBuffer[0]==0xef
		&& tagBuffer[1]==0xef
		&& tagBuffer[2]==0xef
		&& tagBuffer[3]==0xef)
	{
		return true;
	}
	else
		return false;
}

bool CPeizDlg::LoadData(RailDataFrame *pdata)
{
	int i=0;
	int j=0;
	if(m_rawDataBuff.size()==0)
	{
		ClearRawData();//װ��һ�Σ��ͱ������ԭʼ���ݻ���
		return false;
	}

	//���У���
	if(!CheckSum())
	{
		ClearRawData();//װ��һ�Σ��ͱ������ԭʼ���ݻ���
		return false;
	}
	if (m_rawDataBuff[0]==1)
	{
		pdata->num=m_rawDataBuff[3];   //��ɨ���λ��	
		while(j<pdata->num)//Ҫȥ�����һ���ֽ�checksum�������ֽڽ�����־
		{
			pdata->strdata[j].storeno=m_rawDataBuff[4+9*j];
			pdata->strdata[j].startpos=m_rawDataBuff[5+9*j]+m_rawDataBuff[6+9*j]*2^8+m_rawDataBuff[7+9*j]*2^16+m_rawDataBuff[8+9*j]*2^24;
			pdata->strdata[j].endpos=m_rawDataBuff[9+9*j]+m_rawDataBuff[10+9*j]*2^8+m_rawDataBuff[11+9*j]*2^16+m_rawDataBuff[12+9*j]*2^24;
			j++;
		}
	}
	else if (m_rawDataBuff[0]==2)
	{
		revflag=1;
	}
	ClearRawData();
	return true;
}

//���У��ͣ���operation�ֽڵ�checksum��ǰһ���ֽڣ�����������
bool CPeizDlg::CheckSum()
{
	unsigned char tag=m_rawDataBuff[0];
	int sizes=m_rawDataBuff.size();
	int a[256];
	for(int i=1;i<(sizes-1);i++)
	{
		tag^=m_rawDataBuff[i];
		a[i]=m_rawDataBuff[i];
	}
	tag=tag^0xdf^0xdf^0xdf^0xdf;
	unsigned char checkSum=m_rawDataBuff[sizes-1];
	return tag==checkSum;
}

void CPeizDlg::ClearRawData()
{
	std::vector<unsigned char>::iterator theIt;
	for(theIt = m_rawDataBuff.begin(); theIt != m_rawDataBuff.end(); ++theIt)
	{
		m_rawDataBuff.erase(theIt);
		theIt--; 
	}	
}

unsigned char CPeizDlg::CheckFrmSum(char buf[9])
{
	unsigned char tag=0;;
	for(int i=0;i<8;i++)
	{
		tag^=buf[i];
	}
	return tag;
}