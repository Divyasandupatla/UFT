'! This function will close all the existiong IE browsers
'! @param preText Input - pre text for regex
'! @param postText Input - pro text for regex
'! @param stringText Input - Complete test sting to search pattern
'! @param patternToMatch Input - regex pattern
'! @param totalMatches Output - total regex pattern found
'! @param objectArray Output - array of regex pattern found
'! @remarks Matches regular expression
'! @return NA
'! @author Aflac IT QA - NIIT Automation Team – Shakti
'! @version V1.0
'! @date 05/29/2015

'! This function will close all the existiong IE browsers
'! @remarks N/A	
'! @return NA
'! @author Aflac IT QA - NIIT Automation Team – Shakti
'! @version V1.0
'! @date 05/29/2015
Public Function CloseAllIEBrowsers()
   SystemUtil.CloseProcessByName "iexplore.exe"
   'ReportMessage "INFO", "All Existing IE browser closed", False, "N"
End Function

Public Function CloseAllIEProcesses ()
	SystemUtil.CloseProcessByName "iexplore.exe"
	Const strComputer = "." 
	Dim objWMIService, colProcessList
	Set objWMIService = GetObject("winmgmts:" & "{impersonationLevel=impersonate}!\\" & strComputer & "\root\cimv2")
	Set colProcessList = objWMIService.ExecQuery("SELECT * FROM Win32_Process WHERE Name = 'iexplore.exe'")
	On Error resume Next
	For Each objProcess in colProcessList 
		objProcess.Terminate()		
	Next 
	On Error Goto 0
End Function

Public Function CloseAllChromeBrowsers()
   SystemUtil.CloseProcessByName "Chrome.exe"
End Function

Public Function CloseAllIEBrowsersExceptALM()
Dim oDesc, crcnt
Set oDesc = Description.Create
oDesc("micclass").Value = "Browser"
Set BrowserObjArray = Desktop.ChildObjects(oDesc)
If BrowserObjArray.Count > 0 Then
	For crcnt = 0 To BrowserObjArray.Count-1
		On Error Resume Next
		BrowserName = BrowserObjArray(crcnt).GetROProperty("title")
		Set regEx = New RegExp 
		regEx.Pattern = ".*HP Application Lifecycle.*" 
		regEx.IgnoreCase = True 
		regEx.Global = True  
		Set Matches = regEx.Execute(BrowserName) 
		If Matches.Count = 0 Then
			BrowserObjArray(crcnt).Close
			On Error GoTo 0
		End If
	Next
End If
End Function
'===========================================================================================================
'inputs
'fileName = file path including file name to capture screenshot like c:\screenshot1, script wil append filename with .html
'pageName = for which screenshot is required, like browser(xyz).page(abc)
'return value = this function will return complete file path to associate in result file using ahref tag 
Private function getFullBrowserScreenShot(ByVal fileName, ByVal pageName)
 Dim htmlFileName, doc, outputStream

 htmlFileName = fileName
 Set outputStream = CreateObject("Adodb.Stream")

 outputStream.Open
 outputStream.Charset = "UTF-8"
 outputStream.Type = 2  
 
 Set doc = pageName
 outputStream.writeText "<html>" & doc.documentElement.innerHTML & "</html>", 1
 outputStream.SaveToFile htmlFileName, 2 
 outputStream.Close 
End Function

