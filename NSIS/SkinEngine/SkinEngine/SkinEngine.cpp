#include "StdAfx.h"
#include "SkinEngine.h"
#include "api.h"
#include <vector>
#include <sstream>

extern extra_parameters* g_pluginParms;
extern BOOL g_bMSGLoopFlag;
extern DuiLib::CSkinEngine* g_pFrame;

extern TCHAR g_messageBoxCloseBtnControlName[MAX_PATH];
extern  TCHAR g_messageBoxYESBtnControlName[MAX_PATH];
extern TCHAR g_messageBoxNOBtnControlName[MAX_PATH];

namespace DuiLib {

	
	
	
	void CSkinEngine::SaveToControlCallbackMap(CDuiString ctlName, int callback)
	{
		
		
		
		(m_controlCallbackMap)[ctlName] = callback;

		/*TCHAR t[256];
		wsprintf(t, L"%d", m_controlCallbackMap.size());


		MessageBox(NULL, L"SIZE:::::11111", t, 0);*/


		
	}

	void CSkinEngine::Notify(TNotifyUI& msg)
	{

		
		std::map<CDuiString, int >::iterator iter = (m_controlCallbackMap).find(msg.pSender->GetName());
		if( _tcsicmp( msg.sType, _T("click") ) == 0 ){

			
			
			if( iter != (m_controlCallbackMap).end() )
				g_pluginParms->ExecuteCodeSegment( iter->second - 1, 0 );
			
			
		}
		else if( _tcsicmp( msg.sType, _T("textchanged") ) == 0 ){
			
			if( iter != m_controlCallbackMap.end() )
				g_pluginParms->ExecuteCodeSegment( iter->second - 1, 0 );

			
		}
		else if (_tcsicmp(msg.sType, _T("selectchanged")) == 0) {

			if (iter != m_controlCallbackMap.end())
				g_pluginParms->ExecuteCodeSegment(iter->second - 1, 0);


		}
	}

	LRESULT CSkinEngine::OnCreate(UINT uMsg, WPARAM wParam, LPARAM lParam, BOOL& bHandled)
	{
		LONG styleValue = ::GetWindowLong(*this, GWL_STYLE);
		styleValue &= ~WS_CAPTION;
		::SetWindowLong(*this, GWL_STYLE, styleValue | WS_CLIPSIBLINGS | WS_CLIPCHILDREN| WS_SIZEBOX);
		m_pm.Init(m_hWnd);
		
		CDialogBuilder builder;
		CControlUI* pRoot = builder.Create( GetSkinXMLPath(), (UINT)0, NULL, &m_pm);
		ASSERT(pRoot && "Failed to parse XML");

		
		m_pm.AttachDialog(pRoot);
		m_pm.AddNotifier( this );
		ShowWindow( FALSE );

		m_pm.SetDPI(CDPI::GetMainMonitorDPI());
		
		
		return 0;
	}

	LRESULT CSkinEngine::OnDPIChanged(UINT uMsg, WPARAM wParam, LPARAM lParam, BOOL& bHandled)
	{
		///The HIWORD of the wParam contains the Y-axis value of the new dpi of the window. 
		//The LOWORD of the wParam contains the X-axis value of the new DPI of the window. 
		//For example, 96, 120, 144, or 192. 
		//The values of the X-axis and the Y-axis are identical for Windows apps.

		m_pm.GetDPIObj()->SetScale(LOWORD(wParam));  // Set the new DPI, retrieved from the wParam
		m_pm.ResetDPIAssets();
		int g_dpi = HIWORD(wParam);


		RECT* const prcNewWindow = (RECT*)lParam;
		SetWindowPos(m_hWnd,
			NULL,
			prcNewWindow->left,
			prcNewWindow->top,
			prcNewWindow->right - prcNewWindow->left,
			prcNewWindow->bottom - prcNewWindow->top,
			SWP_NOZORDER | SWP_NOACTIVATE);

		if (m_pm.GetRoot() != NULL) m_pm.GetRoot()->NeedUpdate();


		bHandled = false;









		return 0;
	}

	

	LRESULT CSkinEngine::OnClose(UINT uMsg, WPARAM wParam, LPARAM lParam, BOOL& bHandled)
	{
		bHandled = FALSE;
		return 0;
	}

