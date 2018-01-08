; 选择压缩方式
SetCompressor  LZMA
!AddPluginDir MyPlugin
; 引入的头文件
!include "nsDialogs.nsh"
!include "FileFunc.nsh"
!include  MUI.nsh
!include  LogicLib.nsh
!include  WinMessages.nsh
!include "MUI2.nsh"
!include "WordFunc.nsh"
!include "Library.nsh"
!include "basehelp.nsh"

; 引入的dll
ReserveFile "${NSISDIR}\Plugins\system.dll"
ReserveFile "${NSISDIR}\Plugins\nsDialogs.dll"
ReserveFile "${NSISDIR}\Plugins\nsExec.dll"
ReserveFile "${NSISDIR}\Plugins\InstallOptions.dll"


; 名称宏定义
!define PRODUCT_NAME              "HaloRadio"
!define PRODUCT_VERSION           "0.5.1"
!define PRODUCT_NAME_EN           "HaloRadio"
!define PRODUCT_ROOT_KEY          "HKLM"
!define PRODUCT_SUB_KEY           "SOFTWARE\icyarrow\HaloRadio"
!define PRODUCT_MAIN_EXE          "HaloRadio.exe"
!define PRODUCT_MAIN_EXE_MUTEX    "{3D3CB097-93A1-440a-954F-6D253C50CE33}"
!define SETUP_MUTEX_NAME          "{50A3E52E-6F7F-4411-9791-63BD15BBF2C3}"
!define MUI_ICON                  ".\setup res\install.ico"    ; 安装icon
!define MUI_UNICON                ".\setup res\uninst.ico"  ; 卸载icon


!define PRODUCT_PUBLISHER         "IcyArrow"
!define PRODUCT_LEGAL             "copyright © IcyArrow"
!define PRODUCT_WEBSITE           "http://www.icyarrow.com"



!macro MutexCheck _mutexname _outvar _handle
System::Call 'kernel32::CreateMutexA(i 0, i 0, t "${_mutexname}" ) i.r1 ?e'
StrCpy ${_handle} $1
Pop ${_outvar}
!macroend 

;Languages 

!insertmacro MUI_LANGUAGE "English"
LangString DUILIB_RESOURCE ${LANG_ENGLISH} "en-US"
LangString CANCEL_INSTALL_TITLE ${LANG_ENGLISH} "Confirm"
LangString CANCEL_INSTALL_MESSAGE ${LANG_ENGLISH} " Would you like to cancel Install ${PRODUCT_NAME}?"
LangString CANCEL_UNINSTALL_TITLE ${LANG_ENGLISH} "${PRODUCT_NAME} Uninstall"
LangString CANCEL_UNINSTALL_MESSAGE ${LANG_ENGLISH} " Would you like to cancel uninstall ${PRODUCT_NAME}?"
LangString PROUDUCT_RUNNING_MESSAGE ${LANG_ENGLISH} "${PRODUCT_NAME} is running。Please close it then try again！"
LangString INSTALLER_RUNNING_MESSAGE ${LANG_ENGLISH} "${PRODUCT_NAME} Installer is running！"
LangString SYSTEM_REQUIRE_MESSAGE ${LANG_ENGLISH} "${PRODUCT_NAME} Require Windows XP above。"
LangString OVERWRITE_INSTALL_MESSAGE ${LANG_ENGLISH} "${PRODUCT_NAME} Installed already,Overwrite it？"
LangString OVERWRITE_WITH_OLD_INSTALL_MESSAGE ${LANG_ENGLISH} "Newer version ${PRODUCT_NAME} founded，you need to uninstall it before continue."
LangString TEMP_DISK_FREE_SPACE_ERROR_MESSAGE ${LANG_ENGLISH} "Free disk space of Temp directory is too small to unzip files"
LangString UNINSTALL_PREFIX ${LANG_ENGLISH} "Uninstall"
LangString CHOOSE_INSTALL_LOCATION ${LANG_ENGLISH} "Choose install location"


/*

!insertmacro MUI_LANGUAGE "SimpChinese"
LangString DUILIB_RESOURCE ${LANG_SIMPCHINESE} "zh-CN"
LangString CANCEL_INSTALL_TITLE ${LANG_SIMPCHINESE} "提示"
LangString CANCEL_INSTALL_MESSAGE ${LANG_SIMPCHINESE} "确定要退出 ${PRODUCT_NAME} 安装?"
LangString CANCEL_UNINSTALL_TITLE ${LANG_SIMPCHINESE} "${PRODUCT_NAME} 卸载"
LangString CANCEL_UNINSTALL_MESSAGE ${LANG_SIMPCHINESE} "确定要取消 ${PRODUCT_NAME} 卸载?"
LangString PROUDUCT_RUNNING_MESSAGE ${LANG_SIMPCHINESE} "您已经运行了 ${PRODUCT_NAME} 程序。请关闭该程序后再试！"
LangString INSTALLER_RUNNING_MESSAGE ${LANG_SIMPCHINESE} "您已经运行了安装卸载程序！"
LangString SYSTEM_REQUIRE_MESSAGE ${LANG_SIMPCHINESE} "对不起，HaloRadio目前仅可以安装在Windows 7/XP/Vista操作系统上。"
LangString OVERWRITE_INSTALL_MESSAGE ${LANG_SIMPCHINESE} "您已经安装当前版本的 ${PRODUCT_NAME},是否覆盖安装？"
LangString OVERWRITE_WITH_OLD_INSTALL_MESSAGE ${LANG_SIMPCHINESE} "您已经安装较新版本的 ${PRODUCT_NAME}，此旧版本无法完成安装，继续安装需先卸载已有版本"
LangString TEMP_DISK_FREE_SPACE_ERROR_MESSAGE ${LANG_SIMPCHINESE} "临时目录所在磁盘空间不足，无法解压！"
LangString UNINSTALL_PREFIX ${LANG_SIMPCHINESE} "卸载"
LangString CHOOSE_INSTALL_LOCATION ${LANG_SIMPCHINESE} "选择安装目录"

*/

