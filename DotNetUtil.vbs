Public Function SetSwfEdit(ByVal objName, ByVal textVal)
	   If objName.Exist(5) Then
			objName.Set textVal
			SetSwfEdit = 0
		Else
			ReportMessage "FAIL", "Unable to locate: " & objName.toString() & " SwfEdit Object", False, "Y"
			SetSwfEdit = -1
   End If
End Function
RegisterUserFunc "SwfEdit", "Set", "SetSwfEdit" 
'========================================================================================================================================

Public Function GetSwfEditDefaultVal(ByVal objName)
	If objName.Exist(5) Then
		GetSwfEditDefaultVal = objName.GetROProperty("text")
	Else
		ReportMessage "FAIL", "Unable to locate: " & objName.toString() & " SwfEdit Object", False, "Y"
		GetSwfEditDefaultVal = -1
	End If
End Function
RegisterUserFunc "SwfEdit", "GetROProperty", "GetSwfEditDefaultVal"
'========================================================================================================================================

Public Function GetSwfLabelText(ByVal objName)
	If objName.Exist(5) Then
		GetSwfLabelText = objName.GetROProperty("text")
	Else
		ReportMessage "FAIL", "Unable to locate: " & objName.toString() & " SwfObject Object", False, "Y"
		GetSwfLabelText = -1
	End If
End Function
RegisterUserFunc "SwfLabel", "GetROProperty", "GetSwfLabelText"
'========================================================================================================================================

Public Function SelectSwfListViewItem(ByVal objName, ByVal itemIndex)
	If itemIndex < 0 Or itemIndex > objName.GetROProperty("items count") Then
		ReportMessage "FAIL", "Unable to locate item in lis: " & objName.toString() & " SwfListView Object", False, "Y"
		SelectSwfListViewItem = -1
	Exit function
	End If
	If objName.Exist(5) Then
		objName.Select itemIndex
		SelectSwfListViewItem = 0
	Else
		ReportMessage "FAIL", "Unable to locate: " & objName.toString() & " SwfListView Object", False, "Y"
		SelectSwfListViewItem = -1
	End If
End Function
'RegisterUserFunc "SwfListView", "Select", "SelectSwfListViewItem"
'========================================================================================================================================

Public function SelectListViewItemByText(ByVal itemText, ByVal listViewObject)
	cnt = listViewObject.GetItemsCount
    For curItem = 0 To cnt - 1
		curItemLabel = listViewObject.GetItem(curItem)
        itemPath = listViewObject.GetITemProperty(curItem, "text")
        If itemPath = itemText Then
			listViewObject.Select itemPath
            ItemSelected = listViewObject.GetITemProperty(curItem, "selected")
            If ItemSelected Then
                SelectListViewItemByText = 0
                 Exit Function
			End If
		End If
	Next
    SelectListViewItemByText = -1
End Function
'========================================================================================================================================

Public Function SelectSwfListViewItemNOpen(ByVal objName, ByVal itemIndex)
   	If itemIndex < 0 Or itemIndex > objName.GetROProperty("items count") Then
		ReportMessage "FAIL", "Unable to locate item in list: " & objName.toString() & " SwfListView Object", False, "Y"
		SelectSwfListViewItemNOpen = -1
	Exit function
	End If
	If objName.Exist(5) Then
		SwfWindow("Aflac Individual Enrollment").SwfListView("SwfListView").Select itemIndex
		Set WshShell = CreateObject("WScript.Shell")
		WshShell.SendKeys "{ENTER}"
		SelectSwfListViewItemNOpen = 0
	Else
		ReportMessage "FAIL", "Unable to locate: " & objName.toString() & " SwfListView Object", False, "Y"
		SelectSwfListViewItemNOpen = -1
	End If
End Function
'========================================================================================================================================

Public Function SelectSwfListViewItem(ByVal objName, ByVal itemIndex)
	If itemIndex < 0 Or itemIndex > objName.GetROProperty("items count") Then
		ReportMessage "FAIL", "Unable to locate item in list: " & objName.toString() & " SwfListViewt Object", False, "Y"
		SelectSwfListViewItem = -1
	Exit function
	End If
	If objName.Exist(5) Then
		objName.Select itemIndex
		SelectSwfListViewItem = 0
	Else
		ReportMessage "FAIL", "Unable to locate: " & objName.toString() & " SwfListView Object", False, "Y"
		SelectSwfListViewItem = -1
	End If
End Function
'RegisterUserFunc "SwfListView", "Select", "SelectSwfListViewItem"
'========================================================================================================================================

Public Function GetCheckedSwfListItems(ByVal objName)
	If  objName.Exist(5) Then
        GetCheckedSwfListItems = objName.GetCheckMarks
	Else
		ReportMessage "FAIL", "Unable to locate: " & objName.toString() & " SwfListView Object", False, "Y"
		GetCheckedSwfListItems = -1
	End If