	LRESULT CSkinEngine::OnDestroy(UINT uMsg, WPARAM wParam, LPARAM lParam, BOOL& bHandled)
	{
		::PostQuitMessage(0L);
		bHandled = FALSE;
		return 0;
	}

	LRESULT CSkinEngine::OnNcActivate(UINT uMsg, WPARAM wParam, LPARAM lParam, BOOL& bHandled)
	{
		if( ::IsIconic(*this) ) bHandled = FALSE;
		return (wParam == 0) ? TRUE : FALSE;
	}

	LRESULT CSkinEngine::OnNcCalcSize(UINT uMsg, WPARAM wParam, LPARAM lParam, BOOL& bHandled)
	{
		return 0;
	}

	LRESULT CSkinEngine::OnNcPaint(UINT uMsg, WPARAM wParam, LPARAM lParam, BOOL& bHandled)
	{
		return 0;
	}

	LRESULT CSkinEngine::OnNcHitTest(UINT uMsg, WPARAM wParam, LPARAM lParam, BOOL& bHandled)
	{
		POINT pt; pt.x = GET_X_LPARAM(lParam); pt.y = GET_Y_LPARAM(lParam);
		::ScreenToClient(*this, &pt);

		RECT rcClient;
		::GetClientRect(*this, &rcClient);

		if (!::IsZoomed(*this)) {
			RECT rcSizeBox = m_pm.GetSizeBox();
			if (pt.y < rcClient.top + rcSizeBox.top) {
				if (pt.x < rcClient.left + rcSizeBox.left) return HTTOPLEFT;
				if (pt.x > rcClient.right - rcSizeBox.right) return HTTOPRIGHT;
				return HTTOP;
			}
			else if (pt.y > rcClient.bottom - rcSizeBox.bottom) {
				if (pt.x < rcClient.left + rcSizeBox.left) return HTBOTTOMLEFT;
				if (pt.x > rcClient.right - rcSizeBox.right) return HTBOTTOMRIGHT;
				return HTBOTTOM;
			}
			if (pt.x < rcClient.left + rcSizeBox.left) return HTLEFT;
			if (pt.x > rcClient.right - rcSizeBox.right) return HTRIGHT;
		}




		RECT rcCaption = m_pm.GetCaptionRect();
		if (-1 == rcCaption.bottom)
		{
			rcCaption.bottom = rcClient.bottom;
		}

		if (pt.x >= rcClient.left + rcCaption.left && pt.x < rcClient.right - rcCaption.right
			&& pt.y >= rcCaption.top && pt.y < rcCaption.bottom)
		{
			CControlUI* pControl = m_pm.FindControl(pt);
			if (IsInStaticControl(pControl))
			{
				return HTCAPTION;
			}
		}


		return HTCLIENT;
	}

	BOOL CSkinEngine::IsInStaticControl(CControlUI *pControl)
	{
		BOOL bRet = FALSE;
		if (!pControl)
		{
			return bRet;
		}
		
		CDuiString strClassName;
		std::vector<CDuiString> vctStaticName;

		strClassName = pControl->GetClass();
		strClassName.MakeLower();
		vctStaticName.push_back(_T("controlui"));
		vctStaticName.push_back(_T("textui"));
		vctStaticName.push_back(_T("labelui"));
		vctStaticName.push_back(_T("containerui"));
		vctStaticName.push_back(_T("horizontallayoutui"));
		vctStaticName.push_back(_T("verticallayoutui"));
		vctStaticName.push_back(_T("tablayoutui"));
		vctStaticName.push_back(_T("childlayoutui"));
		vctStaticName.push_back(_T("dialoglayoutui"));

		std::vector<CDuiString>::iterator it = std::find(vctStaticName.begin(), vctStaticName.end(), strClassName);
		if (vctStaticName.end() != it)
		{
			CControlUI* pParent = pControl->GetParent();
			while (pParent)
			{
				strClassName = pParent->GetClass();
				strClassName.MakeLower();
				it = std::find(vctStaticName.begin(), vctStaticName.end(), strClassName);
				if (vctStaticName.end() == it)
				{
					return bRet;
				}

				pParent = pParent->GetParent();
			}

			bRet = TRUE;
		}

		return bRet;
	}

