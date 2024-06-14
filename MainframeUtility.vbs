
'Public strEnvironment
'strEnvironment = TestArgs("Environment")
''->
'This file is  having all the generic functions related with Mainframe Silver Screen and it's objects, scope is available throughout the execution for Mainframe application</B>
'->
'@remarks
'@author Shakti
'@version V1.0
'date 06/30/2015
'================================================================================================================

'================================================================================================================
''
'This function will close all the existiong Mainframe sessions.
'
'@ Function Name				fnCloseMainFrame()
'@param Input - 					None
'@param Output - 				None
'@remarks						
'@Return								NA
'@author 								Manoj Kumar Mishra
'@version 							  V1.0					
'@date 									06/30/2015	
'================================================================================================================
Public Function fnCloseMainFrame()
	
	Set Process = GetObject("Winmgmts:\\")
	Set oMFProcess = Process.ExecQuery("Select * from Win32_Process where Name = 'bzmd.exe' ")
    For Each MF In oMFProcess
		MF.Terminate()
	Next
	
End Function
'================================================================================================================
'This function will logout mainframe from Aflac MainMenu screen
Public Function fnLogoutMainFrame()
	
	MySLabel=getScreenLabel()
	Tewindow("TeWindow").TeScreen("label:="& MySLabel).SendKey "999"
	Tewindow("TeWindow").TeScreen("label:="& MySLabel).SendKey "@E"
	MySLabel=getScreenLabel()
	Tewindow("TeWindow").TeScreen("label:="& MySLabel).SendKey "cesf logo"
	MySLabel=getScreenLabel()
	Tewindow("TeWindow").TeScreen("label:="& MySLabel).SendKey "@E"
	MySLabel=getScreenLabel()
	Tewindow("TeWindow").TeScreen("label:="& MySLabel).SendKey "/k"
	Tewindow("TeWindow").TeScreen("label:="& MySLabel).SendKey "@E"
	
End Function


'================================================================================================================
''
'This function will close all the existiong Mainframe sessions in mid of  script execution.
'
'@ Function Name				Exit_Mainframe_InMiddle()
'@param Input - 					None
'@param Output - 				None
'@remarks						
'@Return								NA
'@author 								Manoj Kumar Mishra
'@version 							  V1.0					
'@date 									06/30/2015	
'================================================================================================================

Public Function Exit_Mainframe_InMiddle()
wait 2

	If Window("regexpwndtitle:= BlueZone Mainframe Display", "text:=S1 - .* - Secure .* - BlueZone Mainframe Display").Exist(7) Then
		Window("regexpwndtitle:= BlueZone Mainframe Display", "text:=S1 - .* - Secure .* - BlueZone Mainframe Display").Activate
		Window("regexpwndtitle:= BlueZone Mainframe Display", "text:=S1 - .* - Secure .* - BlueZone Mainframe Display").WinToolbar("regexpwndclass:=ToolbarWindow32", "index:=2").Highlight
		wait 1
		
		Window("regexpwndtitle:= BlueZone Mainframe Display", "text:=S1 - .* - Secure .* - BlueZone Mainframe Display").WinToolbar("regexpwndclass:=ToolbarWindow32", "index:=2").Press 11
		wait 5
		
		Window("regexpwndtitle:= BlueZone Mainframe Display", "text:=S1 - .* - Secure .* - BlueZone Mainframe Display").WinToolbar("regexpwndclass:=ToolbarWindow32", "index:=2").Press 11
	End If

End Function



'================================================================================================================
''
'This function will  get the Level property of TeScreen.
'
'@ Function Name				getScreenLabel()
'@param Input - 					None
'@param Output - 				None
'@remarks						
'@Return								NA
'@author 								Manoj Kumar Mishra
'@version 							  V1.0					
'@date 									06/30/2015	
'================================================================================================================

Function getScreenLabel()
	wait 1
					Set objTeScreens = Description.Create()
				    objTeScreens("micclass").Value = "TeScreen"
					Set objTeList = Tewindow("TeWindow").ChildObjects(objTeScreens)
                	MySLabelf =  objTeList(0).GetROProperty("label")
					getScreenLabel = MySLabelf
End Function



'================================================================================================================
''
'This function will  get the screenshot of  currently active page of  Mainframe.
'
'@ Function Name				GetScreenShot()
'@param Input - 					None
'@param Output - 				None
'@remarks						
'@Return								NA
'@author 								Manoj Kumar Mishra
'@version 							  V1.0					
'@date 									06/30/2015	
'================================================================================================================
Public Function GetScreenShot(strOutputFilePath, strFilename)
   BslaceSine = Right(stroutputFilePath,1)
   If  BslaceSine = "\"  Then
     ScreenshotPath = strOutputFilePath & strFilename &".png"
	Else
	ScreenshotPath = strOutputFilePath &"\" & strFilename &".png"
	End If 
	wait 2
	Desktop.CaptureBitmap ScreenshotPath, True
End Function




'================================================================================================================
''
'This function will  execute the  Mainframe.
'
'@ Function Name				DoOpenEXE()
'@param Input - 					None
'@param Output - 				None
'@remarks						
'@Return								NA
'@author 								Manoj Kumar Mishra
'@version 							  V1.0					
'@date 									06/30/2015	
'================================================================================================================

Public Function DoOpenEXE(actionObj,actionValue)
SystemUtil.CloseDescendentProcesses
SystemUtil.Run actionValue
Call fnDoCheckError()
End Function




'================================================================================================================
''
'This function will  let the user to open and login to  the  Mainframe.
'
'@ Function Name				DoOpenEXE()
'@param Input - 					strMFUId - User ID, StrMFPwd -  incripted Password.
'@param Output - 				None
'@remarks						
'@Return								NA
'@author 								Manoj Kumar Mishra
'@version 							  V1.0					
'@date 									06/30/2015	
'================================================================================================================

Public Function fnMainFrame_Login(strMFUId,strMFPwd)
	
	On Error Resume Next
        	Call fnCloseMainFrame()
		
    		Systemutil.Run "C:\Programdata\Microsoft\Windows\Start Menu\Aflac Apps\Bluezone Systest", "", "", "Open"
    		MySLabel = ""
		wait(4)
    		 If Trim(MySLabel) <> "screen5294" Then
			  MySLabel="screen5294"
		 End If
		TeWindow("TeWindow").Activate
		Tewindow("TeWindow").TeScreen("label:="& MySLabel).SetText 1,2,"TPX"
		Tewindow("TeWindow").TeScreen("label:="& MySLabel).Sendkey TE_ENTER
		Tewindow("TeWindow").TeScreen("label:="& MySLabel).Sync
		Wait 3
		MySLabel = getScreenLabel()
        Tewindow("TeWindow").TeScreen("label:="& MySLabel).TeField("attached text:=Userid.*","index:=1").Set strMFUId 
		Tewindow("TeWindow").TeScreen("label:="& MySLabel).TeField("attached text:=Password.*","index:=1").SetSecure strMFPwd
		wait 1
		Tewindow("TeWindow").TeScreen("label:="& MySLabel).SendKey TE_ENTER
	 
	On Error GoTo 0
 		
 		Call checkExtraScreen()
End Function



'================================================================================================================
''
'This function will  verify if expected text is present in specified range of  co-ordinates in mainframe or not. 
'
'@ Function Name				Verifypageloaded(strobj, Textrange, StrScreenName)
'@param Input - 					strobj - Screen object
'													Textrange - range of the screen where screen name is to be verified. E.g.  "1,30,1,50"
'													StrScreenName  -  Name of the screen expected to be loaded. 

'@param Output - 				"True" if  page loaded else "False"
'@remarks						
'@Return								NA
'@author 								Manoj Kumar Mishra
'@version 							  V1.0					
'@date 									07/01/2015	
'================================================================================================================

Public Function Verifypageloaded(strobj, Textrange, StrScreenName)
Dim strscreennameActual
	strscreennameActual = fnVDoGetText(strobj, Textrange)
	Verifypageloaded = False

	For i = 1 to 10
'		 msgbox instr(1, strscreennameActual , StrScreenName)
			If instr(1, strscreennameActual , StrScreenName) <> 0 Then
				Verifypageloaded = True
				Exit for
			End If
	Next
End Function 


'================================================================================================================
''
'This function will  return text from specified range of mainframe screen. 
'
'@ Function Name				Verifypageloaded(strobj, Textrange, StrScreenName)
'@param Input - 					strobj - Screen object
'													Textrange - range of the screen where screen name is to be verified. E.g.  "1,30,1,50"

'@param Output - 				Text of specified range. 
'@remarks						
'@Return								NA
'@author 								Manoj Kumar Mishra
'@Modified							Purnima
'@version 							  V1.0					
'@date 									07/01/2015	
'================================================================================================================

Public Function fnVDoGetText(actionObj,actionValue)
	If actionObj.Exist(2) Then
		If instr(1, actionValue, ",") <>0 Then
			actionValueArr = split(actionValue, ",")
    		fnVDoGetText = actionObj.GetText(actionValueArr(1),actionValueArr(2),actionValueArr(3),actionValueArr(4))
    		Call fnDoCheckError()
		Else
			'actionObj.GetText actionValue
			fnVDoGetText = actionObj.GetText
			Call fnDoCheckError()
		End If
	Else
		strGblRes=strErrObjNotFound
	End If
End Function



'change format of date to "MMDDYY"
Public Function changeDateFormatMMDDYY(ByVal inputDate)

	monthVal = Month(inputDate)
	If Len(monthVal) = 1 Then
		monthVal = "0" & monthVal
	End If

	dateVal = Day(inputDate)
	If Len(dateVal) = 1 Then
		dateVal = "0" & dateVal
	End If

	yearVal = Year(inputDate)
	If Len(yearVal) > 2 Then
		yearVal = Right(yearVal, 2)
	End If

    changeDateFormatMMDDYY = monthVal & "/" & dateVal & "/" & yearVal
End Function




'================================================================================================================
''
'This function will  return text from specified range of mainframe screen. 
'
'@ Function Name				UDF_ScreenShot(SctScreenshortPath)
'@param Input -                     ScreenshortPath - Path where screenshort need to be saved. 
'@param Output - 				Screenshort of current page is saved in specified path. 
'@remarks						
'@Return								Screen short of Current page. 
'@author 								Manoj Kumar Mishra
'@version 							  V1.0					
'@date 									07/01/2015	
'================================================================================================================
Public Function UDF_ScreenShot()
	
	strRunDate = Split(Replace(Replace(Now,"/","-"),":","-"), " ", -1, 1)
	Environment.Value("Date") = strRunDate(0)
	Environment.Value("Time") = strRunDate(1)
	wait 2
	ScreenshotPath = screenshotFolderPath &"ScreenShot"& "_"&Environment.Value("testcasename")& "_" & Environment.Value("Date")& "_" &Environment.Value("Time")&".png"
	wait 2
				Desktop.CaptureBitmap ScreenshotPath, True
End Function



Function setvActionObject(vObj,objLName)