End Function
RegisterUserFunc "SwfListView", "GetCheckMarks", "GetCheckedSwfListItems"
'========================================================================================================================================

Public Function CheckSwfListItem(ByVal objName, ByVal swfListViewItem, ByVal itemState)
	If  objName.Exist(5) Then
        objName.SetItemState swfListViewItem, itemState
		CheckSwfListItem = 0
	Else
		ReportMessage "FAIL", "Unable to locate: " & objName.toString() & " SwfListView Object", False, "Y"
		CheckSwfListItem = -1
	End If
End Function
RegisterUserFunc "SwfListView", "SetItemState", "CheckSwfListItem"
'========================================================================================================================================
'
'Public Function UncheckSwfListItem(ByVal objName, ByVal swfListViewItem)
'	If  objName.Exist Then
'        objName.SetItemState swfListViewItem, 0
'		UncheckSwfListItem = 0
'	Else
'		ReportMessage "FAIL", "Unable to locate: " & objName.toString() & " SwfListView Object", False, "Y"
'		UncheckSwfListItem = -1
'	End If
'End Function
'RegisterUserFunc "SwfListView", "SetItemState", "CheckSwfListItem"
'========================================================================================================================================

Public Function GetSwfEditorText(ByVal objName)
	If objName.Exist(5) Then
		objName.GetRoProperty("text")
		GetSwfEditorText = 0
	Else
		ReportMessage "FAIL", "Unable to locate: " & objName.toString() & " SwfEditor Object", False, "Y"
		GetSwfEditorText = -1
	End If
End Function
'========================================================================================================================================

Public Function GetSwfEditorTextMultiline(ByVal objName, ByVal startLine, ByVal startCol, ByVal endLine, ByVal endCol)
	If objName.Exist(5) Then
		Set obj = createobject("Mercury.Clipboard")
		obj.Clear
		objName.SetSelection startLine, startCol, endLine, endCol
		objName.Type micCtrlDwn + "c" + micCtrlUp
		GetSwfEditorTextMultiline = obj.GetText
	Else
		ReportMessage "FAIL", "Unable to locate: " & objName.toString() & " SwfEditor Object", False, "Y"
		GetSwfEditorTextMultiline = -1
	End If
End Function
RegisterUserFunc "SwfEditor", "SetSelection", "GetSwfEditorTextMultiline"
'========================================================================================================================================

Public Function ExpandAllSwfTreeView(ByVal treeViewObj, ByVal nodeName)
	If treeViewObj.Exist(5) Then
		treeViewObj.ExpandAll(nodeName)
		ExpandAllSwfTreeView = 0
	Else
		ReportMessage "FAIL", "Unable to locate: " & objName.toString() & " SwfTreeView Object", False, "Y"
		ExpandAllSwfTreeView = -1
	End If
End Function
RegisterUserFunc "SwfTreeView", "ExpandAll", "ExpandAllSwfTreeView"
'========================================================================================================================================

Public Function CollapseSwfTreeView(ByVal treeViewObj, ByVal nodeName)
	If treeViewObj.Exist(5) Then
		treeViewObj.Collapse(nodeName)
		CollapseSwfTreeView = 0
	Else
		ReportMessage "FAIL", "Unable to locate: " & objName.toString() & " SwfTreeView Object", False, "Y"
		CollapseSwfTreeView = -1
	End If
End Function
RegisterUserFunc "SwfTreeView", "Collapse", "CollapseSwfTreeView"
'========================================================================================================================================

Public Function GetTotalNumberOfSwfTreeViewDisplayedNode(ByVal treeViewObj)
	If treeViewObj.Exist(5) Then
        GetTotalNumberOfSwfTreeViewDisplayedNode = treeViewObj.GetItemsCount
	Else
		ReportMessage "FAIL", "Unable to locate: " & objName.toString() & " SwfTreeView Object", False, "Y"
		GetTotalNumberOfSwfTreeViewDisplayedNode = -1
	End If
End Function
RegisterUserFunc "SwfTreeView", "GetItemsCount", "GetTotalNumberOfSwfTreeViewDisplayedNode"
'========================================================================================================================================

Public Function GetNameOfAllSwfTreeViewDisplayedNode(ByVal treeViewObj)
	If treeViewObj.Exist(5) Then
        GetNameOfAllSwfTreeViewDisplayedNode = treeViewObj.GetContent
	Else
		ReportMessage "FAIL", "Unable to locate: " & objName.toString() & " SwfTreeView Object", False, "Y"
		GetNameOfAllSwfTreeViewDisplayedNode = -1
	End If