	LRESULT CSkinEngine::OnSize(UINT uMsg, WPARAM wParam, LPARAM lParam, BOOL& bHandled)
	{
		SIZE szRoundCorner = m_pm.GetRoundCorner();
		if (!::IsIconic(*this) && (szRoundCorner.cx != 0 || szRoundCorner.cy != 0)) {
			CDuiRect rcWnd;
			::GetWindowRect(*this, &rcWnd);
			rcWnd.Offset(-rcWnd.left, -rcWnd.top);
			rcWnd.right++; rcWnd.bottom++;
			HRGN hRgn = ::CreateRoundRectRgn(rcWnd.left, rcWnd.top, rcWnd.right, rcWnd.bottom, szRoundCorner.cx, szRoundCorner.cy);
			::SetWindowRgn(*this, hRgn, TRUE);
			::DeleteObject(hRgn);
		}

		bHandled = FALSE;


		return 0;
	}

	LRESULT CSkinEngine::OnGetMinMaxInfo(UINT uMsg, WPARAM wParam, LPARAM lParam, BOOL& bHandled)
	{
		MONITORINFO oMonitor = {};
		oMonitor.cbSize = sizeof(oMonitor);
		::GetMonitorInfo(::MonitorFromWindow(*this, MONITOR_DEFAULTTOPRIMARY), &oMonitor);
		CDuiRect rcWork = oMonitor.rcWork;
		rcWork.Offset(-oMonitor.rcMonitor.left, -oMonitor.rcMonitor.top);

		LPMINMAXINFO lpMMI = (LPMINMAXINFO)lParam;
		lpMMI->ptMaxPosition.x = rcWork.left;
		lpMMI->ptMaxPosition.y = rcWork.top;
		lpMMI->ptMaxSize.x = rcWork.right;
		lpMMI->ptMaxSize.y = rcWork.bottom;

		bHandled = FALSE;
		return 0;
	}

	LRESULT CSkinEngine::OnSysCommand(UINT uMsg, WPARAM wParam, LPARAM lParam, BOOL& bHandled)
	{
		BOOL bZoomed = ::IsZoomed(this->GetHWND());
		if ((wParam & 0xFFF0 ) == SC_MAXIMIZE ||(wParam &  0xFFF0) == SC_SIZE)
		{ 
			bHandled = false;
			return 0;
		}
		LRESULT lRes = CWindowWnd::HandleMessage(uMsg, wParam, lParam);
		return lRes;
	}

	LRESULT CSkinEngine::OnTBCIAMinMSG(UINT uMsg, WPARAM wParam, LPARAM lParam, BOOL& bHandled)
	{
		LRESULT lRes = 0;
		SendMessage(WM_SYSCOMMAND, SC_MINIMIZE, 0);
		return lRes;
	}

	LRESULT CSkinEngine::OnTBCIACloseMSG(UINT uMsg, WPARAM wParam, LPARAM lParam, BOOL& bHandled)
	{
		LRESULT lRes = 0;
		Close();
		return lRes;
	}

	LRESULT CSkinEngine::OnTBCIABackMSG(UINT uMsg, WPARAM wParam, LPARAM lParam, BOOL& bHandled)
	{
		CTabLayoutUI* pTab = NULL;
		LPCTSTR tabName = (LPCTSTR)wParam;
		int currentIndex;
		pTab = static_cast<CTabLayoutUI*>( m_pm.FindControl( tabName ) );
		if( pTab == NULL )
			return -1;
		currentIndex = pTab->GetCurSel();
		if( currentIndex == 0 )
			return -1;
		else
			pTab->SelectItem( currentIndex - 1 );

		return 0;
	}

	LRESULT CSkinEngine::OnTBCIANextMSG(UINT uMsg, WPARAM wParam, LPARAM lParam, BOOL& bHandled)
	{
		CTabLayoutUI* pTab = NULL;
		LPCTSTR tabName = (LPCTSTR)wParam;
		int currentIndex;
		pTab = static_cast<CTabLayoutUI*>( m_pm.FindControl( tabName ) );
		if( pTab == NULL )
			return -1;
		currentIndex = pTab->GetCurSel();
		pTab->SelectItem( currentIndex + 1 );
		return 0;
	}

	LRESULT CSkinEngine::OnTBCIAStartInstallMSG(UINT uMsg, WPARAM wParam, LPARAM lParam, BOOL& bHandled)
	{
		LRESULT lRes = 0;
		CTabLayoutUI* pTab = NULL;
		LPCTSTR tabName = (LPCTSTR)wParam;
		int currentIndex;
		pTab = static_cast<CTabLayoutUI*>( m_pm.FindControl( tabName ) );
		if( pTab == NULL )
			return -1;
		currentIndex = pTab->GetCurSel();
		pTab->SelectItem( currentIndex + 1 );

		//g_bMSGLoopFlag = FALSE;

		return lRes;
	}