If Not isNull(IActionObject) Then
Select Case UCase(vObj)
CASE  "ACTIVEX"  Set IActionObject = IActionObject.ActiveX(objLName)
CASE  "ACXBUTTON"  Set IActionObject = IActionObject.AcxButton(objLName)
CASE  "ACXCALENDAR"  Set IActionObject = IActionObject.AcxCalendar(objLName)
CASE  "ACXCHECKBOX"  Set IActionObject = IActionObject.AcxCheckBox(objLName)
CASE  "ACXCOMBOBOX"  Set IActionObject = IActionObject.AcxComboBox(objLName)
CASE  "ACXEDIT"  Set IActionObject = IActionObject.AcxEdit(objLName)
CASE  "ACXRADIOBUTTON"  Set IActionObject = IActionObject.AcxRadioButton(objLName)
CASE  "ACXTABLE"  Set IActionObject = IActionObject.AcxTable(objLName)
CASE  "ACXUTIL"  Set IActionObject = IActionObject.AcxUtil(objLName)
CASE  "DELPHIBUTTON"  Set IActionObject = IActionObject.DelphiButton(objLName)
CASE  "DELPHICHECKBOX"  Set IActionObject = IActionObject.DelphiCheckBox(objLName)
CASE  "DELPHICOMBOBOX"  Set IActionObject = IActionObject.DelphiComboBox(objLName)
CASE  "DELPHIEDIT"  Set IActionObject = IActionObject.DelphiEdit(objLName)
CASE  "DELPHIEDITOR"  Set IActionObject = IActionObject.DelphiEditor(objLName)
CASE  "DELPHILIST"  Set IActionObject = IActionObject.DelphiList(objLName)
CASE  "DELPHILISTVIEW"  Set IActionObject = IActionObject.DelphiListView(objLName)
CASE  "DELPHINAVIGATOR"  Set IActionObject = IActionObject.DelphiNavigator(objLName)
CASE  "DELPHIOBJECT"  Set IActionObject = IActionObject.DelphiObject(objLName)
CASE  "DELPHIRADIOBUTTON"  Set IActionObject = IActionObject.DelphiRadioButton(objLName)
CASE  "DELPHISCROLLBAR"  Set IActionObject = IActionObject.DelphiScrollBar(objLName)
CASE  "DELPHISPIN"  Set IActionObject = IActionObject.DelphiSpin(objLName)
CASE  "DELPHISTATIC"  Set IActionObject = IActionObject.DelphiStatic(objLName)
CASE  "DELPHISTATUSBAR"  Set IActionObject = IActionObject.DelphiStatusBar(objLName)
CASE  "DELPHITABLE"  Set IActionObject = IActionObject.DelphiTable(objLName)
CASE  "DELPHITABSTRIP"  Set IActionObject = IActionObject.DelphiTabStrip(objLName)
CASE  "DELPHITREEVIEW"  Set IActionObject = IActionObject.DelphiTreeView(objLName)
CASE  "DELPHIWINDOW"  Set IActionObject = IActionObject.DelphiWindow(objLName)
CASE  "JAVAAPPLET"  Set IActionObject = IActionObject.JavaApplet(objLName)
CASE  "JAVABUTTON"  Set IActionObject = IActionObject.JavaButton(objLName)
CASE  "JAVACALENDAR"  Set IActionObject = IActionObject.JavaCalendar(objLName)
CASE  "JAVACHECKBOX"  Set IActionObject = IActionObject.JavaCheckBox(objLName)
CASE  "JAVADIALOG"  Set IActionObject = IActionObject.JavaDialog(objLName)
CASE  "JAVAEDIT"  Set IActionObject = IActionObject.JavaEdit(objLName)
CASE  "JAVAEXPANDBAR"  Set IActionObject = IActionObject.JavaExpandBar(objLName)
CASE  "JAVAINTERNALFRAME"  Set IActionObject = IActionObject.JavaInternalFrame(objLName)
CASE  "JAVALINK"  Set IActionObject = IActionObject.JavaLink(objLName)
CASE  "JAVALIST"  Set IActionObject = IActionObject.JavaList(objLName)
CASE  "JAVAMENU"  Set IActionObject = IActionObject.JavaMenu(objLName)
CASE  "JAVAOBJECT"  Set IActionObject = IActionObject.JavaObject(objLName)
CASE  "JAVARADIOBUTTON"  Set IActionObject = IActionObject.JavaRadioButton(objLName)
CASE  "JAVASLIDER"  Set IActionObject = IActionObject.JavaSlider(objLName)
CASE  "JAVASPIN"  Set IActionObject = IActionObject.JavaSpin(objLName)
CASE  "JAVASTATICTEXT"  Set IActionObject = IActionObject.JavaStaticText(objLName)
CASE  "JAVATAB"  Set IActionObject = IActionObject.JavaTab(objLName)
CASE  "JAVATABLE"  Set IActionObject = IActionObject.JavaTable(objLName)
CASE  "JAVATOOLBAR"  Set IActionObject = IActionObject.JavaToolbar(objLName)
CASE  "JAVATREE"  Set IActionObject = IActionObject.JavaTree(objLName)
CASE  "JAVAWINDOW"  Set IActionObject = IActionObject.JavaWindow(objLName)
CASE  "SLVACCORDION"  Set IActionObject = IActionObject.SlvAccordion(objLName)
CASE  "SLVBUTTON"  Set IActionObject = IActionObject.SlvButton(objLName)
CASE  "SLVCALENDAR"  Set IActionObject = IActionObject.SlvCalendar(objLName)
CASE  "SLVCHECKBOX"  Set IActionObject = IActionObject.SlvCheckBox(objLName)
CASE  "SLVCOMBOBOX"  Set IActionObject = IActionObject.SlvComboBox(objLName)
CASE  "SLVDATAPAGER"  Set IActionObject = IActionObject.SlvDataPager(objLName)
CASE  "SLVDIALOG"  Set IActionObject = IActionObject.SlvDialog(objLName)
CASE  "SLVEDIT"  Set IActionObject = IActionObject.SlvEdit(objLName)
CASE  "SLVEXPANDER"  Set IActionObject = IActionObject.SlvExpander(objLName)
CASE  "SLVLINK"  Set IActionObject = IActionObject.SlvLink(objLName)
CASE  "SLVLIST"  Set IActionObject = IActionObject.SlvList(objLName)
CASE  "SLVOBJECT"  Set IActionObject = IActionObject.SlvObject(objLName)
CASE  "SLVPAGE"  Set IActionObject = IActionObject.SlvPage(objLName)
CASE  "SLVPROGRESSBAR"  Set IActionObject = IActionObject.SlvProgressBar(objLName)
CASE  "SLVRADIOBUTTON"  Set IActionObject = IActionObject.SlvRadioButton(objLName)
CASE  "SLVSCROLLBAR"  Set IActionObject = IActionObject.SlvScrollBar(objLName)
CASE  "SLVSLIDER"  Set IActionObject = IActionObject.SlvSlider(objLName)
CASE  "SLVTABLE"  Set IActionObject = IActionObject.SlvTable(objLName)
CASE  "SLVTABSTRIP"  Set IActionObject = IActionObject.SlvTabStrip(objLName)
CASE  "SLVTOGGLEBUTTON"  Set IActionObject = IActionObject.SlvToggleButton(objLName)
CASE  "SLVTREEVIEW"  Set IActionObject = IActionObject.SlvTreeView(objLName)
CASE  "SLVWINDOW"  Set IActionObject = IActionObject.SlvWindow(objLName)
CASE  "WBFCALENDAR"  Set IActionObject = IActionObject.WbfCalendar(objLName)
CASE  "WBFGRID"  Set IActionObject = IActionObject.WbfGrid(objLName)
CASE  "WBFTABSTRIP"  Set IActionObject = IActionObject.WbfTabStrip(objLName)
CASE  "WBFTOOLBAR"  Set IActionObject = IActionObject.WbfToolbar(objLName)
CASE  "WBFTREEVIEW"  Set IActionObject = IActionObject.WbfTreeView(objLName)
CASE  "WBFULTRAGRID"  Set IActionObject = IActionObject.WbfUltraGrid(objLName)
CASE  "SWFBUTTON"  Set IActionObject = IActionObject.SwfButton(objLName)
CASE  "SWFCALENDAR"  Set IActionObject = IActionObject.SwfCalendar(objLName)
CASE  "SWFCHECKBOX"  Set IActionObject = IActionObject.SwfCheckBox(objLName)
CASE  "SWFCOMBOBOX"  Set IActionObject = IActionObject.SwfComboBox(objLName)
CASE  "SWFEDIT"  Set IActionObject = IActionObject.SwfEdit(objLName)
CASE  "SWFEDITOR"  Set IActionObject = IActionObject.SwfEditor(objLName)
CASE  "SWFLABEL"  Set IActionObject = IActionObject.SwfLabel(objLName)
CASE  "SWFLIST"  Set IActionObject = IActionObject.SwfList(objLName)
CASE  "SWFLISTVIEW"  Set IActionObject = IActionObject.SwfListView(objLName)
CASE  "SWFOBJECT"  Set IActionObject = IActionObject.SwfObject(objLName)
CASE  "SWFPROPERTYGRID"  Set IActionObject = IActionObject.SwfPropertyGrid(objLName)
CASE  "SWFRADIOBUTTON"  Set IActionObject = IActionObject.SwfRadioButton(objLName)
CASE  "SWFSCROLLBAR"  Set IActionObject = IActionObject.SwfScrollBar(objLName)
CASE  "SWFSPIN"  Set IActionObject = IActionObject.SwfSpin(objLName)
CASE  "SWFSTATUSBAR"  Set IActionObject = IActionObject.SwfStatusBar(objLName)
CASE  "SWFTAB"  Set IActionObject = IActionObject.SwfTab(objLName)
CASE  "SWFTABLE"  Set IActionObject = IActionObject.SwfTable(objLName)
CASE  "SWFTOOLBAR"  Set IActionObject = IActionObject.SwfToolBar(objLName)
CASE  "SWFTREEVIEW"  Set IActionObject = IActionObject.SwfTreeView(objLName)
CASE  "SWFWINDOW"  Set IActionObject = IActionObject.SwfWindow(objLName)
CASE  "WPFBUTTON"  Set IActionObject = IActionObject.WpfButton(objLName)
CASE  "WPFCHECKBOX"  Set IActionObject = IActionObject.WpfCheckBox(objLName)
CASE  "WPFCOMBOBOX"  Set IActionObject = IActionObject.WpfComboBox(objLName)
CASE  "WPFEDIT"  Set IActionObject = IActionObject.WpfEdit(objLName)
CASE  "WPFIMAGE"  Set IActionObject = IActionObject.WpfImage(objLName)
CASE  "WPFLINK"  Set IActionObject = IActionObject.WpfLink(objLName)
CASE  "WPFLIST"  Set IActionObject = IActionObject.WpfList(objLName)
CASE  "WPFMENU"  Set IActionObject = IActionObject.WpfMenu(objLName)
CASE  "WPFOBJECT"  Set IActionObject = IActionObject.WpfObject(objLName)
CASE  "WPFPROGRESSBAR"  Set IActionObject = IActionObject.WpfProgressBar(objLName)
CASE  "WPFRADIOBUTTON"  Set IActionObject = IActionObject.WpfRadioButton(objLName)
CASE  "WPFSCROLLBAR"  Set IActionObject = IActionObject.WpfScrollBar(objLName)
CASE  "WPFSLIDER"  Set IActionObject = IActionObject.WpfSlider(objLName)
CASE  "WPFSTATUSBAR"  Set IActionObject = IActionObject.WpfStatusBar(objLName)
CASE  "WPFTABLE"  Set IActionObject = IActionObject.WpfTable(objLName)
CASE  "WPFTABSTRIP"  Set IActionObject = IActionObject.WpfTabStrip(objLName)
CASE  "WPFTOOLBAR"  Set IActionObject = IActionObject.WpfToolbar(objLName)
CASE  "WPFTREEVIEW"  Set IActionObject = IActionObject.WpfTreeView(objLName)
CASE  "WPFWINDOW"  Set IActionObject = IActionObject.WpfWindow(objLName)
CASE  "ORACLEAPPLICATIONS"  Set IActionObject = IActionObject.OracleApplications(objLName)
CASE  "ORACLEBUTTON"  Set IActionObject = IActionObject.OracleButton(objLName)
CASE  "ORACLECALENDAR"  Set IActionObject = IActionObject.OracleCalendar(objLName)
CASE  "ORACLECHECKBOX"  Set IActionObject = IActionObject.OracleCheckbox(objLName)
CASE  "ORACLEFLEXWINDOW"  Set IActionObject = IActionObject.OracleFlexWindow(objLName)
CASE  "ORACLEFORMWINDOW"  Set IActionObject = IActionObject.OracleFormWindow(objLName)
CASE  "ORACLELIST"  Set IActionObject = IActionObject.OracleList(objLName)
CASE  "ORACLELISTOFVALUES"  Set IActionObject = IActionObject.OracleListOfValues(objLName)
CASE  "ORACLELOGON"  Set IActionObject = IActionObject.OracleLogon(objLName)
CASE  "ORACLENAVIGATOR"  Set IActionObject = IActionObject.OracleNavigator(objLName)
CASE  "ORACLENOTIFICATION"  Set IActionObject = IActionObject.OracleNotification(objLName)
CASE  "ORACLERADIOGROUP"  Set IActionObject = IActionObject.OracleRadioGroup(objLName)
CASE  "ORACLESTATUSLINE"  Set IActionObject = IActionObject.OracleStatusLine(objLName)
CASE  "ORACLETABBEDREGION"  Set IActionObject = IActionObject.OracleTabbedRegion(objLName)
CASE  "ORACLETABLE"  Set IActionObject = IActionObject.OracleTable(objLName)
CASE  "ORACLETEXTFIELD"  Set IActionObject = IActionObject.OracleTextField(objLName)
CASE  "ORACLETREE"  Set IActionObject = IActionObject.OracleTree(objLName)
CASE  "PSFRAME"  Set IActionObject = IActionObject.PSFrame(objLName)
CASE  "PBBUTTON"  Set IActionObject = IActionObject.PbButton(objLName)
CASE  "PBCHECKBOX"  Set IActionObject = IActionObject.PbCheckBox(objLName)
CASE  "PBCOMBOBOX"  Set IActionObject = IActionObject.PbComboBox(objLName)
CASE  "PBDATAWINDOW"  Set IActionObject = IActionObject.PbDataWindow(objLName)
CASE  "PBEDIT"  Set IActionObject = IActionObject.PbEdit(objLName)
CASE  "PBLIST"  Set IActionObject = IActionObject.PbList(objLName)
CASE  "PBLISTVIEW"  Set IActionObject = IActionObject.PbListView(objLName)
CASE  "PBOBJECT"  Set IActionObject = IActionObject.PbObject(objLName)
CASE  "PBRADIOBUTTON"  Set IActionObject = IActionObject.PbRadioButton(objLName)
CASE  "PBSCROLLBAR"  Set IActionObject = IActionObject.PbScrollBar(objLName)
CASE  "PBTABSTRIP"  Set IActionObject = IActionObject.PbTabStrip(objLName)
CASE  "PBTOOLBAR"  Set IActionObject = IActionObject.PbToolbar(objLName)
CASE  "PBTREEVIEW"  Set IActionObject = IActionObject.PbTreeView(objLName)
CASE  "PBWINDOW"  Set IActionObject = IActionObject.PbWindow(objLName)
CASE  "SAPBUTTON"  Set IActionObject = IActionObject.SAPButton(objLName)
CASE  "SAPCALENDAR"  Set IActionObject = IActionObject.SAPCalendar(objLName)
CASE  "SAPCHECKBOX"  Set IActionObject = IActionObject.SAPCheckBox(objLName)
CASE  "SAPDROPDOWNMENU"  Set IActionObject = IActionObject.SAPDropDownMenu(objLName)
CASE  "SAPEDIT"  Set IActionObject = IActionObject.SAPEdit(objLName)
CASE  "SAPFRAME"  Set IActionObject = IActionObject.SAPFrame(objLName)
CASE  "SAPIVIEW"  Set IActionObject = IActionObject.SAPiView(objLName)
CASE  "SAPLIST"  Set IActionObject = IActionObject.SAPList(objLName)
CASE  "SAPMENU"  Set IActionObject = IActionObject.SAPMenu(objLName)
CASE  "SAPNAVIGATIONBAR"  Set IActionObject = IActionObject.SAPNavigationBar(objLName)
CASE  "SAPOKCODE"  Set IActionObject = IActionObject.SAPOKCode(objLName)
CASE  "SAPPORTAL"  Set IActionObject = IActionObject.SAPPortal(objLName)
CASE  "SAPRADIOGROUP"  Set IActionObject = IActionObject.SAPRadioGroup(objLName)
CASE  "SAPSTATUSBAR"  Set IActionObject = IActionObject.SAPStatusBar(objLName)
CASE  "SAPTABLE"  Set IActionObject = IActionObject.SAPTable(objLName)
CASE  "SAPTABSTRIP"  Set IActionObject = IActionObject.SAPTabStrip(objLName)
CASE  "SAPTREEVIEW"  Set IActionObject = IActionObject.SAPTreeView(objLName)
CASE  "SAPGUIAPOGRID"  Set IActionObject = IActionObject.SAPGuiAPOGrid(objLName)
CASE  "SAPGUIBUTTON"  Set IActionObject = IActionObject.SAPGuiButton(objLName)
CASE  "SAPGUICALENDAR"  Set IActionObject = IActionObject.SAPGuiCalendar(objLName)
CASE  "SAPGUICHECKBOX"  Set IActionObject = IActionObject.SAPGuiCheckBox(objLName)
CASE  "SAPGUICOMBOBOX"  Set IActionObject = IActionObject.SAPGuiComboBox(objLName)
CASE  "SAPGUIEDIT"  Set IActionObject = IActionObject.SAPGuiEdit(objLName)
CASE  "SAPGUIELEMENT"  Set IActionObject = IActionObject.SAPGuiElement(objLName)
CASE  "SAPGUIGRID"  Set IActionObject = IActionObject.SAPGuiGrid(objLName)
CASE  "SAPGUILABEL"  Set IActionObject = IActionObject.SAPGuiLabel(objLName)
CASE  "SAPGUIMENUBAR"  Set IActionObject = IActionObject.SAPGuiMenubar(objLName)
CASE  "SAPGUIOKCODE"  Set IActionObject = IActionObject.SAPGuiOKCode(objLName)
CASE  "SAPGUIRADIOBUTTON"  Set IActionObject = IActionObject.SAPGuiRadioButton(objLName)
CASE  "SAPGUISESSION"  Set IActionObject = IActionObject.SAPGuiSession(objLName)
CASE  "SAPGUISTATUSBAR"  Set IActionObject = IActionObject.SAPGuiStatusBar(objLName)
CASE  "SAPGUITABLE"  Set IActionObject = IActionObject.SAPGuiTable(objLName)
CASE  "SAPGUITABSTRIP"  Set IActionObject = IActionObject.SAPGuiTabStrip(objLName)
CASE  "SAPGUITEXTAREA"  Set IActionObject = IActionObject.SAPGuiTextArea(objLName)
CASE  "SAPGUITOOLBAR"  Set IActionObject = IActionObject.SAPGuiToolbar(objLName)
CASE  "SAPGUITREE"  Set IActionObject = IActionObject.SAPGuiTree(objLName)
CASE  "SAPGUIUTIL"  Set IActionObject = IActionObject.SAPGuiUtil(objLName)
CASE  "SAPGUIWINDOW"  Set IActionObject = IActionObject.SAPGuiWindow(objLName)
CASE  "SBLADVANCEDEDIT"  Set IActionObject = IActionObject.SblAdvancedEdit(objLName)
CASE  "SBLBUTTON"  Set IActionObject = IActionObject.SblButton(objLName)
CASE  "SBLCHECKBOX"  Set IActionObject = IActionObject.SblCheckBox(objLName)
CASE  "SBLEDIT"  Set IActionObject = IActionObject.SblEdit(objLName)
CASE  "SBLPICKLIST"  Set IActionObject = IActionObject.SblPickList(objLName)
CASE  "SBLTABLE"  Set IActionObject = IActionObject.SblTable(objLName)
CASE  "SBLTABSTRIP"  Set IActionObject = IActionObject.SblTabStrip(objLName)
CASE  "SBLTREEVIEW"  Set IActionObject = IActionObject.SblTreeView(objLName)
CASE  "SIEBAPPLET"  Set IActionObject = IActionObject.SiebApplet(objLName)
CASE  "SIEBAPPLICATION"  Set IActionObject = IActionObject.SiebApplication(objLName)
CASE  "SIEBBUTTON"  Set IActionObject = IActionObject.SiebButton(objLName)
CASE  "SIEBCALCULATOR"  Set IActionObject = IActionObject.SiebCalculator(objLName)
CASE  "SIEBCALENDAR"  Set IActionObject = IActionObject.SiebCalendar(objLName)
CASE  "SIEBCHECKBOX"  Set IActionObject = IActionObject.SiebCheckbox(objLName)
CASE  "SIEBCOMMUNICATIONSTOOLBAR"  Set IActionObject = IActionObject.SiebCommunicationsToolbar(objLName)
CASE  "SIEBCURRENCY"  Set IActionObject = IActionObject.SiebCurrency(objLName)
CASE  "SIEBINKDATA"  Set IActionObject = IActionObject.SiebInkData(objLName)
CASE  "SIEBLIST"  Set IActionObject = IActionObject.SiebList(objLName)
CASE  "SIEBMENU"  Set IActionObject = IActionObject.SiebMenu(objLName)
CASE  "SIEBPAGETABS"  Set IActionObject = IActionObject.SiebPageTabs(objLName)
CASE  "SIEBPDQ"  Set IActionObject = IActionObject.SiebPDQ(objLName)
CASE  "SIEBPICKLIST"  Set IActionObject = IActionObject.SiebPicklist(objLName)
CASE  "SIEBRICHTEXT"  Set IActionObject = IActionObject.SiebRichText(objLName)
CASE  "SIEBSCREEN"  Set IActionObject = IActionObject.SiebScreen(objLName)
CASE  "SIEBSCREENVIEWS"  Set IActionObject = IActionObject.SiebScreenViews(objLName)
CASE  "SIEBTASK"  Set IActionObject = IActionObject.SiebTask(objLName)
CASE  "SIEBTASKASSISTANT"  Set IActionObject = IActionObject.SiebTaskAssistant(objLName)
CASE  "SIEBTASKLINK"  Set IActionObject = IActionObject.SiebTaskLink(objLName)
CASE  "SIEBTASKSTEP"  Set IActionObject = IActionObject.SiebTaskStep(objLName)
CASE  "SIEBTASKUIPANE"  Set IActionObject = IActionObject.SiebTaskUIPane(objLName)
CASE  "SIEBTEXT"  Set IActionObject = IActionObject.SiebText(objLName)
CASE  "SIEBTEXTAREA"  Set IActionObject = IActionObject.SiebTextArea(objLName)
CASE  "SIEBTHREADBAR"  Set IActionObject = IActionObject.SiebThreadbar(objLName)
CASE  "SIEBTOOLBAR"  Set IActionObject = IActionObject.SiebToolbar(objLName)
CASE  "SIEBTREE"  Set IActionObject = IActionObject.SiebTree(objLName)
CASE  "SIEBVIEW"  Set IActionObject = IActionObject.SiebView(objLName)
CASE  "SIEBVIEWAPPLETS"  Set IActionObject = IActionObject.SiebViewApplets(objLName)
CASE  "DESKTOP"  Set IActionObject = IActionObject.Desktop(objLName)
CASE  "DIALOG"  Set IActionObject = IActionObject.Dialog(objLName)
CASE  "STATIC"  Set IActionObject = IActionObject.Static(objLName)
CASE  "SYSTEMUTIL"  Set IActionObject = IActionObject.SystemUtil(objLName)
CASE  "WINBUTTON"  Set IActionObject = IActionObject.WinButton(objLName)
CASE  "WINCALENDAR"  Set IActionObject = IActionObject.WinCalendar(objLName)
CASE  "WINCHECKBOX"  Set IActionObject = IActionObject.WinCheckBox(objLName)
CASE  "WINCOMBOBOX"  Set IActionObject = IActionObject.WinComboBox(objLName)
CASE  "WINDOW"  Set IActionObject = IActionObject.Window(objLName)
CASE  "WINEDIT"  Set IActionObject = IActionObject.WinEdit(objLName)
CASE  "WINEDITOR"  Set IActionObject = IActionObject.WinEditor(objLName)
CASE  "WINLIST"  Set IActionObject = IActionObject.WinList(objLName)
CASE  "WINLISTVIEW"  Set IActionObject = IActionObject.WinListView(objLName)
CASE  "WINMENU"  Set IActionObject = IActionObject.WinMenu(objLName)
CASE  "WINOBJECT"  Set IActionObject = IActionObject.WinObject(objLName)
CASE  "WINRADIOBUTTON"  Set IActionObject = IActionObject.WinRadioButton(objLName)
CASE  "WINSCROLLBAR"  Set IActionObject = IActionObject.WinScrollBar(objLName)
CASE  "WINSPIN"  Set IActionObject = IActionObject.WinSpin(objLName)
CASE  "WINSTATUSBAR"  Set IActionObject = IActionObject.WinStatusBar(objLName)
CASE  "WINTAB"  Set IActionObject = IActionObject.WinTab(objLName)
CASE  "WINTOOLBAR"  Set IActionObject = IActionObject.WinToolbar(objLName)
CASE  "WINTREEVIEW"  Set IActionObject = IActionObject.WinTreeView(objLName)
CASE  "WINTAB"  Set IActionObject = IActionObject.WinTab(objLName)
CASE  "WINTABLE"  Set IActionObject = IActionObject.WinTable(objLName)
CASE  "WINTOOLBAR"  Set IActionObject = IActionObject.WinToolbar(objLName)
CASE  "WINTREEVIEW"  Set IActionObject = IActionObject.WinTreeView(objLName)
CASE  "TEFIELD"  Set IActionObject = IActionObject.TeField(objLName)
CASE  "TESCREEN"  Set IActionObject = IActionObject.TeScreen(objLName)
CASE  "TETEXTSCREEN"  Set IActionObject = IActionObject.TeTextScreen(objLName)
CASE  "TEWINDOW"  Set IActionObject = IActionObject.TeWindow(objLName)
'CASE  "WDWTEWINDOW" Set IActionObject = IActionObject.TeWindow(objLName)
CASE  "VBBUTTON"  Set IActionObject = IActionObject.VbButton(objLName)
CASE  "VBCHECKBOX"  Set IActionObject = IActionObject.VbCheckBox(objLName)
CASE  "VBCOMBOBOX"  Set IActionObject = IActionObject.VbComboBox(objLName)
CASE  "VBEDIT"  Set IActionObject = IActionObject.VbEdit(objLName)
CASE  "VBEDITOR"  Set IActionObject = IActionObject.VbEditor(objLName)
CASE  "VBFRAME"  Set IActionObject = IActionObject.VbFrame(objLName)
CASE  "VBLABEL"  Set IActionObject = IActionObject.VbLabel(objLName)
CASE  "VBLIST"  Set IActionObject = IActionObject.VbList(objLName)
CASE  "VBLISTVIEW"  Set IActionObject = IActionObject.VbListView(objLName)
CASE  "VBRADIOBUTTON"  Set IActionObject = IActionObject.VbRadioButton(objLName)
CASE  "VBSCROLLBAR"  Set IActionObject = IActionObject.VbScrollBar(objLName)
CASE  "VBTOOLBAR"  Set IActionObject = IActionObject.VbToolbar(objLName)
CASE  "VBTREEVIEW"  Set IActionObject = IActionObject.VbTreeView(objLName)
CASE  "VBWINDOW"  Set IActionObject = IActionObject.VbWindow(objLName)
CASE  "WINBUTTON"  Set IActionObject = IActionObject.WinButton(objLName)
CASE  "WINCHECKBOX"  Set IActionObject = IActionObject.WinCheckBox(objLName)
CASE  "WINEDIT"  Set IActionObject = IActionObject.WinEdit(objLName)
CASE  "WINEDITOR"  Set IActionObject = IActionObject.WinEditor(objLName)
CASE  "WINLIST"  Set IActionObject = IActionObject.WinList(objLName)
CASE  "WINOBJECT"  Set IActionObject = IActionObject.WinObject(objLName)
CASE  "WINRADIOBUTTON"  Set IActionObject = IActionObject.WinRadioButton(objLName)
CASE  "WINSPINBUTTON"  Set IActionObject = IActionObject.WinSpinButton(objLName)
CASE  "WINTAB"  Set IActionObject = IActionObject.WinTab(objLName)
CASE  "WINTABLE"  Set IActionObject = IActionObject.WinTable(objLName)
CASE  "WINTREEVIEW"  Set IActionObject = IActionObject.WinTreeView(objLName)
CASE  "BROWSER"  Set IActionObject = IActionObject.Browser(objLName)
CASE  "FRAME"  Set IActionObject = IActionObject.Frame(objLName)
CASE  "IMAGE"  Set IActionObject = IActionObject.Image(objLName)
CASE  "LINK"  Set IActionObject = IActionObject.Link(objLName)
CASE  "PAGE"  Set IActionObject = IActionObject.Page(objLName)
CASE  "VIEWLINK"  Set IActionObject = IActionObject.ViewLink(objLName)
CASE  "WEBAREA"  Set IActionObject = IActionObject.WebArea(objLName)
CASE  "WEBBUTTON"  Set IActionObject = IActionObject.WebButton(objLName)
CASE  "WEBCHECKBOX"  Set IActionObject = IActionObject.WebCheckBox(objLName)
CASE  "WEBEDIT"  Set IActionObject = IActionObject.WebEdit(objLName)
CASE  "WEBELEMENT"  Set IActionObject = IActionObject.WebElement(objLName)
CASE  "WEBFILE"  Set IActionObject = IActionObject.WebFile(objLName)
CASE  "WEBLIST"  Set IActionObject = IActionObject.WebList(objLName)
CASE  "WEBRADIOGROUP"  Set IActionObject = IActionObject.WebRadioGroup(objLName)
CASE  "WEBTABLE"  Set IActionObject = IActionObject.WebTable(objLName)
CASE  "WEBXML"  Set IActionObject = IActionObject.WebXML(objLName)
CASE  "ATTACHMENTS"  Set IActionObject = IActionObject.Attachments(objLName)
CASE  "CONFIGURATION"  Set IActionObject = IActionObject.Configuration(objLName)
CASE  "HEADERS"  Set IActionObject = IActionObject.headers(objLName)
CASE  "SECURITY"  Set IActionObject = IActionObject.Security(objLName)
CASE  "WEBSERVICE"  Set IActionObject = IActionObject.WebService(objLName)
CASE  "WSUTIL"  Set IActionObject = IActionObject.WSUtil(objLName)
Case Else  IActionObject= NULL
End Select
Else
Select Case UCase(vObj)
CASE  "ACTIVEX"  Set IActionObject = ActiveX(objLName)
CASE  "ACXBUTTON"  Set IActionObject = AcxButton(objLName)
CASE  "ACXCALENDAR"  Set IActionObject = AcxCalendar(objLName)
CASE  "ACXCHECKBOX"  Set IActionObject = AcxCheckBox(objLName)
CASE  "ACXCOMBOBOX"  Set IActionObject = AcxComboBox(objLName)
CASE  "ACXEDIT"  Set IActionObject = AcxEdit(objLName)
CASE  "ACXRADIOBUTTON"  Set IActionObject = AcxRadioButton(objLName)
CASE  "ACXTABLE"  Set IActionObject = AcxTable(objLName)
CASE  "ACXUTIL"  Set IActionObject = AcxUtil(objLName)
CASE  "DELPHIBUTTON"  Set IActionObject = DelphiButton(objLName)
CASE  "DELPHICHECKBOX"  Set IActionObject = DelphiCheckBox(objLName)
CASE  "DELPHICOMBOBOX"  Set IActionObject = DelphiComboBox(objLName)
CASE  "DELPHIEDIT"  Set IActionObject = DelphiEdit(objLName)
CASE  "DELPHIEDITOR"  Set IActionObject = DelphiEditor(objLName)
CASE  "DELPHILIST"  Set IActionObject = DelphiList(objLName)
CASE  "DELPHILISTVIEW"  Set IActionObject = DelphiListView(objLName)
CASE  "DELPHINAVIGATOR"  Set IActionObject = DelphiNavigator(objLName)
CASE  "DELPHIOBJECT"  Set IActionObject = DelphiObject(objLName)
CASE  "DELPHIRADIOBUTTON"  Set IActionObject = DelphiRadioButton(objLName)
CASE  "DELPHISCROLLBAR"  Set IActionObject = DelphiScrollBar(objLName)
CASE  "DELPHISPIN"  Set IActionObject = DelphiSpin(objLName)
CASE  "DELPHISTATIC"  Set IActionObject = DelphiStatic(objLName)
CASE  "DELPHISTATUSBAR"  Set IActionObject = DelphiStatusBar(objLName)
CASE  "DELPHITABLE"  Set IActionObject = DelphiTable(objLName)
CASE  "DELPHITABSTRIP"  Set IActionObject = DelphiTabStrip(objLName)
CASE  "DELPHITREEVIEW"  Set IActionObject = DelphiTreeView(objLName)
CASE  "DELPHIWINDOW"  Set IActionObject = DelphiWindow(objLName)
CASE  "JAVAAPPLET"  Set IActionObject = JavaApplet(objLName)
CASE  "JAVABUTTON"  Set IActionObject = JavaButton(objLName)
CASE  "JAVACALENDAR"  Set IActionObject = JavaCalendar(objLName)
CASE  "JAVACHECKBOX"  Set IActionObject = JavaCheckBox(objLName)
CASE  "JAVADIALOG"  Set IActionObject = JavaDialog(objLName)
CASE  "JAVAEDIT"  Set IActionObject = JavaEdit(objLName)
CASE  "JAVAEXPANDBAR"  Set IActionObject = JavaExpandBar(objLName)
CASE  "JAVAINTERNALFRAME"  Set IActionObject = JavaInternalFrame(objLName)
CASE  "JAVALINK"  Set IActionObject = JavaLink(objLName)
CASE  "JAVALIST"  Set IActionObject = JavaList(objLName)
CASE  "JAVAMENU"  Set IActionObject = JavaMenu(objLName)
CASE  "JAVAOBJECT"  Set IActionObject = JavaObject(objLName)
CASE  "JAVARADIOBUTTON"  Set IActionObject = JavaRadioButton(objLName)
CASE  "JAVASLIDER"  Set IActionObject = JavaSlider(objLName)
CASE  "JAVASPIN"  Set IActionObject = JavaSpin(objLName)
CASE  "JAVASTATICTEXT"  Set IActionObject = JavaStaticText(objLName)
CASE  "JAVATAB"  Set IActionObject = JavaTab(objLName)
CASE  "JAVATABLE"  Set IActionObject = JavaTable(objLName)
CASE  "JAVATOOLBAR"  Set IActionObject = JavaToolbar(objLName)
CASE  "JAVATREE"  Set IActionObject = JavaTree(objLName)
CASE  "JAVAWINDOW"  Set IActionObject = JavaWindow(objLName)
CASE  "SLVACCORDION"  Set IActionObject = SlvAccordion(objLName)
CASE  "SLVBUTTON"  Set IActionObject = SlvButton(objLName)
CASE  "SLVCALENDAR"  Set IActionObject = SlvCalendar(objLName)
CASE  "SLVCHECKBOX"  Set IActionObject = SlvCheckBox(objLName)
CASE  "SLVCOMBOBOX"  Set IActionObject = SlvComboBox(objLName)
CASE  "SLVDATAPAGER"  Set IActionObject = SlvDataPager(objLName)
CASE  "SLVDIALOG"  Set IActionObject = SlvDialog(objLName)
CASE  "SLVEDIT"  Set IActionObject = SlvEdit(objLName)
CASE  "SLVEXPANDER"  Set IActionObject = SlvExpander(objLName)
CASE  "SLVLINK"  Set IActionObject = SlvLink(objLName)
CASE  "SLVLIST"  Set IActionObject = SlvList(objLName)
CASE  "SLVOBJECT"  Set IActionObject = SlvObject(objLName)
CASE  "SLVPAGE"  Set IActionObject = SlvPage(objLName)
CASE  "SLVPROGRESSBAR"  Set IActionObject = SlvProgressBar(objLName)
CASE  "SLVRADIOBUTTON"  Set IActionObject = SlvRadioButton(objLName)
CASE  "SLVSCROLLBAR"  Set IActionObject = SlvScrollBar(objLName)
CASE  "SLVSLIDER"  Set IActionObject = SlvSlider(objLName)
CASE  "SLVTABLE"  Set IActionObject = SlvTable(objLName)
CASE  "SLVTABSTRIP"  Set IActionObject = SlvTabStrip(objLName)
CASE  "SLVTOGGLEBUTTON"  Set IActionObject = SlvToggleButton(objLName)
CASE  "SLVTREEVIEW"  Set IActionObject = SlvTreeView(objLName)
CASE  "SLVWINDOW"  Set IActionObject = SlvWindow(objLName)
CASE  "WBFCALENDAR"  Set IActionObject = WbfCalendar(objLName)
CASE  "WBFGRID"  Set IActionObject = WbfGrid(objLName)
CASE  "WBFTABSTRIP"  Set IActionObject = WbfTabStrip(objLName)
CASE  "WBFTOOLBAR"  Set IActionObject = WbfToolbar(objLName)
CASE  "WBFTREEVIEW"  Set IActionObject = WbfTreeView(objLName)
CASE  "WBFULTRAGRID"  Set IActionObject = WbfUltraGrid(objLName)
CASE  "SWFBUTTON"  Set IActionObject = SwfButton(objLName)
CASE  "SWFCALENDAR"  Set IActionObject = SwfCalendar(objLName)
CASE  "SWFCHECKBOX"  Set IActionObject = SwfCheckBox(objLName)
CASE  "SWFCOMBOBOX"  Set IActionObject = SwfComboBox(objLName)
CASE  "SWFEDIT"  Set IActionObject = SwfEdit(objLName)
CASE  "SWFEDITOR"  Set IActionObject = SwfEditor(objLName)
CASE  "SWFLABEL"  Set IActionObject = SwfLabel(objLName)
CASE  "SWFLIST"  Set IActionObject = SwfList(objLName)
CASE  "SWFLISTVIEW"  Set IActionObject = SwfListView(objLName)
CASE  "SWFOBJECT"  Set IActionObject = SwfObject(objLName)
CASE  "SWFPROPERTYGRID"  Set IActionObject = SwfPropertyGrid(objLName)
CASE  "SWFRADIOBUTTON"  Set IActionObject = SwfRadioButton(objLName)
CASE  "SWFSCROLLBAR"  Set IActionObject = SwfScrollBar(objLName)
CASE  "SWFSPIN"  Set IActionObject = SwfSpin(objLName)
CASE  "SWFSTATUSBAR"  Set IActionObject = SwfStatusBar(objLName)
CASE  "SWFTAB"  Set IActionObject = SwfTab(objLName)
CASE  "SWFTABLE"  Set IActionObject = SwfTable(objLName)
CASE  "SWFTOOLBAR"  Set IActionObject = SwfToolBar(objLName)
CASE  "SWFTREEVIEW"  Set IActionObject = SwfTreeView(objLName)
CASE  "SWFWINDOW"  Set IActionObject = SwfWindow(objLName)
CASE  "WPFBUTTON"  Set IActionObject = WpfButton(objLName)
CASE  "WPFCHECKBOX"  Set IActionObject = WpfCheckBox(objLName)
CASE  "WPFCOMBOBOX"  Set IActionObject = WpfComboBox(objLName)
CASE  "WPFEDIT"  Set IActionObject = WpfEdit(objLName)
CASE  "WPFIMAGE"  Set IActionObject = WpfImage(objLName)
CASE  "WPFLINK"  Set IActionObject = WpfLink(objLName)
CASE  "WPFLIST"  Set IActionObject = WpfList(objLName)
CASE  "WPFMENU"  Set IActionObject = WpfMenu(objLName)
CASE  "WPFOBJECT"  Set IActionObject = WpfObject(objLName)
CASE  "WPFPROGRESSBAR"  Set IActionObject = WpfProgressBar(objLName)
CASE  "WPFRADIOBUTTON"  Set IActionObject = WpfRadioButton(objLName)
CASE  "WPFSCROLLBAR"  Set IActionObject = WpfScrollBar(objLName)
CASE  "WPFSLIDER"  Set IActionObject = WpfSlider(objLName)
CASE  "WPFSTATUSBAR"  Set IActionObject = WpfStatusBar(objLName)
CASE  "WPFTABLE"  Set IActionObject = WpfTable(objLName)
CASE  "WPFTABSTRIP"  Set IActionObject = WpfTabStrip(objLName)
CASE  "WPFTOOLBAR"  Set IActionObject = WpfToolbar(objLName)
CASE  "WPFTREEVIEW"  Set IActionObject = WpfTreeView(objLName)
CASE  "WPFWINDOW"  Set IActionObject = WpfWindow(objLName)
CASE  "ORACLEAPPLICATIONS"  Set IActionObject = OracleApplications(objLName)
CASE  "ORACLEBUTTON"  Set IActionObject = OracleButton(objLName)
CASE  "ORACLECALENDAR"  Set IActionObject = OracleCalendar(objLName)
CASE  "ORACLECHECKBOX"  Set IActionObject = OracleCheckbox(objLName)
CASE  "ORACLEFLEXWINDOW"  Set IActionObject = OracleFlexWindow(objLName)
CASE  "ORACLEFORMWINDOW"  Set IActionObject = OracleFormWindow(objLName)
CASE  "ORACLELIST"  Set IActionObject = OracleList(objLName)
CASE  "ORACLELISTOFVALUES"  Set IActionObject = OracleListOfValues(objLName)
CASE  "ORACLELOGON"  Set IActionObject = OracleLogon(objLName)
CASE  "ORACLENAVIGATOR"  Set IActionObject = OracleNavigator(objLName)
CASE  "ORACLENOTIFICATION"  Set IActionObject = OracleNotification(objLName)
CASE  "ORACLERADIOGROUP"  Set IActionObject = OracleRadioGroup(objLName)
CASE  "ORACLESTATUSLINE"  Set IActionObject = OracleStatusLine(objLName)
CASE  "ORACLETABBEDREGION"  Set IActionObject = OracleTabbedRegion(objLName)
CASE  "ORACLETABLE"  Set IActionObject = OracleTable(objLName)
CASE  "ORACLETEXTFIELD"  Set IActionObject = OracleTextField(objLName)
CASE  "ORACLETREE"  Set IActionObject = OracleTree(objLName)
CASE  "PSFRAME"  Set IActionObject = PSFrame(objLName)
CASE  "PBBUTTON"  Set IActionObject = PbButton(objLName)
CASE  "PBCHECKBOX"  Set IActionObject = PbCheckBox(objLName)
CASE  "PBCOMBOBOX"  Set IActionObject = PbComboBox(objLName)
CASE  "PBDATAWINDOW"  Set IActionObject = PbDataWindow(objLName)
CASE  "PBEDIT"  Set IActionObject = PbEdit(objLName)
CASE  "PBLIST"  Set IActionObject = PbList(objLName)
CASE  "PBLISTVIEW"  Set IActionObject = PbListView(objLName)
CASE  "PBOBJECT"  Set IActionObject = PbObject(objLName)
CASE  "PBRADIOBUTTON"  Set IActionObject = PbRadioButton(objLName)
CASE  "PBSCROLLBAR"  Set IActionObject = PbScrollBar(objLName)
CASE  "PBTABSTRIP"  Set IActionObject = PbTabStrip(objLName)
CASE  "PBTOOLBAR"  Set IActionObject = PbToolbar(objLName)
CASE  "PBTREEVIEW"  Set IActionObject = PbTreeView(objLName)
CASE  "PBWINDOW"  Set IActionObject = PbWindow(objLName)
CASE  "SAPBUTTON"  Set IActionObject = SAPButton(objLName)
CASE  "SAPCALENDAR"  Set IActionObject = SAPCalendar(objLName)
CASE  "SAPCHECKBOX"  Set IActionObject = SAPCheckBox(objLName)
CASE  "SAPDROPDOWNMENU"  Set IActionObject = SAPDropDownMenu(objLName)
CASE  "SAPEDIT"  Set IActionObject = SAPEdit(objLName)
CASE  "SAPFRAME"  Set IActionObject = SAPFrame(objLName)
CASE  "SAPIVIEW"  Set IActionObject = SAPiView(objLName)
CASE  "SAPLIST"  Set IActionObject = SAPList(objLName)
CASE  "SAPMENU"  Set IActionObject = SAPMenu(objLName)
CASE  "SAPNAVIGATIONBAR"  Set IActionObject = SAPNavigationBar(objLName)
CASE  "SAPOKCODE"  Set IActionObject = SAPOKCode(objLName)
CASE  "SAPPORTAL"  Set IActionObject = SAPPortal(objLName)
CASE  "SAPRADIOGROUP"  Set IActionObject = SAPRadioGroup(objLName)
CASE  "SAPSTATUSBAR"  Set IActionObject = SAPStatusBar(objLName)
CASE  "SAPTABLE"  Set IActionObject = SAPTable(objLName)
CASE  "SAPTABSTRIP"  Set IActionObject = SAPTabStrip(objLName)
CASE  "SAPTREEVIEW"  Set IActionObject = SAPTreeView(objLName)
CASE  "SAPGUIAPOGRID"  Set IActionObject = SAPGuiAPOGrid(objLName)
CASE  "SAPGUIBUTTON"  Set IActionObject = SAPGuiButton(objLName)
CASE  "SAPGUICALENDAR"  Set IActionObject = SAPGuiCalendar(objLName)
CASE  "SAPGUICHECKBOX"  Set IActionObject = SAPGuiCheckBox(objLName)
CASE  "SAPGUICOMBOBOX"  Set IActionObject = SAPGuiComboBox(objLName)
CASE  "SAPGUIEDIT"  Set IActionObject = SAPGuiEdit(objLName)
CASE  "SAPGUIELEMENT"  Set IActionObject = SAPGuiElement(objLName)
CASE  "SAPGUIGRID"  Set IActionObject = SAPGuiGrid(objLName)
CASE  "SAPGUILABEL"  Set IActionObject = SAPGuiLabel(objLName)
CASE  "SAPGUIMENUBAR"  Set IActionObject = SAPGuiMenubar(objLName)
CASE  "SAPGUIOKCODE"  Set IActionObject = SAPGuiOKCode(objLName)
CASE  "SAPGUIRADIOBUTTON"  Set IActionObject = SAPGuiRadioButton(objLName)
CASE  "SAPGUISESSION"  Set IActionObject = SAPGuiSession(objLName)
CASE  "SAPGUISTATUSBAR"  Set IActionObject = SAPGuiStatusBar(objLName)
CASE  "SAPGUITABLE"  Set IActionObject = SAPGuiTable(objLName)
CASE  "SAPGUITABSTRIP"  Set IActionObject = SAPGuiTabStrip(objLName)
CASE  "SAPGUITEXTAREA"  Set IActionObject = SAPGuiTextArea(objLName)
CASE  "SAPGUITOOLBAR"  Set IActionObject = SAPGuiToolbar(objLName)
CASE  "SAPGUITREE"  Set IActionObject = SAPGuiTree(objLName)
CASE  "SAPGUIUTIL"  Set IActionObject = SAPGuiUtil(objLName)
CASE  "SAPGUIWINDOW"  Set IActionObject = SAPGuiWindow(objLName)
CASE  "SBLADVANCEDEDIT"  Set IActionObject = SblAdvancedEdit(objLName)
CASE  "SBLBUTTON"  Set IActionObject = SblButton(objLName)
CASE  "SBLCHECKBOX"  Set IActionObject = SblCheckBox(objLName)
CASE  "SBLEDIT"  Set IActionObject = SblEdit(objLName)
CASE  "SBLPICKLIST"  Set IActionObject = SblPickList(objLName)
CASE  "SBLTABLE"  Set IActionObject = SblTable(objLName)
CASE  "SBLTABSTRIP"  Set IActionObject = SblTabStrip(objLName)
CASE  "SBLTREEVIEW"  Set IActionObject = SblTreeView(objLName)
CASE  "SIEBAPPLET"  Set IActionObject = SiebApplet(objLName)
CASE  "SIEBAPPLICATION"  Set IActionObject = SiebApplication(objLName)
CASE  "SIEBBUTTON"  Set IActionObject = SiebButton(objLName)
CASE  "SIEBCALCULATOR"  Set IActionObject = SiebCalculator(objLName)
CASE  "SIEBCALENDAR"  Set IActionObject = SiebCalendar(objLName)
CASE  "SIEBCHECKBOX"  Set IActionObject = SiebCheckbox(objLName)
CASE  "SIEBCOMMUNICATIONSTOOLBAR"  Set IActionObject = SiebCommunicationsToolbar(objLName)
CASE  "SIEBCURRENCY"  Set IActionObject = SiebCurrency(objLName)
CASE  "SIEBINKDATA"  Set IActionObject = SiebInkData(objLName)
CASE  "SIEBLIST"  Set IActionObject = SiebList(objLName)
CASE  "SIEBMENU"  Set IActionObject = SiebMenu(objLName)
CASE  "SIEBPAGETABS"  Set IActionObject = SiebPageTabs(objLName)
CASE  "SIEBPDQ"  Set IActionObject = SiebPDQ(objLName)
CASE  "SIEBPICKLIST"  Set IActionObject = SiebPicklist(objLName)
CASE  "SIEBRICHTEXT"  Set IActionObject = SiebRichText(objLName)
CASE  "SIEBSCREEN"  Set IActionObject = SiebScreen(objLName)
CASE  "SIEBSCREENVIEWS"  Set IActionObject = SiebScreenViews(objLName)
CASE  "SIEBTASK"  Set IActionObject = SiebTask(objLName)
CASE  "SIEBTASKASSISTANT"  Set IActionObject = SiebTaskAssistant(objLName)
CASE  "SIEBTASKLINK"  Set IActionObject = SiebTaskLink(objLName)
CASE  "SIEBTASKSTEP"  Set IActionObject = SiebTaskStep(objLName)
CASE  "SIEBTASKUIPANE"  Set IActionObject = SiebTaskUIPane(objLName)
CASE  "SIEBTEXT"  Set IActionObject = SiebText(objLName)
CASE  "SIEBTEXTAREA"  Set IActionObject = SiebTextArea(objLName)
CASE  "SIEBTHREADBAR"  Set IActionObject = SiebThreadbar(objLName)
CASE  "SIEBTOOLBAR"  Set IActionObject = SiebToolbar(objLName)
CASE  "SIEBTREE"  Set IActionObject = SiebTree(objLName)
CASE  "SIEBVIEW"  Set IActionObject = SiebView(objLName)
CASE  "SIEBVIEWAPPLETS"  Set IActionObject = SiebViewApplets(objLName)
CASE  "DESKTOP"  Set IActionObject = Desktop(objLName)
CASE  "DIALOG"  Set IActionObject = Dialog(objLName)
'CASE  "STATIC"  Set IActionObject = Static(objLName)
CASE  "SYSTEMUTIL"  Set IActionObject = SystemUtil(objLName)
CASE  "WINBUTTON"  Set IActionObject = WinButton(objLName)
CASE  "WINCALENDAR"  Set IActionObject = WinCalendar(objLName)
CASE  "WINCHECKBOX"  Set IActionObject = WinCheckBox(objLName)
CASE  "WINCOMBOBOX"  Set IActionObject = WinComboBox(objLName)
CASE  "WINDOW"  Set IActionObject = Window(objLName)
CASE  "WINEDIT"  Set IActionObject = WinEdit(objLName)
CASE  "WINEDITOR"  Set IActionObject = WinEditor(objLName)
CASE  "WINLIST"  Set IActionObject = WinList(objLName)
CASE  "WINLISTVIEW"  Set IActionObject = WinListView(objLName)
CASE  "WINMENU"  Set IActionObject = WinMenu(objLName)
CASE  "WINOBJECT"  Set IActionObject = WinObject(objLName)
CASE  "WINRADIOBUTTON"  Set IActionObject = WinRadioButton(objLName)
CASE  "WINSCROLLBAR"  Set IActionObject = WinScrollBar(objLName)
CASE  "WINSPIN"  Set IActionObject = WinSpin(objLName)
CASE  "WINSTATUSBAR"  Set IActionObject = WinStatusBar(objLName)
CASE  "WINTAB"  Set IActionObject = WinTab(objLName)
CASE  "WINTOOLBAR"  Set IActionObject = WinToolbar(objLName)
CASE  "WINTREEVIEW"  Set IActionObject = WinTreeView(objLName)
CASE  "WINTAB"  Set IActionObject = WinTab(objLName)
CASE  "WINTABLE"  Set IActionObject = WinTable(objLName)
CASE  "WINTOOLBAR"  Set IActionObject = WinToolbar(objLName)
CASE  "WINTREEVIEW"  Set IActionObject = WinTreeView(objLName)
CASE  "TEFIELD"  Set IActionObject = TeField(objLName)
CASE  "TESCREEN"  Set IActionObject = TeScreen(objLName)
CASE  "TETEXTSCREEN"  Set IActionObject = TeTextScreen(objLName)
CASE  "TEWINDOW"  Set IActionObject = TeWindow(objLName)
'CASE  "WDWTEWINDOW" Set IActionObject = IActionObject.TeWindow(objLName)
CASE  "VBBUTTON"  Set IActionObject = VbButton(objLName)
CASE  "VBCHECKBOX"  Set IActionObject = VbCheckBox(objLName)
CASE  "VBCOMBOBOX"  Set IActionObject = VbComboBox(objLName)
CASE  "VBEDIT"  Set IActionObject = VbEdit(objLName)
CASE  "VBEDITOR"  Set IActionObject = VbEditor(objLName)
CASE  "VBFRAME"  Set IActionObject = VbFrame(objLName)
CASE  "VBLABEL"  Set IActionObject = VbLabel(objLName)
CASE  "VBLIST"  Set IActionObject = VbList(objLName)
CASE  "VBLISTVIEW"  Set IActionObject = VbListView(objLName)
CASE  "VBRADIOBUTTON"  Set IActionObject = VbRadioButton(objLName)
CASE  "VBSCROLLBAR"  Set IActionObject = VbScrollBar(objLName)
CASE  "VBTOOLBAR"  Set IActionObject = VbToolbar(objLName)
CASE  "VBTREEVIEW"  Set IActionObject = VbTreeView(objLName)
CASE  "VBWINDOW"  Set IActionObject = VbWindow(objLName)
CASE  "WINBUTTON"  Set IActionObject = WinButton(objLName)
CASE  "WINCHECKBOX"  Set IActionObject = WinCheckBox(objLName)
CASE  "WINEDIT"  Set IActionObject = WinEdit(objLName)
CASE  "WINEDITOR"  Set IActionObject = WinEditor(objLName)
CASE  "WINLIST"  Set IActionObject = WinList(objLName)
CASE  "WINOBJECT"  Set IActionObject = WinObject(objLName)
CASE  "WINRADIOBUTTON"  Set IActionObject = WinRadioButton(objLName)
CASE  "WINSPINBUTTON"  Set IActionObject = WinSpinButton(objLName)
CASE  "WINTAB"  Set IActionObject = WinTab(objLName)
CASE  "WINTABLE"  Set IActionObject = WinTable(objLName)
CASE  "WINTREEVIEW"  Set IActionObject = WinTreeView(objLName)
CASE  "BROWSER"  Set IActionObject = Browser(objLName)
CASE  "FRAME"  Set IActionObject = Frame(objLName)
CASE  "IMAGE"  Set IActionObject = Image(objLName)
CASE  "LINK"  Set IActionObject = Link(objLName)
CASE  "PAGE"  Set IActionObject = Page(objLName)
CASE  "VIEWLINK"  Set IActionObject = ViewLink(objLName)
CASE  "WEBAREA"  Set IActionObject = WebArea(objLName)
CASE  "WEBBUTTON"  Set IActionObject = WebButton(objLName)
CASE  "WEBCHECKBOX"  Set IActionObject = WebCheckBox(objLName)
CASE  "WEBEDIT"  Set IActionObject = WebEdit(objLName)
CASE  "WEBELEMENT"  Set IActionObject = WebElement(objLName)
CASE  "WEBFILE"  Set IActionObject = WebFile(objLName)
CASE  "WEBLIST"  Set IActionObject = WebList(objLName)
CASE  "WEBRADIOGROUP"  Set IActionObject = WebRadioGroup(objLName)
CASE  "WEBTABLE"  Set IActionObject = WebTable(objLName)
CASE  "WEBXML"  Set IActionObject = WebXML(objLName)
CASE  "ATTACHMENTS"  Set IActionObject = Attachments(objLName)
CASE  "CONFIGURATION"  Set IActionObject = Configuration(objLName)
CASE  "HEADERS"  Set IActionObject = headers(objLName)
CASE  "SECURITY"  Set IActionObject = Security(objLName)
CASE  "WEBSERVICE"  Set IActionObject = WebService(objLName)
CASE  "WSUTIL"  Set IActionObject = WSUtil(objLName)