'Do not make any changes in below function, it is specific to IE 11 for wrong browser count because of tab browsing, it is not complete
'Public Function CloseAllIEBrowsersExceptALMIE11()
'Dim oDesc, crcnt, browserCount
'Set oDesc = Description.Create
'oDesc("micclass").Value = "Browser"
'Set BrowserObjArray = Desktop.ChildObjects(oDesc)
'browserCount = BrowserObjArray.Count
'If browserCount > 0 Then
'	For crcnt = 0 To BrowserObjArray.Count-1
'		If BrowserObjArray(crcnt).GetROProperty("visible") = True Then
'			ReportMessage "INFO", "Browser = " & crcnt, False, "N"
'			BrowserName = BrowserObjArray(crcnt).GetROProperty("title")
'			BrowserURL = BrowserObjArray(crcnt).GetROProperty("url")
'			Set regEx = New RegExp 
'			'regEx.Pattern = "HP Application Lifecycle Management 12.20" 
'			regEx.Pattern = ".*HP Application Lifecycle Management.*"
'			regEx.IgnoreCase = True 
'			regEx.Global = True  -i
'			Set Matches = regEx.Execute(BrowserName) 
'			If Matches.Count = 0 And BrowserURL <> ""Then
'				BrowserObjArray(crcnt).Close
'			End If
'			Set oDesc = Nothing
'			Set oDesc = Description.Create
'			oDesc("micclass").Value = "Browser"
'			Set BrowserObjArray = Nothing
'			Set BrowserObjArray = Desktop.ChildObjects(oDesc)
'			browserCount = BrowserObjArray.Count
'			ReportMessage "INFO", "Browser = " & browserCount, False, "N"
'			crcnt = 0
'			If browserCount = 0 Then
'				Exit Function
'			End If
'        End If
'	Next
'End If
'End Function

'============

'Public Function fnObjectExist(ByVal Obj)
'Dim i
'	For i=1 To 60 Step 1
'		If Obj.Exist( Then
'			Exit For
'		End If
'	Next
'	If i>=60 Then
'		ReportMessage"FAIL",""&Obj.tostring() & " object is not displayed",True,"Y"
'		fnObjectExist = -1
'		Exit Function
'	End If
'	
'	
'	For Iterator = 1 to 60 
'		wait 1
'		if Obj.exist(0) then
'		Exit for 
'		 else
'		 	ReportMessage"FAIL",""&Obj.tostring() & " object is not displayed",True,"Y"
'			fnObjectExist = -1
'		End if
'		
'	Next
'
'End Function

'===================
'! This function deletes cookies for IE browser
'! @remarks N/A
'! @return NA
'! @author Aflac IT QA - NIIT Automation Team – Shakti
'! @version V1.0
'! @date 05/29/2015
Public Function DeleteBrowserCookies()
	Wait(1)
	WebUtil.DeleteCookies()
	ReportMessage "INFO", "Browser cookies deleted", False, "N"
End Function

'! This function will launch the IE browser with provided URL
'! @param URL Input - WebPage URL
'! @remarks N/A
'! @return N/A
'! @author Aflac IT QA - NIIT Automation Team – Shakti
'! @version V1.0
'! @date 05/29/2015
Public Function LaunchNNavigateURL(ByVal URL)
	DeleteBrowserCookies()
	'CloseAllIEProcesses()
	wait 2
	SystemUtil.Run "iexplore.exe", URL, "", "", 3
	wait 5
	ReportMessage "INFO", "Browser launched with URL: " & URL, False, "N"
End Function

'! This function is used for sync operation for browser
'! @param pageName Input - Page Name
'! @param pageObject Input - Validating page object
'! @remarks N/A
'! @return 0 for pass or -1 for fail
'! @author Aflac IT QA - NIIT Automation Team – Shakti
'! @version V1.0
'! @date 05/29/2015
Public Function SyncBrowser(ByVal pageName, ByVal pageObject)
	
	If pageName.exist = true Then
        ReportMessage "Pass", pageName.tostring() & " displayed", False, "N"
		'!pageName.highlight()
        If Not IsObject(pageObject) Then
			SyncBrowser = -1
			Exit Function
		Else
			For repeat = 1 to 10
				If pageObject.Exist Then
                    ReportMessage "Pass", pageObject.tostring() & " object displayed", False, "Y"
					SyncBrowser = 0
					Exit Function
				Else 
					wait 1
				End If
			Next
            ReportMessage "Fail", "Webpage object not displayed", False, "Y"
			SyncBrowser = -1
            Exit Function
		End If
	End If
    ReportMessage "Fail", "Webpage not displayed", False, "Y"
	SyncBrowser = -1
End Function