!insertmacro MUI_LANGUAGE "TradChinese"
LangString DUILIB_RESOURCE ${LANG_TRADCHINESE} "zh-HK"
LangString CANCEL_INSTALL_TITLE ${LANG_TRADCHINESE} "提示"
LangString CANCEL_INSTALL_MESSAGE ${LANG_TRADCHINESE} "確定要退出 ${PRODUCT_NAME} 安裝?"
LangString CANCEL_UNINSTALL_TITLE ${LANG_TRADCHINESE} "${PRODUCT_NAME} 卸載"
LangString CANCEL_UNINSTALL_MESSAGE ${LANG_TRADCHINESE} "確定要取消 ${PRODUCT_NAME} 卸載?"
LangString PROUDUCT_RUNNING_MESSAGE ${LANG_TRADCHINESE} "您已經運行了 ${PRODUCT_NAME} 程序。請關閉該程序後再試！"
LangString INSTALLER_RUNNING_MESSAGE ${LANG_TRADCHINESE} "您已經運行了安裝卸載程序！"
LangString SYSTEM_REQUIRE_MESSAGE ${LANG_TRADCHINESE} "對不起，${PRODUCT_NAME} 目前僅可以安裝在Windows 7/XP/Vista操作系統上。"
LangString OVERWRITE_INSTALL_MESSAGE ${LANG_TRADCHINESE} "您已經安裝當前版本的 ${PRODUCT_NAME},是否覆蓋安裝？"
LangString OVERWRITE_WITH_OLD_INSTALL_MESSAGE ${LANG_TRADCHINESE} "您已經安裝較新版本的 ${PRODUCT_NAME}，此舊版本無法完成安裝，繼續安裝需先卸載已有版本"
LangString TEMP_DISK_FREE_SPACE_ERROR_MESSAGE ${LANG_TRADCHINESE} "臨時目錄所在磁盤空間不足，無法解壓！"
LangString UNINSTALL_PREFIX ${LANG_TRADCHINESE} "卸載"
LangString CHOOSE_INSTALL_LOCATION ${LANG_TRADCHINESE} "選擇安裝目錄"


Var Dialog
Var MessageBoxHandle
Var DesktopIconState
Var FastIconState
Var FreeSpaceSize
Var installPath
Var timerID
Var timerID4Uninstall
Var changebkimageIndex
Var changebkimage4UninstallIndex
Var RunNow
Var InstallState
Var LocalPath
Var 360Safetemp

Name      "${PRODUCT_NAME}"              ; 提示对话框的标题
OutFile   "${PRODUCT_NAME_EN}Setup.exe"  ; 输出的安装包名

InstallDir "$PROGRAMFILES\${PRODUCT_PUBLISHER}\${PRODUCT_NAME_EN}"                   ;Default installation folder
InstallDirRegKey ${PRODUCT_ROOT_KEY} ${PRODUCT_SUB_KEY} "installDir"   ;Get installation folder from registry if available



!packhdr "$%TEMP%\exehead.tmp" 'header.cmd'

;Request application privileges for Windows Vista
RequestExecutionLevel admin

;--------------------------------------------------------------------------------------------------------------------------------------------------------------

;Installer Sections

Section "Dummy Section" SecDummy
  

  ;复制要发布的安装文件  
  SetOutPath "$INSTDIR"
  SetOverWrite on
  File /r /x *.svn /x *.ipdb /x *.iobj /x *.lib /x *.exp /x *.pdb /x .debug /x .projectCentennial /x *.log /x *.vs "..\..\..\ONERadio\bin\Release\*.*"
  SetOverWrite on
  SetRebootFlag false
 
  WriteUninstaller "$INSTDIR\Uninstall.exe"   ;Create uninstaller
  Call BuildShortCut



SectionEnd
 

;--------------------------------------------------------------------------------------------------------------------------------------------------------------

;Uninstaller Section

Section "Uninstall"
  ;执行uninstall.exe
  Delete "$SMSTARTUP\${PRODUCT_NAME}.lnk"
  Delete "$DESKTOP\${PRODUCT_NAME}.lnk"
  Delete "$QUICKLAUNCH\${PRODUCT_NAME}.lnk"

  SetShellVarContext all
  RMDir /r /REBOOTOK "$SMPROGRAMS\${PRODUCT_NAME}"

  
  SetShellVarContext current
  RMDir /r /REBOOTOK "$SMPROGRAMS\${PRODUCT_NAME}"
  RMDir /r /REBOOTOK "$APPDATA\${PRODUCT_PUBLISHER}\${PRODUCT_NAME_EN}"
  
  SetRebootFlag false
  RMDir /r /REBOOTOK "$INSTDIR"
  DeleteRegKey ${PRODUCT_ROOT_KEY} "${PRODUCT_SUB_KEY}"

  SetRebootFlag false
  DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT_NAME_EN}"

  DeleteRegValue HKCU  "Software\Microsoft\Windows\CurrentVersion\Run" "${PRODUCT_NAME_EN}"

  Delete "$INSTDIR\Uninstall.exe"
  ;RMDir "$INSTDIR"	
SectionEnd

;--------------------------------------------------------------------------------------------------------------------------------------------------------------

; 安装和卸载页面
Page         custom     360Safe
;Page         instfiles  "" InstallShow

UninstPage   custom     un.360SafeUninstall
;UninstPage   instfiles  "" un.UninstallShow

;--------------------------------------------------------------------------------------------------------------------------------------------------------------

