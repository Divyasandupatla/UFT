
Private columnCount_, rowCount_
'Public appsInputDataTablePath:appsInputDataTablePath = "F:\Old Framework Code\AflacAutomation\DataTable\APPS.xls"
'Public appsInputDataTablePath:appsInputDataTablePath = "F:\BOTAutomation\Data\WDData.xls"
Public appsInputDataTablePath:appsInputDataTablePath = "G:\NIIT Automation\Manual_Execution\MMR\Robotics\Robotics_NewAppEntry.xls"
Public inputDataTableDictObj:Set inputDataTableDictObj = CreateDict()

'! This function is used to set the column count for the datatable
'! @param columnCount Input - Datatable column count
'! @remarks  Setter function
'! @return NA
'! @author Aflac IT QA - NIIT Automation Team – Vikas
'! @version V1.0
'! @date 05/29/2015
Public Function SetDataTableColumnCount(ByVal columnCount)
   columnCount_ = columnCount
End Function

'! This function is used to get the column count of the datatable
'! @remarks  Getter function
'! @return Datatable column count
'! @author Aflac IT QA - NIIT Automation Team – Vikas
'! @version V1.0
'! @date 05/29/2015
Public Function GetDataTableColumnCount()
   GetDataTableColumnCount = columnCount_
End Function


'! This function is used to set the row count for the datatable
'! @param rowCount Input - Datatable row count
'! @remarks  Setter function
'! @return NA
'! @author Aflac IT QA - NIIT Automation Team – Vikas
'! @version V1.0
'! @date 05/29/2015
Public Function SetDataTableRowCount(ByVal rowCount)
   rowCount_ = rowCount
End Function

'! This function is used to get the row count of the datatable
'! @remarks  Getter function
'! @return Datatable row count
'! @author Aflac IT QA - NIIT Automation Team – Vikas
'! @version V1.0
'! @date 05/29/2015
Public Function GetDataTableRowCount()
   GetDataTableRowCount = rowCount_
End Function

'! This function is used to get the row count of the datatable, keyname will always be "#" followed by row number
'! @param dataTablePath Input - Physical location of the datatable
'! @param sheetName Input - Sheet name of the XLS file
'! @param colName Input - Name of the column on which we want to apply the filter
'! @param columnFilteredSubstring Input - String which will be used for filtering the rows to be executed
'! @param inputDataTableDictObj Output -  Dictionary object in which all the rows are stored
'! @remarks  Function will populate a dictionary object after reading the complete datatable and use that object for further execution
'! @return Dictionary object containing all the filtered execution rows
'! @author Aflac IT QA - NIIT Automation Team – Vikas
'! @version V1.0
'! @date 05/29/2015
Public Function CreateExcelDBObject(ByVal dataTablePath, ByVal sheetName, ByVal colName, ByVal columnFilteredSubstring, ByRef inputDataTableDictObj)

	Dim dbQuery, objDB, objResults, totalNumberOfColumns, totalNumberOfRows
	totalNumberOfRows = 0

	'ReportMessage "INFO", "Reading the input sheet - '" & sheetName & "' from the datatable located at '" & dataTablePath & "' path, filter is set on column name - '" & _
					'colName & "' for column values as '" & columnFilteredSubstring & "' ", False, "N"
	If Not(IsObject(inputDataTableDictObj)) Then
        Set inputDataTableDictObj = CreateDict()
	End If

	If colName <> "" Then
		dbQuery = "Select * from [" & sheetName & "$] where (" & colName & " Like '" & columnFilteredSubstring & "')"
	Else
		dbQuery = "Select * from [" & sheetName & "$]"
	End If
	
	Set objDB=CreateObject("ADODB.Connection")
	With objDB
		'.Provider = "Microsoft.Jet.OLEDB.4.0"		'This line is commented by Amit Garg on 10/18/2017 to fix the connection issue happened because of windows update KB4041678.
		.Provider = "Microsoft.Ace.OLEDB.12.0"		'This line is added by Amit Garg on 10/18/2017 to fix the connection issue happened because of windows update KB4041678.
		.ConnectionString = "Data Source=" & dataTablePath & " ;Extended Properties=Excel 8.0;"
		.Open
	End With
	Set objResults = objDB.Execute(dbQuery)
	totalNumberOfColumns = objResults.Fields.Count
	SetDataTableColumnCount totalNumberOfColumns
		
	While Not objResults.EOF
		totalNumberOfRows = totalNumberOfRows + 1
		For colCount = 0 To totalNumberOfColumns-1
			AddDictItem inputDataTableDictObj, objResults.Fields(colCount).name & "#" & totalNumberOfRows, objResults.Fields(colCount).value
		Next
		objResults.MoveNext
	Wend
	SetDataTableRowCount totalNumberOfRows
	Set objDB = Nothing
	Set objResults = Nothing