End Function
RegisterUserFunc "SwfTreeView", "GetContent", "GetNameOfAllSwfTreeViewDisplayedNode"
'========================================================================================================================================

Public Function GetSwfTreeViewSelectedNodeName(ByVal treeViewObj)
	If treeViewObj.Exist(5) Then
        GetSwfTreeViewSelectedNodeName = treeViewObj.GetSelection
	Else
		ReportMessage "FAIL", "Unable to locate: " & objName.toString() & " SwfTreeView Object", False, "Y"
		GetSwfTreeViewSelectedNodeName = -1
	End If
End Function
RegisterUserFunc "SwfTreeView", "GetSelection", "GetSwfTreeViewSelectedNodeName"
'========================================================================================================================================



'! This function is used to select a value from the ComboBox or Tab
'! @param swfObj Input - ComboBox or Tab object
'! @param itemVal Input - Value to be selected
'! @remarks  Function will select the value if its able to find in the list or else will report an error
'! @return '0' for success and '1' for failure
'! @author Aflac IT QA - NIIT Automation Team – Vikas
'! @version V1.0
'! @date 06/15/2015
Public Function SelectItem(ByVal swfObj, ByVal itemVal)
 	If swfObj.Exist(5) and CheckObjectEnableDisable(swfObj) Then
		swfObj.Select itemVal
		SelectItem = 0
	Else
		ReportMessage "Fail", "Object Class " & swfObj.GetROProperty("micclass") & " named " & swfObj.tostring() & " doesn't exist. ", False, "Y"
		SelectItem = -1
	End If
End Function
RegisterUserFunc "SwfComboBox", "Select", "SelectItem"
RegisterUserFunc "SwfTab", "Select", "SelectItem"

'! This function is used to return all the items in ComboBox, Tab or StatusBar
'! @param swfObj Input - ComboBox, Tab or StatusBar object
'! @remarks  Function will return the content and if its not able to find the object then it will report an error
'! @return Returns an array of content
'! @author Aflac IT QA - NIIT Automation Team – Vikas
'! @version V1.0
'! @date 06/15/2015
Public Function GetObjContent(ByVal swfObj)
	Dim content

 	If swfObj.Exist(5) and CheckObjectEnableDisable(swfObj) Then
		content = swfObj.GetContent
		GetObjContent = split(content, vblf)
		GetObjContent = 0
	Else
		ReportMessage "Fail", "Object Class " & swfObj.GetROProperty("micclass") & " named " & swfObj.tostring() & " doesn't exist. ", False, "Y"
		GetObjContent = -1
	End If
End Function
RegisterUserFunc "SwfComboBox", "GetContent", "GetObjContent"
RegisterUserFunc "SwfTab", "GetContent", "GetObjContent"
RegisterUserFunc "SwfStatusBar", "GetContent", "GetObjContent"

'! This function will return the selected item value
'! @param swfObj Input - ComboBox or Tab object
'! @remarks  Function will return the selected item value if its able to find in the list or else will report an error
'! @return Selected item value from the ComboBox or Tab
'! @author Aflac IT QA - NIIT Automation Team – Vikas
'! @version V1.0
'! @date 06/15/2015
Public Function GetSelectedItemVal(ByVal swfObj)
	Dim selectedItemVal

 	If swfObj.Exist(5) and CheckObjectEnableDisable(swfObj) Then
		GetSelectedItemVal = swfObj.GetSelection
	Else
		ReportMessage "Fail", "Object Class " & swfObj.GetROProperty("micclass") & " named " & swfObj.tostring() & " doesn't exist. ", False, "Y"
		GetSelectedItemVal = -1
	End If
End Function
RegisterUserFunc "SwfComboBox", "GetSelection", "GetSelectedItemVal"
RegisterUserFunc "SwfTab", "GetSelection", "GetSelectedItemVal"

'! This function will return the selected item value
'! @param swfObj Input - ComboBox or Tab object
'! @param swfObj Input - ComboBox or Tab object
'! @remarks  Function will return the selected item value if its able to find in the list or else will report an error
'! @return Selected item value from the ComboBox or Tab
'! @author Aflac IT QA - NIIT Automation Team – Vikas
'! @version V1.0
'! @date 06/15/2015
Public Function GetItemVal(ByVal swfObj, ByVal indexVal)
 	If swfObj.Exist(5) and CheckObjectEnableDisable(swfObj) Then
		GetItemVal = swfObj.GetItem(indexVal)
	Else
		ReportMessage "Fail", "Object Class " & swfObj.GetROProperty("micclass") & " named " & swfObj.tostring() & " doesn't exist. ", False, "Y"
		GetItemVal = -1
	End If