Function 360Safe

  
  ;MessageBox MB_OK "start......."


  SetOutPath "$PLUGINSDIR"
  File "MyDll\*.dll"
  ;ExecShell open $PLUGINSDIR

   ;初始化窗口          
   SkinEngine::InitTBCIASkinEngine /NOUNLOAD "$temp\${PRODUCT_NAME_EN}Setup\res\$(DUILIB_RESOURCE)" "InstallPackages.xml" "WizardTab"
   Pop $Dialog

   ;初始化MessageBox窗口
   SkinEngine::InitTBCIAMessageBox "MessageBox.xml" "TitleLab" "TextLab" "CloseBtn" "YESBtn" "NOBtn"
   Pop $MessageBoxHandle   


   

   ;全局按钮绑定函数
   ;最小化按钮绑定函数
   SkinEngine::FindControl "Wizard_MinBtn"
   Pop $0
   ${If} $0 == "-1"
	MessageBox MB_OK "Do not have min button"
   ${Else}
	GetFunctionAddress $0 OnGlobalMinFunc
	SkinEngine::OnControlBindNSISScript "Wizard_MinBtn" $0
   ${EndIf}
   ;关闭按钮绑定函数
   SkinEngine::FindControl "Wizard_CloseBtn"
   Pop $0
   ${If} $0 == "-1"
	MessageBox MB_OK "Do not have close button"
   ${Else}
	GetFunctionAddress $0 OnGlobalCancelFunc
	SkinEngine::OnControlBindNSISScript "Wizard_CloseBtn" $0
   ${EndIf}

   ;----------------------------第一个页面-----------------------------------------------
   ; 显示licence
   SkinEngine::FindControl "LicenceRichEdit"
   Pop $0
   ${If} $0 == "-1"
	MessageBox MB_OK "Do not have LicenceRichEdit button"
   ${Else}
	SkinEngine::ShowLicense "LicenceRichEdit" "Licence.txt"     ;"许可协议控件名字" "许可协议文件名字"
   ${EndIf}

   ;下一步按钮绑定函数
   SkinEngine::FindControl "Wizard_NextBtn4Page1"
   Pop $0
   ${If} $0 == "-1"
	MessageBox MB_OK "Do not have Wizard_NextBtn4Page1 button"
   ${Else}
	GetFunctionAddress $0 OnNextBtnFunc    
        SkinEngine::OnControlBindNSISScript "Wizard_NextBtn4Page1"  $0
   ${EndIf}
   ;取消按钮绑定函数
   SkinEngine::FindControl "Wizard_CancelBtn4Page1"
   Pop $0
   ${If} $0 == "-1"
	MessageBox MB_OK "Do not have Wizard_CancelBtn4Page1 button"
   ${Else}
	GetFunctionAddress $0 OnGlobalCancelFunc    
        SkinEngine::OnControlBindNSISScript "Wizard_CancelBtn4Page1"  $0
   ${EndIf}
   
   ;----------------------------第二个页面-----------------------------------------------
   ;安装路径编辑框设定数据
   SkinEngine::FindControl "Wizard_InstallPathEdit4Page2"
   Pop $0
   ${If} $0 == "-1"
	MessageBox MB_OK "Do not have Wizard_InstallPathBtn4Page2 button"
   ${Else}
	;SkinEngine::SetText2Control "Wizard_InstallPathEdit4Page2"  $installPath
	SkinEngine::SetControlData "Wizard_InstallPathEdit4Page2"  $installPath "text"

	GetFunctionAddress $0 OnTextChangeFunc
	SkinEngine::OnControlBindNSISScript "Wizard_InstallPathEdit4Page2" $0
   ${EndIf}

   ${If} $InstallState == "Cover"
	ReadRegStr $LocalPath HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT_NAME_EN}" "InstallLocation"
	StrCmp $LocalPath "" +4 0
	SkinEngine::SetControlData "Wizard_InstallPathEdit4Page2"  $LocalPath "text"
	SkinEngine::SetControlData "Wizard_InstallPathEdit4Page2" "false" "enable"
	SkinEngine::SetControlData "Wizard_InstallPathBtn4Page2" "false" "enable"
	SkinEngine::SetControlData "Wizard_StartInstallBtn4Page2" "覆盖" "text"
   ${EndIf}
   
   ;可用磁盘空间设定数据
   SkinEngine::FindControl "Wizard_UsableSpaceLab4Page2"
   Pop $0
   ${If} $0 == "-1"
	MessageBox MB_OK "Do not have Wizard_UsableSpaceLab4Page2 button"
   ${Else}
	SkinEngine::SetControlData "Wizard_UsableSpaceLab4Page2"  $FreeSpaceSize  "text"
   ${EndIf}   

   ;安装路径浏览按钮绑定函数
   SkinEngine::FindControl "Wizard_InstallPathBtn4Page2"
   Pop $0
   ${If} $0 == "-1"
	MessageBox MB_OK "Do not have Wizard_InstallPathBtn4Page2 button"
   ${Else}
	GetFunctionAddress $0 OnInstallPathBrownBtnFunc    
        SkinEngine::OnControlBindNSISScript "Wizard_InstallPathBtn4Page2"  $0
   ${EndIf}   

   ;创建桌面快捷方式绑定函数
   SkinEngine::FindControl "Wizard_ShortCutBtn4Page2"
   Pop $0
   ${If} $0 == "-1"
	MessageBox MB_OK "Do not have Wizard_ShortCutBtn4Page2 button"
   ${Else}
        StrCpy $DesktopIconState "1"
        GetFunctionAddress $0 OnDesktopIconStateFunc
        SkinEngine::OnControlBindNSISScript "Wizard_ShortCutBtn4Page2"  $0
   ${EndIf}

   ;添加到快捷启动栏绑定函数
   SkinEngine::FindControl "Wizard_QuickLaunchBarBtn4Page2"
   Pop $0
   ${If} $0 == "-1"
	MessageBox MB_OK "Do not have Wizard_QuickLaunchBarBtn4Page2 button"
   ${Else}
        StrCpy $FastIconState "1"
	GetFunctionAddress $0 OnFastIconStateFunc    
        SkinEngine::OnControlBindNSISScript "Wizard_QuickLaunchBarBtn4Page2"  $0
   ${EndIf}

   ;上一步按钮绑定函数
   SkinEngine::FindControl "Wizard_BackBtn4Page2"
   Pop $0
   ${If} $0 == "-1"
	MessageBox MB_OK "Do not have Wizard_BackBtn4Page2 button"
   ${Else}
	GetFunctionAddress $0 OnBackBtnFunc    
        SkinEngine::OnControlBindNSISScript "Wizard_BackBtn4Page2"  $0
   ${EndIf}

   ;开始安装按钮绑定函数
   SkinEngine::FindControl "Wizard_StartInstallBtn4Page2"
   Pop $0
   ${If} $0 == "-1"
	MessageBox MB_OK "Do not have Wizard_StartInstallBtn4Page2 button"
   ${Else}
	GetFunctionAddress $0 OnStartInstallBtnFunc    
        SkinEngine::OnControlBindNSISScript "Wizard_StartInstallBtn4Page2"  $0
   ${EndIf}

   ;取消按钮绑定函数
   SkinEngine::FindControl "Wizard_CancelBtn4Page2"
   Pop $0
   ${If} $0 == "-1"
	MessageBox MB_OK "Do not have Wizard_CancelBtn4Page2 button"
   ${Else}
	GetFunctionAddress $0 OnGlobalCancelFunc    
        SkinEngine::OnControlBindNSISScript "Wizard_CancelBtn4Page2"  $0
   ${EndIf}

   ;----------------------------第三个页面-----------------------------------------------
   ;取消按钮绑定函数
   SkinEngine::FindControl "Wizard_CancelBtn4Page3"
   Pop $0
   ${If} $0 == "-1"
	MessageBox MB_OK "Do not have Wizard_CancelBtn4Page3 button"
   ${Else}
	GetFunctionAddress $0 OnGlobalCancelFunc    
        SkinEngine::OnControlBindNSISScript "Wizard_CancelBtn4Page3"  $0
   ${EndIf}

   ;切换背景绑定函数
   SkinEngine::FindControl "Wizard_Background4Page3"
   Pop $0
   ${If} $0 == "-1"
	MessageBox MB_OK "Do not have Wizard_Background4Page3 button"
   ${Else}
        StrCpy $changebkimageIndex  "0"
	GetFunctionAddress $timerID OnChangeFunc   
	SkinEngine::TBCIACreatTimer $timerID 2000  ;callback interval        
   ${EndIf}   
     
   ;----------------------------第四个页面-----------------------------------------------
   SkinEngine::FindControl "Wizard_Runing360SafeBtn"
   Pop $0
   ${If} $0 == "-1"
	MessageBox MB_OK "Do not have Wizard_Runing360SafeBtn button"
   ${Else}
        SkinEngine::OnControlBindNSISScript "Wizard_Runing360SafeBtn"  $0
   ${EndIf}

   SkinEngine::FindControl "Wizard_BootRuning360SafeBtn"
   Pop $0
   ${If} $0 == "-1"
	MessageBox MB_OK "Do not have Wizard_BootRuning360SafeBtn button"
   ${Else}
        SkinEngine::OnControlBindNSISScript "Wizard_BootRuning360SafeBtn"  $0
   ${EndIf}

   ;完成按钮绑定函数
   SkinEngine::FindControl "Wizard_FinishedBtn4Page4"
   Pop $0
   ${If} $0 == "-1"
	MessageBox MB_OK "Do not have Wizard_FinishedBtn4Page4 button"
   ${Else}
	GetFunctionAddress $0 OnFinishedBtnFunc    
        SkinEngine::OnControlBindNSISScript "Wizard_FinishedBtn4Page4"  $0
   ${EndIf}

   ;链接按钮绑定函数
   SkinEngine::FindControl "Wizard_110Btn4Page4"
   Pop $0
   ${If} $0 == "-1"
	MessageBox MB_OK "Do not have Wizard_110Btn4Page4 button"
   ${Else}
	GetFunctionAddress $0 OnLinkBtnFunc    
        SkinEngine::OnControlBindNSISScript "Wizard_110Btn4Page4"  $0
   ${EndIf}

   ;---------------------------------显示------------------------------------------------
   SkinEngine::ShowPage
   