	LRESULT CSkinEngine::OnTBCIAStartUninstallMSG(UINT uMsg, WPARAM wParam, LPARAM lParam, BOOL& bHandled)
	{
		LRESULT lRes = 0;
		CTabLayoutUI* pTab = NULL;
		LPCTSTR tabName = (LPCTSTR)wParam;
		int currentIndex;
		pTab = static_cast<CTabLayoutUI*>( m_pm.FindControl( tabName ) );
		if( pTab == NULL )
			return -1;
		currentIndex = pTab->GetCurSel();
		pTab->SelectItem( currentIndex + 1 );

		//g_bMSGLoopFlag = FALSE;

		return lRes;
	}

	LRESULT CSkinEngine::OnTBCIAFinishedInstallMSG(UINT uMsg, WPARAM wParam, LPARAM lParam, BOOL& bHandled)
	{
		LRESULT lRes = 0;
		Close();
		return lRes;
	}

	LRESULT CSkinEngine::HandleMessage(UINT uMsg, WPARAM wParam, LPARAM lParam)
	{
		LRESULT lRes = 0;
		BOOL bHandled = TRUE;
		switch( uMsg ) {
	case WM_CREATE:        lRes = OnCreate(uMsg, wParam, lParam, bHandled); break;
	case WM_CLOSE:         lRes = OnClose(uMsg, wParam, lParam, bHandled); break;
	case WM_DESTROY:       lRes = OnDestroy(uMsg, wParam, lParam, bHandled); break;
	case WM_NCACTIVATE:    lRes = OnNcActivate(uMsg, wParam, lParam, bHandled); break;
	case WM_NCCALCSIZE:    lRes = OnNcCalcSize(uMsg, wParam, lParam, bHandled); break;
	case WM_NCPAINT:       lRes = OnNcPaint(uMsg, wParam, lParam, bHandled); break;
	case WM_NCHITTEST:     lRes = OnNcHitTest(uMsg, wParam, lParam, bHandled); break;
	case WM_SIZE:          lRes = OnSize(uMsg, wParam, lParam, bHandled); break;
	case WM_SYSCOMMAND:    lRes = OnSysCommand(uMsg, wParam, lParam, bHandled); break;
	case WM_GETMINMAXINFO: lRes = OnGetMinMaxInfo(uMsg, wParam, lParam, bHandled); break;
	case WM_TBCIAMIN:      lRes = OnTBCIAMinMSG(uMsg, wParam, lParam, bHandled); break;
	case WM_TBCIACLOSE:   lRes = OnTBCIACloseMSG(uMsg, wParam, lParam, bHandled); break;
	case WM_TBCIABACK:     lRes = OnTBCIABackMSG(uMsg, wParam, lParam, bHandled); break;
	case WM_TBCIANEXT:     lRes = OnTBCIANextMSG(uMsg, wParam, lParam, bHandled); break;
	case WM_TBCIASTARTINSTALL: lRes = OnTBCIAStartInstallMSG(uMsg, wParam, lParam, bHandled); break;
	case WM_TBCIASTARTUNINSTALL: lRes = OnTBCIAStartUninstallMSG(uMsg, wParam, lParam, bHandled); break;
	case WM_TBCIAFINISHEDINSTALL: lRes = OnTBCIAFinishedInstallMSG(uMsg, wParam, lParam, bHandled); break;
	case WM_DPICHANGED:lRes = OnDPIChanged(uMsg, wParam, lParam, bHandled); break;
	default:
		bHandled = FALSE;
		}
		if( bHandled ) return lRes;
		if( m_pm.MessageHandler(uMsg, wParam, lParam, lRes) ) return lRes;
		return CWindowWnd::HandleMessage(uMsg, wParam, lParam);
	}

	void  CSkinEngine::SetSkinXMLPath( LPCTSTR path )
	{
		_tcscpy( m_skinXMLPath, path );
	}

	LPCTSTR CSkinEngine::GetSkinXMLPath()
	{
		return m_skinXMLPath;
	}

	CPaintManagerUI& CSkinEngine::GetPaintManager()
	{
		return m_pm;
	}