'! This function maximize IE browser
'! @param browserName Input -  Browser name
'! @remarks N/A
'! @return None
'! @author Aflac IT QA - NIIT Automation Team – Shakti
'! @version V1.0
'! @date 05/29/2015
Public Function MaximizeBrowser(ByVal browserName)
	Dim hWnd
	hWnd=browserName.GetROProperty("hwnd")
	hWnd = Browser("hwnd:=" & hWnd).Object.hWnd
	Window("hwnd:=" & hWnd).Activate
	Window("hwnd:=" & hWnd).Maximize
	ReportMessage "Info", "Browser window maximized", False, "N"
End Function
RegisterUserFunc "Browser", "Maximize", "MaximizeBrowser" 

'! This function minimize IE browser
'! @param browserName Input -  Browser name
'! @remarks N/A
'! @return None
'! @author Aflac IT QA - NIIT Automation Team – Shakti
'! @version V1.0
'! @date 05/29/2015
Public Function MinimizeBrowser(ByVal browserName)
	Dim hWnd
	hWnd=browserName.GetROProperty("hwnd")
	hWnd = Browser("hwnd:=" & hWnd).Object.hWnd
	Window("hwnd:=" & hWnd).Activate
	Window("hwnd:=" & hWnd).Minimize
	ReportMessage "Info", "Browser window minimized", False, "N"
End Function
RegisterUserFunc "Browser", "Minimize", "MinimizeBrowser" 

'! This function returns current page URL
'! @param pageName Input - Page name
'! @remarks N/A
'! @return Page URL
'! @author Aflac IT QA - NIIT Automation Team – Shakti
'! @version V1.0
'! @date 05/29/2015
Public Function GetPageURL(ByVal pageName)
   GetPageURL = pageName.GetROProperty("url")
End Function

'! This function clicks browser back button
'! @param browserName Input - Browser name
'! @remarks
'! @return None
'! @author Shakti
'! @version V1.0
'! @date 05/29/2015
Public Function ClickBrowserBack(ByVal browserName)
	browserName.Back
'   ReportMessage "Info", "Browser back button clicked", False, "Y"
End Function
RegisterUserFunc "Browser", "Back", "ClickBrowserBack"

'!This function returns default value of a WebEdit box
'!@param pageName - Input ByVal
'!@param objName - Input ByVal
'!@remarks
'!@Return default value of WebEdit box
'!@author Shakti
'!@version V1.0
'!@date 05/29/2015
Public Function GetWebEditDefaultVal(ByVal pageName, ByVal objName)
   GetWebEditDefaultVal = pageName.WebEdit(objName).GetROProperty("value")
End Function

'!This function sets value of WebEdit box using expanded list after entering few chars
'!@param pageName - Input ByVal
'!@param objName - Input ByVal
'!@param text - Input ByVal
'!@param indexOfVaIInList - Input ByVal
'!@remarks
'!@Return default value of WebEdit box
'!@author Shakti
'!@version V1.0
'!@date 05/29/2015
Public Function SetWebEditTextFromList(ByVal pageName, ByVal objName, ByVal text, ByVal indexOfVaIInList)
	Set WshShell = CreateObject("WScript.Shell")
	pageName.WebEdit(objName).Click
	WshShell.SendKeys text
	wait 2
	For itemCount = 0 to indexOfVaIInList
		WshShell.SendKeys "{DOWN}" 
		wait 1
	Next
	WshShell.SendKeys "{ENTER}"
End Function

'!This function sets value of WebEdit box
'!@param objName - Input ByVal
'!@param textVal - Input ByVal
'!@remarks
'!@Return 0 if pass else -1 
'!@author Shakti
'!@version V1.0
'!@date 05/29/2015
Public Function SetWebEditVal(ByVal objName, ByVal textVal)
   If objName.Exist Then
		objName.Set textVal
		SetWebEditVal = 0
	Else
		ReportMessage "FAIL", "Unable to locate: " & objName.toString() & " WebEdit Object", False, "Y"
		SetWebEditVal = -1
   End If
End Function
RegisterUserFunc "WebEdit", "Set", "SetWebEditVal" 