End Function

'! This function is used to clear all the object, variables after the execution is completed
'! @remarks  Clears objects after completing the execution
'! @return NA
'! @author Aflac IT QA - NIIT Automation Team – Vikas
'! @version V1.0
'! @date 05/29/2015
Public Function ClearObjectData()
	SetDataTableColumnCount ""
	SetDataTableRowCount ""
End Function

'! This function is used to remove a particular test row once the execution is completed for that
'! @param index Input - Index for the similar item that needs to be deleted
'! @param inputDataTableDictObj Output - Dictionary object containing all the filtered execution rows
'! @remarks  Clears objects after completing the execution
'! @return Dictionary object from which the executed row is deleted
'! @author Aflac IT QA - NIIT Automation Team – Vikas
'! @version V1.0
'! @date 05/29/2015
Public Function RemoveDictObjData(ByRef inputDataTableDictObj, ByVal index)
	Dim keyArr, iter

	keyArr = inputDataTableDictObj.Keys
	For iter = 0 To Ubound(keyArr)
        If Instr(keyArr(iter), "#" & index) <> 0 Then
			inputDataTableDictObj.Remove keyArr(iter)
		End If
	Next
End Function


'! This function is used to get the row count of the datatable, keyname will always be "#" followed by row number
'! @param dataTablePath Input - Physical location of the datatable
'! @param sheetName Input - Sheet name of the XLS file
'! @param colName Input - Name of the column on which we want to apply the filter
'! @param columnFilteredSubstring Input - String which will be used for filtering the rows to be executed
'! @param inputDataTableDictObj Output -  Dictionary object in which all the rows are stored
'! @remarks  Function will populate a dictionary object after reading the complete datatable and use that object for further execution
'! @return Dictionary object containing all the filtered execution rows
'! @author Aflac IT QA - NIIT Automation Team – Vikas
'! @version V1.0
'! @date 05/29/2015
Public Function CreateExcelDataTableObject(ByVal dataTablePath, ByVal sheetName, ByVal colName, ByVal columnFilteredSubstring, ByRef inputDataTableDictObj)
	Dim columnCount, rowCount, rowNum, colNum, columnName, dictItemNum
	dictItemNum = 1

	ReportMessage "INFO", "Reading the input sheet - '" & sheetName & "' from the datatable located at '" & dataTablePath & "' path, filter is set on column name - '" & _
					colName & "' for column values as '" & columnFilteredSubstring & "' ", False, "N"

	If Not(IsObject(inputDataTableDictObj)) Then
        Set inputDataTableDictObj = CreateDict()
	End If
	
	Datatable.ImportSheet dataTablePath, sheetName, "Global"
	rowCount = DataTable.GetSheet(dtGlobalSheet).GetRowCount()
	columnCount = DataTable.GetSheet(dtGlobalSheet).GetParameterCount()
	SetDataTableColumnCount columnCount

	For rowNum = 1 To rowCount
		For colNum = 1 To columnCount
			columnName = DataTable.GetSheet(dtGlobalSheet).GetParameter(colNum).Name
			columnValue = DataTable.GetSheet(dtGlobalSheet).GetParameter(colNum).Value
			AddDictItem inputDataTableDictObj, columnName & "#" & dictItemNum, columnValue
			If colName <> "" Then
				If lcase(colName) = lcase(columnName) Then
					If Not(Instr(1, lcase(columnValue), lcase(columnFilteredSubstring)) <> 0) Then
						RemoveDictObjData inputDataTableDictObj, dictItemNum
						dictItemNum = dictItemNum - 1
						Exit For
					End If
				End If
			End If
		Next
		dictItemNum = dictItemNum + 1
		DataTable.SetNextRow
	Next
	SetDataTableRowCount dictItemNum-1
	
End Function