	//////////////////////////////////////////////////////////////////////////
	///  CTBCIAMessageBox

	void CTBCIAMessageBox::Notify(TNotifyUI& msg)
	{
		std::map<CDuiString, int >::iterator iter = m_controlCallbackMap.find( msg.pSender->GetName() );
		if( _tcsicmp( msg.sType, _T("click") ) == 0 ){
			if( iter != m_controlCallbackMap.end() )
				g_pluginParms->ExecuteCodeSegment( iter->second - 1, 0 );
			else if( _tcsicmp( msg.pSender->GetName(), g_messageBoxCloseBtnControlName ) == 0 ){
// 				SetParent( this->GetHWND(), NULL );
// 				ShowWindow( SW_HIDE, FALSE );
// 				::EnableWindow(g_pFrame->GetHWND(), TRUE);
// 				::SetFocus(g_pFrame->GetHWND());
				Close();
			}
			else if( _tcsicmp( msg.pSender->GetName(), g_messageBoxYESBtnControlName ) == 0 ){
				PostQuitMessage(0);
			}
			else if( _tcsicmp( msg.pSender->GetName(), g_messageBoxNOBtnControlName ) == 0 ){
 				SetParent( this->GetHWND(), NULL );
 				ShowWindow( SW_HIDE, FALSE );
 				::EnableWindow(g_pFrame->GetHWND(), TRUE);
				::SetFocus(g_pFrame->GetHWND());
				//Close();
			}
		}
 		else if( _tcsicmp( msg.sType, _T("textchanged") ) == 0 ){
 			if( iter != m_controlCallbackMap.end() )
 				g_pluginParms->ExecuteCodeSegment( iter->second - 1, 0 );
 		}
	}

	LRESULT CTBCIAMessageBox::OnCreate(UINT uMsg, WPARAM wParam, LPARAM lParam, BOOL& bHandled)
	{
		LONG styleValue = ::GetWindowLong(*this, GWL_STYLE);
		styleValue &= ~WS_CAPTION;
		::SetWindowLong(*this, GWL_STYLE, styleValue | WS_CLIPSIBLINGS | WS_CLIPCHILDREN);
		m_pm.Init(m_hWnd);
		CDialogBuilder builder;
		CControlUI* pRoot = builder.Create( GetSkinXMLPath(), (UINT)0, NULL, &m_pm);
		ASSERT(pRoot && "Failed to parse XML");
		m_pm.AttachDialog(pRoot);
		m_pm.AddNotifier( this );
		ShowWindow( FALSE );
		m_pm.SetDPI(CDPI::GetMainMonitorDPI());
		return 0;
	}

	LRESULT CTBCIAMessageBox::OnDPIChanged(UINT uMsg, WPARAM wParam, LPARAM lParam, BOOL& bHandled)
	{
		///The HIWORD of the wParam contains the Y-axis value of the new dpi of the window. 
		//The LOWORD of the wParam contains the X-axis value of the new DPI of the window. 
		//For example, 96, 120, 144, or 192. 
		//The values of the X-axis and the Y-axis are identical for Windows apps.

		m_pm.GetDPIObj()->SetScale(LOWORD(wParam));  // Set the new DPI, retrieved from the wParam
		m_pm.ResetDPIAssets();
		int g_dpi = HIWORD(wParam);


		RECT* const prcNewWindow = (RECT*)lParam;
		SetWindowPos(m_hWnd,
			NULL,
			prcNewWindow->left,
			prcNewWindow->top,
			prcNewWindow->right - prcNewWindow->left,
			prcNewWindow->bottom - prcNewWindow->top,
			SWP_NOZORDER | SWP_NOACTIVATE);

		if (m_pm.GetRoot() != NULL) m_pm.GetRoot()->NeedUpdate();


		bHandled = false;









		return 0;
	}

	LRESULT CTBCIAMessageBox::OnClose(UINT uMsg, WPARAM wParam, LPARAM lParam, BOOL& bHandled)
	{
		bHandled = FALSE;
		return 0;
	}

	LRESULT CTBCIAMessageBox::OnDestroy(UINT uMsg, WPARAM wParam, LPARAM lParam, BOOL& bHandled)
	{
		::PostQuitMessage(0L);
		bHandled = FALSE;
		return 0;
	}