FunctionEnd

Function un.360SafeUninstall

  SetOutPath "$PLUGINSDIR"
  File "MyDll\*.dll"
   ;初始化窗口          
   SkinEngine::InitTBCIASkinEngine /NOUNLOAD "$temp\${PRODUCT_NAME_EN}Setup\res\$(DUILIB_RESOURCE)" "UninstallPackages.xml" "WizardTab"
   Pop $Dialog

   ;初始化MessageBox窗口
   SkinEngine::InitTBCIAMessageBox "MessageBox.xml" "TitleLab" "TextLab" "CloseBtn" "YESBtn" "NOBtn"
   Pop $MessageBoxHandle   

   ;全局按钮绑定函数
   ;最小化按钮绑定函数
   SkinEngine::FindControl "Wizard_MinBtn"
   Pop $0
   ${If} $0 == "-1"
	MessageBox MB_OK "Do not have min button"
   ${Else}
	GetFunctionAddress $0 un.OnGlobalMinFunc
	SkinEngine::OnControlBindNSISScript "Wizard_MinBtn" $0
   ${EndIf}
   ;关闭按钮绑定函数
   SkinEngine::FindControl "Wizard_CloseBtn"
   Pop $0
   ${If} $0 == "-1"
	MessageBox MB_OK "Do not have close button"
   ${Else}
	GetFunctionAddress $0 un.OnGlobalCancelFunc
	SkinEngine::OnControlBindNSISScript "Wizard_CloseBtn" $0
   ${EndIf}

   ;-------------------------------------确定卸载页面------------------------------------
   ;开始卸载按钮绑定函数
   SkinEngine::FindControl "UninstallBtn4UninstallPage"
   Pop $0
   ${If} $0 == "-1"
	MessageBox MB_OK "Do not have UninstallBtn4UninstallPage button"
   ${Else}
	GetFunctionAddress $0 un.OnStartUninstallBtnFunc    
        SkinEngine::OnControlBindNSISScript "UninstallBtn4UninstallPage"  $0
   ${EndIf}

   ;取消按钮绑定函数
   SkinEngine::FindControl "CancelBtn4UninstallPage"
   Pop $0
   ${If} $0 == "-1"
	MessageBox MB_OK "Do not have CancelBtn4UninstallPage button"
   ${Else}
	GetFunctionAddress $0 un.OnGlobalCancelFunc    
        SkinEngine::OnControlBindNSISScript "CancelBtn4UninstallPage"  $0
   ${EndIf}

   ;切换背景绑定函数
   SkinEngine::FindControl "Wizard_BackgroundUninstallPage"
   Pop $0
   ${If} $0 == "-1"
	MessageBox MB_OK "Do not have Wizard_BackgroundUninstallPage button"
   ${Else}
        StrCpy $changebkimage4UninstallIndex  "0"
	GetFunctionAddress $timerID4Uninstall un.OnChangeFunc   
	SkinEngine::TBCIACreatTimer $timerID4Uninstall 2000  ;callback interval        
   ${EndIf}   

    ;--------------------------------卸载完成页面----------------------------------------
   ;完成按钮绑定函数
   SkinEngine::FindControl "FinishedBtn4UninstallPage"
   Pop $0
   ${If} $0 == "-1"
	MessageBox MB_OK "Do not have FinishedBtn4UninstallPage button"
   ${Else}
	GetFunctionAddress $0 un.OnUninstallFinishedBtnFunc    
        SkinEngine::OnControlBindNSISScript "FinishedBtn4UninstallPage"  $0
   ${EndIf}

   ;链接按钮绑定函数
   SkinEngine::FindControl "Wizard_110Btn4UninstallPage"
   Pop $0
   ${If} $0 == "-1"
	MessageBox MB_OK "Do not have Wizard_110Btn4UninstallPage button"
   ${Else}
	GetFunctionAddress $0 un.OnLinkBtnFunc    
        SkinEngine::OnControlBindNSISScript "Wizard_110Btn4UninstallPage"  $0
   ${EndIf}

   SkinEngine::ShowPage   

