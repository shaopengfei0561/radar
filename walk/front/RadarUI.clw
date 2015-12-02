; CLW file contains information for the MFC ClassWizard

[General Info]
Version=1
LastClass=CPeizDlg
LastTemplate=CDialog
NewFileInclude1=#include "stdafx.h"
NewFileInclude2=#include "RadarUI.h"

ClassCount=6
Class1=CRadarUIApp
Class2=CRadarUIDlg
Class3=CAboutDlg

ResourceCount=6
Resource1=IDD_RADARUI_DIALOG
Resource2=IDR_MAINFRAME
Resource3=IDD_ABOUTBOX
Resource4=IDD_PEIZHI
Class4=CPeizDlg
Class5=CChakDlg
Resource5=IDD_CHAKAN
Class6=CSetParseDlg
Resource6=IDD_DIALOG_ALG_MORE_DETECT

[CLS:CRadarUIApp]
Type=0
HeaderFile=RadarUI.h
ImplementationFile=RadarUI.cpp
Filter=N
LastObject=IDC_BUTTON_STARTRADAR

[CLS:CRadarUIDlg]
Type=0
HeaderFile=RadarUIDlg.h
ImplementationFile=RadarUIDlg.cpp
Filter=D
LastObject=CRadarUIDlg
BaseClass=CDialog
VirtualFilter=dWC

[CLS:CAboutDlg]
Type=0
HeaderFile=RadarUIDlg.h
ImplementationFile=RadarUIDlg.cpp
Filter=D
LastObject=CAboutDlg

[DLG:IDD_ABOUTBOX]
Type=1
Class=CAboutDlg
ControlCount=4
Control1=IDC_STATIC,static,1342177283
Control2=IDC_STATIC,static,1342308480
Control3=IDC_STATIC,static,1342308352
Control4=IDOK,button,1342373889

[DLG:IDD_RADARUI_DIALOG]
Type=1
Class=CRadarUIDlg
ControlCount=9
Control1=IDC_BUTTON1,button,1342242816
Control2=IDC_BUTTON2,button,1342242816
Control3=IDC_BUTTON3,button,1342242816
Control4=IDC_BUTTON4,button,1342242816
Control5=IDC_STATIC,button,1342178055
Control6=IDC_STATIC,static,1342308352
Control7=IDC_STATIC,static,1342308352
Control8=IDC_PROGRESS1,msctls_progress32,1350565888
Control9=IDC_PROGRESS2,msctls_progress32,1350565888

[CLS:CPeizDlg]
Type=0
HeaderFile=PeizDlg.h
ImplementationFile=PeizDlg.cpp
BaseClass=CDialog
Filter=D
LastObject=CPeizDlg
VirtualFilter=dWC

[CLS:CChakDlg]
Type=0
HeaderFile=ChakDlg.h
ImplementationFile=ChakDlg.cpp
BaseClass=CDialog
Filter=D
LastObject=CChakDlg
VirtualFilter=dWC