'Vinay 
Case "VERIFYTETEXTNEGATIVE" Call fnVDoVerifyTETextNegative(actionObj,actionValue)
Case "VALIDATESURRENDERDATE" Call fnValidateSurrenderDate(actionObj)
Case "LOGININTOMAINFRAME_AND_ENTERINTOREGION" Call LoginIntoMainFrame_And_EnterIntoRegion ()
Case Else  IActionObject= NULL
End Select
'If NOt isnull(IActionObject) Then
'	IActionObject.Activate
'End If
End If
End Function




Function fnDoAction(actionName, actionTarget, actionValue)
On Error Resume Next
	Call mapORObjects(actionTarget)
	
	Set actionObj=IActionObject
	If instr(ucase(Err.description),"OBJECT REQUIRED")>0 Then
		Err.clear
	End If
If instr(ucase(actionName),"UDF_")>0 Then
Call fnUDFManager (actionName, actionObj, actionValue,TDDictObj,TestArgs("strOutPutFilePath"))
else
If  instr(ucase(actionName),"OPEN")>0 Then
	 actionObj = actionTarget
	 Select Case UCase(actionName)
	 Case "OPENEXE" Call fnVDoOpenEXE(actionValue)
     CASE "OPEN" Call fnVDoOpen(actionObj,actionValue)
	 Case Else strGblRes="Unknown Action Name (" & actionName &")"
	 End Select