End Function
RegisterUserFunc "SwfComboBox", "GetItem", "GetItemVal"
RegisterUserFunc "SwfTab", "GetItem", "GetItemVal"
RegisterUserFunc "SwfStatusBar", "GetItem", "GetItemVal"

'! This function will return the items count from ComboBox, Tab or StatusBar
'! @param swfObj Input - ComboBox,Tab or StatusBar object
'! @remarks  Function will return the items count if its able to find in the object or else will report an error
'! @return Returns item count
'! @author Aflac IT QA - NIIT Automation Team – Vikas
'! @version V1.0
'! @date 06/15/2015
Public Function GetItemsValCount(ByVal swfObj)
 	If swfObj.Exist(5) and CheckObjectEnableDisable(swfObj) Then
		GetItemsValCount = swfObj.GetItemsCount
	Else
		ReportMessage "Fail", "Object Class " & swfObj.GetROProperty("micclass") & " named " & swfObj.tostring() & " doesn't exist. ", False, "Y"
		GetItemsValCount = -1
	End If
End Function
RegisterUserFunc "SwfComboBox", "GetItemsCount", "GetItemsValCount"
RegisterUserFunc "SwfTab", "GetItemsCount", "GetItemsValCount"
RegisterUserFunc "SwfStatusBar", "GetItemsCount", "GetItemsValCount"

'! This function will set the value for a WinEdit object
'! @param winEditObj Input - WinEdit object
'! @param textVal Input - Text value
'! @remarks  Function will set the value if its able to find in the object or else will report an error
'! @return '0' for success or '-1' for failure
'! @author Aflac IT QA - NIIT Automation Team – Vikas
'! @version V1.0
'! @date 06/15/2015
Public Function WinEditSet(ByVal winEditObj, ByVal textVal)
 	If winEditObj.Exist(5) and CheckObjectEnableDisable(winEditObj) Then
		winEditObj.Set textVal
		WinEditSet = 0
	Else
		ReportMessage "Fail", "Object Class " & winEditObj.GetROProperty("micclass") & " named " & winEditObj.tostring() & " doesn't exist. ", False, "Y"
		WinEditSet = -1
	End If
End Function
RegisterUserFunc "WinEdit", "Set", "WinEditSet"

'! This function will check whether the object is 'enable' or 'disabled'
'! @param swfObj Input - Any object having enable/disable property
'! @return 'True' if the object is enabled or 'False' if the object is disabled
'! @author Aflac IT QA - NIIT Automation Team – Vikas
'! @version V1.0
'! @date 06/15/2015
Public Function CheckObjectEnableDisable(ByVal swfObj)
	If swfObj.GetROProperty("enabled") Then
		CheckObjectEnableDisable = True
	Else
		CheckObjectEnableDisable = False
	End If
End Function

'! This function will click on the button object
'! @param buttonObj Input - Button object
'! @remarks  Function will click on the button if its able to find in the object or else will report an error
'! @return '0' for success or '-1' for failure
'! @author Aflac IT QA - NIIT Automation Team – Vikas
'! @version V1.0
'! @date 06/15/2015
Public Function ButtonClick(ByVal buttonObj)
	If buttonObj.Exist(5) and CheckObjectEnableDisable(buttonObj) Then
		buttonObj.Click
		ButtonClick = 0
	Else
		ReportMessage "Fail", "Object Class " & buttonObj.GetROProperty("micclass") & " named " & buttonObj.toString() & " doesn't exist. ", false, "Y"
		ButtonClick = -1
	End If
End Function
RegisterUserFunc "SwfButton", "Click", "ButtonClick"

'! This function will set the date value in the Calendar object
'! @param calendarObj Input - Calendar object
'! @param dateVal Input - Date value
'! @remarks  Function will set the date value, format of date should be "10-Feb-2015"
'! @return '0' for success or '-1' for failure
'! @author Aflac IT QA - NIIT Automation Team – Vikas
'! @version V1.0
'! @date 06/15/2015
Public Function CalendarSetDate(ByVal calendarObj, ByVal dateVal)
   If calendarObj.Exist(5) and CheckObjectEnableDisable(calendarObj) Then
		calendarObj.SetDate dateVal
		CalendarSetDate = 0
	Else
		ReportMessage "Fail", "Object Class " & calendarObj.GetROProperty("micclass") & " named " & calendarObj.toString() & " doesn't exist. ", false, "Y"
		CalendarSetDate = -1
   End If
End Function
RegisterUserFunc "SwfCalendar", "SetDate", "CalendarSetDate"