FunctionEnd

;--------------------------------------------------------------------------------------------------------------------------------------------------------------
; 函数的定义

Function .onInit


 ; Push ${LANG_ENGLISH}
 ; Push ${LANG_SIMPCHINESE}
 ; Pop $LANGUAGE
 ;StrCpy $Language ${LANG_ENGLISH}
 ;StrCpy $Language ${LANG_TRADCHINESE}
  
    
  GetTempFileName $0
  StrCpy $360Safetemp $0
  Delete $0
  SetOutPath $temp\${PRODUCT_NAME_EN}Setup\res
  ;File ".\setup res\*.png"
  ;File ".\setup res\*.txt"
  ;File ".\setup res\*.xml"
  File /r /x *.psd ".\setup res\*.*"


  StrCpy $installPath "$PROGRAMFILES\${PRODUCT_PUBLISHER}\${PRODUCT_NAME_EN}"
  Call UpdateFreeSpace

  FindWindow $0 "UIMainFrame" "${PRODUCT_NAME_EN}"  ;判断客户端是否在运行中
  ;Dumpstate::debug
  IsWindow $0 0 +5  
     MessageBox MB_RETRYCANCEL $(PROUDUCT_RUNNING_MESSAGE) IDRETRY RetryInstall  IDCANCEL NotInstall
     RetryInstall:
       Goto -4;
     NotInstall:
       Goto +1     
  Goto close_run_cancel

  ; 判断mutex 知道是否还有安装卸载程序运行
  !insertmacro MutexCheck "${SETUP_MUTEX_NAME}" $0 $9
  StrCmp $0 0 launch
  MessageBox MB_OK $(INSTALLER_RUNNING_MESSAGE)
  Abort
  StrLen $0 "$(^Name)"
  IntOp $0 $0 + 1

 loop:
   FindWindow $1 '#32770' '' 0 $1
   StrCmp $1 0 +1 +2
   IntOp $3 $3 + 1
   IntCmp $3 3 +5
   System::Call "user32::GetWindowText(i r1, t .r2, i r0) i."
   StrCmp $2 "$(^Name)" 0 loop
   System::Call "user32::SetForegroundWindow(i r1) i."
   System::Call "user32::ShowWindow(i r1,i 9) i."
   Abort

 launch: 
  ; 判断操作系统
  Call GetWindowsVersion
  Pop $R0
  StrCmp $R0 "98"   done
  StrCmp $R0 "2000" done
   Goto End
  done:
     MessageBox MB_OK $(SYSTEM_REQUIRE_MESSAGE)
     Abort
  End:  
  
  ; 检查版本
  SetOutPath "$360Safetemp\${PRODUCT_NAME_EN}Setup"
  File "..\..\..\ONERadio\bin\Release\${PRODUCT_MAIN_EXE}"
  
  Var /GLOBAL local_setup_version
  ${GetFileVersion} "$360Safetemp\${PRODUCT_NAME_EN}Setup\${PRODUCT_MAIN_EXE}" $local_setup_version
  ReadRegStr $0 ${PRODUCT_ROOT_KEY} "${PRODUCT_SUB_KEY}" "Version"
  
  Var /Global local_check_version
  ${VersionCompare} "$local_setup_version" "$0" $local_check_version
  
  ; 覆盖安装
  ${If} $0 != ""
    ;相同版本
    ${If} $local_check_version == "0"
	StrCmp $local_check_version "0" 0 +4
	MessageBox MB_YESNO $(OVERWRITE_INSTALL_MESSAGE) IDYES true IDNO false
	true:
	   StrCpy $InstallState "Cover"
	   Goto CHECK_RUN
	false: 
	   Quit
    ;安装包版本较低
    ${ElseIf} $local_check_version == "2"
	MessageBox MB_OK|MB_ICONINFORMATION $(OVERWRITE_WITH_OLD_INSTALL_MESSAGE)
	Quit
    ;安装包版本较高
    ${Else}
	Goto CHECK_RUN
    ${EndIf}    
  ${EndIf}

  ;判断进程是否存在
  CHECK_RUN:
	Push "${PRODUCT_MAIN_EXE_MUTEX}"
	nsInstallAssist::CheckRun
	Pop $R0
	StrCmp $R0 "run" 0 NO_RUNNING_PROCESS
	MessageBox MB_RETRYCANCEL|MB_ICONINFORMATION PROUDUCT_RUNNING_MESSAGE IDRETRY close_run_retry IDCANCEL close_run_cancel
  close_run_retry:
	Goto CHECK_RUN
  close_run_cancel:
	Quit
  NO_RUNNING_PROCESS:
  
  SectionGetSize ${SecDummy} $1
  
  ${GetRoot} $360Safetemp $0
  System::Call kernel32::GetDiskFreeSpaceEx(tr0,*l,*l,*l.r0)
  System::Int64Op $0 / 1024
  Pop $2
  IntCmp $2 $1 "" "" +3
  MessageBox MB_OK|MB_ICONEXCLAMATION $(TEMP_DISK_FREE_SPACE_ERROR_MESSAGE)
  Quit  
