// LeuzeSocketComm.cpp: implementation of the CLeuzeSocketComm class.
//
//////////////////////////////////////////////////////////////////////
#include "stdafx.h"
#include "LeuzeSocketComm.h"
//#include "PeizDlg.h"
//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////
CLeuzeSocketComm::CLeuzeSocketComm()
{
	findStartTag=false;
	findStopTag=false;
	ReSetTagBuffer();
	m_pFile=NULL;
}

CLeuzeSocketComm::~CLeuzeSocketComm()
{
	closesocket(m_socket_radar1);
	closesocket(m_socket_radar2);
	WSACleanup();

}
void CLeuzeSocketComm::SetTagBuffer(unsigned char tag)
{
	if(tagBufferNumber==3)
	{
		tagBuffer[0]=tagBuffer[1];
		tagBuffer[1]=tagBuffer[2];
		tagBufferNumber=2;
	}
	tagBuffer[tagBufferNumber]=tag;
	tagBufferNumber++;
}
void CLeuzeSocketComm::ReSetTagBuffer()
{
	tagBuffer[0]=0xff;
	tagBuffer[1]=0xff;
	tagBuffer[2]=0xff;

	tagBufferNumber=0;
}
int  CLeuzeSocketComm::StartRadar(int radarNo, CString SavePath,CString ip,int port)
{       
	CreateDirectory("D:\\Radar", NULL );//�����ļ���
	m_pFile=fopen(SavePath,"w+");
	if(!m_pFile)
	return -2;
	//���SOCKET�汾
	WORD wVersionRequested;
	WSADATA wsaData;
	int err;
	
	wVersionRequested = MAKEWORD( 1, 1 );
	
	err = WSAStartup( wVersionRequested, &wsaData );
	if ( err != 0 ) 
	{
		return -1;
	}
	
	if ( LOBYTE( wsaData.wVersion ) != 1 ||
        HIBYTE( wsaData.wVersion ) != 1 ) 
	{
		WSACleanup( );
		return -1; 
	}
	
	//����
	if(radarNo==1)
	{
		m_socket_radar1=socket(AF_INET,SOCK_STREAM,0);
		int TimeOut=20;//���ý��ճ�ʱ 
		if(::setsockopt(m_socket_radar1,SOL_SOCKET,SO_RCVTIMEO,(char *)&TimeOut,sizeof(int))==SOCKET_ERROR)
		{
			
			return -1;
			
		}	
		SOCKADDR_IN addrSrv;
		addrSrv.sin_addr.S_un.S_addr=inet_addr(ip);
		addrSrv.sin_family=AF_INET;
		addrSrv.sin_port=htons(port);
		int ret=connect(m_socket_radar1,(SOCKADDR*)&addrSrv,sizeof(SOCKADDR));
		if(ret == SOCKET_ERROR )
			return ret;	
		//�������ײ��״��ʼ��������
		
		char buf[5];
		buf[0]=0x02;
		buf[1]='S';
		buf[2]='B';
		buf[3]='+';
		buf[4]=0x03;
		int recvCnt=send(m_socket_radar1,buf,5,0);
		return 1;	
	}
	else if(radarNo==2)
	{
		m_socket_radar2=socket(AF_INET,SOCK_STREAM,0);
		int TimeOut=20;//���ý��ճ�ʱ 
		if(::setsockopt(m_socket_radar2,SOL_SOCKET,SO_RCVTIMEO,(char *)&TimeOut,sizeof(int))==SOCKET_ERROR)
		{
			
			return -1;
			
		}	
		SOCKADDR_IN addrSrv;
		addrSrv.sin_addr.S_un.S_addr=inet_addr(ip);
		addrSrv.sin_family=AF_INET;
		addrSrv.sin_port=htons(port);
		int ret=connect(m_socket_radar2,(SOCKADDR*)&addrSrv,sizeof(SOCKADDR));
		if(ret == SOCKET_ERROR )
			return ret;	
		//�������ײ��״��ʼ��������
		
		char buf[5];
		buf[0]=0x02;
		buf[1]='S';
		buf[2]='B';
		buf[3]='+';
		buf[4]=0x03;
		int recvCnt=send(m_socket_radar2,buf,5,0);
		return 1;	
	}
	else
		return 0;	
}

int	 CLeuzeSocketComm::CloseRadar(void)
{
	//�������ײ��״������������
	char buf[5];
	buf[0]=0x02;
	buf[1]='S';
	buf[2]='B';
	buf[3]='-';		//�ؼ������
	buf[4]=0x03;
	int recvCnt1=send(m_socket_radar1,buf,5,0);
	int recvCnt2=send(m_socket_radar2,buf,5,0);
		if(m_pFile!=NULL)
		{
			//�ر��ļ�
			fclose(m_pFile);
			m_pFile=NULL;
		}
	
	closesocket(m_socket_radar1);
	closesocket(m_socket_radar2);
	WSACleanup();
	ClearRawData();
	return 1;
}

