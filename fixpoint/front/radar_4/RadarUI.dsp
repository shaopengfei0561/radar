# Microsoft Developer Studio Project File - Name="RadarUI" - Package Owner=<4>
# Microsoft Developer Studio Generated Build File, Format Version 6.00
# ** DO NOT EDIT **

# TARGTYPE "Win32 (x86) Application" 0x0101

CFG=RadarUI - Win32 Release
!MESSAGE This is not a valid makefile. To build this project using NMAKE,
!MESSAGE use the Export Makefile command and run
!MESSAGE 
!MESSAGE NMAKE /f "RadarUI.mak".
!MESSAGE 
!MESSAGE You can specify a configuration when running NMAKE
!MESSAGE by defining the macro CFG on the command line. For example:
!MESSAGE 
!MESSAGE NMAKE /f "RadarUI.mak" CFG="RadarUI - Win32 Release"
!MESSAGE 
!MESSAGE Possible choices for configuration are:
!MESSAGE 
!MESSAGE "RadarUI - Win32 Debug" (based on "Win32 (x86) Application")
!MESSAGE "RadarUI - Win32 Release" (based on "Win32 (x86) Application")
!MESSAGE 

# Begin Project
# PROP AllowPerConfigDependencies 0
# PROP Scc_ProjName ""
# PROP Scc_LocalPath ""
CPP=cl.exe
MTL=midl.exe
RSC=rc.exe

!IF  "$(CFG)" == "RadarUI - Win32 Debug"

# PROP BASE Use_MFC 6
# PROP BASE Use_Debug_Libraries 1
# PROP BASE Output_Dir "Debug"
# PROP BASE Intermediate_Dir "Debug"
# PROP BASE Target_Dir ""
# PROP Use_MFC 6
# PROP Use_Debug_Libraries 1
# PROP Output_Dir "Debug"
# PROP Intermediate_Dir "Debug"
# PROP Ignore_Export_Lib 0
# PROP Target_Dir ""
# ADD BASE CPP /nologo /MDd /W3 /Gm /GX /ZI /Od /D "WIN32" /D "_DEBUG" /D "_WINDOWS" /D "_AFXDLL" /Yu"stdafx.h" /FD /GZ /c
# ADD CPP /nologo /MDd /W3 /Gm /GX /ZI /Od /D "WIN32" /D "_DEBUG" /D "_WINDOWS" /D "_AFXDLL" /FR /FD /GZ /c
# SUBTRACT CPP /WX /YX /Yc /Yu
# ADD BASE MTL /nologo /D "_DEBUG" /mktyplib203 /win32
# ADD MTL /nologo /D "_DEBUG" /mktyplib203 /win32
# ADD BASE RSC /l 0x804 /d "_DEBUG" /d "_AFXDLL"
# ADD RSC /l 0x804 /d "_DEBUG" /d "_AFXDLL"
BSC32=bscmake.exe
# ADD BASE BSC32 /nologo
# ADD BSC32 /nologo
LINK32=link.exe
# ADD BASE LINK32 /nologo /subsystem:windows /debug /machine:I386 /pdbtype:sept
# ADD LINK32 Ws2_32.lib SkinPPWTL.lib /nologo /stack:0x10000000 /subsystem:windows /debug /machine:I386 /pdbtype:sept

!ELSEIF  "$(CFG)" == "RadarUI - Win32 Release"