FunctionEnd

Function .onGUIEnd
  RMDir /r $360Safetemp\${PRODUCT_NAME_EN}Temp
  IfFileExists $360Safetemp\${PRODUCT_NAME_EN}Temp 0 +2
  RMDir /r /REBOOTOK $360Safetemp\${PRODUCT_NAME_EN}Temp
FunctionEnd

Function BuildShortCut
  ;开始菜单
  CreateDirectory "$SMPROGRAMS\${PRODUCT_NAME}"
  CreateShortCut  "$SMPROGRAMS\${PRODUCT_NAME}\${PRODUCT_NAME}.lnk"       "$INSTDIR\${PRODUCT_MAIN_EXE}"
  CreateShortCut  "$SMPROGRAMS\${PRODUCT_NAME}\$(UNINSTALL_PREFIX)${PRODUCT_NAME}.lnk"   "$INSTDIR\Uninstall.exe"   
  ;桌面快捷方式
  StrCmp $DesktopIconState "1" "" +2
  CreateShortCut "$DESKTOP\${PRODUCT_NAME}.lnk" "$INSTDIR\${PRODUCT_MAIN_EXE}"
    
  ;快速启动
  StrCmp $FastIconState "1" "" +2
  CreateShortCut "$QUICKLAUNCH\${PRODUCT_NAME}.lnk" "$INSTDIR\${PRODUCT_MAIN_EXE}"
  
  ;注册表
  ;控制面板卸载连接
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT_NAME_EN}" "DisplayName" "${PRODUCT_NAME}"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT_NAME_EN}" "UninstallString" '"$INSTDIR\Uninstall.exe"'
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT_NAME_EN}" "DisplayIcon" '"$INSTDIR\${PRODUCT_MAIN_EXE}"'
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT_NAME_EN}" "InstallLocation" "$INSTDIR"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT_NAME_EN}" "Publisher" "${PRODUCT_PUBLISHER}"  
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT_NAME_EN}" "HelpLink" "${PRODUCT_WEBSITE}"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT_NAME_EN}" "DisplayVersion" "${PRODUCT_VERSION}"
FunctionEnd

Function un.onInit
  ;判断客户端是否在运行中
  ;FindWindow $0 "UIMainFrame" "360安全卫士"
  ;Dumpstate::debug
  ;IsWindow $0 0 +4  
  ;MessageBox MB_OK "您已经运行了360Safe程序。如需卸载，请先关闭该程序！"
  ;Goto -3;
  ;Goto close_run_cancel


   SetOutPath $temp\${PRODUCT_NAME_EN}Setup\res
  ;File ".\setup res\*.png"
  ;File ".\setup res\*.txt"
  ;File ".\setup res\*.xml"
  File /r /x *.psd ".\setup res\*.*"
  
  ;判断客户端是否在运行中
  FindWindow $0 "UIMainFrame" "${PRODUCT_NAME_EN}"
  ;Dumpstate::debug
  IsWindow $0 0 +5  
  MessageBox MB_RETRYCANCEL $(PROUDUCT_RUNNING_MESSAGE) IDRETRY RetryUninstall  IDCANCEL NotUninstall
     RetryUninstall:
       Goto -3;
     NotUninstall:
        Goto +1     
  Goto close_run_cancel
  
  ; 判断mutex 知道是否还有安装卸载程序运行
  !insertmacro MutexCheck "${SETUP_MUTEX_NAME}" $0 $9
  StrCmp $0 0 launch
  MessageBox MB_OK $(INSTALLER_RUNNING_MESSAGE)
  Goto close_run_cancel
  StrLen $0 "$(^Name)"
  IntOp $0 $0 + 1

loop:
  FindWindow $1 '#32770' '' 0 $1
  StrCmp $1 0 +1 +2
  IntOp $3 $3 + 1
  IntCmp $3 3 +5
  System::Call "user32::GetWindowText(i r1, t .r2, i r0) i."
  StrCmp $2 "$(^Name)" 0 loop
  System::Call "user32::SetForegroundWindow(i r1) i."
  System::Call "user32::ShowWindow(i r1,i 9) i."
  Abort
launch: 
  ;判断进程是否存在
  CHECK_RUN:
    Push "${PRODUCT_MAIN_EXE_MUTEX}"
    nsInstallAssist::CheckRun
    Pop $R0
    StrCmp $R0 "run" 0 NO_RUNNING_PROCESS
    MessageBox MB_RETRYCANCEL|MB_ICONINFORMATION $(PROUDUCT_RUNNING_MESSAGE) IDRETRY close_run_retry IDCANCEL close_run_cancel

close_run_retry:
    Goto CHECK_RUN
close_run_cancel:
    Quit
NO_RUNNING_PROCESS:
FunctionEnd