'!This function selects value of weblist by value and by index
'!@param objName - Input ByVal
'!@param listVal - Input ByVal
'!@remarks
'!@Return 0 if pass else -1 
'!@author Shakti
'!@version V1.0
'!@date 05/29/2015
Public Function SetWebListVal(ByVal objName, ByVal listVal)
	 If objName.Exist Then
		objName.Select listVal
		SetWebListVal = 0
	Else
		ReportMessage "FAIL", "Unable to locate: " & objName.toString() & " WebList Object", False, "Y"
		SetWebListVal = -1
   End If
End Function
RegisterUserFunc "WebList", "Select", "SetWebListVal"

'!This function returns selected value of weblist 
'!@param objName - Input ByVal
'!@remarks
'!@Return weblist selected value
'!@author Shakti
'!@version V1.0
'!@date 05/29/2015
Public Function GetWebListDefaultVal(ByVal objName)
    If objName.Exist Then
		GetWebListDefaultVal = objName.GetROProperty("value")
   Else
		ReportMessage "FAIL", "Unable to locate: " & objName.toString() & " WebList Object", False, "Y"
		GetWebListDefaultVal = -1
	End If
End Function
RegisterUserFunc "WebList", "GetROProperty", "GetWebListDefaultVal"

'!This function returns selected value of weblist with its different properties
'!@param pageName - Input ByVal
'!@param objName - Input ByVal
'!@param selectedVal - Output ByRef
'!@param selectedItemIndex - Output ByRef
'!@param allItems - Output ByRef
'!@param selectedItemsCount - Output ByRef
'!@param itemsCount - Output ByRef
'!@remarks
'!@Return None
'!@author Shakti
'!@version V1.0
'!@date 05/29/2015
Public Function GetWebListProperties(ByVal pageName, ByVal objName, ByRef selectedVal, ByRef selectedItemIndex, ByRef allItems, ByRef selectedItemsCount, ByRef itemsCount)
	selectedVal = pageName.WebList(ObjName).GetROProperty("value")
	selectedItemIndex = pageName.WebList(ObjName).GetROProperty("selected item index")
    allItems = pageName.WebList(ObjName).GetROProperty("all items")
	selectedItemsCount = pageName.WebList(ObjName).GetROProperty("selected items count")
	itemsCount = pageName.WebList(ObjName).GetROProperty("items count")
End Function

'!This function sets value of webcheckbox 
'!@param objName - Input ByVal
'!@param checkBoxVal - Input ByVal
'!@remarks
'!@Return 0 if pass else -1 
'!@author Shakti
'!@version V1.0
'!@date 05/29/2015
Public Function SetWebCheckbox(ByVal objName, ByVal checkBoxVal)
	If objName.Exist Then
		objName.Set checkBoxVal
		SetWebCheckbox = 0
	Else
		ReportMessage "FAIL", "Unable to locate: " & objName.toString() & " WebCheckbox Object", False, "Y"
		SetWebCheckbox = -1
   End If
End Function
RegisterUserFunc "WebCheckBox", "Set", "SetWebCheckbox"

'!This function selects value of webradiogroup 
'!@param objName - Input ByVal
'!@param radioGrpVal - Input ByVal
'!@remarks
'!@Return 0 if pass else -1 
'!@author Shakti
'!@version V1.0
'!@date 05/29/2015
Public Function SetWebRadioGroup(ByVal objName, ByVal radioGrpVal)
	 If objName.Exist Then
		objName.Select radioGrpVal
		SetWebRadioGroup = 0
	Else
		ReportMessage "FAIL", "Unable to locate: " & objName.toString() & " WebRadioGroup Object", False, "Y"
		SetWebRadioGroup = -1
   End If
End Function
RegisterUserFunc "WebRadioGroup", "Select", "SetWebRadioGroup"

'!This function clicks on object 
'!
'!@param objName - Input ByVal
'!@remarks
'!@Return 0 if pass else -1 
'!@author Shakti
'!@version V1.0
'!@date 05/29/2015
Public Function ClickOnObject(ByVal objName)
 	objectMicClass = objName.GetROProperty("micclass")
	If  objectMicClass = "WebButton" OR objectMicClass = "WebEdit" Then
		If objName.GetROProperty("disabled") = 1 Then
			ReportMessage "FAIL", "Object is disabled: " & objName.toString(), False, "Y"
			Exit Function
		End If
	End If
    If objName.Exist Then
		objName.Click
		ClickOnObject = 0
	Else
		ReportMessage "FAIL", "Unable to locate: " & objName.toString() & " Object", False, "Y"
		ClickOnObject = -1
   End If