'! This function will set the date range for the object
'! @param dateRangeObj Input - DateRange object
'! @param dateRangeVal Input - DateRange value
'! @remarks  Function will set the date range, format for date range should be "[19-May-2003 - 23-May-2003]"
'! @return '0' for success or '-1' for failure
'! @author Aflac IT QA - NIIT Automation Team – Vikas
'! @version V1.0
'! @date 06/15/2015
Public Function SwfObjectSetDateRange(ByVal dateRangeObj, ByVal dateRangeVal)
	If dateRangeObj.Exist(5) and CheckObjectEnableDisable(dateRangeObj) Then
		dateRangeObj.SetDateRange dateRangeVal
		SwfObjectSetDateRange = 0
	Else
		ReportMessage "Fail", "Object Class " & dateRangeObj.GetROProperty("micclass") & " named " & dateRangeObj.toString() & " doesn't exist. ", false, "Y"
		SwfObjectSetDateRange = -1
   End If
End Function
RegisterUserFunc "SwfObject", "SetDateRange", "SwfObjectSetDateRange"

'! This function will set the time
'! @param timeObj Input - Object to set the for
'! @param timeVal Input - Value that needs to set for the object
'! @remarks  Function will set the time, format for date range should be "13:00:00"
'! @return '0' for success or '-1' for failure
'! @author Aflac IT QA - NIIT Automation Team – Vikas
'! @version V1.0
'! @date 06/15/2015
Public Function SwfObjectSetTime(ByVal timeObj, ByVal timeVal)
	If timeObj.Exist(5) and CheckObjectEnableDisable(timeObj) Then
		timeObj.SetTime timeVal
		SwfObjectSetTime = 0
	Else
		ReportMessage "Fail", "Object Class " & timeObj.GetROProperty("micclass") & " named " & timeObj.toString() & " doesn't exist. ", false, "Y"
		SwfObjectSetTime = -1
   End If
End Function
RegisterUserFunc "SwfObject", "SetTime", "SwfObjectSetTime"

'! This function will select or deselect the checkbox according to the value passed
'! @param checkboxObj Input - Checkbox object
'! @param checkboxVal Input - Value for the checkbox
'! @remarks  Function will set "ON" and "OFF" value for the checkbox
'! @return '0' for success or '-1' for failure
'! @author Aflac IT QA - NIIT Automation Team – Vikas
'! @version V1.0
'! @date 06/15/2015
Public Function CheckboxSet(ByVal checkboxObj, ByVal checkboxVal)
	If checkboxObj.Exist(5) and CheckObjectEnableDisable(checkboxObj) Then
		checkboxObj.Set checkboxVal
		CheckboxSet = 0
	Else
		ReportMessage "Fail", "Checkbox Object " & checkboxObj.toString() & " doesn't exist. ", false, "Y"
		CheckboxSet = -1
   End If
End Function
RegisterUserFunc "SwfCheckBox", "Set", "CheckboxSet"

'! This function will select the specified radio button
'! @param radioButtonObj Input - Radiobutton object
'! @return '0' for success or '-1' for failure
'! @author Aflac IT QA - NIIT Automation Team – Vikas
'! @version V1.0
'! @date 06/15/2015
Public Function RadioButtonSet(ByVal radioButtonObj)
	If radioButtonObj.Exist(5) and CheckObjectEnableDisable(radioButtonObj) Then
		radioButtonObj.Set
		RadioButtonSet = 0
	Else
		ReportMessage "Fail", "Radio button Object " & radioButtonObj.toString() & " doesn't exist. ", false, "Y"
		RadioButtonSet = -1
	End If
End Function
RegisterUserFunc "SwfRadioButton", "Set", "RadioButtonSet"

'! This function will select the property value for the property grid
'! @param swfObj Input - PropertyGrid object
'! @param prop Input - Property value for Grid
'! @remarks  PropertyGrid property value format should be "Font;Bold"
'! @return '0' for success or '-1' for failure
'! @author Aflac IT QA - NIIT Automation Team – Vikas
'! @version V1.0
'! @date 06/15/2015
Public Function PropertyGridSelect(ByVal swfObj, ByVal prop)
	If swfObj.Exist(5) Then
		swfObj.SelectProperty prop
		PropertyGridSelect = 0
	Else
		ReportMessage "Fail", "Property grid Object " & swfObj.toString() & " doesn't exist. ", false, "Y"
		PropertyGridSelect = -1
	End If
End Function
RegisterUserFunc "SwfPropertyGrid", "SelectProperty", "PropertyGridSelect"

'! This function will set the property value for the PropertyGrid
'! @param swfObj Input - PropertyGrid object
'! @param prop Input - Property value for Grid
'! @param propValue Input - Value as "True" or "False"
'! @remarks  PropertyGrid property value format should be "Font;Bold"
'! @return '0' for success or '-1' for failure
'! @author Aflac IT QA - NIIT Automation Team – Vikas
'! @version V1.0
'! @date 06/15/2015
Public Function PropertyGridSetValue(ByVal swfObj, ByVal prop, ByVal propValue)
	If swfObj.Exist(5) Then
		swfObj.SetValue prop, propValue
	Else
		ReportMessage "Fail", "Property grid Object " & swfObj.toString() & " doesn't exist. ", false, "Y"
		PropertyGridSetValue = -1
	End If