Function OnGlobalMinFunc
   SkinEngine::TBCIASendMessage $Dialog WM_TBCIAMIN
FunctionEnd

Function OnGlobalCancelFunc
   ;SkinEngine::TBCIASendMessage $Dialog WM_TBCIACANCEL "HaloRadio安装" "确定要退出HaloRadio安装?"
   SkinEngine::TBCIAShowMessageBox $Dialog $(CANCEL_INSTALL_TITLE) $(CANCEL_INSTALL_MESSAGE)
   Pop $0
   ${If} $0 == "0"
     SkinEngine::ExitTBCIASkinEngine
   ${EndIf}
FunctionEnd

Function un.OnGlobalMinFunc
   SkinEngine::TBCIASendMessage $Dialog WM_TBCIAMIN
FunctionEnd

Function un.OnGlobalCancelFunc
  ;SkinEngine::TBCIASendMessage $Dialog WM_TBCIACANCEL "HaloRadio卸载" "确定要退出HaloRado卸载?"
  SkinEngine::TBCIAShowMessageBox $Dialog $(CANCEL_UNINSTALL_TITLE) $(CANCEL_UNINSTALL_MESSAGE)
   Pop $0
   ${If} $0 == "0"
     SkinEngine::ExitTBCIASkinEngine
   ${EndIf}
FunctionEnd

Function OnBackBtnFunc
   SkinEngine::TBCIASendMessage $Dialog WM_TBCIABACK
FunctionEnd

Function OnNextBtnFunc
   SkinEngine::TBCIASendMessage $Dialog WM_TBCIANEXT
FunctionEnd

Function OnInstallProgressCallback
    Pop $R0
   ; Pop $R1
    SkinEngine::TBCIASendMessage $Dialog WM_TBCIAINSTALLPROGRESS $R0 "PRO"
   
FunctionEnd

Function OnStartInstallBtnFunc
   SkinEngine::TBCIASendMessage $Dialog WM_TBCIASTARTINSTALL
    GetFunctionAddress $0 OnInstallProgressCallback
    section::call $0

FunctionEnd



Function un.OnUninstallProgressCallback
    Pop $R0
    SkinEngine::TBCIASendMessage $Dialog WM_TBCIAUNINSTALLPROGRESS $R0 "uninstall progress"
   
FunctionEnd


Function un.OnStartUninstallBtnFunc
   SkinEngine::TBCIASendMessage $Dialog WM_TBCIASTARTUNINSTALL
    
   GetFunctionAddress $0 un.OnUninstallProgressCallback
   section::call $0
FunctionEnd

Function RunAfterInstall

    StrCmp $RunNow "1" "" +2
    Exec '"$INSTDIR\${PRODUCT_MAIN_EXE}"'
   ; ExecShell "" "$INSTDIR\${PRODUCT_MAIN_EXE}"

    ;FindWindow $0 "UIMainFrame" "" 
    
;System::Call "user32::SetWindowPos(i $0, i -1, i0, i0, i0, i0, i 3)"


FunctionEnd

Function OnFinishedBtnFunc
   SkinEngine::TBCIASendMessage $Dialog WM_TBCIAOPTIONSTATE "Wizard_Runing360SafeBtn" ""
   Pop $0
   ${If} $0 == "1"
     StrCpy $RunNow "1"
   ${Else}
     StrCpy $RunNow "0" 
   ${EndIf}

   ;开机运行
   SkinEngine::TBCIASendMessage $Dialog WM_TBCIAOPTIONSTATE "Wizard_BootRuning360SafeBtn" ""
   Pop $0
   ${If} $0 == "1"
      ;CreateShortCut "$SMSTARTUP\${PRODUCT_NAME}.lnk" "$INSTDIR\${PRODUCT_MAIN_EXE}" "" "$INSTDIR\${PRODUCT_MAIN_EXE}" 0
      WriteRegStr HKCU  "Software\Microsoft\Windows\CurrentVersion\Run" "${PRODUCT_NAME_EN}"  "$INSTDIR\${PRODUCT_MAIN_EXE} -autorun"
   ${EndIf}

   call RunAfterInstall
   SkinEngine::TBCIAKillTimer $timerID
   SkinEngine::TBCIASendMessage $Dialog WM_TBCIAFINISHEDINSTALL
FunctionEnd

Function un.OnUninstallFinishedBtnFunc
   DeleteRegValue HKLM  "Software\Microsoft\Windows\CurrentVersion\Run" "${PRODUCT_NAME_EN}"
   SkinEngine::TBCIASendMessage $Dialog WM_TBCIAFINISHEDINSTALL
   ;SkinEngine::TBCIASendMessage $Dialog WM_TBCIAOPENURL "http://www.icyarrow.com/?action=uninstall&product=haloradio"
FunctionEnd

Function OnLinkBtnFunc
   SkinEngine::TBCIASendMessage $Dialog WM_TBCIAOPENURL "${PRODUCT_WEBSITE}"
   Pop $0
   ${If} $0 == "url error"
     MessageBox MB_OK "url error"
   ${EndIf}
FunctionEnd

Function OnTextChangeFunc
   ; 改变可用磁盘空间大小
   SkinEngine::GetControlData Wizard_InstallPathEdit4Page2 "text"
   Pop $0
   ;MessageBox MB_OK $0
   StrCpy $INSTDIR $0

   ;重新获取磁盘空间
   Call UpdateFreeSpace

   ;更新磁盘空间文本显示
   SkinEngine::FindControl "Wizard_UsableSpaceLab4Page2"
   Pop $0
   ${If} $0 == "-1"
	MessageBox MB_OK "Do not have Wizard_UsableSpaceLab4Page2 button"
   ${Else}
	;SkinEngine::SetText2Control "Wizard_UsableSpaceLab4Page2"  $FreeSpaceSize
	SkinEngine::SetControlData "Wizard_UsableSpaceLab4Page2"  $FreeSpaceSize  "text"
   ${EndIf}
   ;路径是否合法（合法则不为0Bytes）
   ${If} $FreeSpaceSize == "0Bytes"
	SkinEngine::SetControlData "Wizard_StartInstallBtn4Page2" "false" "enable"
   ${Else}
	SkinEngine::SetControlData "Wizard_StartInstallBtn4Page2" "true" "enable"
   ${EndIf}