End Function
RegisterUserFunc "WebButton", "Click", "ClickOnObject"
RegisterUserFunc "Link", "Click", "ClickOnObject" 
RegisterUserFunc "Image", "Click", "ClickOnObject"
RegisterUserFunc "WebEdit", "Click", "ClickOnObject"
RegisterUserFunc "WebElement", "Click", "ClickOnObject" 

'!This function validate a link
'!
'!@param linkName - Input ByVal
'!@param currentPageName - Input ByVal
'!@param expectedPageName - Input ByVal
'!@param expectedPageText - Input ByVal
'!@param popup - Input ByVal
'!@param buttonToClose - Input ByVal
'!@remarks It needs modification as per functionality
'!@Return
'!@author Shakti
'!@version V1.0
'!@date 05/29/2015
Public Function WebPageLinkCheck(ByVal linkName, ByVal currentPageName, ByVal expectedPageName, ByVal expectedPageText, ByVal popup, ByVal buttonToClose)
	currentPageName.Link(linkName).click
	SyncBrowser expectedPageName, ""
	TextExistOnPage expectedPageName, expectedPageText
	ClickBrowserBack expectedPageName
	SyncBrowser currentPageName, ""
End Function

'!This function validate existance of an object on page
'!
'!@param pageName - Input ByVal
'!@param pageObject - Input ByVal
'!@remarks
'!@Return
'!@author Shakti
'!@version V1.0
'!@date 05/29/2015

Public Function CheckObjectExistanceOnPage(ByVal pageName, ByVal pageObject)
	If Not IsObject(pageObject) Then
		CheckObjectExistanceOnPage = -1
		Exit Function
	Else
    	objectClass = pageObject.GetROProperty("micclass")
	'!	Eval("pageName." & eval(objectClass) & "(pageObject).highlight()")
			Select Case objectClass
			Case "WebButton"
				pageName.WebButton(pageObject).highlight()
				CheckObjectExistanceOnPage = 0
			Case "WebList"
				pageName.WebList(pageObject).highlight()
				CheckObjectExistanceOnPage = 0
			Case "Link"
				pageName.Link(pageObject).highlight()
				CheckObjectExistanceOnPage = 0
			Case "Image"
				pageName.Image(pageObject).highlight()
				CheckObjectExistanceOnPage = 0
			Case "WebEdit"
				pageName.WebEdit(pageObject).highlight()
				CheckObjectExistanceOnPage = 0
			Case "WebRadioGroup"
				pageName.WebRadioGroup(pageObject).highlight()
				CheckObjectExistanceOnPage = 0
			Case "WebCheckBox"
				pageName.WebCheckBox(pageObject).highlight()
				CheckObjectExistanceOnPage = 0
			Case Else
'				Msgbox "Not Found"
				CheckObjectExistanceOnPage = -1
			End Select
	End If
End Function

'!This function returns the webpage source code
'!
'!@param pageName - Input ByVal
'!@remarks
'!@Return Page Source
'!@author Shakti
'!@version V1.0
'!@date 05/29/2015
Public Function GetWebpageSourceCode(ByVal pageName)
	If pageName.Exist Then
		GetWebpageSourceCode = pageName.Object.DocumentElement.OuterHtml
	Else
		ReportMessage "FAIL", "Unable to locate: " & pageName.toString() & " Object", False, "Y"
		GetWebpageSourceCode = -1
   End If
End Function

'!This function returns date from webtable for given cell number(row, col)
'!
'!@param webTableObject - Input ByVal
'!@param rowNum - Input ByVal
'!@param colNum - Input ByVal
'!@remarks
'!@Return Cell data
'!@author Shakti
'!@version V1.0
'!@date 05/29/2015
Public Function GetWebTableCellData(ByVal webTableObject, ByVal rowNum, ByVal colNum)
	If webTableObject.Exist Then
		GetWebTableCellData = webTableObject.GetCellData(rowNum, colNum)
	Else
		ReportMessage "FAIL", "Unable to locate: " & webTableObject.toString() & " Object", False, "Y"
		GetWebTableCellData = -1
   End If