End Function
RegisterUserFunc "SwfPropertyGrid", "SetValue", "PropertyGridSetValue"

'! This function will get the value for thespecific property of the PropertyGrid
'! @param swfObj Input - PropertyGrid object
'! @param prop Input - Property value for Grid
'! @remarks  PropertyGrid property value format should be "Font;Bold"
'! @return '0' for success or '-1' for failure
'! @author Aflac IT QA - NIIT Automation Team – Vikas
'! @version V1.0
'! @date 06/15/2015
Public Function PropertyGridGetValue(ByVal swfObj, ByVal prop)
	If swfObj.Exist(5) Then
		PropertyGridGetValue = swfObj.GetValue(prop)
	Else
		ReportMessage "Fail", "Property grid Object " & swfObj.toString() & " doesn't exist. ", false, "Y"
		PropertyGridGetValue = -1
	End If
End Function
RegisterUserFunc "SwfPropertyGrid", "GetValue", "PropertyGridGetValue"

'! This function will scroll to the next specified line number
'! @param swfObj Input - ScrollBar object
'! @param lineNum Input - Line number to move to
'! @return '0' for success or '-1' for failure
'! @author Aflac IT QA - NIIT Automation Team – Vikas
'! @version V1.0
'! @date 06/15/2015
Public Function ScrollBarNextLine(ByVal swfObj, ByVal lineNum)
   	If swfObj.Exist(5) Then
		swfObj.NextLine lineNum
		ScrollBarNextLine = 0
	Else
		ReportMessage "Fail", "Scroll Bar Object " & swfObj.toString() & " doesn't exist. ", false, "Y"
		ScrollBarNextLine = -1
	End If
End Function
RegisterUserFunc "SwfScrollBar", "NextLine", "ScrollBarNextLine"

'! This function will scroll to the next specified page number
'! @param swfObj Input - ScrollBar object
'! @param pageNum Input - Page number to move to
'! @return '0' for success or '-1' for failure
'! @author Aflac IT QA - NIIT Automation Team – Vikas
'! @version V1.0
'! @date 06/15/2015
Public Function ScrollBarNextPage(ByVal swfObj, ByVal pageNum)
	If swfObj.Exist(5) Then
		swfObj.NextPage pageNum
		ScrollBarNextPage = 0
	Else
		ReportMessage "Fail", "Scroll Bar Object " & swfObj.toString() & " doesn't exist. ", false, "Y"
		ScrollBarNextPage = -1
	End If
End Function
RegisterUserFunc "SwfScrollBar", "NextPage", "ScrollBarNextPage"

'! This function will scroll to the previous specified line number
'! @param swfObj Input - ScrollBar object
'! @param lineNum Input - Line number to move to
'! @return '0' for success or '-1' for failure
'! @author Aflac IT QA - NIIT Automation Team – Vikas
'! @version V1.0
'! @date 06/15/2015
Public Function ScrollBarPrevLine(ByVal swfObj, ByVal lineNum)
	If swfObj.Exist(5) Then
		swfObj.PrevLine lineNum
		ScrollBarPrevLine = 0
	Else
		ReportMessage "Fail", "Scroll Bar Object " & swfObj.toString() & " doesn't exist. ", false, "Y"
		ScrollBarPrevLine = -1
	End If
End Function
RegisterUserFunc "SwfScrollBar", "PrevLine", "ScrollBarPrevLine"

'! This function will scroll to the previous specified page number
'! @param swfObj Input - ScrollBar object
'! @param pageNum Input - Page number to move to
'! @return '0' for success or '-1' for failure
'! @author Aflac IT QA - NIIT Automation Team – Vikas
'! @version V1.0
'! @date 06/15/2015
Public Function ScrollBarPrevPage(ByVal swfObj, ByVal pageNum)
	If swfObj.Exist(5) Then
		swfObj.PrevPage pageNum
		ScrollBarPrevPage = 0
	Else
		ReportMessage "Fail", "Scroll Bar Object " & swfObj.toString() & " doesn't exist. ", false, "Y"
		ScrollBarPrevPage = -1
	End If
End Function
RegisterUserFunc "SwfScrollBar", "PrevPage", "ScrollBarPrevPage"