	LRESULT CTBCIAMessageBox::OnNcActivate(UINT uMsg, WPARAM wParam, LPARAM lParam, BOOL& bHandled)
	{
		if( ::IsIconic(*this) ) bHandled = FALSE;
		return (wParam == 0) ? TRUE : FALSE;
	}

	LRESULT CTBCIAMessageBox::OnNcCalcSize(UINT uMsg, WPARAM wParam, LPARAM lParam, BOOL& bHandled)
	{
		return 0;
	}

	LRESULT CTBCIAMessageBox::OnNcPaint(UINT uMsg, WPARAM wParam, LPARAM lParam, BOOL& bHandled)
	{
		return 0;
	}

	LRESULT CTBCIAMessageBox::OnNcHitTest(UINT uMsg, WPARAM wParam, LPARAM lParam, BOOL& bHandled)
	{
		POINT pt; pt.x = GET_X_LPARAM(lParam); pt.y = GET_Y_LPARAM(lParam);
		::ScreenToClient(*this, &pt);

		RECT rcClient;
		::GetClientRect(*this, &rcClient);

		if (!::IsZoomed(*this)) {
			RECT rcSizeBox = m_pm.GetSizeBox();
			if (pt.y < rcClient.top + rcSizeBox.top) {
				if (pt.x < rcClient.left + rcSizeBox.left) return HTTOPLEFT;
				if (pt.x > rcClient.right - rcSizeBox.right) return HTTOPRIGHT;
				return HTTOP;
			}
			else if (pt.y > rcClient.bottom - rcSizeBox.bottom) {
				if (pt.x < rcClient.left + rcSizeBox.left) return HTBOTTOMLEFT;
				if (pt.x > rcClient.right - rcSizeBox.right) return HTBOTTOMRIGHT;
				return HTBOTTOM;
			}
			if (pt.x < rcClient.left + rcSizeBox.left) return HTLEFT;
			if (pt.x > rcClient.right - rcSizeBox.right) return HTRIGHT;
		}




		RECT rcCaption = m_pm.GetCaptionRect();
		if (-1 == rcCaption.bottom)
		{
			rcCaption.bottom = rcClient.bottom;
		}

		if (pt.x >= rcClient.left + rcCaption.left && pt.x < rcClient.right - rcCaption.right
			&& pt.y >= rcCaption.top && pt.y < rcCaption.bottom)
		{
			CControlUI* pControl = m_pm.FindControl(pt);
			if (IsInStaticControl(pControl))
			{
				return HTCAPTION;
			}
		}


		return HTCLIENT;
	}


	BOOL CTBCIAMessageBox::IsInStaticControl(CControlUI *pControl)
	{
		BOOL bRet = FALSE;
		if (!pControl)
		{
			return bRet;
		}

		CDuiString strClassName;
		std::vector<CDuiString> vctStaticName;

		strClassName = pControl->GetClass();
		strClassName.MakeLower();
		vctStaticName.push_back(_T("controlui"));
		vctStaticName.push_back(_T("textui"));
		vctStaticName.push_back(_T("labelui"));
		vctStaticName.push_back(_T("containerui"));
		vctStaticName.push_back(_T("horizontallayoutui"));
		vctStaticName.push_back(_T("verticallayoutui"));
		vctStaticName.push_back(_T("tablayoutui"));
		vctStaticName.push_back(_T("childlayoutui"));
		vctStaticName.push_back(_T("dialoglayoutui"));

		std::vector<CDuiString>::iterator it = std::find(vctStaticName.begin(), vctStaticName.end(), strClassName);
		if (vctStaticName.end() != it)
		{
			CControlUI* pParent = pControl->GetParent();
			while (pParent)
			{
				strClassName = pParent->GetClass();
				strClassName.MakeLower();
				it = std::find(vctStaticName.begin(), vctStaticName.end(), strClassName);
				if (vctStaticName.end() == it)
				{
					return bRet;
				}

				pParent = pParent->GetParent();
			}

			bRet = TRUE;
		}

		return bRet;
	}