# PROP BASE Use_MFC 6
# PROP BASE Use_Debug_Libraries 1
# PROP BASE Output_Dir "RadarUI___Win32_Release"
# PROP BASE Intermediate_Dir "RadarUI___Win32_Release"
# PROP BASE Ignore_Export_Lib 0
# PROP BASE Target_Dir ""
# PROP Use_MFC 6
# PROP Use_Debug_Libraries 1
# PROP Output_Dir "Release"
# PROP Intermediate_Dir "Release"
# PROP Ignore_Export_Lib 0
# PROP Target_Dir ""
# ADD BASE CPP /nologo /MDd /W3 /Gm /GX /ZI /Od /D "WIN32" /D "_DEBUG" /D "_WINDOWS" /D "_AFXDLL" /FR /FD /GZ /c
# SUBTRACT BASE CPP /WX /YX /Yc /Yu
# ADD CPP /nologo /MD /W3 /GX /O2 /D "WIN32" /D "NDEBUG" /D "_WINDOWS" /D "_AFXDLL" /D "_MBCS" /FR /Yu"stdafx.h" /FD /c
# ADD BASE MTL /nologo /D "_DEBUG" /mktyplib203 /win32
# ADD MTL /nologo /D "_DEBUG" /mktyplib203 /win32
# ADD BASE RSC /l 0x804 /d "_DEBUG" /d "_AFXDLL"
# ADD RSC /l 0x804 /d "_DEBUG" /d "_AFXDLL"
BSC32=bscmake.exe
# ADD BASE BSC32 /nologo
# ADD BSC32 /nologo
LINK32=link.exe
# ADD BASE LINK32 Ws2_32.lib SkinPPWTL.lib /nologo /subsystem:windows /debug /machine:I386 /pdbtype:sept
# ADD LINK32 Ws2_32.lib SkinPPWTL.lib /nologo /subsystem:windows /debug /machine:I386 /pdbtype:sept

!ENDIF 

# Begin Target

# Name "RadarUI - Win32 Debug"
# Name "RadarUI - Win32 Release"
# Begin Group "Source Files"

# PROP Default_Filter "cpp;c;cxx;rc;def;r;odl;idl;hpj;bat"
# Begin Source File

SOURCE=.\AlgBase.cpp
# End Source File
# Begin Source File

SOURCE=.\AlgClassify.cpp
# End Source File
# Begin Source File

SOURCE=.\ChakDlg.cpp
# End Source File
# Begin Source File

SOURCE=.\Coordinate.cpp
# End Source File
# Begin Source File

SOURCE=.\LeuzeSocketComm.cpp
# End Source File
# Begin Source File

SOURCE=.\PeizDlg.cpp
# End Source File
# Begin Source File

SOURCE=.\RadarCommunicationBase.cpp
# End Source File
# Begin Source File

SOURCE=.\RadarUI.cpp
# End Source File
# Begin Source File

SOURCE=.\RadarUI.rc
# End Source File
# Begin Source File

SOURCE=.\RadarUIDlg.cpp
# End Source File
# Begin Source File

SOURCE=.\rs232.c
# End Source File
# Begin Source File

SOURCE=.\SetParseDlg.cpp
# End Source File
# Begin Source File

SOURCE=.\StdAfx.cpp
# ADD CPP /Yc"stdafx.h"
# End Source File
# Begin Source File

SOURCE=.\YTController.cpp
# End Source File
# End Group
# Begin Group "Header Files"

# PROP Default_Filter "h;hpp;hxx;hm;inl"
# Begin Source File

SOURCE=.\AlgBase.h
# End Source File
# Begin Source File

SOURCE=.\AlgClassify.h
# End Source File
# Begin Source File

SOURCE=.\ChakDlg.h
# End Source File
# Begin Source File

SOURCE=.\Coordinate.h
# End Source File
# Begin Source File

SOURCE=.\LeuzeSocketComm.h
# End Source File
# Begin Source File

SOURCE=.\PeizDlg.h
# End Source File
# Begin Source File

SOURCE=.\RadarCommunicationBase.h
# End Source File
# Begin Source File

SOURCE=.\RadarUI.h
# End Source File
# Begin Source File

SOURCE=.\RadarUIDlg.h
# End Source File
# Begin Source File

SOURCE=.\Resource.h
# End Source File
# Begin Source File

SOURCE=.\rs232.h
# End Source File
# Begin Source File

SOURCE=.\SetParseDlg.h
# End Source File
# Begin Source File

SOURCE=.\StdAfx.h
# End Source File
# Begin Source File

SOURCE=.\struct.h
# End Source File
# Begin Source File

SOURCE=.\YTController.h
# End Source File
# End Group
# Begin Group "Resource Files"

# PROP Default_Filter "ico;cur;bmp;dlg;rc2;rct;bin;rgs;gif;jpg;jpeg;jpe"
# Begin Source File

SOURCE=.\res\012107.bmp
# End Source File
# Begin Source File

SOURCE=.\res\RadarUI.ico
# End Source File
# Begin Source File

SOURCE=.\res\RadarUI.rc2
# End Source File
# End Group
# Begin Source File

SOURCE=.\ReadMe.txt
# End Source File
# End Target
# End Project
