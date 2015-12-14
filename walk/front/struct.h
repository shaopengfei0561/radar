
#include "windows.h"
#ifndef _RADARSTRUCT_H_
#define _RADARSTRUCT_H_
#define ERRDIS 0

#define MAX_STORE_NUM 30
//系统时间结构体
typedef struct _SYSTIME
{
    int nYear;					//年
    int nMonth;					//月
    int nDayOfWeek;				//星期
    int nDay;					//日期
    int nHour;					//时
    int nMinute;				//分
    int nSecond;				//秒
    int nMilliseconds;			//毫秒
}SYSTIME;

//点座标结构体：
typedef struct _SYSPOINT
{
	int x,y,z;
}SYSPOINT;

//原始数据结构体
typedef struct _DataFrame
{
    SYSTIME time;								//获取到本数据帧的时间
    float startAngle,stopAngle;					//开始角度和停止角度（单位：弧度）
    int dataLength;								//数据实际长度
    int data[1100];								//存放数据（单位：厘米）
}DataFrame;

//两台雷达的数据结构体
typedef struct _SecDataFrame
{ 
    SYSTIME time;								//获取到本数据帧的时间
    float startAngle,stopAngle;					//开始角度和停止角度（单位：弧度）
    int dataLength;								//数据实际长度
    int data[1440];								//存放数据（单位：cm）
}SecDataFrame;

//仓位信息结构体
typedef struct _StoreInfo
{ 
    char storeno;								//仓位号
    int startpos;								//起点坐标（单位：mm）
	int endpos;									//终点坐标（单位：mm）							
}StoreInfo;

//下发导轨信息结构体
typedef struct _RailDataFrame
{ 
    char num;									//需要扫描的仓位数量
    StoreInfo strdata[30];						//存放数据（单位：cm）
}RailDataFrame;

/*************************一期算法部分*******************************/
//地图结构体


typedef struct _WarningObject
{
    float angle;								//目标中心点的方位角（单位：弧度）
	  int distance;								//目标中心点的距离（单位：厘米）
    int objWidth;								//目标宽度（单位：厘米）
	  int preObj;								//跟踪上一个目标
     int objType;								//目标类型
}WarningObject;


//报警结果结构体
typedef struct _WarningResult
{
    SYSTIME time;								//本次结果的时间
	  int objNum;								//检测到的目标数
    WarningObject obj[1000];					//存储报警目标
}WarningResult;
	

/*************************雷达部分*******************************/

//雷达运行模式枚举
typedef enum _RadarMode
{
	AlgMode=0,					//算法运算模式
	RawDataMode=1,				//原始数据模式
}RadarMode;

//雷达产品类型枚举
typedef enum _EnumRadar
{
    SCIP=0,				
	LeuzeSocket,				//劳易测socket
	LeuzeCom,					//劳易测COM
	CustomTcpRadar,				//定制的TCP的雷达
}EnumRadar;

//雷达配置信息结构体
typedef struct _HardConfigInfo			//雷达硬件设备配置信息结构体
{
	EnumRadar radar;					//雷达产品	
    int BitRate;						//数据传送比特率
    float startAngle,stopAngle;			//扫描的开始角度和终止角度，单位为弧度
	char comDevice[50];					//雷达COM口
	char ip[50];						//雷达IP
	int  port;							//雷达端口
	
}HardConfigInfo;

//雷达相关信息结构体
typedef struct _RadarInfo				//雷达信息结构体
{
    BYTE radarType;						//雷达类型
    BYTE radarID;						//雷达编号
}RadarInfo;

//雷达地图显示控件状态
typedef enum _RadarMapState
{
	RDReadyScan=0,						//待扫描
	RDStudying,							//学习中
	RDScanning,							//学习完毕，扫描中
	RDPlayBack,							//数据回放
}RadarMapState;



/*************************协议部分的结构体*******************************/
//算法种类枚举
typedef enum _AlgType
{
	AlgOriginal=0,						//激光雷达一期算法
	AlgDetection,						//检测算法
	AlgClassify,						//识别算法
	AlgTrace,							//跟踪算法
}AlgType;