End Function

'!This function returns count of  objects of same class from webtable for given cell number(row, col)
'!@param webTableObject - Input ByVal
'!@param rowNum - Input ByVal
'!@param colNum - Input ByVal
'!@param objType - Input ByVal
'!@remarks
'!@Return Count of objects of same class
'!@author Shakti
'!@version V1.0
'!@date 05/29/2015
Public Function GetWebTableCellObjectCount(ByVal webTableObject, ByVal rowNum, ByVal colNum, ByVal objType)
	If webTableObject.Exist Then
		GetWebTableCellObjectCount = webTableObject.ChildItemCount(rowNum, colNum, objType)
	Else
		ReportMessage "FAIL", "Unable to locate: " & webTableObject.toString() & " Object", False, "Y"
		GetWebTableCellObjectCount = -1
   End If
End Function

'!This function returns count for total number of rows and columns of a webtable
'!@param webTableObject - Input ByVal
'!@param totalRows - Output ByRef
'!@param totalCol - Output ByRef
'!@remarks
'!@Return None
'!@author Shakti
'!@version V1.0
'!@date 05/29/2015
Public Function GetWebTableRowColumnCount(ByVal webTableObject, ByRef totalRows, ByRef totalCol)
	If webTableObject.Exist Then
		totalRows = webTableObject.RowCount
		totalCol = webTableObject.ColumnCount(1)
	Else
		ReportMessage "FAIL", "Unable to locate: " & webTableObject.toString() & " Object", False, "Y"
		GetWebTableCellObjectCount = -1
   End If	
End Function

'!This function returns count for total number of rows matchi9ng with given text
'!@param webTableObject - Input ByVal
'!@param textToMatch - Input ByVal
'!@param textColNum - Input ByVal
'!@param startRowNum - Input ByVal
'!@param rowNumArray - Output ByRef
'!@remarks
'!@Return None
'!@author Shakti
'!@version V1.0   
'!@date 05/29/2015
Public Function GetRowNumberswithMatchingText(ByVal webTableObject, ByVal textToMatch, ByVal textColNum, ByVal startRowNum, ByRef rowNumArray)
   rCount = 0
   rowNumStringAll = ""
   rowNumber = 0
   wTableRowCount = webTableObject.RowCount
   rowNumber = webTableObject.GetRowWithCellText(textToMatch, , 1)
   If  rowNumber = -1 Or textToMatch = "" Or wTableRowCount < startRowNum Then
	   rowNumArray = -1
	   Exit Function
   End If
	rCount = rowNumber
   If rowNumber=>1 And rowNumber =<wTableRowCount Then
		While rCount  <= wTableRowCount
			rowNumber = webTableObject.GetRowWithCellText(textToMatch, , startRowNum)
			If  rowNumber = -1Then
				rowNumArray = split(rowNumStringAll, ":")
				rowNumArray(0) = "RowNum_List"
				Exit Function
			End If
			rowNumStringAll = rowNumStringAll & ":" & rowNumber 
			rCount = rowNumber+1
			startRowNum = rowNumber +1		
		Wend
	End If
	rowNumArray = split(rowNumStringAll, ":")
	rowNumArray(0) = "RowNum_List"
End Function  

'! This function is used to check whether a web page is loaded or not
'! @param pageName Input - Object storing the page details
'! @param pageObject Input - Object that appears on a page
'! @remarks Function will check that whether a page is loaded or not before starting any operations
'! @return NA
'! @author Aflac IT QA - NIIT Automation Team – Vikas
'! @version V1.0
'! @date 05/29/2015
'!New method added will be moving to browser util
Public Function SetPage(ByVal pageName, ByVal pageObject)
	Dim pageExistCounter, pageExistStatus

	pageExistStatus = False

	For pageExistCounter = 1 to 15
		If pageName.exist(2) and pageObject.exist(2) Then
			pageExistStatus = True
			SetIterStatusSuccess()
			ReportMessage "INFO", pageName.tostring() & " loaded completely. ", False, "Y"
			Exit For
		Else
			wait 1
		End If
	Next

	If Not(pageExistStatus) Then
		ReportMessage "FAIL", pageName.tostring() & " not loaded. ", False, "Y"
		SetIterStatusFailure()
	End If