'! This function will set scroll position
'! @param swfObj Input - ScrollBar object
'! @param pos Input - ScrollBar position to set
'! @return '0' for success or '-1' for failure
'! @author Aflac IT QA - NIIT Automation Team – Vikas
'! @version V1.0
'! @date 06/15/2015
Public Function ScrollBarSet(ByVal swfObj, ByVal pos)
   If swfObj.exist(5) Then
		swfObj.Set pos
		ScrollBarSet = 0
	Else
		ReportMessage "Fail", "Scroll Bar Object " & swfObj.toString() & " doesn't exist. ", false, "Y"
		ScrollBarSet = -1	
   End If
End Function
RegisterUserFunc "SwfScrollBar", "Set", "ScrollBarSet"

'! This function will spin the SpinObject to the next position
'! @param swfObj Input - Spin object
'! @return '0' for success or '-1' for failure
'! @author Aflac IT QA - NIIT Automation Team – Vikas
'! @version V1.0
'! @date 06/15/2015
Public Function SpinNext(ByVal swfObj)
   If swfObj.exist(5) Then
		swfObj.Next
		SpinNext = 0
	Else
		ReportMessage "Fail", "Spin Object " & swfObj.toString() & " doesn't exist. ", false, "Y"
		SpinNext = -1	
   End If
End Function
RegisterUserFunc "SwfSpin", "Next", "SpinNext"

'! This function will spin the SpinObject to the previous position
'! @param swfObj Input - Spin object
'! @return '0' for success or '-1' for failure
'! @author Aflac IT QA - NIIT Automation Team – Vikas
'! @version V1.0
'! @date 06/15/2015
Public Function SpinPrev(ByVal swfOb)
   If swfObj.exist(5) Then
		swfObj.Prev
		SpinPrev = 0
	Else
		ReportMessage "Fail", "Spin Object " & swfObj.toString() & " doesn't exist. ", false, "Y"
		SpinPrev = -1	
   End If
End Function
RegisterUserFunc "SwfScrollBar", "Prev", "SpinPrev"

'! This function will spin the SpinObject to the specified spin value
'! @param swfObj Input - Spin object
'! @param spinValue Input - Value set for the Spin object
'! @return '0' for success or '-1' for failure
'! @author Aflac IT QA - NIIT Automation Team – Vikas
'! @version V1.0
'! @date 06/15/2015
Public Function SpinSet(ByVal swfObj, ByVal spinValue)
   If swfObj.exist(5) Then
		swfObj.Set spinValue
		SpinSet = 0
	Else
		ReportMessage "Fail", "Spin Object " & swfObj.toString() & " doesn't exist. ", false, "Y"
		SpinSet = -1	
   End If
End Function
RegisterUserFunc "SwfScrollBar", "Set", "SpinSet"

'! This function is used to perform the sync
'! @param swfObj Input - Any Object
'! @return NA
'! @author Aflac IT QA - NIIT Automation Team – Vikas
'! @version V1.0
'! @date 06/15/2015
Public Function SyncDotNetApplication(ByVal swfObj, ByVal screenName, ByVal reportError, ByVal waitTime)
	Dim counter, objStatus
	objStatus = False
'	If waitTime = "" Then
'		waitTime = 4
'	End If
counter = 1
	Do
	If Not(swfObj.Exist(1)) Then
'			wait 1
			If Not(reportError) and counter = waitTime Then
				Exit DO
			End If
		Else
			objStatus = True
			Exit DO
		End If
		counter=counter+1
	Loop While counter <10

' 	For counter = 1 To 60
'		If Not(swfObj.Exist(1)) Then
''			wait 1
'			If Not(reportError) and counter = waitTime Then
'				Exit For
'			End If
'		Else
'			objStatus = True
'			Exit For
'		End If
''	Next

	If Not(objStatus) and reportError Then
		SetIterStatusFailure()
		ReportMessage "Fail", "Object " & swfObj.toString() & " doesn't exist. ", False, "Y"
	ElseIf objStatus Then
		If screenName = "" Then
			screenName = "Application"
		End If
		ReportMessage "Pass", screenName & " screen loaded properly. ", False, "Y"
	End If
End Function
RegisterUserFunc "SwfComboBox", "SyncDNApps", "SyncDotNetApplication"
RegisterUserFunc "SwfEdit", "SyncDNApps", "SyncDotNetApplication"
RegisterUserFunc "SwfButton", "SyncDNApps", "SyncDotNetApplication"
RegisterUserFunc "SwfTable", "SyncDNApps", "SyncDotNetApplication"
RegisterUserFunc "SwfLabel", "SyncDNApps", "SyncDotNetApplication"