[DLG:IDD_DIALOG_ALG_MORE_DETECT]
Type=1
Class=CSetParseDlg
ControlCount=45
Control1=IDC_STATIC,button,1342177287
Control2=IDC_STATIC_DT_DISMIN,static,1342308354
Control3=IDC_EDIT_ALG_MORE_DETECT_ANGLEDEVIATION,edit,1350631552
Control4=IDC_STATIC_DT_OFFSETMAX,static,1342308354
Control5=IDC_STATIC_DT_ANGLEMAX,static,1342308354
Control6=IDC_STATIC_DT_MAPPERIOD,static,1342308354
Control7=IDC_STATIC_DT_BLGMAPTIME,static,1342308354
Control8=IDC_STATIC_DT_ANGLEMIN,static,1342308354
Control9=ORE_DETECT_MAXRANGE,edit,1350631552
Control10=IDC_EDIT_ALG_MORE_DETECT_MINANGLE,edit,1350631552
Control11=IDC_EDIT_ALG_MORE_DETECT_MAXANGLE,edit,1350631552
Control12=IDC_EDIT_ALG_MORE_DETECT_MAPPINGTIME,edit,1350631552
Control13=IDC_EDIT_ALG_MORE_DETECT_MAPPINGPREIOD,edit,1350631552
Control14=IDC_STATIC_DT_ADJACENT,static,1342308354
Control15=IDC_STATIC_DT_OFFSET,static,1342308354
Control16=IDC_STATIC_DT_OBJWIDTHMIN,static,1342308354
Control17=IDC_EDIT_ALG_MORE_DETECT_BACKGROUNDOFFSET,edit,1350631552
Control18=IDC_EDIT_ALG_MORE_DETECT_ADJACENTJUMP,edit,1350631552
Control19=IDC_EDIT_ALG_MORE_DETECT_MINWIDTH,edit,1350631552
Control20=IDC_STATIC_DT_MAXSTEP,static,1342308354
Control21=IDC_EDIT_ALG_MORE_DETECT_MAXSTRDE,edit,1350631552
Control22=IDC_STATIC_DT_FUSHIONWIDTH,static,1342308354
Control23=IDC_STATIC_DT_INSTALLHEIGHT,static,1342308354
Control24=IDC_STATIC_DT_VANMAX,static,1342308354
Control25=IDC_STATIC_DT_SENSITIVITY,static,1342308354
Control26=IDC_EDIT_ALG_MORE_DETECT_MINRANGE,edit,1350631552
Control27=IDC_EDIT_ALG_MORE_DETECT_LIDARHEIGHT,edit,1350631552
Control28=IDC_EDIT_ALG_MORE_DETECT_SENSITIVITY,edit,1350631552
Control29=IDC_EDIT_ALG_MORE_DETECT_FUSHIONWIDTH,edit,1350631552
Control30=IDC_EDIT_ALG_MORE_DETECT_FUSIONDISTANCE,edit,1350631552
Control31=IDC_STATIC_DT_PASTTIME,static,1342308354
Control32=IDC_STATIC_DT_FUSHIONSTEP,static,1342308354
Control33=IDC_STATIC_DT_THROWFUSHIONSTEP,static,1342308354
Control34=IDC_STATIC_DT_FLOWINTERVAL,static,1342308354
Control35=IDC_STATIC_DT_THROWMINWIDTH,static,1342308354
Control36=IDC_STATIC_DT_FUSIONFRAMRNUM,static,1342308354
Control37=IDC_EDIT_ALG_MORE_DETECT_FLOWINTERVAL,edit,1350631552
Control38=IDC_EDIT_ALG_MORE_DETECT_HUMANFUSHIONFN,edit,1350631552
Control39=IDC_EDIT_ALG_MORE_DETECT_MINCARWIDTH,edit,1350631552
Control40=IDC_EDIT_ALG_MORE_DETECT_FUSHIONSTEP,edit,1350631552
Control41=IDC_EDIT_ALG_MORE_DETECT_CARFUSIONFN,edit,1350631552
Control42=IDC_STATIC_DT_HUMANFUSHIONFN,static,1342308354
Control43=IDC_EDIT_ALG_MORE_DETECT_MINHUMANWIDTH,edit,1350631552
Control44=IDC_OK,button,1342242816
Control45=IDC_CANNAL,button,1342242816

[CLS:CSetParseDlg]
Type=0
HeaderFile=SetParseDlg.h
ImplementationFile=SetParseDlg.cpp
BaseClass=CDialog
Filter=D
LastObject=IDC_CANNAL
VirtualFilter=dWC

