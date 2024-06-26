Dim summaryReportPath, comprehensiveReportPath, resultFolderPath, webURLPath, dashboardURLPath, lastFailMsg
Dim QCPswDecryted:QCPswDecryted = False
Dim QCPass:QCPass = ""
Public screenshotNumber, summaryResultFile, comprehensiveResultFile, executedScenarioNum, executionStartTime, executionEndTime, webHostingIP, _
   webHostingPort, almStepNumber, totalTestCasesPassed, totalTestCasesFailed, applicationNameParam, resultFolderName, summaryAdditionalData

webHostingIP = "dcaalm03"
webHostingPort = "81"
screenshotNumber = 1
summaryResultFile = ""
comprehensiveResultFile = ""
executedScenarioNum = 1
totalTestCasesPassed = 0
totalTestCasesFailed = 0
almStepNumber = 1
applicationNameParam = ""
resultFolderName = ""

'! This function is used to set the path for the web hosting URL
'! @param webURL Input - Web URL path
'! @remarks  Setter function
'! @return NA
'! @author Aflac IT QA - NIIT Automation Team – Vikas
'! @version V1.0
'! @date 05/29/2015
Public Function SetWebHostingURL(ByVal webURL)
	webURLPath = webURL
End Function

'! This function returns the path for the web hosting URL
'! @remarks Getter function
'! @return Web hosting URL
'! @author Aflac IT QA - NIIT Automation Team – Vikas
'! @version V1.0
'! @date 05/29/2015
Public Function GetWebHostingURL()
		GetWebHostingURL = webURLPath
End Function

'! This function is used to set the path for the web hosting URL
'! @param webURL Input - Web URL path
'! @remarks  Setter function
'! @return NA
'! @author Aflac IT QA - NIIT Automation Team – Vikas
'! @version V1.0
'! @date 05/29/2015
Public Function SetDashboardURL(ByVal dashboardURL)
	dashboardURLPath = dashboardURL
End Function

'! This function returns the path for the web hosting URL
'! @remarks Getter function
'! @return Web hosting URL
'! @author Aflac IT QA - NIIT Automation Team – Vikas
'! @version V1.0
'! @date 05/29/2015
Public Function GetDashboardURL()
		GetDashboardURL = dashboardURLPath
End Function

'! This function is used to set the path for the screenshots
'! @param resPath Input - Screenshot path
'! @remarks Setter function
'! @return NA
'! @author Aflac IT QA - NIIT Automation Team – Vikas
'! @version V1.0
'! @date 05/29/2015
Public Function SetScreenshotFolderPath(ByVal resPath)
	resultFolderPath = resPath
End Function

'! This function returns the path for the screenshots
'! @remarks Getter function
'! @return Screenshot URL
'! @author Aflac IT QA - NIIT Automation Team – Vikas
'! @version V1.0
'! @date 05/29/2015
Public Function GetScreenshotFolderPath()
	GetScreenshotFolderPath = resultFolderPath
End Function

'! This function sets the path of the Summary view - HTML file
'! @param resPath Input - Summary.html file path
'! @remarks Setter function
'! @return NA
'! @author Aflac IT QA - NIIT Automation Team – Vikas
'! @version V1.0
'! @date 05/29/2015
Public Function SetSummaryResultPath(ByVal resPath)
	summaryReportPath = resPath
End Function

'! This function returns the path of the Summary view - HTML file
'! @remarks Getter function
'! @return Summary result file path
'! @author Aflac IT QA - NIIT Automation Team – Vikas
'! @version V1.0
'! @date 05/29/2015
Public Function GetSummaryResultPath()
	GetSummaryResultPath = summaryReportPath
End Function

'! This function sets the path of the Comprehensive view - HTML file
'! @param resPath Input - Comprehensive.html file path
'! @remarks Setter function
'! @return NA
'! @author Aflac IT QA - NIIT Automation Team – Vikas
'! @version V1.0
'! @date 05/29/2015
Public Function SetComprehensiveResultPath(ByVal resPath)
	comprehensiveReportPath = resPath
End Function

'! This function returns the path of the Comprehensive view - HTML file
'! @remarks Getter function
'! @return Comprehensive result file path
'! @author Aflac IT QA - NIIT Automation Team – Vikas
'! @version V1.0
'! @date 05/29/2015
Public Function GetComprehensiveResultPath()
	GetComprehensiveResultPath = comprehensiveReportPath
End Function

Public Function CreateHTMLResultFile(ByVal applicationName, ByVal resultFolder)

	applicationNameParam = applicationName
	resultFolderName = resultFolder
	
	CheckIfDebugOrFinalRun ()
	
	CreateResultFile()
	
	'Below line is added by Amit Garg to capture the execution start time in an enviornment variable. 
	RecordExecutionStartTime ()
	'Updated by Amit ended.
	
End Function

'! This function creates the results folder and results html file
'! @remarks Results file created are stored on a shared folder and hosted using web server
'! @return NA
'! @author Aflac IT QA - NIIT Automation Team – Vikas
'! @version V1.0
'! @date 05/29/2015
Public Function CreateResultFile()
	Dim objFSO, folderDate, executionResultDir, executionTime, resultDir, webResultDir, resultFolderCounter, screenshotFolderCounter, dateResFolderCount
	Set objFSO = CreateObject("Scripting.FilesystemObject")
	resultFolderCounter = 0
	screenshotFolderCounter = 0
	dateResFolderCount = 0

	folderDate = replace(replace(date(), "-", "_"), "/", "_")
	If resultFolderName <> "" Then
		executionResultDir = resultFolderName &"\ExecutionResults_"&folderDate