'! This function is used to get the row count of the datatable, keyname will always be "#" followed by row number
'! @param dataTablePath Input - Physical location of the datatable
'! @param sheetName Input - Sheet name of the XLS file
'! @param colName Input - Name of the column on which we want to apply the filter
'! @param columnFilteredSubstring Input - String which will be used for filtering the rows to be executed
'! @param inputDataTableDictObj Output -  Dictionary object in which all the rows are stored
'! @remarks  Function will populate a dictionary object after reading the complete datatable and use that object for further execution
'! @return Dictionary object containing all the filtered execution rows
'! @author Aflac IT QA - NIIT Automation Team – Vikas
'! @version V1.0
'! @date 05/29/2015
Public Function CreateExcelApplicationObject(ByVal dataTablePath, ByVal sheetName, ByVal colName, ByVal columnFilteredSubstring, ByRef inputDataTableDictObj)
	Dim objExcel, objSheet, rowCount, columnCount, rowNum, columnNum, dictItemNum
	dictItemNum = 0

	ReportMessage "INFO", "Reading the input sheet - '" & sheetName & "' from the datatable located at '" & dataTablePath & "' path, filter is set on column name - '" & _
					colName & "' for column values as '" & columnFilteredSubstring & "' ", False, "N"
	If Not(IsObject(inputDataTableDictObj)) Then
        Set inputDataTableDictObj = CreateDict()
	End If

	Set objExcel = CreateObject("Excel.Application")
	objExcel.Workbooks.Open dataTablePath
	objExcel.Application.Visible = False

	Set objSheet = objExcel.ActiveWorkbook.Worksheets(sheetName)
 
	rowCount = objSheet.UsedRange.Rows.Count
	columnCount = objSheet.UsedRange.columns.count
	SetDataTableColumnCount columnCount
	For rowNum = 2 to rowCount
		For columnNum =1 to columnCount
			If colName <> "" Then
				If instr(lcase(objSheet.cells(rowNum, objSheet.Range("A1:GZ1").Find(colName).Column).Value), lcase(columnFilteredSubstring)) <> 0 Then
					If columnNum = 1 Then
						dictItemNum = dictItemNum + 1
					End If
					AddDictItem inputDataTableDictObj, objSheet.cells(1, columnNum).value & "#" & dictItemNum, objSheet.cells(rowNum, columnNum).value
				End If
			Else
				If columnNum = 1 Then
					dictItemNum = dictItemNum + 1
				End If
				AddDictItem inputDataTableDictObj, objSheet.cells(1, columnNum).value & "#" & dictItemNum, objSheet.cells(rowNum, columnNum).value
			End If
		Next
	Next
	
	SetDataTableRowCount dictItemNum
	objExcel.ActiveWorkbook.Close
	objExcel.Application.Quit
 
	Set objSheet =nothing
	Set objExcel = nothing
End Function


'Public Function SyncPage()
'
'End Function
'RegisterUserFunc "Page", "Sync", "SyncPage"
'micclass=WebElement
'Class=modal in
'html id=pleaseWaitDialog
'innertext=Processing...
'html tag=DIV

Public Function CreateExcelDBObjectWith2Parameter(ByVal dataTablePath, ByVal sheetName, ByVal colName1, ByVal columnFilteredSubstring1,ByVal colName2, ByVal columnFilteredSubstring2, ByRef inputDataTableDictObj)
	Dim dbQuery, objDB, objResults, totalNumberOfColumns, totalNumberOfRows
	totalNumberOfRows = 0

'	ReportMessage "INFO", "Reading the input sheet - '" & sheetName & "' from the datatable located at '" & dataTablePath & "' path, filter is set on column name - '" & _
'					colName & "' for column values as '" & columnFilteredSubstring & "' ", False, "N"
	If Not(IsObject(inputDataTableDictObj)) Then
        Set inputDataTableDictObj = CreateDict()
	End If

	If colName1 <> "" and colName2 <> ""Then
		dbQuery = "Select * from [" & sheetName & "$] where (" & colName1 & " Like '" & columnFilteredSubstring1 & "' AND " & colName2 & " Like '" & columnFilteredSubstring2 & "')"
	Else
		dbQuery = "Select * from [" & sheetName & "$]"
	End If
	Set objDB=CreateObject("ADODB.Connection")
	With objDB
		'.Provider = "Microsoft.Jet.OLEDB.4.0"		'This line is commented by Amit Garg on 10/18/2017 to fix the connection issue happened because of windows update KB4041678.
		.Provider = "Microsoft.Ace.OLEDB.12.0"		'This line is added by Amit Garg on 10/18/2017 to fix the connection issue happened because of windows update KB4041678.
		.ConnectionString = "Data Source=" & dataTablePath & " ;Extended Properties=Excel 8.0;"
		.Open
	End With
	Set objResults = objDB.Execute(dbQuery)
	totalNumberOfColumns = objResults.Fields.Count
	SetDataTableColumnCount totalNumberOfColumns
		
	While Not objResults.EOF
		totalNumberOfRows = totalNumberOfRows + 1
		For colCount = 0 To totalNumberOfColumns-1
			AddDictItem inputDataTableDictObj, objResults.Fields(colCount).name & "#" & totalNumberOfRows, objResults.Fields(colCount).value
		Next
		objResults.MoveNext
	Wend
	SetDataTableRowCount totalNumberOfRows

	Set objDB = Nothing
	Set objResults = Nothing
End Function