Else
	
	strObjProp =""
    Select Case UCase(actionName)
		CASE "GETOBJPROP" Call fnvGetObjectProperty(actionObj,actionValue)
		'**********
		CASE "LOGIN_INTO_MAINFRAME" Call LoginIntoMainFrame(strMFUId,strMFPwd)
		'*********
        CASE "CAPTUREBITMAP" Call fnVDoCaptureBitmap(actionObj,actionValue)
		CASE "CHECK" Call fnVDoCheck(actionObj,actionValue)
		CASE "CHECKPROPERTY" Call fnVDoCheckProperty(actionObj,actionValue)
		CASE "CHILDOBJECTS" Call fnVDoChildObjects(actionObj,actionValue)
		CASE "CLICK" Call fnVDoClick(actionObj,actionValue)
		CASE "CLICKANDWAIT" Call fnVDoClickAndWait(actionObj,actionValue)
		CASE "DBLCLICK" Call fnVDoDblClick(actionObj,actionValue)
		CASE "DRAG" Call fnVDoDrag(actionObj,actionValue)
		CASE "DROP" Call fnVDoDrop(actionObj,actionValue)
		CASE "FIREEVENT" Call fnVDoFireEvent(actionObj,actionValue)
		CASE "GETROPROPERTY" Call fnVDoGetROProperty(actionObj,actionValue)
		CASE "GETTEXTLOCATION" Call fnVDoGetTextLocation(actionObj,actionValue)
		CASE "GETTOPROPERTIES" Call fnVDoGetTOProperties(actionObj,actionValue)
		CASE "GETTOPROPERTY" Call fnVDoGetTOProperty(actionObj,actionValue)
		CASE "GETVISIBLETEXT" Call fnVDoGetVisibleText(actionObj,actionValue)
		CASE "MAKEVISIBLE" Call fnVDoMakeVisible(actionObj,actionValue)
		CASE "MOUSEMOVE" Call fnVDoMouseMove(actionObj,actionValue)
		CASE "OUTPUT" Call fnVDoOutput(actionObj,actionValue)
		CASE "REFRESHOBJECT" Call fnVDoRefreshObject(actionObj,actionValue)
		CASE "SETTOPROPERTY" Call fnVDoSetTOProperty(actionObj,actionValue)
		CASE "TOSTRING" Call fnVDoToString(actionObj,actionValue)
		CASE "TYPE" Call fnVDoType(actionObj,actionValue)
		CASE "WAITPROPERTY" Call fnVDoWaitProperty(actionObj,actionValue)
		CASE "SETDATE" Call fnVDoSetDate(actionObj,actionValue)
		CASE "SETDATERANGE" Call fnVDoSetDateRange(actionObj,actionValue)
		CASE "SETTIME" Call fnVDoSetTime(actionObj,actionValue)
		CASE "SET" Call fnVDoSet(actionObj,actionValue)
		CASE "GETCONTENT" Call fnVDoGetContent(actionObj,actionValue)
		CASE "GETITEM" Call fnVDoGetItem(actionObj,actionValue)
		CASE "GETITEMSCOUNT" Call fnVDoGetItemsCount(actionObj,actionValue)
		CASE "GETSELECTION" Call fnVDoGetSelection(actionObj,actionValue)
		CASE "SELECT" Call fnVDoSelect(actionObj,actionValue)
		CASE "SETCARETPOS" Call fnVDoSetCaretPos(actionObj,actionValue)
		CASE "SETSECURE" Call fnVDoSetSecure(actionObj,actionValue)
		CASE "SETSELECTION" Call fnVDoSetSelection(actionObj,actionValue)
		CASE "ACTIVATECELL" Call fnVDoActivateCell(actionObj,actionValue)
		CASE "ACTIVATECOLUMN" Call fnVDoActivateColumn(actionObj,actionValue)
		CASE "ACTIVATEROW" Call fnVDoActivateRow(actionObj,actionValue)
		CASE "GETCELLDATA" Call fnVDoGetCellData(actionObj,actionValue)
		CASE "MAKECELLVISIBLE" Call fnVDoMakeCellVisible(actionObj,actionValue)
		CASE "SELECTCELL" Call fnVDoSelectCell(actionObj,actionValue)
		CASE "SELECTCOLUMN" Call fnVDoSelectColumn(actionObj,actionValue)
		CASE "SELECTROW" Call fnVDoSelectRow(actionObj,actionValue)
		CASE "SETCELLDATA" Call fnVDoSetCellData(actionObj,actionValue)
		CASE "COLUMNCOUNT" Call fnVDoColumnCount(actionObj,actionValue)
		CASE "EXIST" Call fnVDoExist(actionObj,actionValue)
		CASE "OBJECT" Call fnVDoObject(actionObj,actionValue)
		CASE "ROWCOUNT" Call fnVDoRowCount(actionObj,actionValue)
		CASE "SETROPROPERTY" Call fnVDoSetROProperty(actionObj,actionValue)
		CASE "ACTIVATE" Call fnVDoActivate(actionObj,actionValue)
		CASE "CHECKITEMPROPERTY" Call fnVDoCheckItemProperty(actionObj,actionValue)
		CASE "DESELECT" Call fnVDoDeselect(actionObj,actionValue)
		CASE "EXTENDSELECT" Call fnVDoExtendSelect(actionObj,actionValue)
		CASE "GETITEMPROPERTY" Call fnVDoGetItemProperty(actionObj,actionValue)
		CASE "SELECTRANGE" Call fnVDoSelectRange(actionObj,actionValue)
		CASE "WAITITEMPROPERTY" Call fnVDoWaitItemProperty(actionObj,actionValue)
		CASE "DRAGITEM" Call fnVDoDragItem(actionObj,actionValue)
		CASE "DROPONITEM" Call fnVDoDropOnItem(actionObj,actionValue)
		CASE "EDITLABEL" Call fnVDoEditLabel(actionObj,actionValue)
		CASE "GETCHECKMARKS" Call fnVDoGetCheckMarks(actionObj,actionValue)
		CASE "GETCOLUMNHEADER" Call fnVDoGetColumnHeader(actionObj,actionValue)
		CASE "GETSUBITEM" Call fnVDoGetSubItem(actionObj,actionValue)
		CASE "SETITEMSTATE" Call fnVDoSetItemState(actionObj,actionValue)
		CASE "CLICKCANCEL" Call fnVDoClickCancel(actionObj,actionValue)
		CASE "CLICKDELETE" Call fnVDoClickDelete(actionObj,actionValue)
		CASE "CLICKEDIT" Call fnVDoClickEdit(actionObj,actionValue)
		CASE "CLICKFIRST" Call fnVDoClickFirst(actionObj,actionValue)
		CASE "CLICKINSERT" Call fnVDoClickInsert(actionObj,actionValue)
		CASE "CLICKLAST" Call fnVDoClickLast(actionObj,actionValue)
		CASE "CLICKNEXT" Call fnVDoClickNext(actionObj,actionValue)
		CASE "CLICKPOST" Call fnVDoClickPost(actionObj,actionValue)
		CASE "CLICKPRIOR" Call fnVDoClickPrior(actionObj,actionValue)
		CASE "CLICKREFRESH" Call fnVDoClickRefresh(actionObj,actionValue)
		CASE "HSCROLL" Call fnVDoHScroll(actionObj,actionValue)
		CASE "VSCROLL" Call fnVDoVScroll(actionObj,actionValue)
		CASE "NEXTLINE" Call fnVDoNextLine(actionObj,actionValue)
		CASE "NEXTPAGE" Call fnVDoNextPage(actionObj,actionValue)
		CASE "PREVLINE" Call fnVDoPrevLine(actionObj,actionValue)
		CASE "PREVPAGE" Call fnVDoPrevPage(actionObj,actionValue)
		CASE "NEXT" Call fnVDoNext(actionObj,actionValue)
		CASE "PREV" Call fnVDoPrev(actionObj,actionValue)
		CASE "COLLAPSE" Call fnVDoCollapse(actionObj,actionValue)
		CASE "EXPAND" Call fnVDoExpand(actionObj,actionValue)
		CASE "EXPANDALL" Call fnVDoExpandAll(actionObj,actionValue)
		CASE "CLOSE" Call fnVDoClose(actionObj,actionValue)
		CASE "MAXIMIZE" Call fnVDoMaximize(actionObj,actionValue)
		CASE "MINIMIZE" Call fnVDoMinimize(actionObj,actionValue)
		CASE "MOVE" Call fnVDoMove(actionObj,actionValue)
		CASE "RESIZE" Call fnVDoResize(actionObj,actionValue)
		CASE "RESTORE" Call fnVDoRestore(actionObj,actionValue)
		CASE "CREATEOBJECT" Call fnVDoCreateObject(actionObj,actionValue)
		CASE "FIREEVENTEX" Call fnVDoFireEventEx(actionObj,actionValue)
		CASE "GETSTATICS" Call fnVDoGetStatics(actionObj,actionValue)
		CASE "MOUSEDRAG" Call fnVDoMouseDrag(actionObj,actionValue)
		CASE "PRESSKEY" Call fnVDoPressKey(actionObj,actionValue)
		CASE "CLICKLINK" Call fnVDoClickLink(actionObj,actionValue)
		CASE "DELETE" Call fnVDoDelete(actionObj,actionValue)
		CASE "INSERT" Call fnVDoInsert(actionObj,actionValue)
		CASE "REPLACE" Call fnVDoReplace(actionObj,actionValue)
		CASE "REPLACESPECIALCHAR" Call fnVDoReplaceSpecialChar(actionObj,actionValue)
		CASE "SETFOCUS" Call fnVDoSetFocus(actionObj,actionValue)
		CASE "ADDRANGE" Call fnVDoAddRange(actionObj,actionValue)
		CASE "DESELECTRANGE" Call fnVDoDeselectRange(actionObj,actionValue)
		CASE "GETITEMINDEX" Call fnVDoGetItemIndex(actionObj,actionValue)
		CASE "DRAGFROMSTART" Call fnVDoDragFromStart(actionObj,actionValue)
		CASE "DRAGLINE" Call fnVDoDragLine(actionObj,actionValue)
		CASE "DRAGPAGE" Call fnVDoDragPage(actionObj,actionValue)
		CASE "CLOSETAB" Call fnVDoCloseTab(actionObj,actionValue)
		CASE "CLICKCELL" Call fnVDoClickCell(actionObj,actionValue)
		CASE "DESELECTCOLUMN" Call fnVDoDeselectColumn(actionObj,actionValue)
		CASE "DESELECTCOLUMNSRANGE" Call fnVDoDeselectColumnsRange(actionObj,actionValue)
		CASE "DESELECTROW" Call fnVDoDeselectRow(actionObj,actionValue)
		CASE "DESELECTROWSRANGE" Call fnVDoDeselectRowsRange(actionObj,actionValue)
		CASE "DOUBLECLICKCELL" Call fnVDoDoubleClickCell(actionObj,actionValue)
		CASE "EXTENDCOLUMN" Call fnVDoExtendColumn(actionObj,actionValue)
		CASE "EXTENDCOLUMNSRANGE" Call fnVDoExtendColumnsRange(actionObj,actionValue)
		CASE "EXTENDROW" Call fnVDoExtendRow(actionObj,actionValue)
		CASE "EXTENDROWSRANGE" Call fnVDoExtendRowsRange(actionObj,actionValue)
		CASE "GETCOLUMNNAME" Call fnVDoGetColumnName(actionObj,actionValue)
		CASE "SELECTCELLSRANGE" Call fnVDoSelectCellsRange(actionObj,actionValue)
		CASE "SELECTCOLUMNHEADER" Call fnVDoSelectColumnHeader(actionObj,actionValue)
		CASE "SELECTCOLUMNSRANGE" Call fnVDoSelectColumnsRange(actionObj,actionValue)
		CASE "SELECTROWSRANGE" Call fnVDoSelectRowsRange(actionObj,actionValue)
		CASE "PRESS" Call fnVDoPress(actionObj,actionValue)
		CASE "SHOWDROPDOWN" Call fnVDoShowDropdown(actionObj,actionValue)
		CASE "GETCOLUMNVALUE" Call fnVDoGetColumnValue(actionObj,actionValue)
		CASE "OPENCONTEXTMENU" Call fnVDoOpenContextMenu(actionObj,actionValue)
		CASE "GETEXPANDEDITEMS" Call fnVDoGetExpandedItems(actionObj,actionValue)
		CASE "GETITEMCHILDOBJECTS" Call fnVDoGetItemChildObjects(actionObj,actionValue)
		CASE "SHOWCONTEXTMENU" Call fnVDoShowContextMenu(actionObj,actionValue)
		CASE "SETMONTH" Call fnVDoSetMonth(actionObj,actionValue)
		CASE "SETYEAR" Call fnVDoSetYear(actionObj,actionValue)
		CASE "DATE" Call fnVDoDate(actionObj,actionValue)
		CASE "DATERANGE" Call fnVDoDateRange(actionObj,actionValue)
		CASE "DESCRIPTIONVALUE" Call fnVDoDescriptionValue(actionObj,actionValue)
		CASE "ISVALID" Call fnVDoIsValid(actionObj,actionValue)
		CASE "FIRST" Call fnVDoFirst(actionObj,actionValue)
		CASE "LAST" Call fnVDoLast(actionObj,actionValue)
		CASE "PREVIOUS" Call fnVDoPrevious(actionObj,actionValue)
		CASE "SETPAGE" Call fnVDoSetPage(actionObj,actionValue)
		CASE "CURRENTPAGEINDEX" Call fnVDoCurrentPageIndex(actionObj,actionValue)
		CASE "DISPLAYMODE" Call fnVDoDisplayMode(actionObj,actionValue)
		CASE "PAGECOUNT" Call fnVDoPageCount(actionObj,actionValue)
		CASE "SETMULTILINECARETPOS" Call fnVDoSetMultiLineCaretPos(actionObj,actionValue)
		CASE "SETMULTILINESELECTION" Call fnVDoSetMultiLineSelection(actionObj,actionValue)
		CASE "SETSINGLELINECARETPOS" Call fnVDoSetSingleLineCaretPos(actionObj,actionValue)
		CASE "SETSINGLELINESELECTION" Call fnVDoSetSingleLineSelection(actionObj,actionValue)
		CASE "EXTENDSELECTROW" Call fnVDoExtendSelectRow(actionObj,actionValue)
		CASE "GETCELLPROPERTY" Call fnVDoGetCellProperty(actionObj,actionValue)
		CASE "MIDDLECLICK" Call fnVDoMiddleClick(actionObj,actionValue)
		CASE "RIGHTCLICK" Call fnVDoRightClick(actionObj,actionValue)
		CASE "SETWEEK" Call fnVDoSetWeek(actionObj,actionValue)
		CASE "SHOWDATE" Call fnVDoShowDate(actionObj,actionValue)
		CASE "SHOWNEXTMONTH" Call fnVDoShowNextMonth(actionObj,actionValue)
		CASE "SHOWPREVIOUSMONTH" Call fnVDoShowPreviousMonth(actionObj,actionValue)
		CASE "SUBMIT" Call fnVDoSubmit(actionObj,actionValue)
		CASE "CHILDITEM" Call fnVDoChildItem(actionObj,actionValue)
		CASE "CHILDITEMCOUNT" Call fnVDoChildItemCount(actionObj,actionValue)
		CASE "ADDROW" Call fnVDoAddRow(actionObj,actionValue)
		CASE "COLLAPSEROW" Call fnVDoCollapseRow(actionObj,actionValue)
		CASE "DELETEROW" Call fnVDoDeleteRow(actionObj,actionValue)
		CASE "EXPANDROW" Call fnVDoExpandRow(actionObj,actionValue)
		CASE "GROUPROWS" Call fnVDoGroupRows(actionObj,actionValue)
		CASE "SORT" Call fnVDoSort(actionObj,actionValue)
		CASE "GETERRORPROVIDERTEXT" Call fnVDoGetErrorProviderText(actionObj,actionValue)
		CASE "GETVALUE" Call fnVDoGetValue(actionObj,actionValue)
		CASE "SELECTPROPERTY" Call fnVDoSelectProperty(actionObj,actionValue)
		CASE "SETVALUE" Call fnVDoSetValue(actionObj,actionValue)
		CASE "BACK" Call fnVDoBack(actionObj,actionValue)
		CASE "GROUPBY" Call fnVDoGroupBy(actionObj,actionValue)
		CASE "HIDEPARENTROW" Call fnVDoHideParentRow(actionObj,actionValue)
		CASE "OPENCELLELEMENT" Call fnVDoOpenCellElement(actionObj,actionValue)
		CASE "OPENCELLRELATION" Call fnVDoOpenCellRelation(actionObj,actionValue)
		CASE "OPENSUMMARYDLG" Call fnVDoOpenSummaryDlg(actionObj,actionValue)
		CASE "SETFILTER" Call fnVDoSetFilter(actionObj,actionValue)
		CASE "SETVIEW" Call fnVDoSetView(actionObj,actionValue)
		CASE "SHOWPARENTROW" Call fnVDoShowParentRow(actionObj,actionValue)
		CASE "ISITEMENABLED" Call fnVDoIsItemEnabled(actionObj,actionValue)
		CASE "ITEMEXISTS" Call fnVDoItemExists(actionObj,actionValue)
		CASE "AUTOMATIONELEMENT" Call fnVDoAutomationElement(actionObj,actionValue)
		CASE "AUTOMATIONPATTERN" Call fnVDoAutomationPattern(actionObj,actionValue)
		CASE "SUPPORTEDPATTERNS" Call fnVDoSupportedPatterns(actionObj,actionValue)
		CASE "SUPPORTSTEXTSELECTION" Call fnVDoSupportsTextSelection(actionObj,actionValue)
		CASE "MAXIMUM" Call fnVDoMaximum(actionObj,actionValue)
		CASE "MINIMUM" Call fnVDoMinimum(actionObj,actionValue)
		CASE "VALUE" Call fnVDoValue(actionObj,actionValue)
		CASE "SHOWOVERFLOW" Call fnVDoShowOverflow(actionObj,actionValue)
		CASE "EXIT" Call fnVDoExit(actionObj,actionValue)
		CASE "GETACTIVEWINDOW" Call fnVDoGetActiveWindow(actionObj,actionValue)
		CASE "INVOKESOFTKEY" Call fnVDoInvokeSoftkey(actionObj,actionValue)
		CASE "SELECTPOPUPMENU" Call fnVDoSelectPopupMenu(actionObj,actionValue)
		CASE "SYNC" Call fnVDoSync(actionObj,actionValue)
		CASE "CANCEL" Call fnVDoCancel(actionObj,actionValue)
		CASE "ENTER" Call fnVDoEnter(actionObj,actionValue)
		CASE "CLEAR" Call fnVDoClear(actionObj,actionValue)
		CASE "ISSELECTED" Call fnVDoIsSelected(actionObj,actionValue)
		CASE "VERIFYCLEARED" Call fnVDoVerifyCleared(actionObj,actionValue)
		CASE "VERIFYSELECTED" Call fnVDoVerifySelected(actionObj,actionValue)
		CASE "APPROVE" Call fnVDoApprove(actionObj,actionValue)
		CASE "HELP" Call fnVDoHelp(actionObj,actionValue)
		CASE "SHOWCOMBINATIONS" Call fnVDoShowCombinations(actionObj,actionValue)
		CASE "CLOSEFORM" Call fnVDoCloseForm(actionObj,actionValue)
		CASE "CLOSEWINDOW" Call fnVDoCloseWindow(actionObj,actionValue)
		CASE "PRESSTOOLBARBUTTON" Call fnVDoPressToolbarButton(actionObj,actionValue)
		CASE "SAVE" Call fnVDoSave(actionObj,actionValue)
		CASE "SELECTMENU" Call fnVDoSelectMenu(actionObj,actionValue)
		CASE "ISITEMINLIST" Call fnVDoIsItemInList(actionObj,actionValue)
		CASE "FIND" Call fnVDoFind(actionObj,actionValue)
		CASE "LOGON" Call fnVDoLogon(actionObj,actionValue)
		CASE "SELECTFUNCTION" Call fnVDoSelectFunction(actionObj,actionValue)
		CASE "CHOOSE" Call fnVDoChoose(actionObj,actionValue)
		CASE "CHOOSEDEFAULT" Call fnVDoChooseDefault(actionObj,actionValue)
		CASE "DECLINE" Call fnVDoDecline(actionObj,actionValue)
		CASE "VERIFYMESSAGE" Call fnVDoVerifyMessage(actionObj,actionValue)
		CASE "VERIFYERRORCODE" Call fnVDoVerifyErrorCode(actionObj,actionValue)
		CASE "ACTIVATERECORD" Call fnVDoActivateRecord(actionObj,actionValue)
		CASE "ENTERFIELD" Call fnVDoEnterField(actionObj,actionValue)
		CASE "GETFIELDITEM" Call fnVDoGetFieldItem(actionObj,actionValue)
		CASE "GETFIELDVALUE" Call fnVDoGetFieldValue(actionObj,actionValue)
		CASE "ISFIELDEDITABLE" Call fnVDoIsFieldEditable(actionObj,actionValue)
		CASE "OPENDIALOG" Call fnVDoOpenDialog(actionObj,actionValue)
		CASE "VERIFYFIELD" Call fnVDoVerifyField(actionObj,actionValue)
		CASE "VALIDATE" Call fnVDoValidate(actionObj,actionValue)
		CASE "VERIFY" Call fnVDoVerify(actionObj,actionValue)
		CASE "RUNSCRIPT" Call fnVDoRunScript(actionObj,actionValue)
		CASE "RUNSCRIPTFROMFILE" Call fnVDoRunScriptFromFile(actionObj,actionValue)
		CASE "DESCRIBE" Call fnVDoDescribe(actionObj,actionValue)
		CASE "SELECTMENUITEM" Call fnVDoSelectMenuItem(actionObj,actionValue)
		CASE "OPENPOSSIBLEENTRIES" Call fnVDoOpenPossibleEntries(actionObj,actionValue)
		CASE "HIDE" Call fnVDoHide(actionObj,actionValue)
		CASE "RELATE" Call fnVDoRelate(actionObj,actionValue)
		CASE "SHOW" Call fnVDoShow(actionObj,actionValue)
		CASE "DETAILEDNAVIGATION" Call fnVDoDetailedNavigation(actionObj,actionValue)
		CASE "SEARCH" Call fnVDoSearch(actionObj,actionValue)
		CASE "FINDROWBYCELLCONTENT" Call fnVDoFindRowByCellContent(actionObj,actionValue)
		CASE "SELECTITEMINCELL" Call fnVDoSelectItemInCell(actionObj,actionValue)
		CASE "CLEARSELECTION" Call fnVDoClearSelection(actionObj,actionValue)
		CASE "DESELECTCELL" Call fnVDoDeselectCell(actionObj,actionValue)
		CASE "EXTENDCELL" Call fnVDoExtendCell(actionObj,actionValue)
		CASE "FINDALLROWSBYCELLCONTENT" Call fnVDoFindAllRowsByCellContent(actionObj,actionValue)
		CASE "GETCELLFORMAT" Call fnVDoGetCellFormat(actionObj,actionValue)
		CASE "INPUT" Call fnVDoInput(actionObj,actionValue)
		CASE "ISCELLEDITABLE" Call fnVDoIsCellEditable(actionObj,actionValue)
		CASE "PRESSENTER" Call fnVDoPressEnter(actionObj,actionValue)
		CASE "SELECTALL" Call fnVDoSelectAll(actionObj,actionValue)
		CASE "SELECTCELLMENUITEM" Call fnVDoSelectCellMenuItem(actionObj,actionValue)
		CASE "SELECTCOLUMNMENUITEM" Call fnVDoSelectColumnMenuItem(actionObj,actionValue)
		CASE "SELECTKEY" Call fnVDoSelectKey(actionObj,actionValue)
		CASE "SELECTMENUITEMBYID" Call fnVDoSelectMenuItemById(actionObj,actionValue)
		CASE "SETCHECKBOX" Call fnVDoSetCheckbox(actionObj,actionValue)
		CASE "CREATESESSION" Call fnVDoCreateSession(actionObj,actionValue)
		CASE "RESET" Call fnVDoReset(actionObj,actionValue)
		CASE "GETCELLLENGTH" Call fnVDoGetCellLength(actionObj,actionValue)
		CASE "PRESSSETTINGSBUTTON" Call fnVDoPressSettingsButton(actionObj,actionValue)
		CASE "SELECTALLCOLUMNS" Call fnVDoSelectAllColumns(actionObj,actionValue)
		CASE "VALIDROW" Call fnVDoValidRow(actionObj,actionValue)
		CASE "DOUBLECLICK" Call fnVDoDoubleClick(actionObj,actionValue)
		CASE "SETSELECTIONINDEXES" Call fnVDoSetSelectionIndexes(actionObj,actionValue)
		CASE "SETUNPROTECTEDTEXTPART" Call fnVDoSetUnprotectedTextPart(actionObj,actionValue)
		CASE "PRESSBUTTON" Call fnVDoPressButton(actionObj,actionValue)
		CASE "PRESSCONTEXTBUTTON" Call fnVDoPressContextButton(actionObj,actionValue)
		CASE "ACTIVATEITEM" Call fnVDoActivateItem(actionObj,actionValue)
		CASE "ACTIVATENODE" Call fnVDoActivateNode(actionObj,actionValue)
		CASE "CLICKBUTTON" Call fnVDoClickButton(actionObj,actionValue)
		CASE "CLICKCOLUMN" Call fnVDoClickColumn(actionObj,actionValue)
		CASE "EXTENDNODE" Call fnVDoExtendNode(actionObj,actionValue)
		CASE "OPENHEADERCONTEXTMENU" Call fnVDoOpenHeaderContextMenu(actionObj,actionValue)
		CASE "OPENITEMCONTEXTMENU" Call fnVDoOpenItemContextMenu(actionObj,actionValue)
		CASE "OPENNODECONTEXTMENU" Call fnVDoOpenNodeContextMenu(actionObj,actionValue)
		CASE "SELECTITEM" Call fnVDoSelectItem(actionObj,actionValue)
		CASE "SELECTNODE" Call fnVDoSelectNode(actionObj,actionValue)
		CASE "AUTOLOGON" Call fnVDoAutoLogon(actionObj,actionValue)
		CASE "AUTOLOGONBYIP" Call fnVDoAutoLogonByIP(actionObj,actionValue)
		CASE "CLOSECONNECTIONS" Call fnVDoCloseConnections(actionObj,actionValue)
		CASE "OPENCONNECTION" Call fnVDoOpenConnection(actionObj,actionValue)
		CASE "OPENCONNECTIONBYIP" Call fnVDoOpenConnectionByIP(actionObj,actionValue)
		CASE "HORIZONTALSCROLLBARPOSITION" Call fnVDoHorizontalScrollbarPosition(actionObj,actionValue)
		CASE "SENDKEY" Call fnVDoSendKey(actionObj,actionValue)
		CASE "SENDKEYOPT" Call fnVDoSendKeyOpt(actionObj,actionValue)
		CASE "VERTICALSCROLLBARPOSITION" Call fnVDoVerticalScrollbarPosition(actionObj,actionValue)
        CASE "COLUMNEXISTS" Call fnVDoColumnExists(actionObj,actionValue)
		CASE "DRILLDOWN" Call fnVDoDrillDown(actionObj,actionValue)
		CASE "ISCOLUMNWRITABLE" Call fnVDoIsColumnWritable(actionObj,actionValue)
		CASE "SCROLLROWS" Call fnVDoScrollRows(actionObj,actionValue)
		CASE "SORTDOWN" Call fnVDoSortDown(actionObj,actionValue)
		CASE "SORTUP" Call fnVDoSortUp(actionObj,actionValue)
		CASE "MOVELEFT" Call fnVDoMoveLeft(actionObj,actionValue)
		CASE "MOVERIGHT" Call fnVDoMoveRight(actionObj,actionValue)
		CASE "TABEXISTS" Call fnVDoTabExists(actionObj,actionValue)
		CASE "GETDIRECTCHILDREN" Call fnVDoGetDirectChildren(actionObj,actionValue)
		CASE "GETDIRECTCHILDRENCOUNT" Call fnVDoGetDirectChildrenCount(actionObj,actionValue)
		CASE "NODEEXISTS" Call fnVDoNodeExists(actionObj,actionValue)
		CASE "GETACTIVECONTROLNAME" Call fnVDoGetActiveControlName(actionObj,actionValue)
		CASE "GETCLASSCOUNT" Call fnVDoGetClassCount(actionObj,actionValue)
		CASE "GETREPOSITORYNAME" Call fnVDoGetRepositoryName(actionObj,actionValue)
		CASE "GETREPOSITORYNAMEBYINDEX" Call fnVDoGetRepositoryNameByIndex(actionObj,actionValue)
		CASE "ISCONTROLEXISTS" Call fnVDoIsControlExists(actionObj,actionValue)
		CASE "GETBUSYTIME" Call fnVDoGetBusyTime(actionObj,actionValue)
		CASE "GETLASTERRORCODE" Call fnVDoGetLastErrorCode(actionObj,actionValue)
		CASE "GETLASTERRORMESSAGE" Call fnVDoGetLastErrorMessage(actionObj,actionValue)
		CASE "GETLASTOPID" Call fnVDoGetLastOpId(actionObj,actionValue)
		CASE "GETLASTOPTIME" Call fnVDoGetLastOpTime(actionObj,actionValue)
		CASE "GETSESSIONID" Call fnVDoGetSessionId(actionObj,actionValue)
		CASE "GOTOSCREEN" Call fnVDoGotoScreen(actionObj,actionValue)
		CASE "GOTOVIEW" Call fnVDoGotoView(actionObj,actionValue)
		CASE "PROCESSKEYBOARDACCELERATOR" Call fnVDoProcessKeyboardAccelerator(actionObj,actionValue)
		CASE "SETTIMEOUT" Call fnVDoSetTimeOut(actionObj,actionValue)
		CASE "CLICKKEY" Call fnVDoClickKey(actionObj,actionValue)
		CASE "CLICKKEYS" Call fnVDoClickKeys(actionObj,actionValue)
		CASE "OPENPOPUP" Call fnVDoOpenPopup(actionObj,actionValue)
		CASE "SETTEXT" Call fnVDoSetText(actionObj,actionValue)
		Case "ADDRIDER" Call fnVDoAddRider(actionObj,actionValue)
		Case "SELECTRIDER" Call fnselectRider (actionObj, actionValue)
		CASE "SETTEXTOPT" Call fnVDoSetTextOpt(actionObj,actionValue)
		CASE "CANCELPOPUP" Call fnVDoCancelPopup(actionObj,actionValue)
		CASE "CLOSEPOPUP" Call fnVDoClosePopup(actionObj,actionValue)
		CASE "NEXTMONTH" Call fnVDoNextMonth(actionObj,actionValue)
		CASE "PREVMONTH" Call fnVDoPrevMonth(actionObj,actionValue)
		CASE "SELECTTIMEZONE" Call fnVDoSelectTimeZone(actionObj,actionValue)
		Case "VERIFYNAME" Call fnVerifyName(actionObj,actionValue)
		CASE "SETDAY" Call fnVDoSetDay(actionObj,actionValue)
		CASE "SETOFF" Call fnVDoSetOff(actionObj,actionValue)
		CASE "SETON" Call fnVDoSetOn(actionObj,actionValue)
		CASE "GETBUTTONSTATE" Call fnVDoGetButtonState(actionObj,actionValue)
		CASE "GETBUTTONTOOLTIP" Call fnVDoGetButtonTooltip(actionObj,actionValue)
		CASE "SELECTWORKITEM" Call fnVDoSelectWorkItem(actionObj,actionValue)
		CASE "SHOWBUTTONTOOLTIP" Call fnVDoShowButtonTooltip(actionObj,actionValue)
		CASE "AMOUNT" Call fnVDoAmount(actionObj,actionValue)
		CASE "CLASSNAME" Call fnVDoClassName(actionObj,actionValue)
		CASE "CURRENCYCODE" Call fnVDoCurrencyCode(actionObj,actionValue)
		CASE "EXCHANGEDATE" Call fnVDoExchangeDate(actionObj,actionValue)
		CASE "ISENABLED" Call fnVDoIsEnabled(actionObj,actionValue)
		CASE "ISOPEN" Call fnVDoIsOpen(actionObj,actionValue)
		CASE "ISREQUIRED" Call fnVDoIsRequired(actionObj,actionValue)
		CASE "REPOSITORYNAME" Call fnVDoRepositoryName(actionObj,actionValue)
		CASE "TEXT" Call fnVDoText(actionObj,actionValue)
		CASE "UINAME" Call fnVDoUIName(actionObj,actionValue)
		CASE "ASCENDSORT" Call fnVDoAscendSort(actionObj,actionValue)
		CASE "CLICKHIER" Call fnVDoClickHier(actionObj,actionValue)
		CASE "DESCENDSORT" Call fnVDoDescendSort(actionObj,actionValue)
		CASE "DRILLDOWNCOLUMN" Call fnVDoDrillDownColumn(actionObj,actionValue)
		CASE "FIRSTROWSET" Call fnVDoFirstRowSet(actionObj,actionValue)
		CASE "GETCELLTEXT" Call fnVDoGetCellText(actionObj,actionValue)
		CASE "GETCOLUMNREPOSITORYNAME" Call fnVDoGetColumnRepositoryName(actionObj,actionValue)
		CASE "GETCOLUMNREPOSITORYNAMEBYINDEX" Call fnVDoGetColumnRepositoryNameByIndex(actionObj,actionValue)
		CASE "GETCOLUMNSORT" Call fnVDoGetColumnSort(actionObj,actionValue)
		CASE "GETCOLUMNUINAME" Call fnVDoGetColumnUIName(actionObj,actionValue)
		CASE "GETTOTALSVALUE" Call fnVDoGetTotalsValue(actionObj,actionValue)
		CASE "ISCOLUMNDRILLDOWN" Call fnVDoIsColumnDrillDown(actionObj,actionValue)
		CASE "ISCOLUMNEXISTS" Call fnVDoIsColumnExists(actionObj,actionValue)
		CASE "ISROWEXPANDED" Call fnVDoIsRowExpanded(actionObj,actionValue)
		CASE "LASTROWSET" Call fnVDoLastRowSet(actionObj,actionValue)
		CASE "NEXTROW" Call fnVDoNextRow(actionObj,actionValue)
		CASE "NEXTROWSET" Call fnVDoNextRowSet(actionObj,actionValue)
		CASE "PREVIOUSROW" Call fnVDoPreviousRow(actionObj,actionValue)
		CASE "PREVIOUSROWSET" Call fnVDoPreviousRowSet(actionObj,actionValue)
		CASE "SETACTIVECONTROL" Call fnVDoSetActiveControl(actionObj,actionValue)
		CASE "GETUINAME" Call fnVDoGetUIName(actionObj,actionValue)
		CASE "ISEXISTS" Call fnVDoIsExists(actionObj,actionValue)
		CASE "GETITEMBYINDEX" Call fnVDoGetItemByIndex(actionObj,actionValue)
		CASE "PROCESSKEY" Call fnVDoProcessKey(actionObj,actionValue)
		CASE "ACTIVEITEM" Call fnVDoActiveItem(actionObj,actionValue)
		CASE "COUNT" Call fnVDoCount(actionObj,actionValue)
		CASE "GOTO" Call fnVDoGoto(actionObj,actionValue)
		CASE "DONE" Call fnVDoDone(actionObj,actionValue)
		CASE "START" Call fnVDoStart(actionObj,actionValue)
		CASE "STEP" Call fnVDoStep(actionObj,actionValue)
		CASE "STEPVIEW" Call fnVDoStepView(actionObj,actionValue)
		CASE "GETSTEPBYINDEX" Call fnVDoGetStepByIndex(actionObj,actionValue)
		CASE "GETTASKBYINDEX" Call fnVDoGetTaskByIndex(actionObj,actionValue)
		CASE "GOTOINBOX" Call fnVDoGotoInbox(actionObj,actionValue)
		CASE "GETTHREADITEMBYINDEX" Call fnVDoGetThreadItemByIndex(actionObj,actionValue)
		CASE "ISCONTROLENABLED" Call fnVDoIsControlEnabled(actionObj,actionValue)
		CASE "GETCHILDCOUNT" Call fnVDoGetChildCount(actionObj,actionValue)
		CASE "GETTREEITEMNAME" Call fnVDoGetTreeItemName(actionObj,actionValue)
		CASE "ISEXPANDED" Call fnVDoIsExpanded(actionObj,actionValue)
		CASE "PREVIOUSPAGE" Call fnVDoPreviousPage(actionObj,actionValue)
		CASE "GOTOAPPLET" Call fnVDoGotoApplet(actionObj,actionValue)
		CASE "RUNANALOG" Call fnVDoRunAnalog(actionObj,actionValue)
		CASE "BLOCKINPUT" Call fnVDoBlockInput(actionObj,actionValue)
		CASE "CLOSEDESCENDENTPROCESSES" Call fnVDoCloseDescendentProcesses(actionObj,actionValue)
		CASE "CLOSEPROCESSBYHWND" Call fnVDoCloseProcessByHwnd(actionObj,actionValue)
		CASE "CLOSEPROCESSBYID" Call fnVDoCloseProcessById(actionObj,actionValue)
		CASE "CLOSEPROCESSBYNAME" Call fnVDoCloseProcessByName(actionObj,actionValue)
		CASE "CLOSEPROCESSBYWNDTITLE" Call fnVDoCloseProcessByWndTitle(actionObj,actionValue)
		Case "CUSTOMERSCREEN" Call fnCustomerScreen(actionObj,actionValue)
		Case "CUSTOMERSCREEN_LSCI" Call fnCustomerScreenLSCI(actionObj,actionValue)
		CASE "RUN" Call fnVDoRun(actionObj,actionValue)
		CASE "UNBLOCKINPUT" Call fnVDoUnblockInput(actionObj,actionValue)
		CASE "BUILDMENUPATH" Call fnVDoBuildMenuPath(actionObj,actionValue)
		CASE "CLICKCELLBUTTON" Call fnVDoClickCellButton(actionObj,actionValue)
		CASE "DRAGANDDROPCOLUMN" Call fnVDoDragAndDropColumn(actionObj,actionValue)
		CASE "GETCELLDISPLAYEDDATA" Call fnVDoGetCellDisplayedData(actionObj,actionValue)
		CASE "GETSELECTEDCELL" Call fnVDoGetSelectedCell(actionObj,actionValue)
		CASE "GETSELECTEDROW" Call fnVDoGetSelectedRow(actionObj,actionValue)
		CASE "GETTABLEDATA" Call fnVDoGetTableData(actionObj,actionValue)
		CASE "ISCOLUMNHIDDEN" Call fnVDoIsColumnHidden(actionObj,actionValue)
		CASE "ISROWHIDDEN" Call fnVDoIsRowHidden(actionObj,actionValue)
		CASE "SETCURSORPOS" Call fnVDoSetCursorPos(actionObj,actionValue)
		CASE "GETCURSORPOS" Call fnVDoGetCursorPos(actionObj,actionValue)
		CASE "GETTEXT" Call fnVDoGetText(actionObj,actionValue)
		CASE "WAITSTRING" Call fnVDoWaitString(actionObj,actionValue)
		CASE "CLICKPOSITION" Call fnVDoClickPosition(actionObj,actionValue)
		CASE "GETVAPROPERTY" Call fnVDoGetVAProperty(actionObj,actionValue)
		CASE "SETVAPROPERTY" Call fnVDoSetVAProperty(actionObj,actionValue)
		CASE "CLEARCACHE" Call fnVDoClearCache(actionObj,actionValue)
		CASE "CLOSEALLTABS" Call fnVDoCloseAllTabs(actionObj,actionValue)
		CASE "DELETECOOKIES" Call fnVDoDeleteCookies(actionObj,actionValue)
		CASE "EMBEDSCRIPT" Call fnVDoEmbedScript(actionObj,actionValue)
		CASE "EMBEDSCRIPTFROMFILE" Call fnVDoEmbedScriptFromFile(actionObj,actionValue)
		CASE "FORWARD" Call fnVDoForward(actionObj,actionValue)
		CASE "FULLSCREEN" Call fnVDoFullScreen(actionObj,actionValue)
		CASE "HOME" Call fnVDoHome(actionObj,actionValue)
		CASE "ISSIBLINGTAB" Call fnVDoIsSiblingTab(actionObj,actionValue)
		CASE "OPENNEWTAB" Call fnVDoOpenNewTab(actionObj,actionValue)
		CASE "REFRESH" Call fnVDoRefresh(actionObj,actionValue)
		CASE "STOP" Call fnVDoStop(actionObj,actionValue)
		CASE "GETROWWITHCELLTEXT" Call fnVDoGetRowWithCellText(actionObj,actionValue)
		CASE "GETDATA" Call fnVDoGetData(actionObj,actionValue)
		Case "SCREENSHOT" Call UDF_Screenshot()
		Case "REPORTSCREENSHOT" Call fnScreenShot()
		Case "SAVETEXT" Call saveText(actionObj,actionValue)
		Case "SAVEDATA" Call saveData(actionObj,actionValue)
		Case "VERIFYTETEXT" Call fnVDoVerifyTEText(actionObj,actionValue)
		Case "VERIFYTETEXTOPT" Call fnVDoVerifyTETextOpt(actionObj,actionValue)
		Case "VERIFYPREMIUM" Call fnVerifyPremium(actionValue)
		Case "SETSCREEN" Call fnSetScreen(actionObj,actionValue)
		Case "DEBUG" Call debug()
		Case "EXCEPTIONFLAG" Call fnCheckExceptionFlag()
		Case "CAPTURESCREEN" Call fnCaptureScreen(actionObj,actionValue)
		Case "SMOKERFLAG" Call fnSetSmokingFlag()
		Case "SETSCREENOPT" Call fnSetScreenOpt(actionObj,actionValue)
		Case "GETTEXTNEW" Call getTextNew(actionObj,actionValue)
		Case "LOGGER" Call fnSetLogs(actionObj,actionValue)
		Case "LOGGEROPT" Call fnSetLogsOpt(actionObj,actionValue)
		Case "MSGLOG" Call fnMsgLogs(actionValue)
		Case "APPLYFUNDS_COL" Call  fnApply_Funds_COL()
		Case "APPLYFUNDS_NY" Call fnApply_Funds_NY()
        Case "POLICYREINSTATEMENT" Call fnPolicyReinstate_Sit()
		Case  "DELETION_D_T_DIVORCE" Call fnDeletion_DuetoDivorce()
		Case "DELETION_D_T_REQUEST" Call fnDeletion_DuetoRequest()
		Case "DELETION_D_T_DEATH" Call fnDeletion_DueToDeath()  
		Case "REFUND" Call fnReFund()
		Case "MFLOGIN" Call logon_Mainframe()
		Case "MFLOGINCAPPS" Call logon_Mainframecapps()
		Case "MFLOGOUT" Call fnCloseMainFrame()
		Case "DCODE" Call EnterDeskCode(Trim(StrDCode))
		Case "UDF_WOP" Call fnWaiverofPremium()
		Case "SIXCODE" Call fnSixCode()
		Case "REVERSEBILLDATE" reverseBillDate()
		Case "POLICYCANCELLATION" Call fnPolicyCancellation()
		Case "DELETIONOFFAMILY" Call fnDeletionOfFamily()
		Case "ADDITIONOFFAMILY" Call fnAdditionOfFamily()
		Case "D1TOA1" Call fnPaymentTransfer_D1TOA1()
		Case "WOPPOSITIVEFUNDTRANSFER" Call fnWOP_P_F_T()
		Case "NOG3AMOUNTONACCOUNTINGSCREEN" Call fnNoG3AmountAccountingScreen()
		Case "WOPNEGATIVEFUNDTRANSFER" Call fnWOP_N_F_T()
		Case "WOP_SONE"call fnWOP_SONE()
		Case "WOP" Call fnWOP(get_G3Amt)
		Case "PMR" Call fnVerify_PMR()
		Case "REMOVEDDOTFROMBILLINGNAMESCREENONE" Call fnRemoved_Dot_From_BILLING_NAME_SCREEN_ONE()
		Case "PLACEBILLFORMINSCREENONE" Call fnPlace_Billform_In_SCREENONE(testcaseid)
    	Case "SWAIT" Call fnWait(actionValue)
		Case "PLACEBILLFORMA1TOD1INSCREENONE" Call fnPlace_Billform_A1_To_D1_In_SCREENONE(testcaseid)
		Case "PLACEBILLFORMA1TOD1INSCREENONE" Call fnPlace_Billform_A1_To_D1_In_SCREENONE(testcaseid)
		Case "GETTEXTTOVERIABLE" Call fnGetTextToVeriable(actionObj,actionValue)
		Case "SETTEXTFROMVERIABLE" Call fnVDoSetTextFromVeriable(actionObj,actionValue)
		Case "SETMULTITEXT" Call fnVDoSetMultiText(actionObj,actionValue)
		Case "VERIFYERRORANDPRESSENTER" Call fnVDoVerifyErrorPressEnter(actionObj,actionValue)
		Case "GETFORMNUMBER" Call fnGetFormNumber(actionObj,actionValue)
		Case "VERIFYSEVERROR" Call fnVerifySeverror(actionObj, actionValue)
		Case "VERIFYSEVERROR_NEG" Call fnVerifySeverror_Neg(actionObj, actionValue)
		Case "CHECKPOPUP" call fnCheckPopup(actionValue)
		Case "NAVIGATE" call fnNavigate(actionObj,actionValue)
		Case "NAVIGATESCREEN" call fnNavigateScreen(actionValue)
		Case "VERIFYSTATUS" call fnVerifyStatus(actionValue)
		Case "HANDLEPOPUP" call fnHandlePopup()
		Case "HANDLEPOPUP_PEND" call fnHandlePopup_Pend()
		Case "CHECKWARNING" call fnCheckWarning()
		Case "HANDLEWARNING" Call fnHandleWarnings()
		Case "NAVIGATECUSTSCREEN" Call fnNavigateCustScreen()
		Case "NAVIGATECUSTSCREEN_LSCI" Call fnNavigateCustScreenLSCI()
		Case "RULECHECK" Call fnRuleCheck()
		Case "CHECKEMULATORSTATUS" Call checkEmulatorStatus()
		Case "AGHIERARCHYSCREEN" Call fnCheckAgentHierarchyErrorScreen()
		'By Vinay
		Case "SELECTPLANCODEMULTIPLEPAGE" Call fnSelectPlanCodeMultiplePage(actionObj,actionValue)
		Case "VALIDATEPREMIUM" Call CalcAnnPremByRateSheet(actionObj,actionValue)
		Case "VALIDATEPREMIUMACCIDENT" Call CalcAnnPremByRateSheetAccident(actionObj,actionValue)
		Case "DELETERIDER" Call fnDeleteRider(actionObj,actionValue)
		Case "DELETERETAINRIDER" Call fnDeleteRetainRider(actionObj,actionValue)
		Case "DELETERETAINMULTIPLERIDER" Call fnDeleteRetainMultipleRider(actionObj,actionValue)
		Case "CHECKIFRIDERADDEDONCONVHISTSCREENCANCER" Call fnCheckIfRiderAddedOnConvHistScreenCANCER(actionObj,actionValue)
		
		'By Aakash
		Case "CHECKANDFILLNEWBASEPLAN" call fnCheckAndFillNewBasePlan()
		Case "MIBERRORHANDLING" call fnMIBError()
		Case "ADDPOLICYINMIBTABLE" call fnAddingInPolicyMibTable(actionValue)
		Case "VERIFYTETEXTWITHMSG" call fnVDoVerifyTETextWithMsg(actionObj,actionValue)
		Case "SETUNIQUEBUSINESSNAME" Call fnSetUniqueBusinessName ()
		Case "SETDOWNGRADE" call fnSetDownward(actionObj)
		
		'By Amit
		Case "WAITFORNEXTSCREEN" Call WaitForNextScreen()	
		Case "GETTEXTFROMSCREENINTOAVARIABLE"	Call fnGetTextFromScreenIntoAVariable (actionObj,actionValue)
		Case "SETDESKCODE" Call fnsetDeskCode()
		Case "SETDESKCODEAPAY" Call fnsetDeskCodeAPAY()
		Case "NAVIGATEANDVERIFYNEXTSCREEN" Call fnNavigateAndVerifyNextScreen(actionObj,actionValue)
		Case "SCREENSHOTWITHMESSAGE" Call fnScreenShotWithMessage(actionValue)
		Case "CHECKIFRIDERDELETEDONCONVHISTSCREEN" Call fnCheckIfRiderDeletedOnConvHistScreen(actionObj,actionValue)
		Case "CHECKIFRIDERADDEDONCONVHISTSCREEN" Call fnCheckIfRiderAddedOnConvHistScreen(actionObj,actionValue)
		Case "UPDATEQLCODEONPRODINFORMATIONSCREEN" Call fnUpdateQLCodeOnProdInformationScreen (actionObj,actionValue)
		Case "EXITANDRELOGINMAINFRAME" Call Exit_Mainframe_Relogin_OmegaV()
		'By Venkat.
		Case "ISPOLICYPENDED" Call fnCheckPolicyPended(actionObj,actionValue)
		Case "HANDLEAGENTHIERARCHYSCREEN" Call fnHandleAgentHierarchy()
		Case "RETAINRIDERS" Call fnRetainRiders(actionObj,actionValue)
		Case "CHECKIFMULTIPLERIDERSDELETEDADDEDONCONVHISTSCREEN" Call fnCheckIfMultipleRidersDeletedAndAddedOnConvHistScreen(actionObj, actionValue)
		Case "CHECKIFMULTIPLERIDERSRETAINEDONCONVHISTSCREEN" Call fnCheckIfMultipleRidersRetainedOnConvHistScreen(actionObj,actionValue)
		Case "ADDRETAINRIDERS" Call fnAddRetainRiders(actionObj,actionValue)
		Case "CHECKIFMULTIPLERIDERSADDEDRETAINEDONCONVHISTSCREEN" Call fnCheckIfMultipleRidersAddedRetainedOnConvHistScreen(actionObj,actionValue)
		Case "DELETERETAINRIDERS" Call fnDeleteRetainRiders(actionObj,actionValue)
		Case "CHECKIFMULTIPLERIDERSDELETEDRETAINEDONCONVHISTSCREEN" Call fnCheckIfMultipleRidersDeletedRetainedOnConvHistScreen(actionObj,actionValue)
		Case "HANDLEDIFFBILLFORMS" Call fnHandleDifferentBillForms()
		Case "CHANGERIDERUNITS" Call fnAddRiderUnits(actionValue)
		Case "CHECKRIDERUNITSAFTERCHANGEONCONVHISTSCREEN" Call fnCheckRiderUnitsChangedOnConvHistScreen(actionValue)
		Case "VERIFYBASEPLANS" Call fnVerifyBasePlans()
		Case "ISRIDERPRESENT" Call fnCheckRiderNonExistence(actionObj,actionValue)
		Case "VALPOLCOVGEXCEPT" Call fnValidatePolicyCoverageException(actionObj,actionValue)
		Case "NAVIGATEANDVERIFYTETEXT" Call fnVDoNavigateAndVerifyTEText(actionObj,actionValue)
		Case "NAVIGATEANDVERIFYTETEXTWITHCOMMA" Call fnVDoNavigateAndVerifyTETextWithComma(actionObj, actionValue)
		Case "NEWVALIDATIONSPRODUCTSCREEN" Call fnNewValidationsProductScreen()
		Case "NEWVALIDATIONSCHANGECOVERAGE" Call fnNewValidationsCCM()
		Case "ENTERHIREDATE" Call fnEnterHireDateOnCustomerScreen()
		Case "ENTERDESKCODE_CAPPS" Call fnEnterDeskCodeCapps(actionValue)
		Case "CAPTUREACCOUNTTYPE" Call fnCaptureAccountType()
		Case "CHANGEBILLFORM" Call fnChangeBillForm()
		Case "GENERATESUMMARY" Call fnGenerateSummaryNumber()
		Case "SUMMARYHASBEENPROCESSED" Call fnSummaryHasBeenProcessed()
		Case "DATACONDITIONING" Call doDataConditioning()
		Case "VERIFYTAXSTATUS" Call fnVDoVerifyTaxStatus(actionObj)
		Case "SCREENVALIDATIONSBEFORE" Call fnScreenValidationsBefore()
		Case "SCREENVALIDATIONSAFTER" Call fnScreenValidationsAfter()
		Case "SEV3_ERROR_AGENT_HIERARCHY" Call fnVerifySev3ErrorAgentHierarchy(actionObj,actionValue)
		Case "RIDEREXIST"  Call fnCheckRiderExistence(actionObj,actionValue)
		Case "HANDLESUMMARYBALANCING" Call fnHandleSummaryBalancing()
		CASE "LOGIN_INTO_MAINFRAME_CAPPS" Call LoginIntoMainFrame_CAPPS(strMFUId,strMFPwd)
		Case "NAVIGATEANDVERIFYTETEXTBYPRESSINGANYKEY" Call NavigateAndVerifyTeTextByPressingAnyKey(actionObj, actionValue)
		Case "VERIFYCHANNELINDICATOR" Call fnVerifyChannelIndicatorInIIMGScreen(actionObj)
		Case "BEFORECONVERSION_CHANNELINDICATOR" Call fnBeforeConversionVerifyChannelIndicatorInIIMGScreen(actionObj)
		Case "VERIFYQUALCODE" Call fnAfterTaxStatusQualCodeMatch(actionObj)
		'Case "FLEXMESSAGE" Call fnHandleFlexMessage
		Case Else strGblRes="Unknown Action Name (" & actionName &")"
	End Select
	End If
