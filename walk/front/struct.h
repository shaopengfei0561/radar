
#include "windows.h"
#ifndef _RADARSTRUCT_H_
#define _RADARSTRUCT_H_
#define ERRDIS 0

#define MAX_STORE_NUM 30
//ϵͳʱ��ṹ��
typedef struct _SYSTIME
{
    int nYear;					//��
    int nMonth;					//��
    int nDayOfWeek;				//����
    int nDay;					//����
    int nHour;					//ʱ
    int nMinute;				//��
    int nSecond;				//��
    int nMilliseconds;			//����
}SYSTIME;

//������ṹ�壺
typedef struct _SYSPOINT
{
	int x,y,z;
}SYSPOINT;

//ԭʼ���ݽṹ��
typedef struct _DataFrame
{
    SYSTIME time;								//��ȡ��������֡��ʱ��
    float startAngle,stopAngle;					//��ʼ�ǶȺ�ֹͣ�Ƕȣ���λ�����ȣ�
    int dataLength;								//����ʵ�ʳ���
    int data[1100];								//������ݣ���λ�����ף�
}DataFrame;

//��̨�״�����ݽṹ��
typedef struct _SecDataFrame
{ 
    SYSTIME time;								//��ȡ��������֡��ʱ��
    float startAngle,stopAngle;					//��ʼ�ǶȺ�ֹͣ�Ƕȣ���λ�����ȣ�
    int dataLength;								//����ʵ�ʳ���
    int data[1440];								//������ݣ���λ��cm��
}SecDataFrame;

//��λ��Ϣ�ṹ��
typedef struct _StoreInfo
{ 
    char storeno;								//��λ��
    int startpos;								//������꣨��λ��mm��
	int endpos;									//�յ����꣨��λ��mm��							
}StoreInfo;

//�·�������Ϣ�ṹ��
typedef struct _RailDataFrame
{ 
    char num;									//��Ҫɨ��Ĳ�λ����
    StoreInfo strdata[30];						//������ݣ���λ��cm��
}RailDataFrame;

/*************************һ���㷨����*******************************/
//��ͼ�ṹ��


typedef struct _WarningObject
{
    float angle;								//Ŀ�����ĵ�ķ�λ�ǣ���λ�����ȣ�
	  int distance;								//Ŀ�����ĵ�ľ��루��λ�����ף�
    int objWidth;								//Ŀ���ȣ���λ�����ף�
	  int preObj;								//������һ��Ŀ��
     int objType;								//Ŀ������
}WarningObject;


//��������ṹ��
typedef struct _WarningResult
{
    SYSTIME time;								//���ν����ʱ��
	  int objNum;								//��⵽��Ŀ����
    WarningObject obj[1000];					//�洢����Ŀ��
}WarningResult;
	

/*************************�״ﲿ��*******************************/

//�״�����ģʽö��
typedef enum _RadarMode
{
	AlgMode=0,					//�㷨����ģʽ
	RawDataMode=1,				//ԭʼ����ģʽ
}RadarMode;

//�״��Ʒ����ö��
typedef enum _EnumRadar
{
    SCIP=0,				
	LeuzeSocket,				//���ײ�socket
	LeuzeCom,					//���ײ�COM
	CustomTcpRadar,				//���Ƶ�TCP���״�
}EnumRadar;

//�״�������Ϣ�ṹ��
typedef struct _HardConfigInfo			//�״�Ӳ���豸������Ϣ�ṹ��
{
	EnumRadar radar;					//�״��Ʒ	
    int BitRate;						//���ݴ��ͱ�����
    float startAngle,stopAngle;			//ɨ��Ŀ�ʼ�ǶȺ���ֹ�Ƕȣ���λΪ����
	char comDevice[50];					//�״�COM��
	char ip[50];						//�״�IP
	int  port;							//�״�˿�
	
}HardConfigInfo;

//�״������Ϣ�ṹ��
typedef struct _RadarInfo				//�״���Ϣ�ṹ��
{
    BYTE radarType;						//�״�����
    BYTE radarID;						//�״���
}RadarInfo;

//�״��ͼ��ʾ�ؼ�״̬
typedef enum _RadarMapState
{
	RDReadyScan=0,						//��ɨ��
	RDStudying,							//ѧϰ��
	RDScanning,							//ѧϰ��ϣ�ɨ����
	RDPlayBack,							//���ݻط�
}RadarMapState;



/*************************Э�鲿�ֵĽṹ��*******************************/
//�㷨����ö��
typedef enum _AlgType
{
	AlgOriginal=0,						//�����״�һ���㷨
	AlgDetection,						//����㷨
	AlgClassify,						//ʶ���㷨
	AlgTrace,							//�����㷨
}AlgType;