End Function
RegisterUserFunc "Page", "SetPage", "SetPage"

'Public Function SetWebListValByText(ByVal pageName, ByVal objName, ByVal listText)
'	pageName.WebList(objName).Select listText
'End Function
'================================================================================================================
'
'
'Public Function SetWebListValByIndex(ByVal pageName, ByVal objName, ByVal listindex)
'   pageName.WebList(objName).Select listindex
'End Function
'================================================================================================================

'Public Function SelectCheckbox(ByVal pageName, ByVal objName)
'	pageName.WebCheckBox(objName).Set "ON"
'End Function
'================================================================================================================
'
'Public Function DeselectCheckbox(ByVal pageName, ByVal objName)
'   pageName.WebCheckBox(objName).Set "OFF"
'End Function
'================================================================================================================
'
'Public Function SelectRadiogroupbyVal(ByVal pageName, ByVal objName, ByVal radioVal)
'   pageName.WebRadioGroup(objName).Select radioVal
'End Function
'================================================================================================================
'
'
'Public Function SelectRadiogroupbyIndex(ByVal pageName, ByVal objName, ByVal radioIndex)
'   pageName.WebRadioGroup(objName).Select radioIndex
'End Function
'================================================================================================================

'Public Function SetWebEditVal(ByVal pageName, ByVal objName, ByVal textVal)
'   pageName.WebEdit(objName).Set(textVal)
'End Function
'Public Function ClearWebEditText(ByVal pageName, ByVal objName)
'  pageName.WebEdit(objName).Set("")
'End Function
'================================================================================================================

Public Function LaunchChrome_NNavigateURL(ByVal URL, ByVal Normal_OR_Incognito)
    
    If Environment.Value("OS") = "Windows 10" Then
    	If UCASE(Normal_OR_Incognito) = "INCOGNITO" Then
	        systemutil.Run "C:\Program Files (x86)\Google\Chrome\Application\chrome.exe","-" & Normal_OR_Incognito & " " & URL, "", "", 3
	    Else
	        systemutil.Run "C:\Program Files (x86)\Google\Chrome\Application\chrome.exe", URL, "", "", 3
	    End If
	    	
    Else
    	If UCASE(Normal_OR_Incognito) = "INCOGNITO" Then
	        systemutil.Run "C:\Program Files\Google\Chrome\Application\chrome.exe","-" & Normal_OR_Incognito & " " & URL, "", "", 3
	    Else
	        systemutil.Run "C:\Program Files\Google\Chrome\Application\chrome.exe", URL, "", "", 3
	    End If
	End If
    
    ReportMessage "INFO", "Chrome Browser launched with URL: " & URL, False, "N"
    
End Function

'Below function is added by Amit Garg on 02/18/2020 to change the zoom level of the Internet Explorer. 
Public Function fnSetIEZoomPercentage (ByVal intZoomLevel)
	
	Dim objIE
	Const OLECMDID_OPTICAL_ZOOM = 63
	Const OLECMDEXECOPT_DONTPROMPTUSER = 2
	Set objIE = CreateObject("InternetExplorer.Application")
	'objIE.Visible = True
	objIE.Navigate ("www.google.com")
	While objIE.Busy = True
		wait 1
	Wend
	objIE.ExecWB OLECMDID_OPTICAL_ZOOM, OLECMDEXECOPT_DONTPROMPTUSER, CLng(intZoomLevel), vbNull
	
End Function


'Below function checks if the page is fully loaded or not
Public function WaitToLoadCompletePage( ByRef objPage)

	currentState = objPage.Object.readyState
	
	i = 1
	
	do While currentState <> "complete"
		wait 1
		currentState = objPage.Object.readyState
		i = i + 1
		If i = 100 Then
			Exit do
		End If
		
	Loop 	

End  Function