[DLG:IDD_CHAKAN]
Type=1
Class=CChakDlg
ControlCount=51
Control1=IDC_STATIC,button,1342177287
Control2=IDC_STATIC,button,1342177287
Control3=IDC_STATIC,static,1342308352
Control4=IDC_IPADDRESS1,SysIPAddress32,1342242816
Control5=IDC_OK,button,1342242816
Control6=IDC_STATIC,static,1342308352
Control7=IDC_PORT,edit,1350631552
Control8=IDC_SAVEPATH,edit,1350631552
Control9=IDC_STATIC,static,1342308352
Control10=IDC_STATIC_DT_DISMIN,static,1342308354
Control11=IDC_EDIT_ALG_MORE_DETECT_ANGLEDEVIATION,edit,1350631552
Control12=IDC_STATIC_DT_OFFSETMAX,static,1342308354
Control13=IDC_STATIC_DT_ANGLEMAX,static,1342308354
Control14=IDC_STATIC_DT_MAPPERIOD,static,1342308354
Control15=IDC_STATIC_DT_BLGMAPTIME,static,1342308354
Control16=IDC_STATIC_DT_ANGLEMIN,static,1342308354
Control17=ORE_DETECT_MAXRANGE,edit,1350631552
Control18=IDC_EDIT_ALG_MORE_DETECT_MINANGLE,edit,1350631552
Control19=IDC_EDIT_ALG_MORE_DETECT_MAXANGLE,edit,1350631552
Control20=IDC_EDIT_ALG_MORE_DETECT_MAPPINGTIME,edit,1350631552
Control21=IDC_EDIT_ALG_MORE_DETECT_MAPPINGPREIOD,edit,1350631552
Control22=IDC_STATIC_DT_ADJACENT,static,1342308354
Control23=IDC_STATIC_DT_OFFSET,static,1342308354
Control24=IDC_STATIC_DT_OBJWIDTHMIN,static,1342308354
Control25=IDC_EDIT_ALG_MORE_DETECT_BACKGROUNDOFFSET,edit,1350631552
Control26=IDC_EDIT_ALG_MORE_DETECT_ADJACENTJUMP,edit,1350631552
Control27=IDC_EDIT_ALG_MORE_DETECT_MINWIDTH,edit,1350631552
Control28=IDC_STATIC_DT_MAXSTEP,static,1342308354
Control29=IDC_EDIT_ALG_MORE_DETECT_MAXSTRDE,edit,1350631552
Control30=IDC_STATIC_DT_FUSHIONWIDTH,static,1342308354
Control31=IDC_STATIC_DT_INSTALLHEIGHT,static,1342308354
Control32=IDC_STATIC_DT_VANMAX,static,1342308354
Control33=IDC_STATIC_DT_SENSITIVITY,static,1342308354
Control34=IDC_EDIT_ALG_MORE_DETECT_MINRANGE,edit,1350631552
Control35=IDC_EDIT_ALG_MORE_DETECT_LIDARHEIGHT,edit,1350631552
Control36=IDC_EDIT_ALG_MORE_DETECT_SENSITIVITY,edit,1350631552
Control37=IDC_EDIT_ALG_MORE_DETECT_FUSHIONWIDTH,edit,1350631552
Control38=IDC_EDIT_ALG_MORE_DETECT_FUSIONDISTANCE,edit,1350631552
Control39=IDC_STATIC_DT_PASTTIME,static,1342308354
Control40=IDC_STATIC_DT_FUSHIONSTEP,static,1342308354
Control41=IDC_STATIC_DT_THROWFUSHIONSTEP,static,1342308354
Control42=IDC_STATIC_DT_FLOWINTERVAL,static,1342308354
Control43=IDC_STATIC_DT_THROWMINWIDTH,static,1342308354
Control44=IDC_STATIC_DT_FUSIONFRAMRNUM,static,1342308354
Control45=IDC_EDIT_ALG_MORE_DETECT_FLOWINTERVAL,edit,1350631552
Control46=IDC_EDIT_ALG_MORE_DETECT_HUMANFUSHIONFN,edit,1350631552
Control47=IDC_EDIT_ALG_MORE_DETECT_MINCARWIDTH,edit,1350631552
Control48=IDC_EDIT_ALG_MORE_DETECT_FUSHIONSTEP,edit,1350631552
Control49=IDC_EDIT_ALG_MORE_DETECT_CARFUSIONFN,edit,1350631552
Control50=IDC_STATIC_DT_HUMANFUSHIONFN,static,1342308354
Control51=IDC_EDIT_ALG_MORE_DETECT_MINHUMANWIDTH,edit,1350631552

[DLG:IDD_PEIZHI]
Type=1
Class=CPeizDlg
ControlCount=18
Control1=IDC_STATIC,button,1342177287
Control2=IDC_STATIC,static,1342308352
Control3=IDC_IPADDRESS,SysIPAddress32,1342242816
Control4=IDC_BUTTON_STARTRADAR,button,1342242816
Control5=IDC_BUTTON2,button,1342242816
Control6=IDC_SavaPath,edit,1350631552
Control7=IDC_STATIC,button,1342177287
Control8=IDC_STATIC,static,1342308352
Control9=IDC_LIST1,listbox,1352728835
Control10=IDC_PORT,edit,1350631552
Control11=IDC_STATIC,static,1342308352
Control12=IDC_BUTTON1,button,1342242816
Control13=IDC_STATIC,button,1342177287
Control14=IDC_STATIC,static,1342308352
Control15=IDC_IPADDRESS1,SysIPAddress32,1342242816
Control16=IDC_STATIC,static,1342308352
Control17=IDC_PORT1,edit,1350631552
Control18=IDC_STATIC1,static,1342177287