End If
End Function



'object  methods  ------------------------------------------------------------------->



'Saves a screen capture of the object as a .png or .bmp image, depending on the specified file extension. 

Function fnVDoCaptureBitmap(actionObj,actionValue)
If actionObj.Exist(2) then
	actionObj.CaptureBitmap actionValue
	Call fnDoCheckError()
Else
	strGblRes=strErrObjNotFound
End If
End Function


'Checks whether the actual value of an item matches the expected value. 
Function fnVDoCheck(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.Check actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function

'Checks whether the specified object property achieves the specified value within the specified timeout. 
Function fnVDoCheckProperty(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.CheckProperty actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function

'Returns the collection of child objects contained within the object. 
Function fnVDoChildObjects(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.ChildObjects actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function
Function  fnVDoAddRider(actionObj,actionValue)
	Select Case actionValue
		Case "CIRider"
		     actionObj.SetText 15,11,X
		     actionObj.SetText 15,77,L
		Case "CIRiderH"
		      actionObj.SetText 16,11,X
		      actionObj.SetText 16,77,L
	End Select
	
End Function

'Clicks the object. 
Function fnVDoClick(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.Click
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function

'Clicks the object and wait for 5 seconds
Function fnVDoClickAndWait(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.Click
wait 5
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function

'Double-clicks the object.
Function fnVDoDblClick(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.DblClick actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function

'Performs the 'drag' part of a drag-and-drop operation. 
Function fnVDoDrag(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.Drag actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function

'Performs the 'drop' part of a drag-and-drop operation. 
Function fnVDoDrop(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.Drop actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function


'simulating a click event does not actually perform the click
Function fnVDoFireEvent(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.FireEvent actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function

'Returns the current value of the specified identification property from the object in the application. 
Function fnVDoGetROProperty(actionObj,actionValue)
If actionObj.Exist(2) then
fnVDoGetROProperty = actionObj.GetROProperty(actionValue)
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function

'Returns the location of text in mainframe
Function fnVDoGetTextLocation(actionObj,actionValue)
If actionObj.Exist(2) then
fnVDoGetTextLocation = actionObj.GetTextLocation (actionValue)
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function

'Returns the collection of properties and values used to identify the object. 
Function fnVDoGetTOProperties(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.GetTOProperties actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function

'Returns the value of the specified identification property from the test object description. 
Function fnVDoGetTOProperty(actionObj,actionValue)
If actionObj.Exist(2) then
fnVDoGetTOProperty = actionObj.GetTOProperty (actionValue)
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function

'Returns the text from the specified area. 
Function fnVDoGetVisibleText(actionObj,actionValue)
If actionObj.Exist(2) then
fnVDoGetVisibleText = actionObj.GetVisibleText( actionValue)
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function

'Scrolls the object into view if it is not visible in the parent window. 
Function fnVDoMakeVisible(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.MakeVisible actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function

'Moves the mouse pointer to the designated position over the object. 
Function fnVDoMouseMove(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.MouseMove actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function

'Retrieves the current value of an item and stores it in a specified location. 
Function fnVDoOutput(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.Output actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function

'Instructs QuickTest to re-identify the object in the application the next time a step refers to this object. 
Function fnVDoRefreshObject(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.RefreshObject actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function

'Sets the value of the specified identification property in the test object description. 
Function fnVDoSetTOProperty(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.SetTOProperty actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function

'Returns a string that represents the current test object. 
Function fnVDoToString(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.ToString actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function

'Types the specified string in the object. 
Function fnVDoType(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.Type actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function

'Waits until the specified object property achieves the specified value or exceeds the specified timeout before continuing to the next step. 
Function fnVDoWaitProperty(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.WaitProperty actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function

'Sets the date of the ActiveX calendar. 
Function fnVDoSetDate(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.SetDate actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function

'Sets the date range of the ActiveX calendar. 
Function fnVDoSetDateRange(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.SetDateRange actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function

'Sets the time of the ActiveX calendar. 
Function fnVDoSetTime(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.SetTime actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function


Function fnVDoSet(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.Set actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function

'Returns all of the items in the combo box list. 
Function fnVDoGetContent(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.GetContent actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function


Function fnVDoGetItem(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.GetItem actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function


Function fnVDoGetItemsCount(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.GetItemsCount actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function


Function fnVDoGetSelection(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.GetSelection actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function


Function fnVDoSelect(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.Select actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function


Function fnVDoSetCaretPos(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.SetCaretPos actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function


Function fnVDoSetSecure(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.SetSecure actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function


Function fnVDoSetSelection(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.SetSelection actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function


Function fnVDoActivateCell(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.ActivateCell actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function


Function fnVDoActivateColumn(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.ActivateColumn actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function


Function fnVDoActivateRow(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.ActivateRow actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function


Function fnVDoGetCellData(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.GetCellData actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function


Function fnVDoMakeCellVisible(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.MakeCellVisible actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function


Function fnVDoSelectCell(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.SelectCell actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function


Function fnVDoSelectColumn(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.SelectColumn actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function


Function fnVDoSelectRow(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.SelectRow actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function


Function fnVDoSetCellData(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.SetCellData actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function


Function fnVDoColumnCount(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.ColumnCount actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function


Function fnVDoExist(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.Exist actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function


Function fnVDoObject(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.Object actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function


Function fnVDoRowCount(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.RowCount actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function


Function fnVDoSetROProperty(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.SetROProperty actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function


Function fnVDoActivate(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.Activate actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function


Function fnVDoCheckItemProperty(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.CheckItemProperty actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function


Function fnVDoDeselect(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.Deselect actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function


Function fnVDoExtendSelect(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.ExtendSelect actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function


Function fnVDoGetItemProperty(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.GetItemProperty actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function


Function fnVDoSelectRange(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.SelectRange actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function


Function fnVDoWaitItemProperty(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.WaitItemProperty actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function


Function fnVDoDragItem(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.DragItem actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function


Function fnVDoDropOnItem(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.DropOnItem actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function


Function fnVDoEditLabel(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.EditLabel actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function


Function fnVDoGetCheckMarks(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.GetCheckMarks actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function


Function fnVDoGetColumnHeader(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.GetColumnHeader actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function


Function fnVDoGetSubItem(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.GetSubItem actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function


Function fnVDoSetItemState(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.SetItemState actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function


Function fnVDoClickCancel(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.ClickCancel actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function


Function fnVDoClickDelete(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.ClickDelete actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function


Function fnVDoClickEdit(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.ClickEdit actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function


Function fnVDoClickFirst(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.ClickFirst actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function


Function fnVDoClickInsert(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.ClickInsert actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function


Function fnVDoClickLast(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.ClickLast actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function


Function fnVDoClickNext(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.ClickNext actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function


Function fnVDoClickPost(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.ClickPost actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function


Function fnVDoClickPrior(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.ClickPrior actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function


Function fnVDoClickRefresh(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.ClickRefresh actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function


Function fnVDoHScroll(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.HScroll actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function


Function fnVDoVScroll(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.VScroll actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function


Function fnVDoNextLine(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.NextLine actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function


Function fnVDoNextPage(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.NextPage actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function


Function fnVDoPrevLine(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.PrevLine actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function


Function fnVDoPrevPage(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.PrevPage actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function


Function fnVDoNext(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.Next actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function


Function fnVDoPrev(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.Prev actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function

Function fnVDoCollapse(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.Collapse actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function


Function fnVDoExpand(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.Expand actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function


Function fnVDoExpandAll(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.ExpandAll actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function


Function fnVDoClose(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.Close actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function


Function fnVDoMaximize(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.Maximize actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function


Function fnVDoMinimize(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.Minimize actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function


Function fnVDoMove(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.Move actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function


Function fnVDoResize(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.Resize actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function


Function fnVDoRestore(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.Restore actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function


Function fnVDoCreateObject(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.CreateObject actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function


Function fnVDoFireEventEx(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.FireEventEx actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function


Function fnVDoGetStatics(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.GetStatics actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function


Function fnVDoMouseDrag(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.MouseDrag actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function


Function fnVDoPressKey(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.PressKey actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function


Function fnVDoClickLink(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.ClickLink actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function


Function fnVDoDelete(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.Delete actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function


Function fnVDoInsert(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.Insert actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function


Function fnVDoReplace(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.Replace actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function


Function fnVDoSetFocus(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.SetFocus actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function


Function fnVDoAddRange(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.AddRange actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function


Function fnVDoDeselectRange(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.DeselectRange actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function


Function fnVDoGetItemIndex(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.GetItemIndex actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function


Function fnVDoDragFromStart(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.DragFromStart actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function


Function fnVDoDragLine(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.DragLine actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function


Function fnVDoDragPage(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.DragPage actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function

Function fnVDoCloseTab(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.CloseTab actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function


Function fnVDoClickCell(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.ClickCell actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function


Function fnVDoDeselectColumn(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.DeselectColumn actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function


Function fnVDoDeselectColumnsRange(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.DeselectColumnsRange actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function


Function fnVDoDeselectRow(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.DeselectRow actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function


Function fnVDoDeselectRowsRange(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.DeselectRowsRange actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function


Function fnVDoDoubleClickCell(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.DoubleClickCell actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function


Function fnVDoExtendColumn(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.ExtendColumn actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function


Function fnVDoExtendColumnsRange(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.ExtendColumnsRange actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function


Function fnVDoExtendRow(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.ExtendRow actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function


Function fnVDoExtendRowsRange(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.ExtendRowsRange actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function


Function fnVDoGetColumnName(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.GetColumnName actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function


Function fnVDoSelectCellsRange(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.SelectCellsRange actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function


Function fnVDoSelectColumnHeader(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.SelectColumnHeader actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function


Function fnVDoSelectColumnsRange(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.SelectColumnsRange actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function


Function fnVDoSelectRowsRange(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.SelectRowsRange actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function


Function fnVDoPress(actionObj,actionValue)
If actionObj.Exist(2) then
s actionValue
Call fnDoCheck
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function

Function fnVDoShowDropdown(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.ShowDropdown actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function

Function fnVDoGetColumnValue(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.GetColumnValue actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function


Function fnVDoOpenContextMenu(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.OpenContextMenu actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function


Function fnVDoGetExpandedItems(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.GetExpandedItems actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function


Function fnVDoGetItemChildObjects(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.GetItemChildObjects actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function


Function fnVDoShowContextMenu(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.ShowContextMenu actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function


Function fnVDoSetMonth(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.SetMonth actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function


Function fnVDoSetYear(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.SetYear actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function


Function fnVDoDate(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.Date actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function


Function fnVDoDateRange(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.DateRange actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function


Function fnVDoDescriptionValue(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.DescriptionValue actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function


Function fnVDoIsValid(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.IsValid actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function

Function fnVDoFirst(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.First actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function

Function fnVDoLast(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.Last actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function

Function fnVDoPrevious(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.Previous actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function

Function fnVDoSetPage(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.SetPage actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function

Function fnVDoCurrentPageIndex(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.CurrentPageIndex actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function

Function fnVDoDisplayMode(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.DisplayMode actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function


Function fnVDoPageCount(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.PageCount actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function


Function fnVDoSetMultiLineCaretPos(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.SetMultiLineCaretPos actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function


Function fnVDoSetMultiLineSelection(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.SetMultiLineSelection actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function


Function fnVDoSetSingleLineCaretPos(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.SetSingleLineCaretPos actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function


Function fnVDoSetSingleLineSelection(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.SetSingleLineSelection actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function

Function fnVDoExtendSelectRow(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.ExtendSelectRow actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function

Function fnVDoGetCellProperty(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.GetCellProperty actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function

Function fnVDoMiddleClick(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.MiddleClick actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function

Function fnVDoRightClick(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.RightClick actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function

Function fnVDoSetWeek(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.SetWeek actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function

Function fnVDoShowDate(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.ShowDate actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function


Function fnVDoShowNextMonth(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.ShowNextMonth actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function


Function fnVDoShowPreviousMonth(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.ShowPreviousMonth actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function


Function fnVDoSubmit(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.Submit actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function


Function fnVDoChildItem(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.ChildItem actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function


Function fnVDoChildItemCount(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.ChildItemCount actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function


Function fnVDoAddRow(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.AddRow actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function


Function fnVDoCollapseRow(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.CollapseRow actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function


Function fnVDoDeleteRow(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.DeleteRow actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function


Function fnVDoExpandRow(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.ExpandRow actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function


Function fnVDoGroupRows(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.GroupRows actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function


Function fnVDoSort(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.Sort actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function


Function fnVDoGetErrorProviderText(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.GetErrorProviderText actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function


Function fnVDoGetValue(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.GetValue actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function


Function fnVDoSelectProperty(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.SelectProperty actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function


Function fnVDoSetValue(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.SetValue actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function
Function fnVDoBack(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.Back actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function
Function fnVDoGroupBy(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.GroupBy actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function
Function fnVDoHideParentRow(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.HideParentRow actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function
Function fnVDoOpenCellElement(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.OpenCellElement actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function
Function fnVDoOpenCellRelation(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.OpenCellRelation actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function
Function fnVDoOpenSummaryDlg(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.OpenSummaryDlg actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function
Function fnVDoSetFilter(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.SetFilter actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function
Function fnVDoSetView(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.SetView actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function
Function fnVDoShowParentRow(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.ShowParentRow actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function
Function fnVDoIsItemEnabled(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.IsItemEnabled actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function
Function fnVDoItemExists(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.ItemExists actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function
Function fnVDoAutomationElement(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.AutomationElement actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function
Function fnVDoAutomationPattern(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.AutomationPattern actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function
Function fnVDoSupportedPatterns(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.SupportedPatterns actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function
Function fnVDoSupportsTextSelection(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.SupportsTextSelection actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function
Function fnVDoMaximum(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.Maximum actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function
Function fnVDoMinimum(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.Minimum actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function
Function fnVDoValue(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.Value actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function
Function fnVDoShowOverflow(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.ShowOverflow actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function
Function fnVDoExit(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.Exit actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function
Function fnVDoGetActiveWindow(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.GetActiveWindow actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function
Function fnVDoInvokeSoftkey(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.InvokeSoftkey actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function
Function fnVDoSelectPopupMenu(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.SelectPopupMenu actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function
Function fnVDoSync(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.Sync actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function
Function fnVDoCancel(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.Cancel actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function
Function fnVDoEnter(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.Enter actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function
Function fnVDoClear(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.Clear actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function
Function fnVDoIsSelected(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.IsSelected actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function
Function fnVDoVerifyCleared(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.VerifyCleared actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function
Function fnVDoVerifySelected(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.VerifySelected actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function
Function fnVDoApprove(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.Approve actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function
Function fnVDoHelp(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.Help actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function
Function fnVDoShowCombinations(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.ShowCombinations actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function
Function fnVDoCloseForm(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.CloseForm actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function
Function fnVDoCloseWindow(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.CloseWindow actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function
Function fnVDoPressToolbarButton(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.PressToolbarButton actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function
Function fnVDoSave(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.Save actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function
Function fnVDoSelectMenu(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.SelectMenu actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function
Function fnVDoIsItemInList(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.IsItemInList actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function
Function fnVDoFind(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.Find actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function
Function fnVDoLogon(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.Logon actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function
Function fnVDoSelectFunction(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.SelectFunction actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function
Function fnVDoChoose(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.Choose actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function
Function fnVDoChooseDefault(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.ChooseDefault actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function
Function fnVDoDecline(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.Decline actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function
Function fnVDoVerifyMessage(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.VerifyMessage actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function
Function fnVDoVerifyErrorCode(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.VerifyErrorCode actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function
Function fnVDoActivateRecord(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.ActivateRecord actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function
Function fnVDoEnterField(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.EnterField actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function
Function fnVDoGetFieldItem(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.GetFieldItem actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function
Function fnVDoGetFieldValue(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.GetFieldValue actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function
Function fnVDoIsFieldEditable(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.IsFieldEditable actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function
Function fnVDoOpenDialog(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.OpenDialog actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function
Function fnVDoVerifyField(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.VerifyField actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function
Function fnVDoValidate(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.Validate actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function
Function fnVDoVerify(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.Verify actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function
Function fnVDoRunScript(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.RunScript actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function
Function fnVDoRunScriptFromFile(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.RunScriptFromFile actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function
Function fnVDoDescribe(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.Describe actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function
Function fnVDoSelectMenuItem(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.SelectMenuItem actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function
Function fnVDoOpenPossibleEntries(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.OpenPossibleEntries actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function
Function fnVDoHide(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.Hide actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function
Function fnVDoRelate(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.Relate actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function
Function fnVDoShow(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.Show actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function
Function fnVDoDetailedNavigation(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.DetailedNavigation actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function
Function fnVDoNavigate(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.Navigate actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function
Function fnVDoSearch(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.Search actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function
Function fnVDoFindRowByCellContent(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.FindRowByCellContent actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function
Function fnVDoSelectItemInCell(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.SelectItemInCell actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function
Function fnVDoClearSelection(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.ClearSelection actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function
Function fnVDoDeselectCell(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.DeselectCell actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function
Function fnVDoExtendCell(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.ExtendCell actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function
Function fnVDoFindAllRowsByCellContent(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.FindAllRowsByCellContent actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function
Function fnVDoGetCellFormat(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.GetCellFormat actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function
Function fnVDoInput(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.Input actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function
Function fnVDoIsCellEditable(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.IsCellEditable actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function
Function fnVDoPressEnter(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.PressEnter actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function
Function fnVDoSelectAll(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.SelectAll actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function
Function fnVDoSelectCellMenuItem(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.SelectCellMenuItem actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function
Function fnVDoSelectColumnMenuItem(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.SelectColumnMenuItem actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function
Function fnVDoSelectKey(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.SelectKey actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function
Function fnVDoSelectMenuItemById(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.SelectMenuItemById actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function
Function fnVDoSetCheckbox(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.SetCheckbox actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function
Function fnVDoCreateSession(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.CreateSession actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function
Function fnVDoReset(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.Reset actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function
Function fnVDoGetCellLength(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.GetCellLength actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function
Function fnVDoPressSettingsButton(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.PressSettingsButton actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function
Function fnVDoSelectAllColumns(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.SelectAllColumns actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function
Function fnVDoValidRow(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.ValidRow actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function
Function fnVDoDoubleClick(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.DoubleClick actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function
Function fnVDoSetSelectionIndexes(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.SetSelectionIndexes actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function
Function fnVDoSetUnprotectedTextPart(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.SetUnprotectedTextPart actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function
Function fnVDoPressButton(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.PressButton actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function
Function fnVDoPressContextButton(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.PressContextButton actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function
Function fnVDoActivateItem(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.ActivateItem actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function
Function fnVDoActivateNode(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.ActivateNode actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function
Function fnVDoClickButton(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.ClickButton actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function
Function fnVDoClickColumn(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.ClickColumn actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function
Function fnVDoExtendNode(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.ExtendNode actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function
Function fnVDoOpenHeaderContextMenu(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.OpenHeaderContextMenu actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function
Function fnVDoOpenItemContextMenu(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.OpenItemContextMenu actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function
Function fnVDoOpenNodeContextMenu(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.OpenNodeContextMenu actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function
Function fnVDoSelectItem(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.SelectItem actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function
Function fnVDoSelectNode(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.SelectNode actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function
Function fnVDoAutoLogon(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.AutoLogon actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function
Function fnVDoAutoLogonByIP(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.AutoLogonByIP actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function
Function fnVDoCloseConnections(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.CloseConnections actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function
Function fnVDoOpenConnection(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.OpenConnection actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function
Function fnVDoOpenConnectionByIP(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.OpenConnectionByIP actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function
Function fnVDoHorizontalScrollbarPosition(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.HorizontalScrollbarPosition actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function

 Function fnVDoSendKey(actionObj,actionValue)

If actionObj.Exist(2) then
		  If Instr(1,actionValue,",")>0  Then
				  splitObj=split(actionValue,",")
				  For i=1 to CInt(splitObj(1))
				  actionValue = splitObj(0)
				  'wait 1
				  actionObj.SendKey actionValue
				  WaitForNextScreen()
				  Next
				  'wait 1
				  actionObj.SendKey actionValue
				  WaitForNextScreen()
          End If

		   If Instr(1,actionValue,"::")>0  Then
				  splitObj=split(actionValue,"::")
                  actionValue = splitObj(1)
				  'wait 1
				  actionObj.SendKey actionValue
				  WaitForNextScreen()
          Else 
  			'wait 1
			actionObj.SendKey actionValue
			WaitForNextScreen()
		End If

		 Call fnDoCheckError()
Else
	  strGblRes=strErrObjNotFound
End If

End Function

Public Function fnVDoSendKeyOpt(ByVal actionObj, ByVal actionValue)
	Dim actionValueArr, validationDataArr, iText

	actionValueArr = Split(actionValue, "#~")
	validationDataArr = Split(actionValueArr(0), ",")

	iText = fnVDoGetText(actionObj, actionValueArr(0))
	If Instr(1, iText, validationDataArr(0)) > 0 Then
		fnVDoSendKey actionObj, actionValueArr(1)
	End If
End Function

Function fnVDoVerticalScrollbarPosition(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.VerticalScrollbarPosition actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function

Function fnVDoOpen(actionObj,actionValue)
While Browser("creationtime:=0").Exist(0)  
Browser("creationtime:=0").Close
Wend
SystemUtil.Run "iexplore.exe", actionValue
wait(5)
End Function

Function fnVDoColumnExists(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.ColumnExists actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function

Function fnVDoDrillDown(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.DrillDown actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function

Function fnVDoIsColumnWritable(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.IsColumnWritable actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function

Function fnVDoScrollRows(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.ScrollRows actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function

Function fnVDoSortDown(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.SortDown actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function

Function fnVDoSortUp(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.SortUp actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function

Function fnVDoMoveLeft(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.MoveLeft actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function

Function fnVDoMoveRight(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.MoveRight actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function

Function fnVDoTabExists(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.TabExists actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function

Function fnVDoGetDirectChildren(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.GetDirectChildren actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function

Function fnVDoGetDirectChildrenCount(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.GetDirectChildrenCount actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function

Function fnVDoNodeExists(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.NodeExists actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function

Function fnVDoGetActiveControlName(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.GetActiveControlName actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function

Function fnVDoGetClassCount(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.GetClassCount actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function

Function fnVDoGetRepositoryName(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.GetRepositoryName actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function


Function fnVDoGetRepositoryNameByIndex(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.GetRepositoryNameByIndex actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function


Function fnVDoIsControlExists(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.IsControlExists actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function


Function fnVDoGetBusyTime(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.GetBusyTime actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function


Function fnVDoGetLastErrorCode(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.GetLastErrorCode actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function


Function fnVDoGetLastErrorMessage(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.GetLastErrorMessage actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function


Function fnVDoGetLastOpId(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.GetLastOpId actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function


Function fnVDoGetLastOpTime(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.GetLastOpTime actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function


Function fnVDoGetSessionId(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.GetSessionId actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function


Function fnVDoGotoScreen(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.GotoScreen actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function


Function fnVDoGotoView(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.GotoView actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function


Function fnVDoProcessKeyboardAccelerator(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.ProcessKeyboardAccelerator actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function


Function fnVDoSetTimeOut(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.SetTimeOut actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function


Function fnVDoClickKey(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.ClickKey actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function


Function fnVDoClickKeys(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.ClickKeys actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function


Function fnVDoOpenPopup(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.OpenPopup actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function

Function fnVDoCancelPopup(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.CancelPopup actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function


Function fnVDoClosePopup(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.ClosePopup actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function


Function fnVDoNextMonth(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.NextMonth actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function


Function fnVDoPrevMonth(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.PrevMonth actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function


Function fnVDoSelectTimeZone(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.SelectTimeZone actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function


Function fnVDoSetDay(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.SetDay actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function


Function fnVDoSetOff(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.SetOff actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function


Function fnVDoSetOn(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.SetOn actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function


Function fnVDoGetButtonState(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.GetButtonState actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function


Function fnVDoGetButtonTooltip(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.GetButtonTooltip actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function


Function fnVDoSelectWorkItem(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.SelectWorkItem actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function


Function fnVDoShowButtonTooltip(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.ShowButtonTooltip actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function


Function fnVDoAmount(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.Amount actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function


Function fnVDoClassName(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.ClassName actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function


Function fnVDoCurrencyCode(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.CurrencyCode actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function


Function fnVDoExchangeDate(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.ExchangeDate actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function


Function fnVDoIsEnabled(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.IsEnabled actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function


Function fnVDoIsOpen(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.IsOpen actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function


Function fnVDoIsRequired(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.IsRequired actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function


Function fnVDoRepositoryName(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.RepositoryName actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function


Function fnVDoText(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.Text actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function


Function fnVDoUIName(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.UIName actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function


Function fnVDoAscendSort(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.AscendSort actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function


Function fnVDoClickHier(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.ClickHier actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function


Function fnVDoDescendSort(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.DescendSort actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function


Function fnVDoDrillDownColumn(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.DrillDownColumn actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function


Function fnVDoFirstRowSet(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.FirstRowSet actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function


Function fnVDoGetCellText(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.GetCellText actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function


Function fnVDoGetColumnRepositoryName(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.GetColumnRepositoryName actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function


Function fnVDoGetColumnRepositoryNameByIndex(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.GetColumnRepositoryNameByIndex actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function


Function fnVDoGetColumnSort(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.GetColumnSort actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function


Function fnVDoGetColumnUIName(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.GetColumnUIName actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function


Function fnVDoGetTotalsValue(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.GetTotalsValue actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function


Function fnVDoIsColumnDrillDown(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.IsColumnDrillDown actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function


Function fnVDoIsColumnExists(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.IsColumnExists actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function


Function fnVDoIsRowExpanded(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.IsRowExpanded actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function


Function fnVDoLastRowSet(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.LastRowSet actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function


Function fnVDoNextRow(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.NextRow actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function


Function fnVDoNextRowSet(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.NextRowSet actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function


Function fnVDoPreviousRow(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.PreviousRow actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function


Function fnVDoPreviousRowSet(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.PreviousRowSet actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function


Function fnVDoSetActiveControl(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.SetActiveControl actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function


Function fnVDoGetUIName(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.GetUIName actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function


Function fnVDoIsExists(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.IsExists actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function


Function fnVDoGetItemByIndex(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.GetItemByIndex actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function


Function fnVDoProcessKey(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.ProcessKey actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function


Function fnVDoActiveItem(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.ActiveItem actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function


Function fnVDoCount(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.Count actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function


Function fnVDoGoto(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.Goto actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function


Function fnVDoDone(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.Done actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function


Function fnVDoStart(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.Start actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function


Function fnVDoStep(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.Step actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function


Function fnVDoStepView(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.StepView actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function


Function fnVDoGetStepByIndex(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.GetStepByIndex actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function


Function fnVDoGetTaskByIndex(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.GetTaskByIndex actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function


Function fnVDoGotoInbox(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.GotoInbox actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function


Function fnVDoGetThreadItemByIndex(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.GetThreadItemByIndex actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function


Function fnVDoIsControlEnabled(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.IsControlEnabled actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function


Function fnVDoGetChildCount(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.GetChildCount actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function


Function fnVDoGetTreeItemName(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.GetTreeItemName actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function


Function fnVDoIsExpanded(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.IsExpanded actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function


Function fnVDoPreviousPage(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.PreviousPage actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function


Function fnVDoGotoApplet(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.GotoApplet actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function


Function fnVDoRunAnalog(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.RunAnalog actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function


Function fnVDoBlockInput(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.BlockInput actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function


Function fnVDoCloseDescendentProcesses(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.CloseDescendentProcesses actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function


Function fnVDoCloseProcessByHwnd(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.CloseProcessByHwnd actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function


Function fnVDoCloseProcessById(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.CloseProcessById actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function


Function fnVDoCloseProcessByName(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.CloseProcessByName actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function


Function fnVDoCloseProcessByWndTitle(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.CloseProcessByWndTitle actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function


Function fnVDoRun(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.Run actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function


Function fnVDoUnblockInput(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.UnblockInput actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function


Function fnVDoBuildMenuPath(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.BuildMenuPath actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function


Function fnVDoClickCellButton(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.ClickCellButton actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function


Function fnVDoDragAndDropColumn(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.DragAndDropColumn actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function


Function fnVDoGetCellDisplayedData(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.GetCellDisplayedData actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function


Function fnVDoGetSelectedCell(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.GetSelectedCell actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function


Function fnVDoGetSelectedRow(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.GetSelectedRow actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function


Function fnVDoGetTableData(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.GetTableData actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function


Function fnVDoIsColumnHidden(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.IsColumnHidden actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function


Function fnVDoIsRowHidden(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.IsRowHidden actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function


Function fnVDoSetCursorPos(actionObj,actionValue)
	Dim actionValueArr
	If actionObj.Exist(2) then
		actionValueArr = split(actionValue, ",")
		actionObj.SetCursorPos actionValueArr(0),actionValueArr(1)
		Call fnDoCheckError()
	Else
		strGblRes=strErrObjNotFound
	End If
End Function


Function fnVDoGetCursorPos(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.GetCursorPos actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function




Function fnVDoWaitString(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.WaitString actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function


Function fnVDoClickPosition(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.ClickPosition actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function


Function fnVDoGetVAProperty(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.GetVAProperty actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function

Function fnVDoSetVAProperty(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.SetVAProperty actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function

Function fnVDoClearCache(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.ClearCache actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function

Function fnVDoCloseAllTabs(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.CloseAllTabs actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function


Function fnVDoDeleteCookies(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.DeleteCookies actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function


Function fnVDoEmbedScript(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.EmbedScript actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function


Function fnVDoEmbedScriptFromFile(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.EmbedScriptFromFile actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function


Function fnVDoForward(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.Forward actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function


Function fnVDoFullScreen(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.FullScreen actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function


Function fnVDoHome(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.Home actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function


Function fnVDoIsSiblingTab(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.IsSiblingTab actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function


Function fnVDoOpenNewTab(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.OpenNewTab actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function


Function fnVDoRefresh(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.Refresh actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function


Function fnVDoStop(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.Stop actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function


Function fnVDoGetRowWithCellText(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.GetRowWithCellText actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function


Function fnVDoGetData(actionObj,actionValue)
If actionObj.Exist(2) then
actionObj.GetData actionValue
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function

Function fnvGetObjectProperty(actionObj,actionValue)
If actionObj.Exist(2) then
strObjProp = actionObj.getROProperty(actionValue)
Call fnDoCheckError()
Else
strGblRes=strErrObjNotFound
End If
End Function

Function  fnDoCheckError()
   If Err.Number<>0 Then
	  strReportError ="Error> " & CStr(Err.Number) & " At Step> " & strtestStep & " Description> " & Err.Description
	  Err.Clear
   End If
End Function

Public Function fnWait(actionValue)
   WAit(actionValue)
End Function

Function logon_Mainframe_2()

	Wait 2
	If Window("regexpwndtitle:= BlueZone Mainframe Display", "text:=S1 - .* - Secure .* - BlueZone Mainframe Display").Exist(5) Then
		Window("regexpwndtitle:= BlueZone Mainframe Display", "text:=S1 - .* - Secure .* - BlueZone Mainframe Display").Activate
		Window("regexpwndtitle:= BlueZone Mainframe Display", "text:=S1 - .* - Secure .* - BlueZone Mainframe Display").WinToolbar("regexpwndclass:=ToolbarWindow32", "index:=2").Highlight
'		Window("regexpwndtitle:= BlueZone Mainframe Display", "text:=S1 - .* - Secure .* - BlueZone Mainframe Display").WinToolbar("regexpwndclass:=ToolbarWindow32", "index:=2").Press 11
		wait 5
		Window("regexpwndtitle:= BlueZone Mainframe Display", "text:=S1 - .* - Secure .* - BlueZone Mainframe Display").WinToolbar("regexpwndclass:=ToolbarWindow32", "index:=2").Press 11
		wait 1
	End If

End Function
'

Public Function logon_Mainframe()

	Wait 2
	If Window("regexpwndtitle:= BlueZone Mainframe Display", "text:=S1 - .* - Secure .* - BlueZone Mainframe Display").Exist(7) Then
		Window("regexpwndtitle:= BlueZone Mainframe Display", "text:=S1 - .* - Secure .* - BlueZone Mainframe Display").Activate
		Window("regexpwndtitle:= BlueZone Mainframe Display", "text:=S1 - .* - Secure .* - BlueZone Mainframe Display").WinToolbar("regexpwndclass:=ToolbarWindow32", "index:=2").Highlight
		Window("regexpwndtitle:= BlueZone Mainframe Display", "text:=S1 - .* - Secure .* - BlueZone Mainframe Display").WinToolbar("regexpwndclass:=ToolbarWindow32", "index:=2").Press 11
		wait 5
		Window("regexpwndtitle:= BlueZone Mainframe Display", "text:=S1 - .* - Secure .* - BlueZone Mainframe Display").WinToolbar("regexpwndclass:=ToolbarWindow32", "index:=2").Press 11

'		Set WshShell1 = CreateObject("WScript.Shell")
'		WshShell1.SendKeys ("{ALT+S+D}")
'		wait 1
'		WshShell1.SendKeys ("{ALT+S+C}")
'		Set WshShell1 = Nothing
			
		wait 1
		If TeWindow("short name:=B").TeScreen("label:=screen5294", "screen id:=5294").TeField("attached text:=field2", "field id:=2").Exist(5) Then
			Call login_MF()
		Else
			Call logon_Mainframe_2()
			Call login_MF()
		End If
		
	Else
		Call fnCloseMainFrame()
		On Error Resume Next
'			Datatable.AddSheet("Login_AFLAC")
'			Datatable.ImportSheet "[QualityCenter\Resources] Resources\Automation\DataAssets\Login_AFLAC","Login_AFLAC","Login_AFLAC"
'			intRowCount = Datatable.GetSheet("Login_AFLAC").GetRowCount
'			For intI = 1  to intRowCount
'				Datatable.GetSheet("Login_AFLAC").SetCurrentRow(intI)
'				strEnv = Datatable.Value("Applications","Login_AFLAC")
'				If ucase(trim(strEnv)) = "MAINFRAME" Then
'					strMFPath = Datatable.Value("URL","Login_AFLAC") 
'					Exit For
'				End If
'			Next
           
			Systemutil.Run "C:\Programdata\Microsoft\Windows\Start Menu\Aflac Apps\Bluezone Systest", "", "", "Open"
			
			Call login_MF()
	
	End If

End Function
Public Function logon_Mainframecapps()
	Wait 2
	If Window("regexpwndtitle:= BlueZone Mainframe Display", "text:=S1 - .* - Secure .* - BlueZone Mainframe Display").Exist(7) Then
		Window("regexpwndtitle:= BlueZone Mainframe Display", "text:=S1 - .* - Secure .* - BlueZone Mainframe Display").Activate
		Window("regexpwndtitle:= BlueZone Mainframe Display", "text:=S1 - .* - Secure .* - BlueZone Mainframe Display").WinToolbar("regexpwndclass:=ToolbarWindow32", "index:=2").Highlight
		Window("regexpwndtitle:= BlueZone Mainframe Display", "text:=S1 - .* - Secure .* - BlueZone Mainframe Display").WinToolbar("regexpwndclass:=ToolbarWindow32", "index:=2").Press 11
		wait 5
		Window("regexpwndtitle:= BlueZone Mainframe Display", "text:=S1 - .* - Secure .* - BlueZone Mainframe Display").WinToolbar("regexpwndclass:=ToolbarWindow32", "index:=2").Press 11

'		Set WshShell1 = CreateObject("WScript.Shell")
'		WshShell1.SendKeys ("{ALT+S+D}")
'		wait 1
'		WshShell1.SendKeys ("{ALT+S+C}")
'		Set WshShell1 = Nothing
			
		wait 1
		If TeWindow("short name:=B").TeScreen("label:=screen5294", "screen id:=5294").TeField("attached text:=field2", "field id:=2").Exist(5) Then
			Call login_MF()
		Else
			'commented by venkat on 10/25/2016
			'Call logon_Mainframe_2()
			Call login_MF()
		End If
		
	Else
	'	Call fnCloseMainFrame()
		On Error Resume Next
'			Datatable.AddSheet("Login_AFLAC")
'			Datatable.ImportSheet "[QualityCenter\Resources] Resources\Automation\DataAssets\Login_AFLAC","Login_AFLAC","Login_AFLAC"
'			intRowCount = Datatable.GetSheet("Login_AFLAC").GetRowCount
'			For intI = 1  to intRowCount
'				Datatable.GetSheet("Login_AFLAC").SetCurrentRow(intI)
'				strEnv = Datatable.Value("Applications","Login_AFLAC")
'				If ucase(trim(strEnv)) = "MAINFRAME" Then
'					strMFPath = Datatable.Value("URL","Login_AFLAC") 
'					Exit For
'				End If
'			Next
			
			If ucase(trim(TestArgs("Environment")))="INTG" Then
				Systemutil.Run "C:\Programdata\Microsoft\Windows\Start Menu\Aflac Apps\Bluezone Development", "", "", ""
			Else
				Systemutil.Run "C:\Programdata\Microsoft\Windows\Start Menu\Aflac Apps\Bluezone Systest", "", "", "Open"
			End If
			
			
'			Systemutil.Run strexepath, "", "", "Open"
			Call login_MF()
	
	End If
	
End Function

Public Function login_MF()

   MySLabel = ""
		wait(2)
		 'MySLabel = getScreenLabel()
		 If Trim(MySLabel) <> "screen5294" Then
			  MySLabel="screen5294"
		 End If
		 If TeWindow("TeWindow").Exist(2) Then
         	TeWindow("TeWindow").Activate
		End If
		Tewindow("TeWindow").TeScreen("label:="& MySLabel).SetText 1,2,"TPX"
		Tewindow("TeWindow").TeScreen("label:="& MySLabel).Sendkey TE_ENTER
		Tewindow("TeWindow").TeScreen("label:="& MySLabel).Sync
		Wait 1
'		MySLabel = getScreenLabel()
'		Tewindow("TeWindow").TeScreen("label:="& MySLabel).SetText 14,20,strMFUId
		Wait 2
		MySLabel = getScreenLabel()
'		strMFPwd = setSecure(strMFPwd)
'		Tewindow("TeWindow").TeScreen("label:="& MySLabel).SetSecure 15,20,strMFPwd

        Tewindow("TeWindow").TeScreen("label:="& MySLabel).TeField("attached text:=Userid.*","index:=1").Set strMFUId 
		Tewindow("TeWindow").TeScreen("label:="& MySLabel).TeField("attached text:=Password.*","index:=1").SetSecure strMFPwd
		wait 1
		Tewindow("TeWindow").TeScreen("label:="& MySLabel).SendKey TE_ENTER
'		Tewindow("TeWindow").TeScreen("label:="& MySLabel).Sync
		Wait 2
'		Call Select_TPX_MENU_FOR(TestArgs("Sessid"))

End Function

Function EnterDeskCode(StrDCode)

			If TeWindow("short name:=B").TeScreen("label:=screen27370").TeField("attached text:=ENTER\(protected\)", "text:=ENTER DESK CODE HERE.*").Exist(2) Then
				TeWindow("short name:=B").TeScreen("label:=screen27370").TeField("attached text:=ENTER DESK CODE HERE", "protected:=False").Set StrDCode
				wait 2
				MySLabel = getScreenLabel()
				 If Tewindow("TeWindow").TeScreen("label:="& MySLabel).exist(2) Then
					Tewindow("TeWindow").TeScreen("label:="& MySLabel).SendKey TE_ENTER
					wait 2
				End If
			End If
			If TeWindow("short name:=A").TeScreen("label:=screen27370").TeField("attached text:=ENTER\(protected\)", "text:=ENTER DESK CODE HERE.*").Exist(2) Then
				TeWindow("short name:=A").TeScreen("label:=screen27370").TeField("attached text:=ENTER DESK CODE HERE", "protected:=False").Set StrDCode
				wait 2
				MySLabel = getScreenLabel()
				 If Tewindow("TeWindow").TeScreen("label:="& MySLabel).exist(2) Then
					Tewindow("TeWindow").TeScreen("label:="& MySLabel).SendKey TE_ENTER
					wait 2
				End If
			End If

End Function

Function fnVDoVerifyTEText(actionObj, actionValue)
	Dim actionValueArr, dataToValidate

'	addressChange actionObj, actionValue
	
	'Wait 4
	WaitForNextScreen()
	If actionObj.Exist(2) Then
		Dim itext
		actionValueArr = split(actionValue, ",")
		dataToValidate = actionValueArr(0)
		If dataToValidate="" Then
			Exit Function
		End If
		itext = fnVDoGetText(actionObj,actionValue)

		If instr(1, dataToValidate, "DD::") <> 0 Then
			dataToValidate = replace(dataToValidate, "DD::", "")
			dataToValidate = Eval(dataToValidate)
		End If

		If Not Instr(1,Trim(itext), Trim(dataToValidate)) > 0 Then
			strGblRes = actionValueArr(0) & " Value Not found"
			ReportMessage "Fail", "Verify text failed - Expected text is '" & dataToValidate & "' and displayed text is '" & itext &"'. ", True, "Y"
    	Else
			ReportMessage "Pass", "Verify text passed - Expected text is '" & dataToValidate & "'. ", True, "Y"
		End If
		Call fnDoCheckError()
	Else
		strGblRes = strErrObjNotFound
	End If
	
End Function


Public Function fnVDoVerifyTETextOpt(ByVal actionObj, ByVal actionValue)
	Dim actionValueArr, validationDataArr, iText

	actionValueArr = Split(actionValue, "#~")
	validationDataArr = Split(actionValueArr(0), ",")

	iText = fnVDoGetText(actionObj, actionValueArr(0))
	If Instr(1, iText, validationDataArr(0)) > 0 Then
		fnVDoVerifyTEText actionObj, actionValueArr(1)
	End If
End Function
Public Function debug()
	wait(2)
End Function
Function fnSetScreen(ByVal actionObj, ByVal actionValue)
	Dim actionValueArr, dataToValidate, itext, screenText, screenLoaded, counter
	screenLoaded = True
	counter = 1
	checkEmulatorStatus()
	While screenLoaded
		If actionObj.Exist(1) Then
			actionValueArr = split(actionValue, ",")
			dataToValidate = actionValueArr(0)
			itext = fnVDoGetText(actionObj,actionValue)
			screenText = fnVDoGetText(actionObj,actionValueArr(0))
	
			If (Instr(1,Trim(itext), Trim(dataToValidate)) > 0) and (Instr(1, lcase(screenText), "abend") = 0) Then
				ReportMessage "Pass", "Screen '" & dataToValidate & "' loaded and there are no abends, so continuing with the execution. ", True, "Y"
				screenLoaded = False
			ElseIf counter>20 Then
				ReportMessage "Fail", "Screen '" & dataToValidate & "' is not loaded or there are abends, so skipping the execution. ", True, "Y"
				SetIterStatusFailure()
				screenLoaded = False
			Else
				Wait 1
			End If
		Else
			ReportMessage "Fail", "Mainframe application not displayed, so skipping the execution for current row. ", True, "Y"
			SetIterStatusFailure()
			Exit Function
		End If
		counter = counter + 1
	Wend
End Function
'================================================================================================================
''
'This function Captures the screenshot of input screen.Used to capture screen after filling data
'
'@ Function Name				fnCaptureScreen()
'@param Input - 				actionObj i.e TeScreen object,name of the screen and the coordinates
'@param Output - 				None
'@remarks	-	                None     				
'@Return	-					NA
'@author 	-					Venkat
'@version 					    V1.0					
'@date 							20/06/2016	
'================================================================================================================

Function fnCaptureScreen(ByVal actionObj, ByVal actionValue)
	Dim actionValueArr, dataToValidate, itext, screenText, screenLoaded, counter
	screenLoaded = True
	counter = 1
	
	While screenLoaded
		If actionObj.Exist(1) Then
			actionValueArr = split(actionValue, ",")
			dataToValidate = actionValueArr(0)
			itext = fnVDoGetText(actionObj,actionValue)
			screenText = fnVDoGetText(actionObj,actionValueArr(0))
	
			If (Instr(1,Trim(itext), Trim(dataToValidate)) > 0) and (Instr(1, lcase(screenText), "abend") = 0) Then
				ReportMessage "Pass", "Screen '" & dataToValidate & "' after filling the data.", True, "Y"
				screenLoaded = False
			ElseIf counter>10 Then
				ReportMessage "Fail", "Screen '" & dataToValidate & "' is not loaded or there are abends, so skipping the execution. ", True, "Y"
				SetIterStatusFailure()
				screenLoaded = False
			Else
				Wait 1
			End If
		Else
			ReportMessage "Fail", "Mainframe application not displayed, so skipping the execution for current row. ", True, "Y"
			SetIterStatusFailure()
			Exit Function
		End If
		counter = counter + 1
	Wend
End Function

Public Function fnSetScreenOpt(ByVal actionObj, ByVal actionValue)
	Dim actionValueArr, validationDataArr, iText

	actionValueArr = Split(actionValue, ",")

	iText = fnVDoGetText(actionObj, actionValue)
	If Instr(1, iText, actionValueArr(0)) > 0 Then
		fnSetScreen actionObj, actionValue
	End If
End Function

Function fnSetLogs(ByVal actionObj, ByVal actionValue)
   Dim actionValueArr
   Dim variableValue
 	If actionValue <> "" Then
		actionValueArr = split(actionValue, ",")
		For iter = 0 To Ubound(actionValueArr)
			If Instr(1, actionValueArr(iter), "DD::") > 0 Then
				paramArr = Split(actionValueArr(iter), "DD::")
				actionValue = Replace(actionValue, "DD::" & paramArr(1), Eval(paramArr(1)))
'			ElseIf Instr(1, actionValueArr(iter), "TP::PASS::") > 0 Then
'				paramArr = Split(actionValueArr(iter), "TP::PASS::")
'				actionValue = Replace(actionValue, "TP::PASS::" & paramArr(1), TestArgs(paramArr(1)))
'			ElseIf Instr(1, actionValueArr(iter), "TP::") > 0 Then
'				paramArr = Split(actionValueArr(iter), "TP::")
'				actionValue = Replace(actionValue, "TP::" & paramArr(1), TestArgs(paramArr(1)))
			End If
		Next
'		variableValue= actionValueArr(0)
'		If instr(1, variableValue, "DD::") <> 0 Then
'			variableValue = replace(variableValue, "DD::", "")
'			variableValue = Eval(variableValue)
'			ReportMessage "Info", actionValueArr(1) & " is " & variableValue , True, "N"
'		Else
'			ReportMessage "Info", actionValue, True, "N"
'		End If
	ReportMessage "Info", actionValue, True, "N"
	End If
End Function

Public Function fnSetLogsOpt(ByVal actionObj, ByVal actionValue)
	Dim actionValueArr, validationDataArr, iText

	actionValueArr = Split(actionValue, "#~")
	validationDataArr = Split(actionValueArr(0), ",")

	iText = fnVDoGetText(actionObj, actionValueArr(0))
	If Instr(1, iText, validationDataArr(0)) > 0 Then
		fnSetLogs actionObj, actionValueArr(1)
	Else
		ReportMessage "Info", "Screen name - " & validationDataArr(0) & " doesn't appeared. ", True, "N"
	End If
End Function

Function mapORObjects(strObjName)
	IActionObject = NULL
	Set xmlDoc = CreateObject("Msxml2.DOMDocument")
	xmlDoc.setProperty "SelectionLanguage", "XPath"
	xmlDoc.load(repPath)
	set obj = xmlDoc.selectSingleNode(".//node()[@Name = '"&strObjName&"']")
	
	mystr = "StartHere"
	call getActionObjects(obj,mystr)
	iairray = Split(mystr,",")
	For i= ubound(iairray) to lbound(iairray) step -1
		If Instr( iairray(i),"::")>0 Then
			Call setvActionObject(split(iairray(i),"::")(0),split(iairray(i),"::")(1))
		End If
	Next
End Function


Function getActionObjects(xmlNode,strObjList)
   If instr(xmlNode.nodename,"document")<1 Then
	
   If NOt isnull(xmlNode) AND NOT IsEmpty(xmlNode) Then
	If xmlNode.attributes.length>1 Then
		If  xmlNode.attributes(0).name ="Class" Then
		strObjList = strObjList & ","& xmlNode.attributes(0).Value
		strObjList = strObjList & "::"& xmlNode.attributes(1).Value
		End if
	End if
		Set iparent = xmlNode.parentNode
		If not isnull(iparent)Then
			Call getActionObjects(iparent,strObjList)
		End If
   End If
  End If
End Function

Function getScriptValue(strValue,TDDictObj)
	Dim ireturnValue, strSplitValue, splitParamArr, passwordParam
	passwordParam = False
	ireturnValue = strValue

	If Not(IsNull(strValue)) Then
		paramListArr = Split(strValue, ",")
		For paramNum = 0 To Ubound(paramListArr)
			If inStr(1,ucase(paramListArr(paramNum)),"TD::") >0 Then
				strSplitValue = split(paramListArr(paramNum),"TD::")
				ireturnValue1=TDDictObj.Item(Trim(strSplitValue(1)))  ' Manoj 
				ReportMessage "Info", "Entering Test data - " & strSplitValue(1) & " as " & ireturnValue1 & " on the screen. ", True, "N"
				ireturnValue = Replace(ireturnValue, "TD::" & strSplitValue(1), ireturnValue1)
			ElseIf inStr(1,ucase(paramListArr(paramNum)),"TDOPT::") >0 Then
				strSplitValue = split(paramListArr(paramNum),"TDOPT::")
				ireturnValue1=TDDictObj.Item(Trim(strSplitValue(1))) 
				If IsNull(ireturnValue1) Then
					ireturnValue1 = ""
					ReportMessage "Info", "Test data - " & strSplitValue(1) & " is not provided in the Scenario Sheet.", True, "Y"
					ireturnValue = Replace(ireturnValue, "TDOPT::" & strSplitValue(1), ireturnValue1)
				Else
					ReportMessage "Info", "Entering Test data - " & strSplitValue(1) & " as " & ireturnValue1 & " on the screen. ", True, "N"
					ireturnValue = Replace(ireturnValue, "TDOPT::" & strSplitValue(1), ireturnValue1)
				End If
					'The below elseif is added to handle the data read from scenario file where data is required only for validation.
			ElseIf inStr(1,ucase(paramListArr(paramNum)),"TDR::") >0 Then
				strSplitValue = split(paramListArr(paramNum),"TDR::")
				ireturnValue1=TDDictObj.Item(Trim(strSplitValue(1)))  
				ireturnValue = Replace(ireturnValue, "TDR::" & strSplitValue(1), ireturnValue1)
			ElseIf InStr(1, paramListArr(paramNum),"TP::") >0 Then
				If InStr(1, paramListArr(paramNum),"TP::PASS::") >0 Then
					strSplitValue = split(paramListArr(paramNum),"TP::PASS::")
					passwordParam = True
				Else
					strSplitValue = split(paramListArr(paramNum),"TP::")
				End If
				ireturnValue1 = TestArgs(strSplitValue(1))
	'			ReportMessage "Info", "Entering Test Parameter - " & splitParamArr(0) & " value as " & ireturnValue & " on the screen. ", True, "N"
				If passwordParam Then
					ireturnValue1 = DecryptPassword(ireturnValue1)
					ireturnValue = Replace(ireturnValue, "TP::PASS::" & strSplitValue(1), ireturnValue1)
				Else
					ireturnValue = Replace(ireturnValue, "TP::" & strSplitValue(1), TestArgs(strSplitValue(1)))
				End If
			ElseIf inStr(1,ucase(paramListArr(paramNum)),"ENV::") >0 Then
				strSplitValue = split(strValue,"ENV::")
				ireturnValue = Replace(ireturnValue, "ENV::" & strSplitValue(1), TestArgs(strSplitValue(1)))
		   End If
		Next
	End If

   If inStr(1,ireturnValue,"'")>0 Then
		ireturnValue = Replace(ireturnValue,"'","")
   End If

  getScriptValue= ireturnValue
End Function

'Function getScriptValue(strValue,TDDictObj)
'	Dim ireturnValue, strSplitValue, splitParamArr, passwordParam
'	passwordParam = False
'	ireturnValue = ""
'
'	If inStr(1,ucase(strValue),"TD::") >0 Then
'		strSplitValue = split(strValue,"TD::")
'		splitParamArr = split(strSplitValue(1), ",")
'		ireturnValue=TDDictObj.Item(Trim(splitParamArr(0)))  ' Manoj 
'		ReportMessage "Info", "Entering Test data - " & splitParamArr(0) & " as " & ireturnValue & " on the screen. ", True, "N"
'		ireturnValue = Replace(strValue, "TD::" & splitParamArr(0), ireturnValue)
'	ElseIf InStr(1, strValue,"TP::") >0 Then
'		If InStr(1, strValue,"TP::PASS::") >0 Then
'			strSplitValue = split(strValue,"TP::PASS::")
'			passwordParam = True
'		Else
'			strSplitValue = split(strValue,"TP::")
'		End If
'		splitParamArr = split(strSplitValue(1), ",")
'		ireturnValue = TestArgs(Trim(splitParamArr(0)))
''		ReportMessage "Info", "Entering Test Parameter - " & splitParamArr(0) & " value as " & ireturnValue & " on the screen. ", True, "N"
'		If passwordParam Then
'			ireturnValue = DecryptPassword(ireturnValue)
'			ireturnValue = Replace(strValue, "TP::PASS::" & splitParamArr(0), ireturnValue)
'		Else
'			ireturnValue = Replace(strValue, "TP::" & splitParamArr(0), TestArgs(splitParamArr(0)))
'		End If
'	Else 
'		if inStr(1,ucase(strValue),"ENV::") >0 Then
'			strSplitValue = split(strValue,"::")
'			ireturnValue=TestArgs(strSplitValue(1))
'		Else
'			ireturnValue=strValue
'		End If
'   End If
'
'   If inStr(1,ireturnValue,"'")>0 Then
'		ireturnValue = Replace(ireturnValue,"'","")
'   End If
'
'  getScriptValue= ireturnValue
'End Function

Public Function getSheetObject(ByVal objExcel, ByRef outputObjWbk, ByRef outputObjWst, ByVal outputSheetPath, ByVal outputSheetName, ByRef rCount, ByRef cCount)
	Dim outObjWbk:Set outObjWbk = objExcel.Workbooks.Open(outputSheetPath)
	Set outObjWst = outObjWbk.Worksheets(outputSheetName)

	rCount = outObjWst.UsedRange.rows.Count
	cCount = outObjWst.UsedRange.columns.Count

	Set outputObjWbk = outObjWbk
	Set outputObjWst = outObjWst
End Function

'======================================================================================
''
'This function will  Set  the data at run time  stored in  a global variable or from data table
'
'@ Function Name				fnVDoSetText(actionObj, actionValue)
'@param Input - 					actionObj - Screen object
'													actionValue - cursor  range of the screen where data wants to be capured E.g.  "1,30,
'@Return								NA
'@author 								Purnima
'@version 							  V1.0					
'@date 									08/19/2015	
'================================================================================================================

Function fnVDoSetText(actionObj,actionValue)
   Dim actionValueArr, dataToSet, coordinate1, coordinate2, paramValue
	If actionObj.Exist(2) then
		actionValueArr = split(actionValue, ",")
		dataToSet = actionValueArr(2)
		If instr(1, dataToSet, "DD::") <> 0 Then
			dataToSet = replace(dataToSet, "DD::", "")
			paramValue = Eval(dataToSet)
			coordinate1 = actionValueArr(0)
			coordinate2 = actionValueArr(1)
			actionObj.SetText coordinate1, coordinate2, paramValue 
'			ReportMessage "INFO", "Setting Value in field " & dataToSet & " as " & paramValue & "'. ", True, "Y"
		Else 
			actionObj.SetText actionValueArr(0), actionValueArr(1), actionValueArr(2)
		End If	
		Call fnDoCheckError()
	Else
		strGblRes=strErrObjNotFound
	End If
End Function

Public Function fnVDoSetTextOpt(ByVal actionObj, ByVal actionValue)
	Dim actionValueArr, validationDataArr, iText

	actionValueArr = Split(actionValue, "#~")
	validationDataArr = Split(actionValueArr(0), ",")

	iText = fnVDoGetText(actionObj, actionValueArr(0))
	If Instr(1, iText, validationDataArr(0)) > 0 Then
		fnVDoSetText actionObj, actionValueArr(1)
	End If
End Function

Public Function fnNavigate(actionObj, actionValue)
	dataToValidate = actionValueArr(0)
	itext = fnVDoGetText(actionObj,actionValue)
	
	While not instr(1,dataToValidate,itext)>0 
					
		MySLabel = getScreenLabel()
		Tewindow("TeWindow").TeScreen("label:="& MySLabel).Sendkey TE_ENTER	
		
	Wend

	
End Function

Function fnVDoOpenEXE(actionValue)
	SystemUtil.Run actionValue
	wait 1
	ReportMessage "INFO", "Opening the application from location - '" & actionValue & "'.", True, "N"
End Function

Public Function DecryptPassword(ByVal pwd)
	Dim oDesc, browserDesc, totalBrowsersOpened

	Set oDesc = Description.Create()
	oDesc("micclass").value="Browser"
	Set browserDesc = DeskTop.ChildObjects(oDesc)
	browsersOpened = browserDesc.Count
	SystemUtil.Run "iexplore.exe", "www.google.com", "","",7
	Set browserDesc = DeskTop.ChildObjects(oDesc)
	totalBrowsersOpened = browserDesc.Count

	If Browser("micclass:=Browser", "index:=" & totalBrowsersOpened-1).WinEdit("micclass:=WinEdit", "index:=" & totalBrowsersOpened-1).Exist Then
		Browser("micclass:=Browser", "index:=" & totalBrowsersOpened-1).WinEdit("micclass:=WinEdit", "index:=" & totalBrowsersOpened-1).SetSecure pwd
		DecryptPassword = Browser("micclass:=Browser", "index:=" & totalBrowsersOpened-1).WinEdit("micclass:=WinEdit", "index:=" & totalBrowsersOpened-1).GetROProperty("text")
		For loopStartNum = totalBrowsersOpened-1 To totalBrowsersOpened-browsersOpened-1 Step -1
			Browser("CreationTime:=" & loopStartNum).Close
		Next
	Else
		ReportMessage "Fail", "Decryption failed, please try again. ", True, "Y"
		DecryptPassword = pwd
	End If
End Function

Public Function saveData(ByVal actionObj, ByVal actionValue)
	Dim actionValueArr, itext, paramName
	
	Wait 2
	If actionObj.Exist Then
		actionValueArr = split(actionValue, ",")
		itext = actionObj.GetText(actionValueArr(2), actionValueArr(3), actionValueArr(4), actionValueArr(5))

		If instr(1, actionValueArr(0), "DD::") <> 0 Then
			paramName = replace(actionValueArr(0), "DD::", "")
		End If
		Execute(paramName & "=""" & itext & """")
	End If
End Function

Public Function fnVDoReplaceSpecialChar(ByVal actionObj, ByVal actionValue)
	Dim actionValueArr, paramName, paramValue

	If actionObj.Exist Then
		actionValueArr = split(actionValue, ",")
		If instr(1, actionValueArr(0), "DD::") <> 0 Then
			paramName = replace(actionValueArr(0), "DD::", "")
			paramValue = Replace(Eval(paramName), actionValueArr(1), actionValueArr(2))
			Execute(paramName & "=""" & paramValue & """")
		End If
	End If
End Function

Public Function fnVerifyName(ByVal actionObj, ByVal actionValue)

	If actionObj.Exist Then
		
		
		If Instr(trim(actionObj.GetText(7,9,7,30)),actionValue) > 0 Then
			ReportMessage"PASS","Expected is: "&actionValue,True,"Y"
		Else
			ReportMessage"FAIL","Expected is: "&actionValue&" Displayed is:"&trim(actionObj.GetText(7,9,7,30)),True,"Y"
			Exit Function
		End If
		strGblRes=strErrObjNotFound
    End If	
			
		
	

	
End Function

Public Function checkIf()

		If strCommand = "CHECKIF" Then
    				strValueArray = split(strValue,",")
					expectedDataToVerify= strValueArray(0)
					actualDataToVerify= strValueArray(1)
					flagValue = strValueArray(2)
					ConditionOpr = strValueArray(3)
           			If instr(1, actualDataToVerify, "DD::") <> 0 Then
						actualDataToVerify = replace(actualDataToVerify, "DD::", "")
						paramValue = Eval(actualDataToVerify)
					Else
						paramValue = actualDataToVerify
					End If
					Select Case  trim(ConditionOpr)
					Case "Equal"
						If  paramValue =  expectedDataToVerify <> 0 Then
							scriptRowNum = scriptRowNum
						Else
							For i = scriptRowNum+1 to totalScriptRowCount
								strCommand = GetDictItem(omegaVDataTableScriptDictObj, "COMMAND#" & i)
								If strCommand = flagValue Then
									scriptRowNum = i
									Exit For
								End If
							Next
						End If
					Case "LessThan"
						If  paramValue <  expectedDataToVerify <> 0 Then
							scriptRowNum = scriptRowNum
						Else
							For i = scriptRowNum+1 to totalScriptRowCount
								strCommand = GetDictItem(omegaVDataTableScriptDictObj, "COMMAND#" & i)
								If strCommand = flagValue Then
									scriptRowNum = i
									Exit For
								End If
							Next
						End If
					Case "GreaterThan"
						If  paramValue >  expectedDataToVerify <> 0 Then
							scriptRowNum = scriptRowNum
						Else
							For i = scriptRowNum+1 to totalScriptRowCount
								strCommand = GetDictItem(omegaVDataTableScriptDictObj, "COMMAND#" & i)
								If strCommand = flagValue Then
									scriptRowNum = i
									Exit For
								End If
							Next
						End If
					Case "NotEqual"
						If  paramValue <> expectedDataToVerify <> 0 Then
							scriptRowNum = scriptRowNum
						Else
							For i = scriptRowNum+1 to totalScriptRowCount
								strCommand = GetDictItem(omegaVDataTableScriptDictObj, "COMMAND#" & i)
								If strCommand = flagValue Then
									scriptRowNum = i
									Exit For
								End If
							Next
						End If
					End Select				
	End If
End Function					
'===============================================
Function fnMsgLogs(ByVal actionValue)
   	If actionValue <> "" Then
		ReportMessage "scenario", actionValue, True, "N"
	End If
End Function
'===============================================	

'===============================================
Function fnScreenShot()
ReportMessage "Info", "Captured Screenshot after Data Entry", True, "Y"
End Function
'===============================================


' This function will validate the screen name at given corrdinates

Public Function ValidateScreen(sr,sc,er,ec,scrName)
	MySLabel = getScreenLabel()
	ScreenName = Tewindow("TeWindow").TeScreen("label:="& MySLabel).GetText (sr,sc,er,ec)

	if ucase(ScreenName)=ucase(trim(scrName)) then
	 ReportMessage "Pass", "Successfully Navigated to "&scrName, False, "Y"
	 
	 else
	 ValidateScreen=-1
	 SetIterStatusFailure()
	 ReportMessage "Fail", "Not able to Navigate to "&scrName, False, "Y"
	 End if
End Function
Public Function keyLoginDetails(strMFUId,strMFPwd)
		wait 3
		TeWindow("TeWindow").Activate
		MySLabel = getScreenLabel()
		Tewindow("TeWindow").TeScreen("label:="& MySLabel).SetText 1,2,"TPX"
		Tewindow("TeWindow").TeScreen("label:="& MySLabel).Sendkey TE_ENTER
		Tewindow("TeWindow").TeScreen("label:="& MySLabel).Sync
		Wait 3
		WaitForNextScreen()
		MySLabel = getScreenLabel()
       	Tewindow("TeWindow").TeScreen("label:="& MySLabel).TeField("attached text:=Userid.*","index:=1").Set strMFUId 
		Tewindow("TeWindow").TeScreen("label:="& MySLabel).TeField("attached text:=Password.*","index:=1").SetSecure strMFPwd
		wait 3
		WaitForNextScreen()
		Tewindow("TeWindow").TeScreen("label:="& MySLabel).SendKey TE_ENTER
		WaitForNextScreen()
	Call checkExtraScreen()
End Function
'Author -Diwakar
Public Function LoginMainFrame(strMFUId,strMFPwd,MF_Environment)
	
	Set Process = GetObject("Winmgmts:\\")
	Set oMFProcess = Process.ExecQuery("Select * from Win32_Process where Name = 'bzmd.exe' ")
	If oMFProcess.Count > 0 Then
		Exit_Mainframe_InMiddle()
		call keyLoginDetails(strMFUId,strMFPwd)
		
	Else
		If MF_Environment="SYST" Then
			Systemutil.Run "C:\Programdata\Microsoft\Windows\Start Menu\Aflac Apps\Bluezone Systest", "", "", "Open"
		ElseIf MF_Environment="INTG" Then
			Systemutil.Run "C:\Programdata\Microsoft\Windows\Start Menu\Aflac Apps\Bluezone Development", "", "", "Open"
		End If
		
		call keyLoginDetails(strMFUId,strMFPwd)
		
	End If
	
	
End Function

Public Function LoginIntoMainFrame(strMFUId, strMFPwd)
	
	Set Process = GetObject("Winmgmts:\\")
	Set oMFProcess = Process.ExecQuery("Select * from Win32_Process where Name = 'bzmd.exe' ")
	If oMFProcess.Count > 0 Then
		Exit_Mainframe_InMiddle()
		call keyLoginDetails(strMFUId,strMFPwd)
	Else
		If MF_Environment="SYST" Then
			Systemutil.Run "C:\Programdata\Microsoft\Windows\Start Menu\Aflac Apps\Bluezone Systest", "", "", "Open"
		ElseIf MF_Environment="INTG" Then
			Systemutil.Run "C:\Programdata\Microsoft\Windows\Start Menu\Aflac Apps\Bluezone Development", "", "", "Open"
		End If
		Systemutil.Run Trim(TestArgs("exePath")), "", "", "Open"
'		Systemutil.Run Trim(TestArgs("BZPath")), "", "", "Open"
		call keyLoginDetails(strMFUId,strMFPwd)
		
	End If
	
End Function

Public Function Exit_Mainframe_Relogin_OmegaLite()
		LoginIntoMainFrame strMFUId,strMFPwd 
		
		If Instr(1,lcase(TestArgs ("exePath")),"bluezone development")>0 Then
			If TestArgs("Region") = "COL" Then
				MySLabel = getScreenLabel()
				Tewindow("TeWindow").TeScreen("label:="& MySLabel).Sendkey "I CICSQTOR"
				Tewindow("TeWindow").TeScreen("label:="& MySLabel).Sendkey TE_ENTER
				wait 1
				MySLabel = getScreenLabel()
				Tewindow("TeWindow").TeScreen("label:="& MySLabel).Sendkey "CICSQTOR"
				Tewindow("TeWindow").TeScreen("label:="& MySLabel).Sendkey TE_ENTER
				wait 1
			Else
				MySLabel = getScreenLabel()
				Tewindow("TeWindow").TeScreen("label:="& MySLabel).Sendkey "I CICSQNYL"
				Tewindow("TeWindow").TeScreen("label:="& MySLabel).Sendkey TE_ENTER
				wait 1
				MySLabel = getScreenLabel()
				Tewindow("TeWindow").TeScreen("label:="& MySLabel).Sendkey "CICSQNYL"
				Tewindow("TeWindow").TeScreen("label:="& MySLabel).Sendkey TE_ENTER
				wait 1
			End If 
		Else
			If TestArgs("Region") = "COL" Then
				MySLabel = getScreenLabel()
				Tewindow("TeWindow").TeScreen("label:="& MySLabel).Sendkey "I CICST"
				Tewindow("TeWindow").TeScreen("label:="& MySLabel).Sendkey TE_ENTER
				wait 1
				MySLabel = getScreenLabel()
				Tewindow("TeWindow").TeScreen("label:="& MySLabel).Sendkey "CICST"
				Tewindow("TeWindow").TeScreen("label:="& MySLabel).Sendkey TE_ENTER
			ElseIf TestArgs("Region") = "NY" Then
				MySLabel = getScreenLabel()
				Tewindow("TeWindow").TeScreen("label:="& MySLabel).Sendkey "I CICSPNYL"
				Tewindow("TeWindow").TeScreen("label:="& MySLabel).Sendkey TE_ENTER
				wait 1
				MySLabel = getScreenLabel()
				Tewindow("TeWindow").TeScreen("label:="& MySLabel).Sendkey "CICSPNYL"
				Tewindow("TeWindow").TeScreen("label:="& MySLabel).Sendkey TE_ENTER
			End If 
		End If
		MySLabel = getScreenLabel()
		Tewindow("TeWindow").TeScreen("label:="& MySLabel).Sendkey  "NTRO"
		Tewindow("TeWindow").TeScreen("label:="& MySLabel).Sendkey TE_ENTER
End Function

Public Function WaitForNextScreen()
	
	emulatorStatus = lcase(Tewindow("TeWindow").GetROProperty("emulator status"))
	While emulatorStatus <> "ready"
		wait 0, 300
		emulatorStatus = lcase(Tewindow("TeWindow").GetROProperty("emulator status"))
	Wend	
	
	wait 0,300
	
End Function

Public Function Exit_Mainframe_Relogin_OmegaV()
		LoginIntoMainFrame strMFUId,strMFPwd 
		If Instr(1,exeFilePath,"Development")>0 Then
			If TestArgs("Region") = "COL" Then
				MySLabel = getScreenLabel()
				Tewindow("TeWindow").TeScreen("label:="& MySLabel).Sendkey "I CICSQTOR"
				Tewindow("TeWindow").TeScreen("label:="& MySLabel).Sendkey TE_ENTER
				WaitForNextScreen()
				MySLabel = getScreenLabel()
				Tewindow("TeWindow").TeScreen("label:="& MySLabel).Sendkey "CICSQTOR"
				Tewindow("TeWindow").TeScreen("label:="& MySLabel).Sendkey TE_ENTER
				WaitForNextScreen()
			ElseIf TestArgs("Region") = "NY" Then
				MySLabel = getScreenLabel()
				Tewindow("TeWindow").TeScreen("label:="& MySLabel).Sendkey "I CICSQNYL"
				Tewindow("TeWindow").TeScreen("label:="& MySLabel).Sendkey TE_ENTER
				WaitForNextScreen()
				MySLabel = getScreenLabel()
				Tewindow("TeWindow").TeScreen("label:="& MySLabel).Sendkey "CICSQNYL"
				Tewindow("TeWindow").TeScreen("label:="& MySLabel).Sendkey TE_ENTER
				WaitForNextScreen()
			End If 
		Else
			If TestArgs("Region") = "COL" Then
				MySLabel = getScreenLabel()
				Tewindow("TeWindow").TeScreen("label:="& MySLabel).Sendkey "I CICST"
				Tewindow("TeWindow").TeScreen("label:="& MySLabel).Sendkey TE_ENTER
				WaitForNextScreen()
				MySLabel = getScreenLabel()
				Tewindow("TeWindow").TeScreen("label:="& MySLabel).Sendkey "CICST"
				Tewindow("TeWindow").TeScreen("label:="& MySLabel).Sendkey TE_ENTER
				WaitForNextScreen()
			ElseIf TestArgs("Region") = "NY" Then
				MySLabel = getScreenLabel()
				Tewindow("TeWindow").TeScreen("label:="& MySLabel).Sendkey "I CICSPNYL"
				Tewindow("TeWindow").TeScreen("label:="& MySLabel).Sendkey TE_ENTER
				WaitForNextScreen()
				MySLabel = getScreenLabel()
				Tewindow("TeWindow").TeScreen("label:="& MySLabel).Sendkey "CICSPNYL"
				Tewindow("TeWindow").TeScreen("label:="& MySLabel).Sendkey TE_ENTER
				WaitForNextScreen()
			End If 
		End If
		MySLabel = getScreenLabel()
		Tewindow("TeWindow").TeScreen("label:="& MySLabel).Sendkey "NTRL"
		Tewindow("TeWindow").TeScreen("label:="& MySLabel).Sendkey TE_ENTER
		WaitForNextScreen()
End Function

Public Function fnGetTextFromScreenIntoAVariable(ByVal actionObj, ByVal actionValue)

	Dim actionValueArr
	Dim actionValueParamArr
	Dim strTempText, paramName
	
	strTempText = ""
	
	Wait 2
	If actionObj.Exist Then
		
		actionValueArr = split(actionValue, ",")
		If instr(1, actionValueArr(0), "DD::") <> 0 Then
			paramName = replace(actionValueArr(0), "DD::", "")
		End If
		
		Execute(paramName & "=""" & strTempText & """")
		
		strTempText = Trim(actionObj.GetText(actionValueArr(1), actionValueArr(2), actionValueArr(3), actionValueArr(4)))
		Execute(paramName & "=""" & strTempText & """")

	End If
	
End Function

Public Function fnsetDeskCode()

	WaitForNextScreen()
	dskCode=TestArgs("MFDeskCode")	
	MySLabel = getScreenLabel()
	strTmpText = Tewindow("TeWindow").TeScreen("label:="& MySLabel).GetText (21,26,21,45)
	
	If strTmpText = "ENTER DESK CODE HERE" Then
		MySLabel = getScreenLabel()
		Tewindow("TeWindow").TeScreen("label:="& MySLabel).SetText 21,53,dskCode
		ReportMessage "Info", "Desk Code Entered as :" & dskCode, True, "Y"
		Tewindow("TeWindow").TeScreen("label:="& MySLabel).Sendkey TE_ENTER
	Else
		ReportMessage "Info", "Screen to Enter Desk Code did not appear.", True, "N"
	End If
	WaitForNextScreen()
	
End Function

Function fnScreenShotWithMessage(ByVal actionValue)
ReportMessage "Info", actionValue, True, "Y"
End Function

Public Function getScreenId()
	wait 1
					Set objTeScreens = Description.Create()
				    objTeScreens("micclass").Value = "TeScreen"
					Set objTeList = Tewindow("TeWindow").ChildObjects(objTeScreens)
                	scrId =  objTeList(0).GetROProperty("screen id")
					getScreenId = scrId
End Function



Function fnVDoVerifyTETextWithMsg(actionObj, actionValue)
	Dim actionValueArr, dataToValidate
	WaitForNextScreen()
	If actionObj.Exist(2) Then
		Dim itext
		actionValueArr = split(actionValue, ",")
		dataToValidate = actionValueArr(0)
		If dataToValidate="" Then
			Exit Function
		End If
		'actionValue=replace (actionValue, actionValueArr(5),"")
		itext = fnVDoGetText(actionObj,actionValue)

		If instr(1, dataToValidate, "DD::") <> 0 Then
			dataToValidate = replace(dataToValidate, "DD::", "")
			dataToValidate = Eval(dataToValidate)
		End If

		If Not Instr(1,Trim(itext), Trim(dataToValidate)) > 0 Then
			strGblRes = actionValueArr(0) & " Value Not found"
			ReportMessage "Fail", "Verify text failed - Expected " &actionValueArr(5)& " is '" &dataToValidate& "' and displayed text is '" &itext& "'.", True, "Y"
    	Else
			ReportMessage "Pass", "Verify text passed - Expected " &actionValueArr(5)& " is '" &dataToValidate& "' and displayed text is '" &itext& "'.", True, "Y"
		End If
		Call fnDoCheckError()
	Else
		strGblRes = strErrObjNotFound
	End If
	
End Function

Function fnVDoNavigateAndVerifyTEText(actionObj, actionValue)
	Dim actionValueArr, dataToValidate,i

'	addressChange actionObj, actionValue
	
	'Wait 4
	WaitForNextScreen()
	If actionObj.Exist(2) Then
		Dim itext
		actionValueArr = split(actionValue, ",")
		dataToValidate = actionValueArr(0)
		itext = trim(fnVDoGetText(actionObj,actionValue))
		itext = ucase(itext)
		
		If instr(1, dataToValidate, "DD::") <> 0 Then
			dataToValidate = replace(dataToValidate, "DD::", "")
			dataToValidate = Eval(dataToValidate)
			dataToValidate = UCASE(dataToValidate)
		End If
		For i = 1 To 6 Step 1
			If Not Instr(1,Trim(itext), Trim(dataToValidate)) > 0 Then
				
				IF Tewindow("TeWindow").TeScreen("label:=.*").TeField("attached text:=YES NO","visible:=True").exist(2) then
					Tewindow("TeWindow").TeScreen("label:=.*").Sendkey "Y"
					wait 1
					ReportMessage "Info", "Screenshot for the popup", True, "Y"
					IF Tewindow("TeWindow").TeScreen("label:=.*").TeField("attached text:=YES NO","visible:=True").exist(0) then
						Tewindow("TeWindow").TeScreen("label:=.*").Sendkey "@8" 
						'Wait 1
						WaitForNextScreen()
					End If
				ElseIf Tewindow("TeWindow").TeScreen("label:=.*").GetText(1,2,1,42) = "ERROR. DOWNGRADE FLAG MUST BE 'Y' OR 'N'." Then
					strDownGrade = GetDictItem(cappsScenarioDictObj, "DownGrade#" & strRowNum)
			    	If IsNull(strDownGrade) = True or strDownGrade="" Then
			    		strDownGrade = "N"
			    	End If
			    	Tewindow("TeWindow").TeScreen("label:=.*").SetText 39,23,strDownGrade
	   				wait 1
		    		ReportMessage "Info", "DownGrade Flag is Entered as:"&strDownGrade, True, "Y"
					Tewindow("TeWindow").TeScreen("label:=.*").SendKey TE_ENTER	
					WaitForNextScreen()					
					
				Else
					Tewindow("TeWindow").TeScreen("label:=.*").SendKey TE_ENTER
					
				End If
					WaitForNextScreen()
			    	itext = fnVDoGetText(actionObj,actionValue)
		    Else
			    ReportMessage "Pass", "Verify text passed - Expected text is '" & dataToValidate & "'. ", True, "Y"
			    Exit For
		    End If
		Next
		If i>6 Then
			strGblRes = actionValueArr(0) & " Value Not found"
			ReportMessage "Fail", "Verify text failed - Expected text is '" & dataToValidate & "' and displayed text is '" & itext &"'. ", True, "Y"
			SetIterStatusFailure()
		End If
		Call fnDoCheckError()
	Else
		strGblRes = strErrObjNotFound
	End If
	
End Function
Function fnVDoNavigateAndVerifyTETextWithComma(actionObj, actionValue)
	Dim actionValueArr, dataToValidate,i,strCoordinates

'	addressChange actionObj, actionValue
	
	'Wait 4
	WaitForNextScreen()
	If actionObj.Exist(2) Then
		Dim itext
		actionValueArr = split(actionValue, "#")
		dataToValidate = actionValueArr(0)
		strCoordinates = split(actionValueArr(1),",")
		itext = Tewindow("TeWindow").TeScreen("label:=.*").GetText(strCoordinates(0),strCoordinates(1),strCoordinates(2),strCoordinates(3))
		itext = ucase(itext)
		
		If instr(1, dataToValidate, "DD::") <> 0 Then
			dataToValidate = replace(dataToValidate, "DD::", "")
			dataToValidate = Eval(dataToValidate)
			dataToValidate = UCASE(dataToValidate)
		End If
		For i = 1 To 6 Step 1
			If Not Instr(1,Trim(itext), Trim(dataToValidate)) > 0 Then
				Tewindow("TeWindow").TeScreen("label:=.*").SendKey TE_ENTER
				WaitForNextScreen()
		    	itext = Tewindow("TeWindow").TeScreen("label:=.*").GetText(strCoordinates(0),strCoordinates(1),strCoordinates(2),strCoordinates(3))
		    Else
			    ReportMessage "Pass", "Verify text passed - Expected text is '" & dataToValidate & "'. ", True, "Y"
			    Exit For
		    End If
		Next
		If i>6 Then
			strGblRes = actionValueArr(0) & " Value Not found"
			ReportMessage "Fail", "Verify text failed - Expected text is '" & dataToValidate & "' and displayed text is '" & itext &"'. ", True, "Y"
			SetIterStatusFailure()
		End If
		Call fnDoCheckError()
	Else
		strGblRes = strErrObjNotFound
	End If
	
End Function

Public Function NavigateAndVerifyTeTextByPressingAnyKey(actionObj, actionValue)
	WaitForNextScreen()
	If actionObj.Exist(2) Then
		Dim itext
		actionValueArr = split(actionValue, "#")
		'dataToValidate = actionValueArr(1)
		strArray = split(actionValueArr(1),",")
		dataToValidate = trim(strArray(0))
		itext = Tewindow("TeWindow").TeScreen("label:=.*").GetText(strArray(1),strArray(2),strArray(3),strArray(4))
		itext = ucase(itext)
		
		If instr(1, dataToValidate, "DD::") <> 0 Then
			dataToValidate = replace(dataToValidate, "DD::", "")
			dataToValidate = Eval(dataToValidate)
			dataToValidate = UCASE(dataToValidate)
		End If
		For i = 1 To 15 Step 1
			If Not Instr(1,Trim(itext), Trim(dataToValidate)) > 0 Then
				Tewindow("TeWindow").TeScreen("label:=.*").SendKey actionValueArr(0)
				WaitForNextScreen()
		    	itext = Tewindow("TeWindow").TeScreen("label:=.*").GetText(strArray(1),strArray(2),strArray(3),strArray(4))
		    Else
			    ReportMessage "Pass", "Verify text passed - Expected text is '" & dataToValidate & "'. ", True, "Y"
			    Exit For
		    End If
		Next
		If i>15 Then
			strGblRes = actionValueArr(0) & " Value Not found"
			ReportMessage "Fail", "Verify text failed - Expected text is '" & dataToValidate & "' and displayed text is '" & itext &"'. ", True, "Y"
			SetIterStatusFailure()
		End If
		Call fnDoCheckError()
	Else
		strGblRes = strErrObjNotFound
	End If
End Function


Function fnVDoVerifyTaxStatus(actionObj)
	Dim dataToValidate,i

'	addressChange actionObj, actionValue
	
	'Wait 4
	WaitForNextScreen()
	If actionObj.Exist(2) Then
		Dim itext
		
		dataToValidate = "TAX STATUS MUST MATCH THE BASE PLAN'S"
		itext = actionObj.GetText(1,2,1,38)
		itext = ucase(itext)
		
		For i = 1 To 6 Step 1
			If Not Instr(1,Trim(itext), Trim(dataToValidate)) > 0 Then
				
				IF Tewindow("TeWindow").TeScreen("label:=.*").TeField("attached text:=YES NO","visible:=True").exist(2) then
					Tewindow("TeWindow").TeScreen("label:=.*").Sendkey "Y"
					wait 1
					ReportMessage "Info", "Screenshot for the popup", True, "Y"
					IF Tewindow("TeWindow").TeScreen("label:=.*").TeField("attached text:=YES NO","visible:=True").exist(0) then
						Tewindow("TeWindow").TeScreen("label:=.*").Sendkey "@8" 
						'Wait 1
						WaitForNextScreen()
					End If
				ElseIf Tewindow("TeWindow").TeScreen("label:=.*").GetText (1,2,1,42) = "ERROR. DOWNGRADE FLAG MUST BE 'Y' OR 'N'." Then
					strDownGrade = GetDictItem(cappsScenarioDictObj, "DownGrade#" & strRowNum)
			    	If IsNull(strDownGrade) = True or strDownGrade="" Then
			    		strDownGrade = "N"
			    	End If
			    	Tewindow("TeWindow").TeScreen("label:=.*").SetText 39,23,strDownGrade
			    	wait 1
			    	ReportMessage "Info", "DownGrade Flag is Entered as:"&strDownGrade, True, "Y"
			    	Tewindow("TeWindow").TeScreen("label:=.*").SendKey TE_ENTER
			    	WaitForNextScreen()
	   			Else
					Tewindow("TeWindow").TeScreen("label:=.*").SendKey TE_ENTER
				End If
				WaitForNextScreen()
				itext = Tewindow("TeWindow").TeScreen("label:=.*").GetText(1,2,1,38)
			    
		    Else
			    ReportMessage "Pass", "Verify text passed - Expected text is '" & dataToValidate & "'. ", True, "Y"
			    Exit For
		    End If
		Next
		If i>6 Then
			strGblRes = dataToValidate & " Value Not found"
			ReportMessage "Fail", "Verify text failed - Expected text is '" & dataToValidate & "' and displayed text is '" & itext &"'. ", True, "Y"
			SetIterStatusFailure()
		End If
		Call fnDoCheckError()
	Else
		strGblRes = strErrObjNotFound
	End If
	
End Function

'Author Diwakar

Public Function NavigateScreen(byval sr,byval sc,byval er,byval ec,byval TextToVerify)
Dim ScreenText,flag
flag=0
    
Do
    scrid = getScreenId()
    WaitForNextScreen()
    'wait 2
    'wait 6
    currentText=Tewindow("TeWindow").TeScreen("screen id:="&scrid).GetText (sr,sc,er,ec)
    
    If TextToVerify=currentText Then
        Flag=1
        Exit Do
    End If
    scrid = getScreenId()
    WaitForNextScreen()
    'wait 2
    Tewindow("TeWindow").TeScreen("screen id:="&scrid).Sendkey TE_ENTER
    wait 1
Loop While  flag<>1

End Function

'Author Diwakar
Function getScreenId()
    wait 1
    Set objTeScreens = Description.Create()
    objTeScreens("micclass").Value = "TeScreen"
    Set objTeList = Tewindow("TeWindow").ChildObjects(objTeScreens)
    scrId =  objTeList(0).GetROProperty("screen id")
    getScreenId = scrId
End Function
'Author Diwakar

Public Function EnterCICSRegion(Region)
	
	If Region = "COL" Then
		MySLabel = getScreenLabel()
		Tewindow("TeWindow").TeScreen("label:="& MySLabel).Sendkey "I CICST"
		Tewindow("TeWindow").TeScreen("label:="& MySLabel).Sendkey TE_ENTER
		WaitForNextScreen
		
		MySLabel = getScreenLabel()
		Tewindow("TeWindow").TeScreen("label:="& MySLabel).Sendkey "CICST"
		Tewindow("TeWindow").TeScreen("label:="& MySLabel).Sendkey TE_ENTER
		WaitForNextScreen
		
	ElseIf Region = "NY" Then
		MySLabel = getScreenLabel()
		Tewindow("TeWindow").TeScreen("label:="& MySLabel).Sendkey "I CICSPNYL"
		Tewindow("TeWindow").TeScreen("label:="& MySLabel).Sendkey TE_ENTER
		WaitForNextScreen
		
		MySLabel = getScreenLabel()
		Tewindow("TeWindow").TeScreen("label:="& MySLabel).Sendkey "CICSPNYL"
		Tewindow("TeWindow").TeScreen("label:="& MySLabel).Sendkey TE_ENTER
		WaitForNextScreen
	
	End If 
	
End Function



'Added by Amit to get the blinking Warning message from screen into a variable.
Public Function fnGetBlinkingTextFromAPPSScreenIntoAVariable(ByVal intTopRow, ByVal intTopCol, ByVal intBottomRow, ByVal intBottomCol)

	Dim strTempText
	
	strTempText = ""
	
	MySLabel = getScreenLabel()
	strTempText = Trim(Tewindow("TeWindow").TeScreen("label:="&MySLabel).GetText(intTopRow,intTopCol,intBottomRow,intBottomCol))

	Dim i 
	i = 0
	While strTempText = "" And i <100
		strTempText = Trim(Tewindow("TeWindow").TeScreen("label:="&MySLabel).GetText(intTopRow,intTopCol,intBottomRow,intBottomCol))
		i = i + 1
	Wend	

	fnGetBlinkingTextFromAPPSScreenIntoAVariable = strTempText
End Function
Public Function LoginIntoMainFrame_And_EnterIntoRegion()
	Exit_Mainframe_Relogin_OmegaLite ()
End Function

Public Function fnValidateSurrenderDate(ByVal actionObj)
	checkEmulatorStatus ()
	If actionObj.Exist(2) Then
		Dim strStatus, strSurrenderDate
		strStatus = actionObj.GetText(4,10,4,20)
		strSurrenderDate = actionObj.GetText(31,73,31,80)
		strCurrentDate = actionObj.GetText(02,71,02,78)
		
		If Instr(1,Trim(strSurrenderDate), "00/00/00") > 0 Then
			strGblRes = "Expected Surrender Date NOT found"
			ReportMessage "Fail", "Verify text failed - Status is <b>'" & Trim(strStatus) & "' </b>and Surrender Date is : <b>"&Trim(strSurrenderDate)&"</b>", True, "Y"
		Else
			If UCASE(Trim(strStatus)) = "ACTIVE" Then
				If CDATE(trim(strSurrenderDate)) < CDATE(trim(strCurrentDate)) Then
					ReportMessage "Pass", "As Expected : Surrender Date : <b>"&strSurrenderDate&"</b> is less than Current Date : <b>"&strCurrentDate&"</b>", True, "Y"
		    	Else
					strGblRes = "Expected Surrender Date NOT found"
					ReportMessage "Info", "Status is <b>'" & Trim(strStatus) & "' </b>and Surrender Date : <b>"&strSurrenderDate&"</b> is Greater than Current Date : <b>"&strCurrentDate&"</b>", True, "Y"
					ReportMessage "Fail", "Surrender Date should be Less Than Current Date.", True, "Y"
				End If
			ElseIf UCASE(Trim(strStatus)) = "TERMINATED" Then
				If CDATE(trim(strSurrenderDate)) > CDATE(trim(strCurrentDate)) Then
					ReportMessage "Pass", "As Expected : Surrender Date : <b>"&strSurrenderDate&"</b> is Greater than Current Date : <b>"&strCurrentDate&"</b>", True, "Y"
		    	Else
		    		strGblRes = "Expected Surrender Date NOT found"
					ReportMessage "Info", "Status is <b>'" & Trim(strStatus) & "' </b>and Surrender Date : <b>"&strSurrenderDate&"</b> is less than Current Date : <b>"&strCurrentDate&"</b>", True, "Y"
					ReportMessage "Fail", "Surrender Date should be Greater Than Current Date.", True, "Y"
				End If
			End If
		End If
	End If
End Function

Function checkExtraScreen()
	WaitForNextScreen()
	Wait 1
	 MySLabel = getScreenLabel()
	  IspfScr=Tewindow("TeWindow").TeScreen("label:="& MySLabel).getText (1,27,1,30)
	  ISPFFlag=False
	  If IspfScr="ISPF" Then
	  	
	  	MySLabel = getScreenLabel()
	  	Tewindow("TeWindow").TeScreen("label:="& MySLabel).Sendkey TE_ERASE_EOF
		Tewindow("TeWindow").TeScreen("label:="& MySLabel).setText 2,15,"X"
	  	Tewindow("TeWindow").TeScreen("label:="& MySLabel).sendkey TE_ENTER
	  	WaitForNextScreen()
	  	 ISPFFlag=True
	  End If
  	checkExtraScreen=ISPFFlag
  	
End Function










Public Function fnDoAccouting (strPolicy, strAdvisePolicy, strAdviseNumber)
	
	If fnGetText (2,29,2,47) = "MAIN MENU SELECTION" Then
		ReportMessage "Info", "Application is on NTRL Screen.", true, "Y"
	Else
		ReportMessage "Info", "Application is NOT on NTRL Screen", true, "Y"
		fnDoAccouting = -1
		Exit Function 
	End If
	
	fnWriteOnscreen 40, 39, "72", "Main Menu Option: ", "Y"

	SendKeyOnScreen "TE_ENTER"
	
	fnSetCAPPSDeskCodeForConversion ()		'Works for Omega V as well... 
	
	fnWriteOnscreen 36, 33, strPolicy, "Entering Policy Number: ", "Y"
	
	If fnNavigateToScreenByPressingENTER ("", rowNum, "SCREEN ONE", 4, 35, 4, 44) = -1 Then
		fnDoAccouting = -1
		Exit Function 
	End If
	
	strStatus = fnGetText (6,46,6, 47)
	
	If strStatus = "13" Then
		ReportMessage "Info", "Policy is in 13 Status. Now Proceeding to do the accounting.", true, "Y"
	Else
		If strStatus = "22" Then
			ReportMessage "Info", "Policy is in 22 Status. Now Exiting the accounting function.", true, "Y"
			fnDoAccouting = 0
			Exit Function 
		Else
			ReportMessage "Info", "Policy is Not in 13 or in 22 status Status. Now exiting the function", true, "Y"
			fnDoAccouting = -1
			Exit Function 
		End If
		
	End If
	
	strPaidToDate = fnGetText(26,19,26,26)
	strCurrentSysDate = fnGetText(4,69,4,78)
	
	SendKeyOnScreen "TE_ENTER"
	SendKeyOnScreen "TE_ENTER"
	
	strPaidToDate = GetDateFormatted(strPaidToDate,"MM/DD/YY")
	strCurrentSysDate = GetDateFormatted(strCurrentSysDate,"MM/DD/YY")
	
	strAccountingMonths = Abs(DateDiff("m",strPaidToDate,strCurrentSysDate))
	
	If strAccountingMonths < 10 Then
		strAccountingMonths= "0" & strAccountingMonths
	End If
		
	If strAccountingMonths = "00" Then	strAccountingMonths = "01"
		
	'Checking if the premium is being greater than 1000, then do not do the accounting. 
	strMode = cdbl(fnGetText(25,19,25,20))
	strPrem = cdbl(fnGetText(28,19,28,31))
	strPrem = strPrem/strMode
	fnTotalPremium = FormatNumber(strPrem*strAccountingMonths, 2)
	
	If cdbl(fnTotalPremium) >= 1000 Then
		ReportMessage"Info", "Not Doing accounting as the premium to be paid till syst date >= $1000",True,"N"
		fnDoAccouting = -1
		Exit Function 
	End If
		
	If fnPressKeyAndNavigateToScreen ("TE_PF19", "ACCOUNTING SCREEN",  4, 32, 4, 48) = -1 Then
		fnDoAccouting = -1
		Exit Function
	End If
	
	fnWriteOnscreen 27, 62, strAccountingMonths, "No Of Months:", "Y"
	SendKeyOnScreen "TE_ENTER"
	
	strPremium = fnGetText(27,32,27,42)
	strPremium = cdbl(trim(replace(strPremium,"_","")))
	
	fnWriteOnscreen 31,72,"Y", "ENTER 'Y' VIEW SUSP.:", "Y"
	ReportMessage "Info","Screen shot after entering number of months and View Suspense",True,"Y"
	
	SendKeyOnScreen "TE_ENTER"
	
	wait 2
	fnWriteOnscreen 14,32,"F", "F/T", "N"
	fnWriteOnscreen 14,35,strAdvisePolicy, "Advise Policy:", "N"
	fnWriteOnscreen 14,45,strAdviseNumber, "Advise Number:", "N"
	fnWriteOnscreen 14,70,strPremium, "Premium Amount:", "Y"
	
	SendKeyOnScreen "TE_ENTER"
	
	ReportMessage"Info","Screen shot after entering AdvisePolicy ,AdviseNumber and Premium. Now pressing F6.",True,"Y"
	SendKeyOnScreen "TE_PF6"
	wait 1
	Tewindow("TeWindow").TeScreen("label:=.*").SendKey TE_PF13
	WaitForNextScreen ()
	strMsg = Tewindow("TeWindow").TeScreen("label:=.*").GetText(1,2,1,16)
	If strMsg="GOOD COMPLETION" Then
		ReportMessage"PASS","Expected Message 'GOOD COMPLETION' is displayed",True,"Y"
		flag = true 
		fnDoAccouting = 0
		SendKeyOnScreen "TE_PF3"
		Exit Function
	End If
	
	strMsg = fnGetText(1,9,1,45)
	
	If strMsg="FUNDS SHOULD BE APPLIED TO G3 TRAILER" Then
	
		Tewindow("TeWindow").TeScreen("label:=.*").SetCursorPos 27,32
		Tewindow("TeWindow").TeScreen("label:=.*").SendKey "@F"
		WaitForNextScreen ()
		Tewindow("TeWindow").TeScreen("label:=.*").SetCursorPos 27,44
		Tewindow("TeWindow").TeScreen("label:=.*").SendKey "@F"
		WaitForNextScreen ()
		Tewindow("TeWindow").TeScreen("label:=.*").SetCursorPos 25,32
		Tewindow("TeWindow").TeScreen("label:=.*").SendKey "@F"
		WaitForNextScreen ()
		Tewindow("TeWindow").TeScreen("label:=.*").SetText 25,32,strPremium
		Tewindow("TeWindow").TeScreen("label:=.*").SetText 25,44,"X"
		ReportMessage"Info","Screen shot after clearing policy this field and entering G3 Amount",True,"Y"
		Tewindow("TeWindow").TeScreen("label:=.*").SendKey TE_ENTER
		WaitForNextScreen ()
		Tewindow("TeWindow").TeScreen("label:=.*").SendKey TE_PF13
		WaitForNextScreen ()
		strMsg = Tewindow("TeWindow").TeScreen("label:=.*").GetText(1,2,1,16)
		If strMsg="GOOD COMPLETION" Then
			ReportMessage"PASS","Expected Message 'GOOD COMPLETION' is displayed",True,"Y"
			flag = true
			fnDoAccouting = 0
			SendKeyOnScreen "TE_PF3"
			Exit Function
		End If
		
	End If
	
	If flag = false Then
		fnDoAccouting = -1
		ReportMessage"FAIL","Expected Message 'GOOD COMPLETION' is not displayed",True,"Y"
		Exit Function
	End If
	
	
End Function



Public Function Select_TPX_MENU_FOR(Sessid)

	C_Sessid = "i " & trim(Sessid)
	MySLabel = getScreenLabel()
	strText = Tewindow("TeWindow").TeScreen("label:="&MySLabel).GetText
	If Instr(1,strText,Ucase(trim(Sessid)))>0 Then
			Tewindow("TeWindow").TeScreen("label:="&MySLabel).SetText 42,15,C_Sessid
			Tewindow("TeWindow").TeScreen("label:="&MySLabel).SendKey TE_ENTER
			checkEmulatorStatus
			strText = Tewindow("TeWindow").TeScreen("label:="&MySLabel).GetText
			If Instr(1,strText,Ucase(trim(Sessid)))>0 Then
				Tewindow("TeWindow").TeScreen("label:="&MySLabel).SetText 42,15,Sessid
				Tewindow("TeWindow").TeScreen("label:="&MySLabel).SendKey TE_ENTER
				checkEmulatorStatus		
			End If
	End If
	MySLabel = getScreenLabel()
	If Right(MySLabel,4) = "7198" Then
		ReportMessage "Info", "Successfully entered to CICS Region  " & Sessid & ".", True, "N"
	Else
		ReportMessage "Fail", "Fails to enter the CICS Region  " & Sessid & ".", True, "Y"
		SetIterStatusFailure()
		Select_TPX_MENU_FOR=-1
        Exit Function
	End If
End Function



Public Function checkEmulatorStatus()

	emulatorStatus = lcase(Tewindow("TeWindow").GetROProperty("emulator status"))
	While emulatorStatus = "busy"
		wait 1
		emulatorStatus = lcase(Tewindow("TeWindow").GetROProperty("emulator status"))
	Wend
	wait 1

End Function


Public Function fnGetSuspenseAdviseNumberForDummyUsers()
	
	strWeekNum = CStr(DatePart("ww", Date(), vbSunday, vbFirstWeek))
	
	If Cint(strWeekNum) Mod 2 = 0 Then
		fnGetSuspenseAdviseNumberForDummyUsers = "AUTOMA01"
	Else
		fnGetSuspenseAdviseNumberForDummyUsers = "AUTOMA02"
	End If
	
End Function