	LRESULT CTBCIAMessageBox::OnSize(UINT uMsg, WPARAM wParam, LPARAM lParam, BOOL& bHandled)
	{


		SIZE szRoundCorner = m_pm.GetRoundCorner();
		if (!::IsIconic(*this) && (szRoundCorner.cx != 0 || szRoundCorner.cy != 0)) {
			CDuiRect rcWnd;
			::GetWindowRect(*this, &rcWnd);
			rcWnd.Offset(-rcWnd.left, -rcWnd.top);
			rcWnd.right++; rcWnd.bottom++;
			HRGN hRgn = ::CreateRoundRectRgn(rcWnd.left, rcWnd.top, rcWnd.right, rcWnd.bottom, szRoundCorner.cx, szRoundCorner.cy);
			::SetWindowRgn(*this, hRgn, TRUE);
			::DeleteObject(hRgn);
		}

		bHandled = FALSE;


		return 0;

		  /*  TODO  只有顶部有圆角
		SIZE szRoundCorner = m_pm.GetRoundCorner();
		if( !::IsIconic(*this) && (szRoundCorner.cx != 0 || szRoundCorner.cy != 0) ) {
			CDuiRect rcWnd;
			::GetWindowRect(*this, &rcWnd);
			rcWnd.Offset(-rcWnd.left, -rcWnd.top);
			rcWnd.right++; rcWnd.bottom++;
			RECT rc = { rcWnd.left, rcWnd.top + szRoundCorner.cx, rcWnd.right, rcWnd.bottom };
			HRGN hRgn1 = ::CreateRectRgnIndirect( &rc );
			HRGN hRgn2 = ::CreateRoundRectRgn(rcWnd.left, rcWnd.top, rcWnd.right, rcWnd.bottom - szRoundCorner.cx, szRoundCorner.cx, szRoundCorner.cy);
			::CombineRgn( hRgn1, hRgn1, hRgn2, RGN_OR );
			::SetWindowRgn(*this, hRgn1, TRUE);
			::DeleteObject(hRgn1);
			::DeleteObject(hRgn2);
		}

		bHandled = FALSE;
		return 0;*/
	}

	LRESULT CTBCIAMessageBox::OnSysCommand(UINT uMsg, WPARAM wParam, LPARAM lParam, BOOL& bHandled)
	{
		BOOL bZoomed = ::IsZoomed(this->GetHWND());
		if ((wParam & 0xFFF0 ) == SC_MAXIMIZE ||(wParam &  0xFFF0) == SC_SIZE)
		{ 
			bHandled = TRUE;
			return 0;
		}
		LRESULT lRes = CWindowWnd::HandleMessage(uMsg, wParam, lParam);
		return lRes;
	}

	LRESULT CTBCIAMessageBox::HandleMessage(UINT uMsg, WPARAM wParam, LPARAM lParam)
	{
		LRESULT lRes = 0;
		BOOL bHandled = TRUE;
		switch( uMsg ) {
	case WM_CREATE:        lRes = OnCreate(uMsg, wParam, lParam, bHandled); break;
	case WM_CLOSE:         lRes = OnClose(uMsg, wParam, lParam, bHandled); break;
	case WM_DESTROY:       lRes = OnDestroy(uMsg, wParam, lParam, bHandled); break;
	case WM_NCACTIVATE:    lRes = OnNcActivate(uMsg, wParam, lParam, bHandled); break;
	case WM_NCCALCSIZE:    lRes = OnNcCalcSize(uMsg, wParam, lParam, bHandled); break;
	case WM_NCPAINT:       lRes = OnNcPaint(uMsg, wParam, lParam, bHandled); break;
	case WM_NCHITTEST:     lRes = OnNcHitTest(uMsg, wParam, lParam, bHandled); break;
	case WM_SIZE:          lRes = OnSize(uMsg, wParam, lParam, bHandled); break;
	case WM_SYSCOMMAND:    lRes = OnSysCommand(uMsg, wParam, lParam, bHandled); break;
	case WM_DPICHANGED:lRes = OnDPIChanged(uMsg, wParam, lParam, bHandled); break;
	default:
		bHandled = FALSE;
		}
		if( bHandled ) return lRes;
		if( m_pm.MessageHandler(uMsg, wParam, lParam, lRes) ) return lRes;
		return CWindowWnd::HandleMessage(uMsg, wParam, lParam);
	}

	void  CTBCIAMessageBox::SetSkinXMLPath( LPCTSTR path )
	{
		_tcscpy( m_skinXMLPath, path );
	}

	LPCTSTR CTBCIAMessageBox::GetSkinXMLPath()
	{
		return m_skinXMLPath;
	}

	CPaintManagerUI& CTBCIAMessageBox::GetPaintManager()
	{
		return m_pm;
	}

} // namespace DuiLib 