bool CLeuzeSocketComm::GetRawData(int readNo,DataFrame * pData,unsigned long LoadDataNum)
{
	//����Ļ����С�������ӳ������й�ϵ��
	char recvBuf[1570]={0};
	int recvCnt=0;
	if(readNo==1)
	{
		for(;recvCnt<=1000;)
		recvCnt=recv(m_socket_radar1,recvBuf,1570,0);
		return ProcessData(recvBuf,recvCnt, pData,LoadDataNum);
	}
	else  if(readNo==2)
	{
		for(;recvCnt<=1000;)
		recvCnt=recv(m_socket_radar2,recvBuf,1570,0);
		return ProcessData(recvBuf,recvCnt, pData,LoadDataNum);
    }
	return 0;	
}
bool CLeuzeSocketComm::CheckStartTag()
{
	if(tagBufferNumber!=3)
		return false;

	if(tagBuffer[0]==0x00
		&& tagBuffer[1]==0x00
		&& tagBuffer[2]!=0xff
		&& tagBuffer[2]!=0x00)
	{
		return true;
	}
	else
		return false;
}
bool CLeuzeSocketComm::CheckStopTag()
{
	if(tagBufferNumber!=3)
		return false;

	if(tagBuffer[0]==0x00
		&& tagBuffer[1]==0x00
		&& tagBuffer[2]==0x00)
	{
		return true;
	}
	else
		return false;
}
bool CLeuzeSocketComm::ProcessData(char * recvBuf,int size,DataFrame * pData,unsigned long LoadDataNum)
{
	char * ptr=recvBuf;
	bool rettag=false;
	char * p;
	unsigned char byte;
	
	for(int i=0;i<size;i+=1,ptr+=1)

	{
		p=ptr;
		byte=*p;
		SetTagBuffer(byte);
		if(CheckStartTag())
		{
			findStartTag=true;
			m_rawDataBuff.push_back(byte);//ע�⣬���ﱣ��������rawdatabuffʼ��û����ʼ��־�������ֽڣ�0x00,0x00��
			ReSetTagBuffer();
			continue;
		}
		if(findStartTag)
		{
			m_rawDataBuff.push_back(byte);
			if(CheckStopTag())
			{
				findStopTag=true;					
				rettag=LoadData(pData);	
				//�������ݣ����ԭʼ����
	
				findStartTag=false;					//�ҵ�������־������Ҫ����ʼ��־��
				ReSetTagBuffer();
				continue;
			}			
		}
	}
	return rettag;
}
bool CLeuzeSocketComm::LoadData(DataFrame *pData)
{
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
	//���operation�ֽ�
	if(!CheckOperation())
	{
		ClearRawData();//װ��һ�Σ��ͱ������ԭʼ���ݻ���
		return false;		
	}


	int distance;
	int index=GetDataOffset();//��ȡ����������buffer�е�ƫ����
	int i=0;
	int dataCnt=0;

	int data[600],okData[600];//�������ײ�ĽǶ���˳ʱ����ת�ģ������Ƕ�����෴��������Ҫ������

	while(i<m_rawDataBuff.size()-4)//Ҫȥ�����һ���ֽ�checksum�������ֽڽ�����־
	{
		if(i<index)
		{
			i++;
			continue;		//ֱ���ƶ������ݶ�ȡ����
		}
		distance=GetDistance(m_rawDataBuff[i],m_rawDataBuff[i+1]);
		
		if(m_rawDataBuff[i]==0x00
			&& m_rawDataBuff[i+1]==0x00)
		{
			i+=3;		//ȥ����ӽ�����0XFF
		}
		else
		{
			i+=2;
		}
		if(dataCnt>=600)//�������ײ��Э�飬�����ܴ���600���������ݡ�
		{
			ClearRawData();//װ��һ�Σ��ͱ������ԭʼ���ݻ���
			return false;
		}
		data[dataCnt]=distance;
		dataCnt++;
	}

	for(i=0;i<dataCnt;i++)
	{
		okData[i]=data[dataCnt-1-i];
	}


	pData->dataLength=dataCnt;
	
	//����-5.04��185.04��,��(-25,925),0.2��ʾ
	if(m_startAngle<-25)
		m_startAngle=-25;
	if(m_stopAngle>925)
		m_stopAngle=925;
	if(m_stopAngle<=m_startAngle)
	{
		m_startAngle=-25;
		m_stopAngle=925;
	}	
	
	double angleResolution=GetAngularResolution()*0.36;//�����ȵ�λ�Ƕȣ�0.36�����ײ�ĵ�λ�����ȣ������ȶ������ı���
	int startDataNumber=(1+m_startAngle-(-25))*0.2/angleResolution;//��ȡ��ʼ����data�����еľ���ֵ���,��1��ԭ���ǣ����ײ��-25����-5.04����1��������0
	int stopDataNumber=(m_stopAngle-(-25))*0.2/angleResolution;//��ȡ��������data�����еľ���ֵ���

	pData->dataLength=stopDataNumber-startDataNumber+1;
	pData->startAngle=m_startAngle;
	pData->stopAngle=m_stopAngle;
	SYSTEMTIME time;
	GetLocalTime(&time);
	
	SYSTIME st;
	st.nDay=time.wDay;
	st.nDayOfWeek=time.wDayOfWeek;
	st.nHour=time.wHour;
	st.nMilliseconds=time.wMilliseconds;
	st.nMinute=time.wMinute;
	st.nMonth=time.wMonth;
	st.nSecond=time.wSecond;
	st.nYear=time.wYear;

	pData->time=st;

	int k=0;
	for(i=0;i<dataCnt;i++)
	{
		if(i<startDataNumber)
			continue;
		if(i>stopDataNumber)
			break;

		pData->data[k]=okData[i];

		//�����ļ�
			fprintf(m_pFile,"%d ",okData[i]);
		
		k++;
	}
	ClearRawData();//װ��һ�Σ��ͱ������ԭʼ���ݻ���
	return true;
}
bool CLeuzeSocketComm::CheckOperation()
{
	return m_rawDataBuff[0]==0x23;
}
//���У��ͣ���operation�ֽڵ�checksum��ǰһ���ֽڣ�����������
bool CLeuzeSocketComm::CheckSum()
{
	unsigned char tag=m_rawDataBuff[0];
	int sizes=m_rawDataBuff.size();
	for(int i=1;i<(sizes-4);i++)
	{
		tag^=m_rawDataBuff[i];
	}
	if(tag==0x00)tag=0xff;
	unsigned char checkSum=m_rawDataBuff[sizes-4];
	return tag==checkSum;
}
//��ȡangular resolution
int CLeuzeSocketComm::GetAngularResolution()
{
	int optionBytes=GetOptionByteNum();
	return m_rawDataBuff[1+optionBytes+8];
}
//����һ��Э������ݵ�ʱ�򣬻�ȡЭ���о������ݴ�start�ֽڵ��������ݵ�ƫ����
int CLeuzeSocketComm::GetDataOffset()
{
	//m_rawDataBuff��û�д���ʼ�����ֽڱ�־
	int offset=0;
	if(m_rawDataBuff.size()<19)//��������ǰ����ֽ��������19��
		return offset;
	
	int startAngleIndex,stopAngleIndex;
	int optionByteNum=GetOptionByteNum();//option�ֽ���
	
	startAngleIndex=1+optionByteNum+8+1;
	offset=startAngleIndex;
	if(m_rawDataBuff[startAngleIndex]==0x00		//15����ʼ�Ǹ�λ�ֽڵ�ƫ��λ��
	&& m_rawDataBuff[startAngleIndex+1]==0x00)		
	{
		offset+=3;
		stopAngleIndex=startAngleIndex+3;
	}
	else
	{
		offset+=2;
		stopAngleIndex=startAngleIndex=2;
	}
	if(m_rawDataBuff[stopAngleIndex]==0x00		//17�ǽ����Ǹ�λ�ֽڵ�ƫ��λ��
	&& m_rawDataBuff[stopAngleIndex=1]==0x00)		
	{
		offset+=3;
	}
	else
	{
		offset+=2;
	}
	return offset;

}
//����option�ֽ���������option1��2��3
int CLeuzeSocketComm::GetOptionByteNum()
{
	//option 1+2+3
	if((m_rawDataBuff[1] & 3) > 0)
	{
		return 3;
	}
	//option 1+2
	else if((m_rawDataBuff[1] & 2) > 0)
	{
		return 2;
	}
	//option 1
	else if((m_rawDataBuff[1] & 1) > 0)
	{
		return 1;
	}
	return 3;
}
int CLeuzeSocketComm::GetDistance(unsigned char highByte,unsigned char lowByte)
{
	int distance=0;
	distance=(highByte<<8) | (lowByte & 0xFE);//���ε����ֽڵ�bit0λ��
	return distance;
}

void CLeuzeSocketComm::ClearRawData()
{
	std::vector<unsigned char>::iterator theIt;
	for(theIt = m_rawDataBuff.begin(); theIt != m_rawDataBuff.end(); ++theIt)
	{
		m_rawDataBuff.erase(theIt);
		theIt--; 
	}	
}

