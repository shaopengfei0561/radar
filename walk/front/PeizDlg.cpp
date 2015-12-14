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
#include "iostream.h"
#include "Windows.h"
//     #include <Afxsock.h>
#include "io.h"
#include "SetParseDlg.h"
#include "PLCControllor.h"
#ifdef _DEBUG
#define new DEBUG_NEW
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif
using namespace alg_classify;
int ret1,ret2;
int Wbeset;
int sendflag;
/////////////////////////////////////////////////////////////////////////////
// CPeizDlg dialog
unsigned char g_config[100];
PLCControllor plcControllor;
/*导轨控制*/
int storeID[MAX_STORE_NUM] = {0};
UINT startPos[MAX_STORE_NUM] = {0};
UINT endPos[MAX_STORE_NUM] = {0};
int pnum=0;
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
CString CRadarEnumMap::m_appErrorArray[10]={"成功"
											,"其它未知错误"	
											,"雷达没有初始化"
											,"雷达启动失败"
											,"数据库初始化出错"
											,"ini文件未创建"			//5
											,"密码错误"
											,"通信模块初始化错误"
											,"从INI文件配置雷达失败"
											,"初始化算法失败"
											}; 

BOOL CPeizDlg::OnInitDialog() 
{
	CDialog::OnInitDialog();
	m_port=GetPrivateProfileInt("LidarIp","LidarPort1",0,".\\LidarConfig.ini"); 
	m_port1=GetPrivateProfileInt("LidarIp","LidarPort2",0,".\\LidarConfig.ini"); 
    UpdateData(FALSE); 
	char strip[16];
	GetPrivateProfileString("LidarIp","LidarIP1","", strip,sizeof(strip), ".\\LidarConfig.ini");
	char strip1[16];
	GetPrivateProfileString("LidarIp","LidarIP2","", strip1,sizeof(strip1), ".\\LidarConfig.ini");

	CString savepath="C:\\data.txt"; //文件路径
	SetDlgItemText(IDC_IPADDRESS,strip);
    SetDlgItemText(IDC_SavaPath,"c:\\Radar.zip");
	SetDlgItemText(IDC_IPADDRESS1,strip1);
    FitNum=1;								//符合时间差的帧数
	LoadDataNum=1;							//雷达数据帧计数
	LoadDataNum1=1;							//雷达数据帧计数
	stop=-1;								//初始化停止指令
	tagBufferNumber=0;
	findStartTag=0;
	revflag=0;
	resendnum=0;
	OnButtonStartradar();
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
DWORD   WINAPI mythread2(LPVOID   lParam);

//int TTT；
void CPeizDlg::StartRadar() 
{  
	Wbeset=InitWebsocket();				//开启服务器端socket，连接matlab客户端
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
	Wbeset=InitWebsocket();				//开启服务器端socket，连接matlab客户端
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
	RailDataFrame  *sData= new RailDataFrame;	//导轨数据
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
void CPeizDlg::RestartRail() 
{
	/*导轨控制*/
	plcControllor.ScanStorage(pnum,storeID,startPos,endPos);
}
void CPeizDlg::InitStartRadar() 
{
	//    DetailedConfigInfo Configres;
	
	SYSTEMTIME startime;
	HardConfigInfo *cfgInfo=new HardConfigInfo;
	CLeuzeSocketComm app;
	CAlgClassify *Alg=new CAlgClassify;
	SecDataFrame  *pData= new SecDataFrame;		//两台雷达数据
    DataFrame  *pData1= new DataFrame;			//接受雷达一的数据
	DataFrame  *pData2= new DataFrame;			//接受雷达二的数据
	RailDataFrame  *sData= new RailDataFrame;	//导轨数据
	char buf[1100];
	char mbuf[9];
	int k,lenpet;
	
	//读取对话框的ip和端口号
    CString ip1,ip2,SavePath;
    int port1;
	int port2;
    GetDlgItemText(IDC_IPADDRESS,ip1);			//读取对话框1IP
    port1=GetDlgItemInt(IDC_PORT);				//读取对话框1port

	GetDlgItemText(IDC_IPADDRESS1,ip2);			//读取对话框2IP
    port2=GetDlgItemInt(IDC_PORT1);				//读取对话框2port

    GetDlgItemText(IDC_SavaPath,SavePath);		//读取对话框数据保存地址
recv:
	m_strCurInfo="正在连接雷达";

	AddData1();
	ret1=app.StartRadar(1,SavePath,ip1,port1);
	ret2=app.StartRadar(2,SavePath,ip2,port2);
	
    //将参数读到目录下
	Alg->InternalInitial();
	if(ret1==-1||ret2==-1)
	{      
		if(ret1==-1)
		{
			m_strCurInfo.Format("启动"+ip1+"雷达出错！错误信息：%s",CRadarEnumMap::m_appErrorArray[-ret1]);	
			AddData1();
			Sleep(1000);
			goto recv;
		}
		else if (ret2==-1)
		{
			m_strCurInfo.Format("启动"+ip2+"雷达出错！错误信息：%s",CRadarEnumMap::m_appErrorArray[-ret2]);	
			AddData1();
			Sleep(1000);
			goto recv;
		}	
	}
	else if(ret1==-2||ret2==-2)
	{
		m_strCurInfo="建立保存数据的文件夹c:\\Radar.zip"; //modify：D:\\Radar-->C:\\Radar.zip
		AddData1();
			Sleep(1000);
		goto recv;
	}
	else if(ret1 ==1&&ret2==1)
	{
		m_strCurInfo="雷达启动成功";
		AddData1();	
	}
	else if (ret1==0||ret2==0)
	{
		m_strCurInfo="没有找到雷达，请检查";
		AddData1();	
		Sleep(1000);
		goto recv;
	}
	int  length=0;
	int flag=0;
	CString DataNum,Fnum;
    stop=2;										//避开启动时变量即为关闭值-1；
	Alg->jianditu=1;

	while(1)
	{
	  redata:

		app.GetRawData(1,pData1,LoadDataNum++);  //获取雷达原始数据
		app.GetRawData(2,pData2,LoadDataNum1++); //获取雷达原始数据
		
		if(pData2->time.nMilliseconds<0)
		{
			m_strCurInfo="雷达"+ip2+"读取数据出错，重启雷达";
			AddData1();
			Sleep(20);
			//closesocket(m_socket_radar2);
			goto redata;
		}
		else if(pData1->time.nMilliseconds<0)
		{
			m_strCurInfo="雷达"+ip1+"读取数据出错，重启雷达";
			AddData1();
			Sleep(20);
			//closesocket(m_socket_radar1);
			goto redata;
		}
		
		flag++;
		if(flag % 1 !=0)
		{
			LoadDataNum--;
			LoadDataNum1--;
			goto redata;
		}
		
		length=0;
		/*******************计算时间差***************************/
		int result=((pData2->time.nHour-pData1->time.nHour)*3600
			+(pData2->time.nMinute-pData1->time.nMinute)*60+pData2->time.nSecond-pData1->time.nSecond)*1000+pData2->time.nMilliseconds-pData1->time.nMilliseconds;
		if(pData1->time.nYear!=pData2->time.nYear)
			result=255;
		if(pData1->time.nMonth!=pData2->time.nMonth)
			result=255;
		if(pData1->time.nDay!=pData2->time.nDay)
			result=255;
		/*******************计算时间差***************************/
		
		if(result<20)			
		{
			pData->dataLength=pData1->dataLength+pData2->dataLength; 
			pData->startAngle=pData1->startAngle;
			pData->stopAngle=pData1->stopAngle;
			pData->time.nYear= pData1->time.nYear;
			pData->time.nMonth= pData1->time.nMonth;
			pData->time.nDay= pData1->time.nDay;
			pData->time.nDayOfWeek= pData1->time.nDayOfWeek;
			pData->time.nHour= pData1->time.nHour;  
			pData->time.nMinute= pData1->time.nMinute;
			pData->time.nSecond= pData1->time.nSecond;
			pData->time.nMilliseconds= pData1->time.nMilliseconds;
			for(int i=0;i<528;i++)
			{
				pData->data[i]=pData1->data[i];			
				pData->data[i+528]=pData2->data[i];	
			}
			if(m_savFlag==1||m_savState==1)								
			{
				if(m_savState==0)
				{
					m_nCurID=0;
					m_storeNum=m_savNum;
					m_savState=1;
					
					//发送开始扫描库位消息
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
				length=Alg->GetResult(pData,buf,1100);		//处理并保存数据  
				buf[length]='\0';
			}
		}
 	
		DataNum.Format("%ld",m_nCurID);
	    m_strCurInfo=DataNum+"帧数据";
		AddData1();	
		
		if(m_sndFlag==1)
		{    
			if (m_nCurID>=1000)
			{
				//发送开始算法处理命令
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
				WriteLog("发送开始算法处理指令.\n");
				revflag=0;
				resendnum=0;
				m_sndFlag=0;
			}
			else
			{
				revflag=0;
				resendnum=0;
				m_sndFlag=0;
				m_nCurID=0;

				HANDLE handle;
				DWORD nThreadId=0;
				handle=CreateThread(NULL,0,mythread2,(LPVOID)this,0,&nThreadId);
				CloseHandle(handle);
			}
		}
		
		if(stop==1)
		{
			stop=0;
			break;
		}//关闭命令
	}
	
//	app.CloseRadar();
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

DWORD   WINAPI mythread2(LPVOID   lParam)
{
	CPeizDlg *pMyClass=(CPeizDlg *)lParam; 
	pMyClass->RestartRail();
	return 0;
}

DWORD   WINAPI ReadThreadProc(LPVOID   pParam);
int CPeizDlg::InitWebsocket()
{
 //初始化与绑定服务器 
	WSADATA   wsaData; 
	Client_num=0;

	int   iErrorCode; 
	if   (WSAStartup(MAKEWORD(2,2),&wsaData))   //调用Windows   Sockets   DLL 
	{   
		m_strCurInfo="初始套接字失败";
		AddData1();
		WSACleanup(); 
		return 0;
	} 
	else
	{
		m_strCurInfo="服务器开始创建SOCKET";
		AddData1();
	}
	m_socket=WSASocket(PF_INET,SOCK_STREAM,0,NULL,0,0);//创建服务器端Socket，类型为SOCK_STREAM，面向连接的通信 
	if(m_socket==INVALID_SOCKET) 
	{ 
		m_strCurInfo="无法创建服务器SOCKET";
		AddData1();
		WSACleanup(); 
		return 0;
	} 
	SOCKADDR_IN sockServerAddr;
	sockServerAddr.sin_family =AF_INET; 
	sockServerAddr.sin_addr.s_addr=htonl(INADDR_ANY);   //INADDR_ANY;       //向所有的IP地址发送消息 
	sockServerAddr.sin_port= htons(7008); 
	
	if(bind(m_socket,(LPSOCKADDR)&sockServerAddr,sizeof(sockServerAddr))   ==   SOCKET_ERROR)   //与选定的端口绑定 
	{ 
		m_strCurInfo="无法绑定服务器";
		AddData1();
		closesocket(m_socket); 
		WSACleanup(); 
		return 0;
	} 
	else
	{
		m_strCurInfo="服务器端口:7008";
		AddData1();
	}

	if (listen(m_socket,100)==SOCKET_ERROR)   
	{ 
		m_strCurInfo="服务器监听失败";
		AddData1();
		return 0;
	} 
	else
	{
		m_strCurInfo="服务器绑定监听成功";
		AddData1();
	}
	iErrorCode=WSAAsyncSelect(m_socket,m_hWnd,WM_SERVER_ACCEPT,FD_ACCEPT); //产生相应传递给窗口的消息为WM_SERVER_ACCEPT   ，这是自定义消息 
	  if (iErrorCode == SOCKET_ERROR)   
	{ 
		m_strCurInfo="注册请求连接网络事件失败";
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
	
	if(WSAGETSELECTEVENT(lParam) == FD_ACCEPT)//接收 
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
	//打入时间戳
	m_CurTime = CTime::GetCurrentTime();
	m_strCurTime = m_CurTime.Format("%Y-%m-%d %H:%M:%S  ");
    str = m_strCurTime + m_strCurInfo;
		AddData2(str);
}

void CPeizDlg::AddData2(CString str)
{
	int MaxPos = 100;		//最大长度位置
	int DelNum = 50;		//一次删除时的数量
	int i;
	//插入字符串
		m_data.InsertString(m_nInsertPos,str);
		//选中新插入的字符串
		m_data.SetCurSel(m_nInsertPos);
	//调整
	m_nInsertPos++;

	//如果已达到最大长度
	if(m_nInsertPos>MaxPos)
	{
		//删掉前头的DelNum项
		for(i = 0;i<DelNum;i++)
		{    			
				m_data.DeleteString(0);//删除字符串
			
		}
		//调整
		m_nInsertPos -= DelNum;	
		m_data.SetCurSel(m_nInsertPos-1);
	}
}

void CPeizDlg::Paint(SYSPOINT vpoint[50000],unsigned long pointnum) 
{
	unsigned long i=0;
	CWnd *pwnd=GetDlgItem(IDC_STATIC1);	//返回窗口中指定参数ID的子元素的句柄，可以通过返回的句柄对窗口内的子元素进行操作。CWnd是MFC窗口类的基类,提供了微软基础类库中所有窗口类的基本功能。
	CCoordinate cor(pwnd,1000,1000,200,200);
	cor.DrawCoordinate(vpoint,pointnum);
	if (IsIconic())				//如果窗口最小化
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
	else		//如果没有最小化
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
			for(i=4;i<size-4;i++)
			m_rawDataBuff.push_back(recv[i]);
			rettag4=true;
		}

		if(rettag4==true)
		{
			rettag=LoadData(pData);	
			//处理数据，填充原始数据
			if (rettag)
			{
				//收到matlab消息应答
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
				
				pnum=pData->num;
				for (i = 0;i<pnum;i++)
				{
					storeID[i] = pData->strdata[i].storeno;
					startPos[i] = pData->strdata[i].startpos;
					endPos[i] = pData->strdata[i].endpos;
				}
				plcControllor.ScanStorage(pnum,storeID,startPos,endPos);
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
		ClearRawData();//装载一次，就必须清空原始数据缓存
		return false;
	}

	//检查校验和
	if(!CheckSum())
	{
		ClearRawData();//装载一次，就必须清空原始数据缓存
		return false;
	}
	if (m_rawDataBuff[0]==1)
	{
		pdata->num=m_rawDataBuff[3];   //待扫描库位数	
		while(j<pdata->num)//要去掉最后一个字节checksum和三个字节结束标志
		{
			pdata->strdata[j].storeno=m_rawDataBuff[4+9*j];
			pdata->strdata[j].startpos=m_rawDataBuff[5+9*j]+m_rawDataBuff[6+9*j]*pow(2,8)+m_rawDataBuff[7+9*j]*pow(2,16)+m_rawDataBuff[8+9*j]*pow(2,24);
			pdata->strdata[j].endpos=m_rawDataBuff[9+9*j]+m_rawDataBuff[10+9*j]*pow(2,8)+m_rawDataBuff[11+9*j]*pow(2,16)+m_rawDataBuff[12+9*j]*pow(2,24);
			j++;
		}
	}
	else if (m_rawDataBuff[0]==2)
	{
		revflag=1;
		WriteLog("收到开始算法处理指令应答.\n");
	}
	ClearRawData();
	return true;
}

//检查校验和，从operation字节到checksum的前一个字节，进行异或操作
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

void CPeizDlg:: WriteLog(const char* format, ... )
{
	
    va_list    valist;
    FILE *fp;
	
    fp=fopen("test.log", "a" );	
    va_start( valist, format );
    vfprintf( fp, format, valist );
    va_end( valist );
    fclose(fp);
}