//用户配置结构体
typedef struct _UserConfigInfo
{
    int AlgorithmType;					//算法类型
    int Sensitivity;					//算法灵敏度
    int AbstractPara1;					//抽象参数1，备用
    int AbstractPara2;                
    int AbstractPara3;                
    int AbstractPara4;                
    float AbstractPara5; 
}UserConfigInfo;

//详细配置结构体
typedef struct _DetailedConfigInfo
{
    int AlgorithmType;					//算法类型
    int identifier;                     //算法识别码
    unsigned char parabuf[100];					//参数缓存
}DetailedConfigInfo;

//系统参数
typedef struct _SystemConfig
{
	unsigned char mode;					//模式配置，里面：bit0表示工作模式，0：上传处理结果模式；1：原始数据模式
	int radarId;						//雷达ID
	float startAngle;					//起始角，单位：弧度
	float stopAngle;					//结束角，单位：弧度
	
}SystemConfig;


//IP参数
typedef struct _IpConfig
{
	char ip[50];						//对外的IP地址
	char subMask[50];					//系统的子网掩码
	int port;							//对外服务的端口	
}IpConfig;


//私有参数,存储系统内部的一些参数
typedef struct _privateConfig
{
	char radarIp[50];					//雷达传感器的IP
	int radarPort;						//雷达传感器的端口
	char com[50];						//雷达的串口号
	int bitRate;						//雷达的波特率

}PrivateConfig;


typedef struct  _RPRadarInfo       //雷达信息（雷达协议的信息结构体）
{
	BYTE  version;
}RPRadarInfo;


//雷达收到的命令枚举
typedef enum _RPRadarCmd
{
	CMD_RADARSTART			=0X01,				//雷达开启命令
	CMD_RADARSTOP			=0X02,				//雷达停止命令

	CMD_RADARGETSYSPARA		=0X03,				//索要系统参数命令
	CMD_RADARGETUSERALG		=0X04,				//索要用户算法配置命令
	CMD_RADARGETDETAILALG	=0X05,				//索要详细算法配置命令

	CMD_RADARGETSTATE		=0X06,				//状态查询命令
	CMD_RADARGETRADARINFO	=0X07,				//雷达信息获取命令

	CMD_RADARSETSYSPARA		=0X08,				//设置系统参数命令
	CMD_RADARSETUSERALG		=0X09,				//设置用户算法配置参数命令
	CMD_RADARSETDETAILALG	=0X0a,				//设置详细算法配置参数命令
	CMD_RADARSETIP			=0X0b,				//设置IP参数命令
	
	CMD_RADARGETIP			=0X0c,				//获取IP参数命令
	
}RPRadarCmd;

//雷达上报报文类型
typedef enum _RPRadarReturnType
{
	CMD_ANWSER				=0X01,				//应答
	CMD_RAWDATA				=0X02,				//原始数据
	CMD_SYSCONFIG			=0X03,				//系统参数
	CMD_UALGCONFIG			=0X04,				//用户算法参数
	CMD_DALGCONFIG			=0X05,				//详细算法参数
	CMD_ALGRESULT			=0X06,				//算法处理结果
	CMD_RADARINFO			=0X07,				//雷达信息
	CMD_IPCONFIG			=0X0C,				//IP配置
}RPRadarReturnType;

//雷达应答结果枚举
typedef enum _RPRadarAnwser
{
	ANW_RADARSTART_OK		=0X01,				//雷达开启成功应答	
	ANW_RADARSTART_ERR		=0X02,				//雷达开启失败应答	

	ANW_RADARSTOP_OK		=0X03,				//雷达停止成功应答	
	ANW_RADARSTOP_ERR		=0X04,				//雷达停止失败应答
	
	ANW_RADARSETPARA_OK		=0X05,				//雷达新参数设置成功应答	
	ANW_RADARSETPARA_ERR	=0X06,				//雷达新参数设置失败应答	

	ANW_RADARSTATE_OK		=0X08,				//当前状态正常（作为对"状态查询命令"的应答）	
	
	ANW_RADAR_UNDERVOL		=0X0b,				//雷达电压不足	
	ANW_RADAR_TIMEOUT		=0X0c,				//获取原始数据超时
	ANW_RADAR_ABORT			=0X0d,				//系统出现其他异常
}RPRadarAnwser;

#endif