//�û����ýṹ��
typedef struct _UserConfigInfo
{
    int AlgorithmType;					//�㷨����
    int Sensitivity;					//�㷨������
    int AbstractPara1;					//�������1������
    int AbstractPara2;                
    int AbstractPara3;                
    int AbstractPara4;                
    float AbstractPara5; 
}UserConfigInfo;

//��ϸ���ýṹ��
typedef struct _DetailedConfigInfo
{
    int AlgorithmType;					//�㷨����
    int identifier;                     //�㷨ʶ����
    unsigned char parabuf[100];					//��������
}DetailedConfigInfo;

//ϵͳ����
typedef struct _SystemConfig
{
	unsigned char mode;					//ģʽ���ã����棺bit0��ʾ����ģʽ��0���ϴ�������ģʽ��1��ԭʼ����ģʽ
	int radarId;						//�״�ID
	float startAngle;					//��ʼ�ǣ���λ������
	float stopAngle;					//�����ǣ���λ������
	
}SystemConfig;


//IP����
typedef struct _IpConfig
{
	char ip[50];						//�����IP��ַ
	char subMask[50];					//ϵͳ����������
	int port;							//�������Ķ˿�	
}IpConfig;


//˽�в���,�洢ϵͳ�ڲ���һЩ����
typedef struct _privateConfig
{
	char radarIp[50];					//�״ﴫ������IP
	int radarPort;						//�״ﴫ�����Ķ˿�
	char com[50];						//�״�Ĵ��ں�
	int bitRate;						//�״�Ĳ�����

}PrivateConfig;


typedef struct  _RPRadarInfo       //�״���Ϣ���״�Э�����Ϣ�ṹ�壩
{
	BYTE  version;
}RPRadarInfo;


//�״��յ�������ö��
typedef enum _RPRadarCmd
{
	CMD_RADARSTART			=0X01,				//�״￪������
	CMD_RADARSTOP			=0X02,				//�״�ֹͣ����

	CMD_RADARGETSYSPARA		=0X03,				//��Ҫϵͳ��������
	CMD_RADARGETUSERALG		=0X04,				//��Ҫ�û��㷨��������
	CMD_RADARGETDETAILALG	=0X05,				//��Ҫ��ϸ�㷨��������

	CMD_RADARGETSTATE		=0X06,				//״̬��ѯ����
	CMD_RADARGETRADARINFO	=0X07,				//�״���Ϣ��ȡ����

	CMD_RADARSETSYSPARA		=0X08,				//����ϵͳ��������
	CMD_RADARSETUSERALG		=0X09,				//�����û��㷨���ò�������
	CMD_RADARSETDETAILALG	=0X0a,				//������ϸ�㷨���ò�������
	CMD_RADARSETIP			=0X0b,				//����IP��������
	
	CMD_RADARGETIP			=0X0c,				//��ȡIP��������
	
}RPRadarCmd;

//�״��ϱ���������
typedef enum _RPRadarReturnType
{
	CMD_ANWSER				=0X01,				//Ӧ��
	CMD_RAWDATA				=0X02,				//ԭʼ����
	CMD_SYSCONFIG			=0X03,				//ϵͳ����
	CMD_UALGCONFIG			=0X04,				//�û��㷨����
	CMD_DALGCONFIG			=0X05,				//��ϸ�㷨����
	CMD_ALGRESULT			=0X06,				//�㷨������
	CMD_RADARINFO			=0X07,				//�״���Ϣ
	CMD_IPCONFIG			=0X0C,				//IP����
}RPRadarReturnType;

//�״�Ӧ����ö��
typedef enum _RPRadarAnwser
{
	ANW_RADARSTART_OK		=0X01,				//�״￪���ɹ�Ӧ��	
	ANW_RADARSTART_ERR		=0X02,				//�״￪��ʧ��Ӧ��	

	ANW_RADARSTOP_OK		=0X03,				//�״�ֹͣ�ɹ�Ӧ��	
	ANW_RADARSTOP_ERR		=0X04,				//�״�ֹͣʧ��Ӧ��
	
	ANW_RADARSETPARA_OK		=0X05,				//�״��²������óɹ�Ӧ��	
	ANW_RADARSETPARA_ERR	=0X06,				//�״��²�������ʧ��Ӧ��	

	ANW_RADARSTATE_OK		=0X08,				//��ǰ״̬��������Ϊ��"״̬��ѯ����"��Ӧ��	
	
	ANW_RADAR_UNDERVOL		=0X0b,				//�״��ѹ����	
	ANW_RADAR_TIMEOUT		=0X0c,				//��ȡԭʼ���ݳ�ʱ
	ANW_RADAR_ABORT			=0X0d,				//ϵͳ���������쳣
}RPRadarAnwser;

#endif