'! This function is used to handle the windows dailog popup
'! @param dialogText Input Dialog title text
'! @return NA
'! @author Aflac IT QA - NIIT Automation Team – Vikas
'! @version V1.0
'! @date 07/20/2015
Public Function HandleDotNetDialog(ByVal dialogText, ByVal buttonText)
	wait 1
	While Dialog("text:=.*" & dialogText & ".*", "index:=0").Exist(1)
		If buttonText <> "" Then
			If Dialog("text:=.*" & dialogText & ".*", "index:=0").WinButton("text:=.*" & buttonText).Exist(1) Then
				dialogBoxText = GetDialogBoxText(Dialog("text:=.*" & dialogText & ".*", "index:=0"))
				Dialog("text:=.*" & dialogText & ".*", "index:=0").WinButton("text:=.*" & buttonText).Click
				If dialogBoxText <> "" Then
					ReportMessage "Info", "Clicked on '" & buttonText & "' button on the dialog box having title - '" & dialogText & "' and with text - '" & dialogBoxText & "'", False, "N"
				Else
					ReportMessage "Info", "Clicked on '" & buttonText & "' button on the dialog box having title - '" & dialogText & "'", False, "N"
				End If
'				wait 1
				Exit Function
			End If
		End If

		If Dialog("text:=.*" & dialogText & ".*", "index:=0").WinButton("text:=OK").Exist(1) Then
			dialogBoxText = GetDialogBoxText(Dialog("text:=.*" & dialogText & ".*", "index:=0"))
			Dialog("text:=.*" & dialogText & ".*", "index:=0").WinButton("text:=OK").Click
			If dialogBoxText <> "" Then
				ReportMessage "Info", "Clicked on 'OK' button on the dialog box having title - '" & dialogText & "' and with text - '" & dialogBoxText & "'", False, "N"
			Else
				ReportMessage "Info", "Clicked on 'OK' button on the dialog box having title - '" & dialogText & "'", False, "N"
			End If
			Exit Function
'			wait 1
		ElseIf Dialog("text:=.*" & dialogText & ".*", "index:=0").WinButton("text:=.*Yes").Exist(1) Then
			dialogBoxText = GetDialogBoxText(Dialog("text:=.*" & dialogText & ".*", "index:=0"))
			Dialog("text:=.*" & dialogText & ".*", "index:=0").WinButton("text:=.*Yes").Click
			If dialogBoxText <> "" Then
				ReportMessage "Info", "Clicked on 'Yes' button on the dialog box having title - '" & dialogText & "' and with text - '" & dialogBoxText & "'", False, "N"
			Else
				ReportMessage "Info", "Clicked on 'Yes' button on the dialog box having title - '" & dialogText & "'", False, "N"
			End If
			Exit Function
'			wait 1
		End If
		Exit function 
	Wend
End Function

'! This function is used to get the content of the dialog window
'! @param dialogBoxObj Dialog box object
'! @return Dialog box text message
'! @author Aflac IT QA - NIIT Automation Team – Vikas
'! @version V1.0
'! @date 07/27/2015
Private Function GetDialogBoxText(ByVal dialogBoxObj)
	Dim indexVal
	indexVal = 0
	
	While dialogBoxObj.Static("hwnd:=.*", "index:=" & indexVal).Exist(1)
        dialogBoxText = dialogBoxObj.Static("hwnd:=.*", "index:=" & indexVal).GetROProperty("text")
		dialogBoxTextLen = Len(dialogBoxText)
		indexVal = indexVal + 1
		If dialogBoxTextLen > 10 Then
			GetDialogBoxText = dialogBoxText
			Exit Function
		End If
	Wend

	GetDialogBoxText = ""
End Function

'Function added by Tushar Batra on 7/28/20 to get the text of new SWFWindow with EV number in the latest build.
Private Function GetSwfWindowText(ByVal dialogBoxObj)
	Dim indexVal
	indexVal = 0
	
	While dialogBoxObj.Exist(1)
        UnregisterUserFunc "SwfLabel", "GetROProperty"
         dialogBoxText = dialogBoxObj.SwfLabel("swfname:=label1","swftypename:=System.Windows.Forms.Label").GetROProperty("text")
		dialogBoxTextLen = Len(dialogBoxText)
		indexVal = indexVal + 1
		If dialogBoxTextLen > 10 Then
			GetSwfWindowText = dialogBoxText
			Exit Function
		End If
	Wend

	GetSwfWindowText = ""
End Function

'! This is generic function which can be used to close any application
'! @param applicationName Name of the application to be closed
'! @return NA
'! @author Aflac IT QA - NIIT Automation Team – Vikas
'! @version V1.0
'! @date 07/27/2015
Public Function CloseAllApplicationsByName(ByVal applicationName)
 	ReportMessage "Info", "Closing all the existing application with Application Name = " & applicationName, False, "N"
	SystemUtil.CloseProcessByName applicationName
End Function