'################################################################################################################################################
'Function Name			: fnWriteDataBackinInputSheet
'Purpose				: Generic function to connect to an excel file as a database and return the database connection object. This function will retry to 
'						  create the connection object in case the connection is not successful in previous attempt. Maximum try would be 5. 
'Pre-Condition			: 
'Post-Condition			: 
'-----------------------------------------------------------------------------------------------------------------------------------------------
'Input Parameters		: dataTableFilePath:- The path of the Excel file with which the connection needs to be made.  
'Output Parameters		: None
'Return Type			: DataBase connection Object. 
'Author:				: Amit Garg
'Date Written			: 04/20/2020
'Date Modified			: 
'Modification details	:
'################################################################################################################################################
Public Function CheckErrorAndCreateConnection (dataTableFilePath)
	
	On Error Resume Next
	
	For i = 1 To 5 Step 1
				
		Set objDB=CreateObject("ADODB.Connection")
		With objDB
			.Provider = "Microsoft.Ace.OLEDB.12.0"		
			.ConnectionString = "Data Source=" & dataTableFilePath & " ;Extended Properties=Excel 8.0;"
			.Open
		End With
		
		'If Err.Number = -2147467259 Then
		If Err.Number <> 0 Then
			Wait 2
			objDB.Close
			Set objDB = Nothing
			Err.Clear 
		Else			
			Exit For
		End If
			
	Next 	
	
	Set CheckErrorAndCreateConnection = objDB
	
	On Error GoTo 0
	
End Function

'################################################################################################################################################
'Function Name			: fnWriteDataBackinInputSheet
'Purpose				: Generic function to write values in excel sheet in multiple/single column based on a search criteria. 
'Pre-Condition			: 
'Post-Condition			: 
'-----------------------------------------------------------------------------------------------------------------------------------------------
'Input Parameters		:  strLookUpColumn:- The name of column in which we have search  < strLookUpRowValue >. 
'						:  strLookUpRowValue:- The value to be searched for in the column < strLookUpColumn >. The row in which this value appear will be used to write the values passed in < arrValueToBeWritten >. 
'						:  arrColNameToBeWritten: - An Array having column names in which values to be written. 
'						:  arrValueToBeWritten: - An Array having values to be written. The Array must be having the values in same sequence in which the column names are provided in the arrary < arrColNameToBeWritten >
'						:  strExcelPath:- Path of the Excel file. 
'						:  strSheetName: Sheet name in the Excel sheet to be used in the above operation. 
'Output Parameters		: None
'Return Type			: None
'Author:				: Amit Garg
'Date Written			: 04/20/2020
'Date Modified			: 
'Modification details	:
'################################################################################################################################################
Public Function fnWriteDataBackinInputSheet (ByVal strLookUpColumn, ByVal strLookUpRowValue, ByVal arrColNameToBeWritten, ByVal arrValueToBeWritten, ByVal strExcelPath, ByVal strSheetName)
	
	Dim objDB, objResults, dbQuery, blnConnectionStatus 	
	blnConnectionStatus = False	
	
	If blnConnectionStatus = False Then
		Set objDB = CheckErrorAndCreateConnection(strExcelPath)
		blnConnectionStatus = True
	End If	
	Select Case UBound(arrColNameToBeWritten)
		Case 0
			dbQuery = "Update [" & strSheetName & "$] SET " & arrColNameToBeWritten(0) & " = '" & arrValueToBeWritten(0) & "' Where " & strLookUpColumn & " = '" & strLookUpRowValue & "'"
		Case 1
			dbQuery = "Update [" & strSheetName & "$] SET " & arrColNameToBeWritten(0) & " = '" & arrValueToBeWritten(0) & "', " & arrColNameToBeWritten(1) & " = '" & arrValueToBeWritten(1) & "' Where " & strLookUpColumn & " = '" & strLookUpRowValue & "'"
		Case 2
			dbQuery = "Update [" & strSheetName & "$] SET " & arrColNameToBeWritten(0) & " = '" & arrValueToBeWritten(0) & "', " & arrColNameToBeWritten(1) & " = '" & arrValueToBeWritten(1) & "', " & arrColNameToBeWritten(2) & " = '" & arrValueToBeWritten(2) &"' Where " & strLookUpColumn & " = '" & strLookUpRowValue & "'"
	End Select			
	Do
		Set objResults = objDB.Execute(dbQuery)
		
		If Instr(Err.Description, "updateable query") > 0 OR Instr(Err.Description, "Operation is not allowed when the object is closed") > 0 Then
			Wait 2
			objDB.Close
			Set objDB = Nothing
			Err.Clear
			Set objDB = CheckErrorAndCreateConnection(dataTableFilePath)	
		Else
			Exit Do
		End If	
	Loop While True
	
	On Error Goto 0
	
	Set objResults = Nothing
	objDB.Close
	Set objDB = Nothing
	
End Function