'		webResultDir = executionResultDir
		webResultDir = Replace(executionResultDir,"\","/")
'		executionResultDir = "\\dcaalm03\AutomationResults\RegressionResults\ExecutionResults_" & folderDate
		'webResultDir = "http://" & webHostingIP & ":" & webHostingPort & "/RegressionResults/ExecutionResults_" & folderDate
		If Instr(resultFolderName, "DebugResults") > 0 Then
			webResultDir = "http://" & webHostingIP & ":" & webHostingPort & "/DebugResults/ExecutionResults_" & folderDate
		End If
		
	Else
		executionResultDir = "\\dcaalm03\AutomationResults\HTMLResults\ExecutionResults_" & folderDate
'		executionResultDir = "G:\NIIT Automation\GPS20\AutomationResults\HTMLResults\ExecutionResults_" & folderDate
		webResultDir = "http://" & webHostingIP & ":" & webHostingPort & "/HTMLResults/ExecutionResults_" & folderDate
	End If
	dashboardDir = "http://" & webHostingIP & ":" & webHostingPort & "/AutomationDashboard/main.html"
	
'	If Not objFSO.FolderExists(executionResultDir) Then
'		objFSO.CreateFolder executionResultDir
'	End If

	While Not objFSO.FolderExists(executionResultDir)
		objFSO.CreateFolder executionResultDir
		dateResFolderCount = dateResFolderCount + 1
		wait 2
		If dateResFolderCount = 10 Then
			Reporter.ReportEvent micFail, "Step" & almStepNumber, "Unable to create date folder " & executionResultDir
			Exit Function
		End If
	Wend

	executionTime = replace(replace(time(), ":", "_"), " ", "_")
	If applicationNameParam <>"" Then
		
		'Below lines are added By Amit Garg on 10/04/2019 to handle the cases where applicationNameParam contains spaces and due to which URL's are generated as broken.
		If Instr(Trim(applicationNameParam), " ") > 0 Then
			applicationNameParam = Replace(applicationNameParam, " ", "_")
		End If
		'Updation from Amit Garg on 10/04/2019 ends.
		
		resultDir = executionResultDir & "\" & applicationNameParam & "_" & Environment("UserName") & "_" & ExecutionTime
		webResultDir = webResultDir & "/" & applicationNameParam & "_" & Environment("UserName") & "_" &  ExecutionTime
	Else
		resultDir = executionResultDir & "\Results_" & Environment("UserName") & "_" & ExecutionTime
		webResultDir = webResultDir & "/Results_" & Environment("UserName") & "_" & ExecutionTime
	End If

	While Not objFSO.FolderExists(resultDir)
		objFSO.CreateFolder resultDir
		resultFolderCounter = resultFolderCounter + 1
		wait 2
		If resultFolderCounter = 10 Then
			Reporter.ReportEvent micFail, "Step" & almStepNumber, "Unable to create result folder " & resultDir
			Exit Function
		End If
	Wend

	screenshotDir = resultDir & "\Screenshot"
	While Not objFSO.FolderExists(screenshotDir)
		objFSO.CreateFolder screenshotDir
		screenshotFolderCounter = screenshotFolderCounter + 1
		wait 2
		If screenshotFolderCounter = 10 Then
			Reporter.ReportEvent micFail, "Step" & almStepNumber, "Unable to create screenshot folder " & screenshotDir
			Exit Function
		End If
	Wend

	If objFSO.FileExists(resultDir & "\Summary.html") Then
		Set summaryResultFile = objFSO.OpenTextFile(resultDir & "\Summary.html", 8, True)
		Set comprehensiveResultFile = objFSO.OpenTextFile(resultDir & "\Comprehensive.html", 8, True)
	Else
		Set summaryResultFile = objFSO.CreateTextFile(resultDir & "\Summary.html", True)
		Set comprehensiveResultFile = objFSO.CreateTextFile(resultDir & "\Comprehensive.html", True)
	End If
	SetScreenshotFolderPath screenshotDir
	SetSummaryResultPath resultDir & "\Summary.html"
	SetComprehensiveResultPath resultDir & "\Comprehensive.html"
	SetWebHostingURL webResultDir
	SetDashboardURL dashboardDir

	PrintLogFileHeader summaryResultFile, GetWebHostingURL() & "/Comprehensive.html", "Comprehensive Report", "Automation run Summary report"
	PrintLogFileHeader comprehensiveResultFile, GetWebHostingURL() & "/Summary.html", "Summary Report", "Automation run Comprehensive report"

	'!Method call added to generate the Summary Report header
	GenerateExecutionSummaryReport()
	
End Function

'! This function writes the steps result in the Comprehensive file
'! @param status Input - Status of the message reported in the output file
'! @param messageInfo Input - Message information stating what operation are performed
'! @param almReportStatus Input - Value will be True/False if we want to report this message in ALM
'! @param screenshot Input - '!Y'! or '!YES'! if we want to take screenshot/ '!N'!,  or '!NO'! if we dont want to take screenshot
'! @remarks Step results are shown in different colors according to the value if the status param
'! @return NA
'! @author Aflac IT QA - NIIT Automation Team – Vikas
'! @version V1.0
'! @date 05/29/2015
Public Function ReportMessage(ByVal status, ByVal messageInfo, ByVal almReportStatus, ByVal screenshot)
	Dim color, screenshotFile, msg, htmlMessage, almStatus

	If lcase(status) = "info" Then
		color = "black"
		almStatus = micDone
	ElseIf lcase(status) = "pass" Then
		color = "green"
		almStatus = micPass
	ElseIf lcase(status) = "warn" Then
		color = "purple"
		almStatus = micWarning
	ElseIf lcase(status) = "fail" Then
		lastFailMsg = ""
		color = "red"
		almStatus = micFail
		lastFailMsg = messageInfo 'To report last failed msg in ALM TC Execution status - DC
	ElseIf Instr(1, lcase(status), "scenario") > 0 Then
		color = "blue"
	End If

	If QCUtil.IsConnected and almReportStatus = True Then
        Reporter.ReportEvent almStatus, "Step" & almStepNumber, messageInfo
		almStepNumber = almStepNumber + 1
	End If


	
	If IsObject(screenshot) = True Then
		If screenshot.getToProperty("micclass") = "Browser" Then
			screenshotFile = GetScreenshotFolderPath() & "\Screenshot" & screenshotNumber & ".html"
			'Dim htmlFileName, doc, outputStream

 			'htmlFileName = screenshotFile
' 			Set outputStream = CreateObject("Adodb.Stream")
'
' 			outputStream.Open
' 			outputStream.Charset = "UTF-8"
' 			outputStream.Type = 2
' 			
' 			Set doc = screenshot.Object.Document
' 			outputStream.writeText "<html>" & doc.documentElement.innerHTML & "</html>", 1
' 			outputStream.SaveToFile screenshotFile, 2 
' 			outputStream.Close
 			
 			
 			Set outputStream = CreateObject("Adodb.Stream")
 			outputStream.Open
 			outputStream.Charset = "UTF-8"
 			outputStream.Type = 2 

			Set ie = screenshot.Object
			Set doc = ie.Document
			hostURL = ie.LocationURL
			'urlArr = Split(hostURL, "/")
			urlArr = Split(hostURL, "/")

 			If UBound(urlArr) > 0 Then
 				hostURL = urlArr(0) & urlArr(1) & "//" & urlArr(2)
    			outputStream.writeText "<html><base href=" & hostURL & ">" & doc.documentElement.innerHTML & "</html>", 1
    			outputStream.SaveToFile screenshotFile, 2
			End if
 			
 			
 			
 		'	msg = "[Time: " & time() & "]" & " - Status: " & status & ",	Message: " & messageInfo & "<a href= " & GetWebHostingURL() & "/Screenshot/Screenshot" & screenshotNumber & ".html" & "> Screenshot </a><br></br>"
 			msg = "[Time: " & time() & "]" & " - Status: " & status & ",	Message: " & messageInfo & "<a href= " & GetWebHostingURL() & "/Screenshot/Screenshot" & screenshotNumber & ".html" & "> Screenshot </a><br></br>"
			htmlMessage = "<font color=" & color & ">" & msg & "</font>"
			comprehensiveResultFile.Write htmlMessage
			screenshotNumber = screenshotNumber + 1
			Exit Function
		End If
	'ElseIf 
	ElseIf lcase(screenshot) = "y" or lcase(screenshot) =  "yes" Then
		screenshotFile = GetScreenshotFolderPath() & "\Screenshot" & screenshotNumber & ".png"
		Desktop.CaptureBitmap screenshotFile
		
		msg = "[Time: " & time() & "]" & " - Status: " & status & ",	Message: " & messageInfo & "<a href= " & GetWebHostingURL() & "/Screenshot/Screenshot" & screenshotNumber & ".png" & "> Screenshot </a><br></br>"
		htmlMessage = "<font color=" & color & ">" & msg & "</font>"
		comprehensiveResultFile.Write htmlMessage
		screenshotNumber = screenshotNumber + 1

	Else
		msg = "[Time: "& time() &"]"&" - Status: " & status & ", Message: " & messageInfo & "<br></br>"
		htmlMessage = "<font color=" & color & ">" & msg & "</font>"
		comprehensiveResultFile.Write htmlMessage
	End If
End Function

'! This method will create a basic HTML result file and creates the hyperlink for toggling between Summary and Comprehensive reports
'! @param logFile Input - File system object for writing into the log file
'! @param logFilePath Input - Absolute path of the log file
'! @param logFileName Input - Name if the log file
'! @param headerString Input - Header string for the report
'! @remarks Generates the HTML log file header
'! @return NA
'! @author Aflac IT QA - NIIT Automation Team – Vikas
'! @version V1.0
'! @date 05/29/2015
Private Function PrintLogFileHeader(ByVal logFile, ByVal logFilePath, ByVal logFileName, ByVal headerString)
	Dim rc

	logFile.writeline "<HTML><HEAD>"
	logFile.writeline "<BODY>"
	logFile.writeline "<style type=text/css>"
	logFile.writeline "BODY"
	logFile.writeline "{PADDING-RIGHT: 0px; PADDING-LEFT: 0px; FONT-SIZE: 11px; PADDING-BOTTOM: 0px; MARGIN: 0px; PADDING-TOP: 0px;FONT-FAMILY: Tahoma, Verdana, Sans-Serif; BACKGROUND-COLOR: #ffffff;}"
	logFile.writeline ".logoTable"
	logFile.writeline "{FONT-SIZE: 11px; COLOR: #333333;BACKGROUND-COLOR: #00a7e1; FONT-FAMILY: Tahoma, Verdana, Geneva; TEXT-DECORATION: none}"
	logFile.writeline "TD"
	logFile.writeline "{FONT-SIZE: 11px; COLOR: ""black""; FONT-FAMILY: Tahoma, Verdana, Geneva; TEXT-DECORATION: none}"
	logFile.writeline "TH"
	logFile.writeline "{font-size:14px;background-color:#00a7e1;border-width: 1px;padding: 8px;border-style: solid;border-color: #729ea5;text-align:left;color:#ffffff;}"
	logFile.writeline ".inner"
	logFile.writeline "{FONT-SIZE: 15px;}"
	logFile.writeline ".subheading"
	logFile.writeline "{BACKGROUND-COLOR:#dcdcdc}"
	logFile.writeline "</style>"
	logFile.writeline "<TABLE class = ""logoTable"" cellSpacing=0 cellPadding=0 width=""100%"" border=0>"
	logFile.writeline "<TBODY>"
	logFile.writeline "<TR>"
	logFile.writeline "<TD vAlign=center align=left height=""100%""  width=""25%""><IMG src=""/AflacITQA.jpg"" border=0></td>"
	logFile.writeline "<TD vAlign=bottom align=center  width=""50%""><font color=#eeeeee><p style=""FONT-SIZE: 20px;FAMILY: Arial;"">" & headerString & "&nbsp;</p></font></TD>"

	logFile.writeline "<TD vAlign=bottom align=right  width=""25%""><font color=#eeeeee><p style=""FONT-SIZE: 12px;FAMILY: Arial;"">" & "Date:&nbsp;" & Now() & "&nbsp; &nbsp;<IMG src=""/AflacDuck.png"" border=0></p></font></TD>"
	logFile.writeline "</TR>"
	logFile.writeline "</table>"

	logFile.WriteLine "<br> &nbsp; <a href=""" & logFilePath & """>" & logFileName & "</a>"
	logFile.WriteLine "<br></br>"

End Function

'! This function closes the html log files created and destroys the object
'! @remarks Closes the log file and resets the parameters
'! @return NA
'! @author Aflac IT QA - NIIT Automation Team – Vikas
'! @version V1.0
'! @date 05/29/2015
Public function CloseLogFiles()

	If GetComprehensiveResultPath() <> "" Then
		comprehensiveResultFile.WriteLine "</td></tr></table>"
		comprehensiveResultFile.WriteLine "</BODY></HTML>"
		comprehensiveResultFile.Close
	End If

	If GetSummaryResultPath() <> "" Then
		summaryResultFile.WriteLine "</table>"
		summaryResultFile.WriteLine "</br>"
		
		'Below lines are added by Amit Garg to log the execution start time, end time and duration in the summary.html file.
		RecordExecutionEndTime ()
		Call PrintExecutionDetails (summaryResultFile)
		'Updates from Amit Garg ended.
		
		summaryResultFile.WriteLine "</BODY></HTML>"
		summaryResultFile.Close
	End If

	Set summaryResultFile = Nothing
	Set comprehensiveResultFile = nothing

	ResetAllParameters()
End Function

'! This function creates the header'!s for the summary report file
'! @remarks Generates the Parameter header and execution results in the Summary HTML file
'! @return NA
'! @author Aflac IT QA - NIIT Automation Team – Vikas
'! @version V1.0
'! @date 05/29/2015
Private Function GenerateExecutionSummaryReport()
	Dim qtApp:Set qtApp = CreateObject("QuickTest.Application") 
	Dim pDefColl:Set pDefColl = qtApp.Test.ParameterDefinitions
	paramCount = pDefColl.Count

	summaryResultFile.WriteLine "<style type=""text/css"">"
	summaryResultFile.WriteLine ".tftable {font-size:12px;color:#ffffff;width:100%;border-width: 1px;border-color: #729ea5;border-collapse: collapse;}"
	summaryResultFile.WriteLine ".tftable th "
	summaryResultFile.WriteLine "{font-size:14px;background-color:#00a7e1;border-width: 1px;padding: 8px;border-style: solid;border-color: #729ea5;text-align:left;}"
	summaryResultFile.WriteLine ".tftable tr {background-"
	summaryResultFile.WriteLine "color:#dcdcdc;}"
	summaryResultFile.WriteLine ".tftable td {font-size:12px;border-width: 1px;padding: 8px;border-style: solid;border-color: #729ea5;color:black;}"
	summaryResultFile.WriteLine ".tftable tr:hover {background-"
	summaryResultFile.WriteLine "color:#ffffff;}"
	summaryResultFile.WriteLine "</style>"

	If paramCount > 0 Then
		summaryResultFile.WriteLine "<TABLE class=""tftable"">"
		summaryResultFile.WriteLine "<TR><TH width=""40%"">Test Parameter Name</TH><TH width=""60%"">Test Parameter Value</TH></TR>"
		For paramNum = 1 To paramCount
			Set pDef = pDefColl.Item(paramNum)
			If pDef.Type <> 4 Then
				summaryResultFile.WriteLine "<TR><TD>" & pDef.Name & "</TD><TD>" & TestArgs(pDef.Name) &"</TD></TR>"
			End If
		Next
		summaryResultFile.WriteLine "</table><br>"
	End If

	summaryResultFile.WriteLine "<table class=""tftable"" border=""1"">"
	summaryResultFile.WriteLine "<tr><th width=""40%"">Scenario Name</th><th width=""10%"">Status</th><th width=""30%"">Additional Data</th><th width=""20%"">Execution Time</th></tr>"

End Function

'! This function writes the scenario status after completion of the execution in Summary file
'! @param scenarioName Input - Name of the scenario executed
'! @param testcaseStatus Input - Status of the scenario executed
'! @remarks Scenario results are written on the Summary HTML file
'! @return NA
'! @author Aflac IT QA - NIIT Automation Team – Vikas
'! @version V1.0
'! @date 05/29/2015
Public Function SummaryExecutionStatus(ByVal scenarioName, ByVal testcaseStatus)
	'!Calling method to end the test case in the comprehensive file
	If GetRegexMatchCount(lcase(scenarioName), "login.*mainframe|logout.*mainframe") = 0 Then
		LogTestCaseEndMessage scenarioName
	
		executionTimeSec = datediff("s", executionStartTime, executionEndTime)
		executionTime = int(executionTimeSec/60) & " mins and " & int(executionTimeSec mod 60) & " secs"
		If Ucase(testcaseStatus) = "PASS" Then
			totalTestCasesPassed = totalTestCasesPassed + 1
			executionStatus = "<font color=green>" & Ucase(testcaseStatus) & "</font>"
		ElseIf Ucase(testcaseStatus) = "FAIL" Then
			totalTestCasesFailed = totalTestCasesFailed + 1
			executionStatus = "<font color=red>" & Ucase(testcaseStatus) & "</font>"
		End If
'		summaryResultFile.WriteLine "<tr><td><a href=" & GetWebHostingURL() & "/Comprehensive.html#" & replace(scenarioName, " ", "") & executedScenarioNum & ">" & scenarioName & ": " & executedScenarioNum & "</a></td><td>"& executionStatus & "</td><td>"& summaryAdditionalData & "</td><td>" & executionTime & "</td></tr>"
		summaryResultFile.WriteLine "<tr><td><a href=" & GetWebHostingURL() & "/Comprehensive.html#" & replace(scenarioName, " ", "") & executedScenarioNum & ">" & executedScenarioNum & ": "  & scenarioName & "</a></td><td>"& executionStatus & "</td><td>"& summaryAdditionalData & "</td><td>" & executionTime & "</td></tr>"
		executedScenarioNum = executedScenarioNum + 1
	
		executionStartTime = ""
		executionEndTime = ""
	End If
End Function

'! This function shows the start of a scenario in the Comprehensive file
'! @param scenarioName Input - Name of the scenario executed
'! @remarks Shows starting of the test cases execution
'! @return NA
'! @author Aflac IT QA - NIIT Automation Team – Vikas
'! @version V1.0
'! @date 05/29/2015
Public Function LogTestCaseStartMessage(ByVal scenarioName)
	summaryAdditionalData = ""
 	If GetRegexMatchCount(lcase(scenarioName), "login.*mainframe|logout.*mainframe") = 0 Then
		executionStartTime = Time()
		comprehensiveResultFile.WriteLine "<div id=iterationDiv>"
		comprehensiveResultFile.WriteLine "<TABLE class=""logoTable"" cellSpacing=0 cellPadding=0 width=100% border=0>"
		comprehensiveResultFile.WriteLine "<TBODY>"
'		comprehensiveResultFile.WriteLine "<tr height=24><th><a name=" & replace(scenarioName, " ", "") & executedScenarioNum & ">" & scenarioName & ": " & executedScenarioNum & "</a></STRONG></th></tr>"
		comprehensiveResultFile.WriteLine "<tr height=24><th><a name=" & replace(scenarioName, " ", "") & executedScenarioNum & ">" & executedScenarioNum & ": " & scenarioName & "</a></STRONG></th></tr>"
		comprehensiveResultFile.WriteLine "</TBODY>"
		comprehensiveResultFile.WriteLine "</TABLE>"
	End If

End Function

'! This function shows the end of a scenario in the Comprehensive file
'! @param scenarioName Input - Name of the scenario executed
'! @remarks Shows end of the test cases execution
'! @return NA
'! @author Aflac IT QA - NIIT Automation Team – Vikas
'! @version V1.0
'! @date 05/29/2015
Private Function LogTestCaseEndMessage(ByVal scenarioName)
	executionEndTime = Time()
	executionTimeSec = datediff("s", executionStartTime, executionEndTime)
	executionTime = int(executionTimeSec/60) & " mins and " & int(executionTimeSec mod 60) & " secs"
	comprehensiveResultFile.WriteLine "<br></br>"
	comprehensiveResultFile.WriteLine "<TABLE class=""logoTable"" cellSpacing=0 cellPadding=0 width=100% border=0>"
	comprehensiveResultFile.WriteLine "<TBODY>"
'	comprehensiveResultFile.WriteLine "<tr height=24><th>" & scenarioName & ": " & executedScenarioNum & " - Test completed in time - " & executionTime & "</STRONG></th></tr>"
	comprehensiveResultFile.WriteLine "<tr height=24><th>" & executedScenarioNum  & ": " & scenarioName & " - Test completed in time - " & executionTime & "</STRONG></th></tr>"
	comprehensiveResultFile.WriteLine "</TBODY>"
	comprehensiveResultFile.WriteLine "</TABLE>"
	comprehensiveResultFile.WriteLine "</div>"
	comprehensiveResultFile.WriteLine "<br></br>"
	almStepNumber = 1
End Function

'! This function is used to reset all the public variables, objects for the next application execution
'! @remarks Resets the parameter value to start next execution
'! @return NA
'! @author Aflac IT QA - NIIT Automation Team – Vikas
'! @version V1.0
'! @date 05/29/2015
Private Function ResetAllParameters()
	screenshotNumber = 1
	executedScenarioNum = 1
	totalTestCasesPassed = 0
	totalTestCasesFailed = 0
End Function

'! This function is used to create the format for the email and add test parameters & result link to it
'! @param recipientEmail Input - Recipient emails where we want to send the results
'! @remarks Creating email format
'! @return NA
'! @author Aflac IT QA - NIIT Automation Team – Vikas
'! @version V1.0
'! @date 05/29/2015
Public Function GeneratingResultEmail(ByVal recipientEmail)
	Dim results
	Dim qtApp:Set qtApp = CreateObject("QuickTest.Application") 
	Dim pDefColl:Set pDefColl = qtApp.Test.ParameterDefinitions
	paramCount = pDefColl.Count
	ParamExist=False
	
	If recipientEmail <> "" Then
		results = results & "<html><body>"
		results = "<p style=""color:red"">Automated result email, please do not reply.</p>"
		results = results & "-------------------------------------------------------------------------------------------------------------------------------------------------------------<br>"
		If paramCount > 0 Then
			results = results & "<h3>Test Parameters Details</h3>"
			For paramNum = 1 to paramCount
				Set pDef = pDefColl.Item(paramNum)
				If pDef.Type <> 4 Then
					results = results & "<b>Param name: </b>" & pDef.Name & ", <b>Param Value: </b>" & TestArgs(pDef.Name) & "<br>"
				End If
				'Added by Diwakar to Pass Application Name in Subject line of Email
				If ucase(pDef.Name)="APPLICATIONNAME" then
					strAppName=TestArgs(pDef.Name)
					ParamExist=True
					Exit for
				End If
			Next
			results = results & "<b>Testscript Name</b> :"& Environment("TestName") & "<br>"
			results = results & "-------------------------------------------------------------------------------------------------------------------------------------------------------------<br>"
		End If
		results = results  & "<h3>ExecutionStatus</h3>"
		results = results & "Total Testcases Executed: <span style=""background-color:yellow""><font color=black>" & totalTestCasesPassed+totalTestCasesFailed & "</font></span><br>"
		results = results & "Total Testcases Passed: <span style=""background-color:yellow""><font color=green>" & totalTestCasesPassed & "</font></span><br>"
		results = results & "Total Testcases Failed: <span style=""background-color:yellow""><font color=red>" & totalTestCasesFailed & "</font></span><br>"
		results = results & "-------------------------------------------------------------------------------------------------------------------------------------------------------------<br>"
		results = results & "<h3>Execution Result URL</h3>"
'		If resultFolderName <> "" Then
'			results = results &"\\NTFS3\"&GetWebHostingURL() & "\Summary.html" & "<br>"
'		Else
			results = results & GetWebHostingURL() & "/Summary.html" & "<br>"
'		End If
		results = results & "-------------------------------------------------------------------------------------------------------------------------------------------------------------<br><br>"
'		results = results & "<h3>Automation Dashboard Home Page</h3>"
'		results = results & GetDashboardURL() & "<br><br>"
        results = results & "Regards,<br>"
		results = results & "Automation Team"
		results = results & "</body></html>"
		
		If ParamExist Then
			SendEmail "mail.aflac.com", "AflacAutomation@aflac.com", recipientEmail, strAppName&" Aflac Automation Execution Results", results
		else
			SendEmail "mail.aflac.com", "AflacAutomation@aflac.com", recipientEmail, "Aflac Automation Execution Results", results
		End If
		
	End If
	
	'Added by Chandrakant on 02/26/2020 to update the consolidated execution log.
	Fn_Update_AutomationExecution_SummaryReport  totalTestCasesPassed, totalTestCasesFailed, GetWebHostingURL() & "/Summary.html"
	
End Function

'! This function calls the method which will create the format for the email and add test parameters & result link to it. Also it will update the dashboard
'! @param recipientEmail Input - Recipient emails where we want to send the results
'! @param updateDashboard Input - Update dashboard - 'Yes' or 'No' if we want to update the results in Dashboard
'! @param dashboardFolderPath Input - Dashboard folder path
'! @param cluster Input - Cluster Name
'! @param region Input - Regions - SYST or INTG
'! @param applicationName Input - Name of the application
'! @param version Input - Application version
'! @param environmentDetails Input - Detail of the environment
'! @remarks Update dashboard
'! @return NA
'! @author Aflac IT QA - NIIT Automation Team – Vikas
'! @version V1.0
'! @date 11/19/2015
Public Function GenerateResultUpdateDashboard(ByVal recipientEmail, ByVal updateDashboard, ByVal dashboardFolderPath, ByVal cluster, ByVal region, ByVal applicationName, ByVal version, ByVal environmentDetails)
	'GeneratingResultEmail recipientEmail

	If lcase(updateDashboard) = "yes" Then
		dateVal = GetDateFormatted(date, "MM/DD/YYYY")
		If GetRegexMatchCount(region, "columbus|col") > 0 Then
			region = "COL"
		ElseIf GetRegexMatchCount(region, "newyork|new york|ny") > 0 Then
			region = "NY"
		End If
		executionData = cluster & "~^" & region & "~^" & applicationName & "~^" & version & "~^" & totalTestCasesPassed+totalTestCasesFailed & "~^" & _
						totalTestCasesPassed & "~^" & totalTestCasesFailed & "~^" & environmentDetails & "~^" & GetWebHostingURL() & "/Summary.html~^" & dateVal
		WriteExecutionResults dashboardFolderPath & "\", cluster, region, applicationName, executionData
	End If
End Function

'! This function is used to send an email to the recipient list with the execution parameters and results link
'! @param mailServer Input - Mail server used for sending emails
'! @param senderEmail Input - Sender email address
'! @param recipientEmail Input - Recipient emails where we want to send the results
'! @param subject Input - Subject Line for the email
'! @param detailedMessage Input - Detailed message containing the execution parameters and result link
'! @remarks Send email after execution is completed
'! @return NA
'! @author Aflac IT QA - NIIT Automation Team – Vikas
'! @version V1.0
'! @date 05/29/2015
Private function SendEmail(ByVal mailServer, ByVal senderEmail, ByVal recipientEmail, ByVal subject, ByVal detailedMessage)
	Dim objEmail:Set objEmail = CreateObject("CDO.Message")
	Err.clear

	ReportMessage "INFO", "Sending result email to the recipient listed. ", False, "N"
	objEmail.From = senderEmail
	objEmail.To = recipientEmail
	objEmail.Subject = subject
	objEmail.HTMLbody = detailedMessage
	objEmail.Configuration.Fields.Item ("http://schemas.microsoft.com/cdo/configuration/smtpserver") = mailServer
	objEmail.Configuration.Fields.Item ("http://schemas.microsoft.com/cdo/configuration/sendusing") = 2
	objEmail.Configuration.Fields.Item ("http://schemas.microsoft.com/cdo/configuration/smtpserverport") = 25
	objEmail.Configuration.Fields.Update
	objEmail.Send

	If Err.Number <> 0 Then
		SendEmail = Err.Number
		ReportMessage "FAIL", "Unable to send an email to the recipient\s - " & recipientEmail, False, "N"
	Else
		SendEmail = 0
		ReportMessage "PASS", "Successfully send an email to the recipient\s - " & recipientEmail, False, "N"
	End If
End Function

'---------------------------Function to read (from results sheet) and update execution status results to ALM : DC -------------------------------
Public Function readAndUpdateResultsToQC(resultSheetPath, AlmUserName, AlmPassword, AlmDomain, AlmProject, testSetFolderPath, testSetName)

Dim xlApp, xlBook, xlSheet, manualTestCaseID, executionStatus

Set xlApp = CreateObject("Excel.Application") 
xlApp.visible = false 
Set xlBook = xlApp.Workbooks.open(resultSheetPath) 
Set xlSheet = xlBook.Worksheets("Global")
'MsgBox  xlSheet.Cells(1, 1).Value

row_cnt = xlSheet.UsedRange.Rows.Count
'MsgBox "number of rows is --> " & (row_cnt-1)
col_cnt = xlSheet.UsedRange.Columns.Count
'MsgBox "number of columns is --> " & col_cnt
For i = 2 To row_cnt
	manualTestCaseID = xlApp.Cells(i,1).Value
    executionStatus = xlApp.Cells(i,2).Value   
    If	executionStatus = "FAIL" Then
	retStatus = - 1
	updateResultsToQC AlmDomain, AlmProject, AlmUserName, AlmPassword, testSetName, testSetFolderPath, manualTestCaseID, "Failed"	
	'MsgBox "Iteration Failed"
	Else If executionStatus = "PASS" Then
		updateResultsToQC AlmDomain, AlmProject, AlmUserName, AlmPassword, testSetName, testSetFolderPath, manualTestCaseID, "Passed"		
		retStatus = 0
		'MsgBox "Iteration completed successfully."
	Else 
		'MsgBox "Execution Status not Recognised. for row" & (i-1)
	 End If	
	End If
Next
xlApp.Quit
Set xlApp = Nothing
Set xlBook = Nothing
Set xlSheet = Nothing
'MsgBox "Status Update Complete."
End Function

'--------------------------------Function to update execution status results to ALM : DC------------------------------------------------------------------------------------------------------------
Public Function updateResultsToQC (domainName, projectName, QCUserID, QCPassword, testSetName, testSetFolderPath, testCaseID, testStatus)

	If Trim(domainName) = "" OR Trim(projectName) = "" Then
		Exit Function
	End If

	Dim QCConnect,tsTreeMgr, tsttr, tsetFact, tsetList, tset, varTSTestList, testCase, runFactory, testCaseRun, stepFact, varStepList, testStep, testCasesUpdated
	'Encrypted password will be decrypted once in one session at first call of this function.
	If QCPswDecryted <> TRUE Then
		QCPassword = DecryptPassword(QCPassword)
		QCPass = QCPassword
		QCPswDecryted = TRUE
	Else
		QCPassword = QCPass
	End If
	'Dim DescObj:Set DescObj = CreateObject("Scripting.Dictionary")
	testCaseID = CStr(testCaseID)
	Set QCConnect = CreateObject("TDApiOle80.TDConnection")
	QCConnect.InitConnectionEx "http://pcaalm03:8080/qcbin"'serverURL
	QCConnect.login QCUserID, QCPassword
	QCConnect.Connect domainName, projectName

	Set tsTreeMgr = QCConnect.TestSetTreeManager 
	Set tsttr = tsTreeMgr.NodeByPath(testSetFolderPath)
	Set tsetFact = tsttr.TestSetFactory
	Set tsetList = tsetFact.NewList("")
	testCasesUpdated = -1
	If QCConnect.Connected   then
		For Each tset in tsetList
			If testSetName = tset.Name Then			
				Set varTSTestList = tset.TSTestFactory.NewList("")
				'For testCaseCount = 1 To varTSTestList.Count
					For each testCase In varTSTestList
						If testCase.TestId = testCaseID Then
							'DescObj.Add testCase.name, testCase.name
							Set runFactory = testCase.RunFactory
							Set testCaseRun = runFactory.AddItem(CStr(runFactory.UniqueRunName))
							testCaseRun.Status = testStatus
							
							If testStatus = "Passed" Then
								testCaseRun.CopyDesignSteps()
								testCaseRun.Post
								Set stepFact = testCaseRun.StepFactory
								Set varStepList = stepFact.NewList("")
								For each testStep In varStepList
									testStep.Field("ST_ACTUAL") = GetWebHostingURL()
									testStep.Status = "Passed"
									testStep.Post
								Next
							ElseIf testStatus = "Failed" Then
									testCaseRun.CopyDesignSteps()
									'testCaseRun.Field("RN_COMMENTS") = lastFailMsg'"Failure Reason: Update With Test Case Failure Reason"
									testCaseRun.Post
									
									Set stepFact = testCaseRun.StepFactory
									Set varStepList = stepFact.NewList("")
									stepCntr1 = 0
									For each testStep In varStepList
										stepCntr1 = stepCntr1 + 1
										testStep.Field("ST_ACTUAL") = GetWebHostingURL()
										If stepCntr1 <> varStepList.count Then
											testStep.Field("ST_ACTUAL") = GetWebHostingURL()
											testStep.Status = "Passed"
										else
											testStep.Field("ST_ACTUAL") = GetWebHostingURL()
											testStep.Status = "Failed"
										End If
										
										testStep.Post
										
									Next
									
							ElseIf testStatus = "Not Completed" Then
								testCaseRun.CopyDesignSteps()
								testCaseRun.Post
								Set stepFact = testCaseRun.StepFactory
								Set varStepList = stepFact.NewList("")
								For each testStep In varStepList
									testStep.Status = "Passed"
									testStep.Post
								Next
							End If
							testCasesUpdated = 0
							Exit For
						End If
					Next
				'Next
			End If
		Next
	End If
	QCConnect.DisConnect
	set QCConnect = nothing
	updateResultsToQC = testCasesUpdated ' case when not updated or last test updated ok.
End Function
'--------------------------------------------------------------------------------------------------------------------------------------------

'! This function captures the Execution Start Time and stores in an Environment Variable.
'! @param None
'! @remarks Setter function
'! @return NA
'! @author Aflac IT QA - NIIT Automation Team – Amit Garg
'! @version V1.0
'! @date 07/06/2018

Public Function RecordExecutionStartTime ()
	Environment.Value("ExecutionStartTime") = Now()
End Function

'! This function captures the Execution End Time and stores in an Environment Variable.
'! @param None
'! @remarks Setter function
'! @return NA
'! @author Aflac IT QA - NIIT Automation Team – Amit Garg
'! @version V1.0
'! @date 07/06/2018
Public Function RecordExecutionEndTime ()
	Environment.Value("ExecutionEndTime") = Now()
End Function

'! This function logs the Execution Start Time, Execution End Time and Execution Duration in the summary.html file.
'! @param logfile - 
'! @remarks Setter function
'! @return NA
'! @author Aflac IT QA - NIIT Automation Team – Amit Garg
'! @version V1.0
'! @date 07/06/2018
Public Function PrintExecutionDetails (ByVal logFile)
	Dim rc
	logFile.writeline "<BODY>"
	logFile.writeline "<style type=text/css>"
	logFile.writeline "BODY"
	logFile.writeline "{PADDING-RIGHT: 0px; PADDING-LEFT: 0px; FONT-SIZE: 11px; PADDING-BOTTOM: 0px; MARGIN: 0px; PADDING-TOP: 0px;FONT-FAMILY: Tahoma, Verdana, Sans-Serif; BACKGROUND-COLOR: #ffffff;}"
	logFile.writeline ".executionDetailsTable"
	logFile.writeline "{FONT-SIZE: 11px; COLOR: #333333;BACKGROUND-COLOR: #00a7e1; FONT-FAMILY: Tahoma, Verdana, Geneva; TEXT-DECORATION: none}"
	logFile.writeline "TD"
	logFile.writeline "{FONT-SIZE: 11px; COLOR: ""black""; FONT-FAMILY: Tahoma, Verdana, Geneva; TEXT-DECORATION: none}"
	logFile.writeline "TH"
	logFile.writeline "{font-size:14px;background-color:#00a7e1;border-width: 1px;padding: 8px;border-style: solid;border-color: #729ea5;text-align:left;color:#ffffff;}"
	logFile.writeline ".inner"
	logFile.writeline "{FONT-SIZE: 15px;}"
	logFile.writeline ".subheading"
	logFile.writeline "{BACKGROUND-COLOR:#dcdcdc}"
	logFile.writeline "</style>"

	logFile.writeline "<TABLE class = ""executionDetailsTable"" cellSpacing=0 cellPadding=0 width=""100%"" border=0>"
	logFile.writeline "<TBODY>"
	logFile.writeline "<TR>"
	logFile.writeline "<TD vAlign=bottom align=right  width=""75%""><font color=#eeeeee><p style=""FONT-SIZE: 12px;FAMILY: Arial;"">" & "<b>Execution Start & End Date:</b>&nbsp;</p></font></TD>"
	logFile.writeline "<TD vAlign=bottom align=right  width=""50%""><font color=#eeeeee><p style=""FONT-SIZE: 12px;FAMILY: Arial;"">" & Environment.Value("ExecutionStartTime") & "&nbsp;-&nbsp;"& Environment.Value("ExecutionEndTime") & "&nbsp; &nbsp;</p></font></TD>"
	logFile.writeline "</TR>"
	logFile.writeline "<TR>"
	logFile.writeline "<TD vAlign=bottom align=right  width=""75%""><font color=#eeeeee><p style=""FONT-SIZE: 12px;FAMILY: Arial;"">" & "<b>Execution Time:</b>&nbsp;</p></font></TD>"
	logFile.writeline "<TD vAlign=bottom align=right  width=""50%""><font color=#eeeeee><p style=""FONT-SIZE: 12px;FAMILY: Arial;"">" & Round(Cdbl(DateDiff("s", Environment.Value("ExecutionStartTime"), Environment.Value("ExecutionEndTime")))/60, 2) & "&nbsp; Minutes &nbsp;</p></font></TD>"
	logFile.writeline "</TR>"
	logFile.writeline "</table>"
	logFile.WriteLine "<br></br>"
End Function
'--------------------------------------------------------------------------------------------------------------------------------------------
Public Function fnWriteDashboardDataSheet (ByVal objDictResults, ByVal strRegion)
	
	Dim objFSO, dataTableFolderPath, dataTableFilePath, objDB, objResults, dbQuery, blnConnectionStatus 	
	blnConnectionStatus = False	
	Set objFSO = CreateObject("Scripting.FilesystemObject")
		
	On Error Resume Next
	arrTestCaseNoKeys = objDictResults.Keys 
	
	For i = lBound(arrTestCaseNoKeys) To uBound(arrTestCaseNoKeys) Step 1
		strTestCaseNo = arrTestCaseNoKeys(i)
		strCurrValue = objDictResults.Item(strTestCaseNo)
		tmpArrExecDetails = Split(strCurrValue, "-")
		
		strPolNumber = tmpArrExecDetails(0)
		strEnvironment = tmpArrExecDetails(1)		
		strExecStatus = tmpArrExecDetails(2)
		
		If Instr(strTestCaseNo, "SANITY") > 0 Then	
			dataTableFolderPath = "G:\NIIT Automation\Sanity_DataSheet\DailySanityAPPSOutput\" & replace(replace(date(), "-", "_"), "/", "_")
			dataTableFilePath = dataTableFolderPath & "\DailySanityExecutionTestResults.xls"
			
			If Not objFSO.FolderExists(dataTableFolderPath) Then
				objFSO.CreateFolder dataTableFolderPath			
				objFSO.CopyFile "G:\NIIT Automation\Sanity_DataSheet\DailySanityAPPSOutput\Template\DailySanityExecutionTestResultsTemplate.xls", dataTableFilePath 
				Wait 2
			End If			
		ElseIf Instr(strTestCaseNo, "CPT") > 0 Then 
		
			dataTableFolderPath = "G:\NIIT Automation\DashBoardData\WeeklyCPT\" & replace(replace(date(), "-", "_"), "/", "_")
			dataTableFilePath = dataTableFolderPath & "\WeeklyCPTExecutionTestResults.xls"			
			If Not objFSO.FolderExists(dataTableFolderPath) Then
				objFSO.CreateFolder dataTableFolderPath
				objFSO.CopyFile "G:\NIIT Automation\DashBoardData\WeeklyCPT\Template\WeeklyCPTExecutionTestResultsTemplate.xls", dataTableFilePath
				Wait 2
			End If			
		End If
		
		If blnConnectionStatus = False Then
			Set objDB = CheckErrorAndCreateConnection(dataTableFilePath)
			blnConnectionStatus = True
		End If
		
		dbQuery = "Update [Sheet1$] SET ExecutionStatus = '" & strExecStatus & "', PolicyNumber = '" & strPolNumber & "' Where Region = '" & strRegion  & "' and Environment = '" & Trim(strEnvironment) & "' and TestCaseNo = '" & strTestCaseNo & "'"
		
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

	Next	
	On Error Goto 0
	Set objResults = Nothing
	objDB.Close
	Set objDB = Nothing
	
End Function

'added by Amit Garg on 05/02/2019
Public Function ReportMessageWithFullPageScreenshot (ByVal status, ByVal messageInfo, ByVal almReportStatus, ByVal objOrStrToTakeScreenshot)
	Dim color, screenshotFile, msg, htmlMessage, almStatus, outputStream, doc

	If lcase(status) = "info" Then
		color = "black"
		almStatus = micDone
	ElseIf lcase(status) = "pass" Then
		color = "green"
		almStatus = micPass
	ElseIf lcase(status) = "warn" Then
		color = "purple"
		almStatus = micWarning
	ElseIf lcase(status) = "fail" Then
		color = "red"
		almStatus = micFail
	ElseIf Instr(1, lcase(status), "scenario") > 0 Then
		color = "blue"
	End If
	If QCUtil.IsConnected and almReportStatus = True Then
        Reporter.ReportEvent almStatus, "Step" & almStepNumber, messageInfo
		almStepNumber = almStepNumber + 1
	End If

	If IsObject(objOrStrToTakeScreenshot) = True Then
		If objOrStrToTakeScreenshot.getToProperty("micclass") = "Page" Then
			screenshotFile = GetScreenshotFolderPath() & "\Screenshot" & screenshotNumber & ".html"
 						
 			Set outputStream = CreateObject("Adodb.Stream")
 			outputStream.Open
 			outputStream.Charset = "UTF-8"
 			outputStream.Type = 2 

			Set doc = objOrStrToTakeScreenshot.Object
   			outputStream.writeText "<html><base href=" & hostURL & ">" & doc.documentElement.innerHTML & "</html>", 1
   			outputStream.SaveToFile screenshotFile, 2
   			outputStream.Close

 			msg = "[Time: " & time() & "]" & " - Status: " & status & ",	Message: " & messageInfo & "<a href= " & GetWebHostingURL() & "/Screenshot/Screenshot" & screenshotNumber & ".html" & "> Screenshot </a><br></br>"
			htmlMessage = "<font color=" & color & ">" & msg & "</font>"
			comprehensiveResultFile.Write htmlMessage
			screenshotNumber = screenshotNumber + 1
			'Exit Function
			Set outputStream = Nothing
			Set doc = Nothing
		End If
	'ElseIf 
	ElseIf lcase(objOrStrToTakeScreenshot) = "y" or lcase(objOrStrToTakeScreenshot) =  "yes" Then
		screenshotFile = GetScreenshotFolderPath() & "\Screenshot" & screenshotNumber & ".png"
		Desktop.CaptureBitmap screenshotFile
		
		msg = "[Time: " & time() & "]" & " - Status: " & status & ",	Message: " & messageInfo & "<a href= " & GetWebHostingURL() & "/Screenshot/Screenshot" & screenshotNumber & ".png" & "> Screenshot </a><br></br>"
		htmlMessage = "<font color=" & color & ">" & msg & "</font>"
		comprehensiveResultFile.Write htmlMessage
		screenshotNumber = screenshotNumber + 1

	Else
		msg = "[Time: "& time() &"]"&" - Status: " & status & ", Message: " & messageInfo & "<br></br>"
		htmlMessage = "<font color=" & color & ">" & msg & "</font>"
		comprehensiveResultFile.Write htmlMessage
	End If
	
End Function


'! This function is used to create the format for the email and add test parameters & result link to it
'! @param recipientEmail Input - Recipient emails where we want to send the results
'! @remarks Creating email format
'! @return NA
'! @author Aflac IT QA - NIIT Automation Team – Amit Garg 
'! @version V1.0
'! @date 02/21/2020
Public Function SendAutomationExecutionStartEmail(ByVal recipientEmail)

	Dim results
	Dim qtApp:Set qtApp = CreateObject("QuickTest.Application") 
	Dim pDefColl:Set pDefColl = qtApp.Test.ParameterDefinitions
	paramCount = pDefColl.Count
	ParamExist=False
	
	If recipientEmail <> "" Then
		results = results & "<html><body>"
		results = "<p style=""color:blue""><font face=""Calibri""><B>Automated Execution Started, please do not reply.</B></font></p>"
		
		results =  results & "<p style=""color:blue""><font face=""Calibri""><B>Please refer to the Execution URL (In the end of this email) to check the execution progress...</B></font></p>"
		
		results = results & "<font face=""Calibri"">-------------------------------------------------------------------------------------------------------------------------------------------------------------</font><br>"
		If paramCount > 0 Then
			results = results & "<h3><font face=""Calibri"">Test Parameters Details></font></h3>"
			For paramNum = 1 to paramCount
				Set pDef = pDefColl.Item(paramNum)
				If pDef.Type <> 4 Then
					results = results & "<font face=""Calibri""><b>Param name: </b>" & pDef.Name & ", <b>Param Value: </b>" & TestArgs(pDef.Name) & "</font><br>"
				End If
				'Added by Diwakar to Pass Application Name in Subject line of Email
				If ucase(pDef.Name)="APPLICATIONNAME" then
					strAppName=TestArgs(pDef.Name)
					ParamExist=True
					Exit for
				End If
			Next
			results = results & "<font face=""Calibri""><b>Testscript Name</b> :"& Environment("TestName") & "</font><br>"
			results = results & "<font face=""Calibri"">-------------------------------------------------------------------------------------------------------------------------------------------------------------</font><br>"
		End If
		
		results = results & "<font face=""Calibri"">-------------------------------------------------------------------------------------------------------------------------------------------------------------</font><br>"
		results = results & "<h3><font face=""Calibri"">Execution Result URL</font></h3>"
'		If resultFolderName <> "" Then
'			results = results &"\\NTFS3\"&GetWebHostingURL() & "\Summary.html" & "<br>"
'		Else
		results = results & "<font face=""Calibri"">" & GetWebHostingURL() & "/Summary.html" & "</font><br>"
'		End If
		results = results & "-------------------------------------------------------------------------------------------------------------------------------------------------------------<br><br>"
'		results = results & "<h3>Automation Dashboard Home Page</h3>"
'		results = results & GetDashboardURL() & "<br><br>"
        results = results & "<font face=""Calibri"">Regards,</font><br>"
		results = results & "<font face=""Calibri"">Automation Team</font>"
		results = results & "</body></html>"
		
		If ParamExist Then
			SendEmail "mail.aflac.com", "AflacAutomation@aflac.com", recipientEmail, strAppName&" : Aflac Automation Execution Started", results
		else
			SendEmail "mail.aflac.com", "AflacAutomation@aflac.com", recipientEmail, " : Aflac Automation Execution Started", results
		End If
		
	End If
		
End Function




Public Function Fn_Update_AutomationExecution_SummaryReport(strPassed,strFailed, strExecutionURL)
	
	'blnConnectionStatus = False
	strUserID = Environment("UserName")
	strScriptName = Environment("TestName")
	totalExecutedTestCases = strPassed+strFailed
	totalPassed = strPassed
	totalFailed = strFailed
	strDate = Date
	strExecutionTime = Round(Cdbl(DateDiff("s", Environment.Value("ExecutionStartTime"), Now()))/60, 2)
		
	dataTableFilePath = "G:\NIIT Automation\Reports\AutomatedExecutionsLog\AutomatedExecutionConsolidatedLog.accdb"
	If blnConnectionStatus = False Then
		Set objDB = CheckErrorAndCreateAccessDataBaseConnection(dataTableFilePath)
		blnConnectionStatus = True
	End If
	
	'Get the User Name and SOW Details from the UsersDetails Table. 
	dbQuery = "Select UserName, SOW, UserRole From UsersDetails Where UserID Like '[vV]" & Right(strUserID, 5) &"'"
	Set objResults = objDB.Execute(dbQuery)
	
	If objResults.EOF <> True Then
		strUserName = objResults.Fields("UserName").Value
		strSOW = objResults.Fields("SOW").Value
		strUserRole = objResults.Fields("UserRole").Value
	Else
		strUserName = UserID
		strSOW = "UNKNOWN"
		strUserRole = "UNKNOWN"
	End If
	
'	UserID	ScriptName	ExecutedTestCases	Passed	Failed	TotalExecutionTime
	
	'dbQuery = "Insert into [Sheet1$] values('"&strDate&"','"&strUserID&"','"&strScriptName&"',"&totalExecutedTestCases&","&totalPassed&","&totalFailed&","&strExecutionTime&",'"&strExecutionURL&"')"
	dbQuery = "Insert into ExecutionLog(ExecutionDate, UserID, UserName, SOW, UserRole, ScriptName, ExecutedTestCases, Passed, Failed, TotalExecutionTime, ExecutionURL) " & _
		"values('"&strDate&"','"&strUserID&"','"&strUserName&"','"&strSOW&"', '"&strUserRole&"', '"&strScriptName&"',"&totalExecutedTestCases&","&totalPassed&","&totalFailed&","&strExecutionTime&",'"&strExecutionURL&"')"
	objDB.Execute(dbQuery)
	wait 1
	objDB.close
	Set objDB = Nothing
	
End Function

Public Function CheckErrorAndCreateAccessDataBaseConnection (dataBaseFilePath)
	
	On Error Resume Next	
	For i = 1 To 5 Step 1
				
		Set objDB=CreateObject("ADODB.Connection")
		With objDB
			.Provider = "Microsoft.ACE.OLEDB.12.0"		
			.ConnectionString = "Data Source=" & dataBaseFilePath & ";"
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
	
	Set CheckErrorAndCreateAccessDataBaseConnection = objDB
	
	On Error GoTo 0
	
End Function

'! Wraper Function of Report Message - Used to take snapshots with required object highlighted
'! @param testStepStatus Input - Status of the message reported in the output file
'! @param messageInfo Input - Message information stating what operation are performed
'! @param almReportStatus Input - Value will be True/False if we want to report this message in ALM
'! @param testObj Input - Object which has to be highlighthed in the report snapshot
'! @param screenshot Input - '!Y'! or '!YES'! if we want to take screenshot/ '!N'!,  or '!NO'! if we dont want to take screenshot
'! @return NA

Public Function ReportMessageExtended(ByVal testStepStatus, ByVal messageInfo, ByVal almReportStatus, ByVal screenshot, ByRef testObj)
''   oldBorder = testObj.Object.style.border
'	msgbox testObj.tostring()
'    testObj.Object.style.border = "thick solid yellow"
''	testObj.Object.style.border = "2px Solid Yellow"
'    Wait(1)
'   ReportMessage testStepStatus,messageInfo,almReportStatus,screenshot
'    testObj.Object.style.border = "none"
'   testObj.Object.style.border = "2px inset"
''   testObj.Object.style.border = ""
''   testObj.Object.currentStyle.borderstyle = "inset"
		
	Call WaitToLoadCompletePage(Browser("Online Services/Aflac").Page("Online Services/Aflac")) 
	
	Call PageScroll(testObj)
		
	If  Browser("Online Services/Aflac").Exist(1) Then 
		Browser("Online Services/Aflac").Sync 
	End If
	
	If  Browser("Aflac Login").Exist(1) Then
		Browser("Aflac Login").Sync
	End If
	
	If  Browser("Online Services/Aflac").Page("IT Community").Exist(2) Then
		Browser("Online Services/Aflac").Sync
	End If

	If Instr(1,testObj.tostring(),"edit box") > 0 Then
		oldBorder = testObj.Object.style.border
		testObj.Object.style.border = "thick solid yellow"
		'wait 1
		ReportMessage testStepStatus,messageInfo,almReportStatus,screenshot
'		testObj.Object.style.border = oldBorder
		testObj.Object.style.border = "2px inset"		
		
	Else
		oldBorder = testObj.Object.style.border
		testObj.Object.style.border = "thick solid yellow"
		'wait 1
		ReportMessage testStepStatus,messageInfo,almReportStatus,screenshot
		testObj.Object.style.border = oldBorder
	End If

End Function

Public Function CheckIfDebugOrFinalRun()
	
	If Setting("IsInTestDirectorTest") Then		
	Else	
		strDebugResp = Msgbox ("Is this execution part of Debugging...", vbYesNo)	
		If strDebugResp = vbYes Then			
			resultFolderName = "\\dcaalm03\AutomationResults\DebugResults"						
		End If		
	End If	
End Function

Public Function PageScroll(testObj)	
	Dim NewHeight
	
	Height = Browser("Online Services/Aflac").GetRoProperty("height")
	NewHeight = Height  - 50	
	Set Obj = testObj	
	absY =  Obj.GetRoProperty("abs_y")
	wait 1
	If  absY > NewHeight Then
		SendKey "{PGDN}"
		'msgbox "pgdn"
	else
	 'do nothing
	 'msgbox "no pgdn"
	End If	
	If Instr(1,Obj.tostring(),"link") > 0 Then
'		Obj.highlight
		Wait(1)
	End If	
End Function

Public Function fnGetCredentialsForALMUpdates (ByRef strOutALMUserID, ByRef strOutALMPassword)
	
	If UCase(Left(TestArgs("MFUserID"), 1)) = "Q" Then
		strOutALMUserID = TestArgs("ALMUserID")
		strOutALMPassword = TestArgs("ALMPassword")
	Else
		If TestArgs("ALMUserID") <> "" Then
			strOutALMUserID = TestArgs("ALMUserID")
			strOutALMPassword = TestArgs("ALMPassword")
		Else
			strOutALMUserID = TestArgs("MFUserID")
			strOutALMPassword = TestArgs("MFPassWord")
		End If
	End If		
End Function