FunctionEnd

Function OnChangeFunc
   ${If} $changebkimageIndex == "0"
        StrCpy $changebkimageIndex "1"
	SkinEngine::SetControlData "Wizard_Background4Page3" "progress_banner1.png" "bkimage"
   ${Else}
        StrCpy $changebkimageIndex "0"
	SkinEngine::SetControlData "Wizard_Background4Page3" "progress_banner2.png" "bkimage"
   ${EndIf}

FunctionEnd

Function OnDesktopIconStateFunc
   SkinEngine::TBCIASendMessage $Dialog WM_TBCIAOPTIONSTATE "Wizard_ShortCutBtn4Page2" ""
   Pop $0
   ${If} $0 == "1"
     StrCpy $DesktopIconState "1"
   ${Else}
     StrCpy $DesktopIconState "0" 
   ${EndIf}

  
FunctionEnd

Function OnFastIconStateFunc
   SkinEngine::TBCIASendMessage $Dialog WM_TBCIAOPTIONSTATE "Wizard_QuickLaunchBarBtn4Page2" ""
   Pop $1
   ${If} $1 == "1"
      StrCpy $FastIconState "1"
   ${Else}
      StrCpy $FastIconState "0"
   ${EndIf}
FunctionEnd

Function OnInstallPathBrownBtnFunc
   SkinEngine::SelectFolderDialog $(CHOOSE_INSTALL_LOCATION)
   Pop $installPath

   StrCpy $0 $installPath
   ${If} $0 == "-1"
   ${Else}
      StrCpy $INSTDIR "$installPath\${PRODUCT_NAME_EN}"
      ;设置安装路径编辑框文本
      SkinEngine::FindControl "Wizard_InstallPathEdit4Page2"
      Pop $0
      ${If} $0 == "-1"
	 MessageBox MB_OK "Do not have Wizard_InstallPathBtn4Page2 button"
      ${Else}
	 ;SkinEngine::SetText2Control "Wizard_InstallPathEdit4Page2"  $installPath
	 StrCpy $installPath $INSTDIR
	 SkinEngine::SetControlData "Wizard_InstallPathEdit4Page2"  $installPath  "text"
      ${EndIf}
   ${EndIf}

   ;重新获取磁盘空间
   Call UpdateFreeSpace


   ;路径是否合法（合法则不为0Bytes）
   ${If} $FreeSpaceSize == "0Bytes"
	SkinEngine::SetControlData "Wizard_StartInstallBtn4Page2" "false" "enable"
   ${Else}
	SkinEngine::SetControlData "Wizard_StartInstallBtn4Page2" "true" "enable"
   ${EndIf}

   ;更新磁盘空间文本显示
   SkinEngine::FindControl "Wizard_UsableSpaceLab4Page2"
   Pop $0
   ${If} $0 == "-1"
	MessageBox MB_OK "Do not have Wizard_UsableSpaceLab4Page2 button"
   ${Else}
	;SkinEngine::SetText2Control "Wizard_UsableSpaceLab4Page2"  $FreeSpaceSize
	SkinEngine::SetControlData "Wizard_UsableSpaceLab4Page2"  $FreeSpaceSize  "text"
   ${EndIf}   
FunctionEnd

Function UpdateFreeSpace
  ${GetRoot} $INSTDIR $0
  StrCpy $1 "Bytes"

  System::Call kernel32::GetDiskFreeSpaceEx(tr0,*l,*l,*l.r0)
   ${If} $0 > 1024
   ${OrIf} $0 < 0
      System::Int64Op $0 / 1024
      Pop $0
      StrCpy $1 "KB"
      ${If} $0 > 1024
      ${OrIf} $0 < 0
	 System::Int64Op $0 / 1024
	 Pop $0
	 StrCpy $1 "MB"
	 ${If} $0 > 1024
	 ${OrIf} $0 < 0
	    System::Int64Op $0 / 1024
	    Pop $0
	    StrCpy $1 "GB"
	 ${EndIf}
      ${EndIf}
   ${EndIf}

   StrCpy $FreeSpaceSize  "$0$1"
FunctionEnd

Function InstallShow
   ;进度条绑定函数
   SkinEngine::FindControl "Wizard_InstallProgress"
   Pop $0
   ${If} $0 == "-1"
	MessageBox MB_OK "Do not have Wizard_InstallProgress button"
   ${Else}
	SkinEngine::StartInstall  Wizard_InstallProgress
   ${EndIf}   
FunctionEnd 

Function un.UninstallShow 
   ;进度条绑定函数
   SkinEngine::FindControl "Wizard_UninstallProgress"
   Pop $0
   ${If} $0 == "-1"
	MessageBox MB_OK "Do not have Wizard_InstallProgress button"
   ${Else}
	SkinEngine::StartUninstall  Wizard_UninstallProgress
   ${EndIf} 
FunctionEnd

Function un.OnLinkBtnFunc
   SkinEngine::TBCIASendMessage $Dialog WM_TBCIAOPENURL "${PRODUCT_WEBSITE}"
   Pop $0
   ${If} $0 == "url error"
     MessageBox MB_OK "url error"
   ${EndIf}
FunctionEnd

Function un.OnChangeFunc
   ${If} $changebkimage4UninstallIndex == "0"
        StrCpy $changebkimage4UninstallIndex "1"
	SkinEngine::SetControlData "Wizard_BackgroundUninstallPage" "内嵌背景4Page3_1.png" "bkimage"
   ${Else}
        StrCpy $changebkimage4UninstallIndex "0"
	SkinEngine::SetControlData "Wizard_BackgroundUninstallPage" "内嵌背景4Page3_2.png" "bkimage"
   ${EndIf}
FunctionEnd