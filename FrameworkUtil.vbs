
'! This method will fill return the total pattern matches with regex and an array consisting all matching patterns
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
'! @date 05/05/2015
Public Function GetRegexMatch(ByVal preText, ByVal postText, ByVal stringText, ByVal patternToMatch, ByRef totalMatches, ByRef objectArray)
	Dim regEx, Match, Matches  
	Set regEx = New RegExp   
	If preText ="" And postText = "" Then
		regEx.Pattern = patternToMatch
	ElseIf patternToMatch = "" Then
		regEx.Pattern = preText & ".*" & postText
	End If
'	regEx.Pattern = patternToMatch  
	regEx.IgnoreCase = True   
	regEx.Global = True   
	Set Matches = regEx.Execute(stringText)   
	totalMatches = Matches.count
	Set objectArray = Matches
End Function

'! This method will fill return the total pattern matches with regex
'! @param stringText Input - Complete test sting to search pattern
'! @param patternToMatch Input - regex pattern
'! @remarks N/A
'! @return total count for regex match
'! @author Aflac IT QA - NIIT Automation Team – Shakti
'! @version V1.0
'! @date 05/05/2015
Public Function GetRegexMatchCount(ByVal stringText, ByVal patternToMatch)
	Dim regEx, Match, Matches  
	Set regEx = New RegExp   
	regEx.Pattern = patternToMatch  
	regEx.IgnoreCase = True   
	regEx.Global = True   
	Set Matches = regEx.Execute(stringText)   
	GetRegexMatchCount = Matches.count
End Function

'! This function returns current date values after splitting it
'! @param N/A Input - N/A
'! @param currentMonth Output- Current Month
'! @param currentDay Output- Current Month
'! @param currentYear Output- Current Month
'! @remarks N/A
'! @return N/a
'! @author Aflac IT QA - NIIT Automation Team – Shakti
'! @version V1.0
'! @date 05/05/2015
Public Function GetCurrentDateParameters(ByRef currentMonth, ByRef currentDay, ByRef currentYear)
	currentDate = Date()
	currentDate = replace(currentDate, "/", "_")
	currentDate = replace(currentDate, "-", "_")
	dateParameters = split(currentDate, "_")
	currentMonth = dateParameters(0)
	currentDay = dateParameters(1)
	currentYear = dateParameters(2)
End Function

'! This function returns current time values after splitting it
'! @param N/A Input - N/A
'! @param currentHour Output- Hour
'! @param currentMinute Output- Minute
'! @param currentSeconds Output- Seconds
'! @param ampm Output- Am/Pm
'! @remarks N/A
'! @return N/a
'! @author Aflac IT QA - NIIT Automation Team – Shakti
'! @version V1.0
'! @date 05/05/2015
Public Function GetCurrentTimeParameters(ByRef currentHour, ByRef currentMinute, ByRef currentSeconds, ByRef ampm)
	currentTime = time()
	currentTime = replace(currentTime, ":", "_")
	currentTime = replace(currentTime, " ", "_")
    timeParameters = split(currentTime, "_")
	currentHour = timeParameters(0)
	currentMinute = timeParameters(1)
	currentSeconds = timeParameters(2)
	ampm = timeParameters(3)
End Function

'! This function returns Name(partial/full) of the month as per month number
'! @param monthNumber Input - Calender month number
'! @param monthFullNameFlag Input - Fullname/shortname of the month as return value
'! @remarks N/A
'! @return Month Name (partial/full)
'! @author Aflac IT QA - NIIT Automation Team – Shakti
'! @version V1.0
'! @date 05/05/2015
Public Function GetMonthNameFromMonthNumber(ByVal monthNumber, ByVal monthFullNameFlag)
	Dim monthShortNameArr, monthFullNameArr
	monthShortNameArr = Array("Null", "Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec")
    monthFullNameArr = Array("Null", "January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December")
	If monthNumber<1 Or monthNumber>12 Then
        ReportMessage "FAIL", "Month number is invalid", "False", "N"
		GetMonthNameFromMonthNumber = -1
		Exit Function
	End If

	If  monthFullNameFlag = "Yes" Then
		GetMonthNameFromMonthNumber = monthFullNameArr(monthNumber)
	Else
		GetMonthNameFromMonthNumber = monthShortNameArr(monthNumber)
	End If
End Function

'! This function returns Name(partial/full) of the day as per given date
'! @param givenDate Input - Desired date
'! @param dayFullNameFlag Input - Flag for Day full name
'! @remarks N/A
'! @return Day Name (partial/full)
'! @author Aflac IT QA - NIIT Automation Team – Shakti
'! @version V1.0
'! @date 05/05/2015
Public Function GetDayForGivenDate(ByVal givenDate, ByVal dayFullNameFlag)
	If dayFullNameFlag = "Yes" Then	
	GetDayForGivenDate =  weekdayname(weekday(givenDate))
	
	Else
		GetDayForGivenDate =  weekdayname(weekday(givenDate), true)
	End If
End Function

'! This function returns text for given webpage 
'!  @param pageName Input - Page Name 
'!  @remarks N/A
'!  @return webpage text
'!  @author Aflac IT QA - NIIT Automation Team – Shakti
'!  @version V1.0
'!  @date 05/05/2015
Public Function GetWebPageText(ByVal pageName)
   Dim pageText
   pageText = pageName.object.body.innertext
   GetWebPageText = pageText
End Function

'! This function returns text between given pretext and posttext with its occurance(index) from webpage text
'! @param pageName Input -  Page Name
'! @param preText Input  - Pre Text
'! @param preText Input  - Post Text
'! @param stringIndex Input  - String Index
'! @remarks N/A
'! @return text between pre and post text or -1
'! @author Aflac IT QA - NIIT Automation Team – Shakti
'! @version V1.0
'! @date 05/05/2015
Public Function GetTextBetweenStringsFromWebPage(ByVal pageName, ByVal preText, ByVal postText, ByVal stringIndex)
	pageText = pageName.object.body.innertext
	GetRegexMatch preText, postText, pageText, "", totalMatches, objectArray
	totalMatch = totalMatches
	If  totalMatch >0 And stringIndex <= totalMatch-1Then
		GetTextBetweenStringsFromPage = objectArray(stringIndex).Value
    ElseIf totalMatch >0 And stringIndex = "" Then
		GetTextBetweenStringsFromPage = objectArray(0).Value
	ElseIf totalMatch = 0 Or stringIndex > totalMatch-1 Then
		GetTextBetweenStringsFromPage = -1
	End If
End Function

'! This function checks wether text is exist on page or not
'! @param pageName Input -  Page Name
'! @param searchStringText Input -  String to search
'! @remarks N/A
'! @return 0 or -1
'! @author Aflac IT QA - NIIT Automation Team – Shakti
'! @version V1.0
'! @date 05/05/2015
Public Function TextExistOnPage(ByVal pageName, ByVal searchStringText)
	pageText = pageName.object.body.innertext
	pageText = replace(pageText, vbnewline, "")
	GetRegexMatch "", "", pageText, searchStringText, totalMatches, objectArray
	totalMatch = totalMatches
    If  totalMatch >0 Then
		TextExistOnPage = 0
        ReportMessage "PASS", "Text found on page: " & searchStringText, False, "N"
	Else 
		TextExistOnPage = -1
		ReportMessage "FAIL", "Text not found on page: " & searchStringText, False, "Y"
	End If
End Function
RegisterUserFunc "Page", "TextExistOnPage", "TextExistOnPage" 


'! This function checks wether text is exist in given string
'! @param stringText Input -  String/Text
'! @param searchStringText Input -  Sub String to search
'! @remarks
'! @return 0 or -1
'! @author Aflac IT QA - NIIT Automation Team – Shakti
'! @version V1.0
'! @date 05/05/2015
Public Function TextExistinString(ByVal stringText, ByVal searchStringText)
'	pageText = pageName.object.body.innertext
	stringText = replace(stringText, vbnewline, "")
	GetRegexMatch "", "", stringText, searchStringText, totalMatches, objectArray
	totalMatch = totalMatches
    If  totalMatch >0 Then
		TextExistinString = 0
        ReportMessage "PASS", "Searched Text found in the string: " & searchStringText, False, "N"
	Else 
		TextExistinString = -1
		ReportMessage "FAIL", "Searched Text: " & searchStringText & " not found in the string: " & stringText, False, "Y"
	End If
End Function

'! This function returns text between given pretext and posttext with its 1st occurance(0 index) from any given string
'! @param textString Input - String/Text
'! @param preText Input  - Pre text of string to be searched
'! @param postText Input  - Pre text of string to be searched
'! @remarks N/A
'! @return text between string or -1
'! @author Aflac IT QA - NIIT Automation Team – Shakti
'! @version V1.0
'! @date 05/05/2015
Public Function getTextBetweenStrings(ByVal textString, byVal preText, ByVal postText)
	Dim regEx, Match, Matches  
	GetRegexMatch preText, postText, textString, "", totalMatches, objectArray
	If  totalMatches >0 Then
		returnText = objectArray(0).value
'!		startIndext = Matches(0).FirstIndex
'!		endIndex = len(returnText)
		getTextBetweenStrings = mid(returnText, len(preText)+1, (len(returnText)-len(postText))-len(preText))
    Else 
		getTextBetweenStrings = -1
	End If
End Function

'! This function returns sorted array in ascending order
'! @param itemArray Input - Name of array
'! @param itemArray Output - Name of array
'! @remarks N/A
'! @return None
'! @author Aflac IT QA - NIIT Automation Team – Shakti
'! @version V1.0
'! @date 05/05/2015
Public Function SortAscendingOrder(ByRef itemArray)
	If ubound(itemArray) = 0 Then
		ReportMessage "FAIL", "Type mismatch, variable is not an Array", False, "N"
		Exit Function
	ElseIf ubound(itemArray) = 1 Then
		If itemArray(0)>itemArray(1) Then
			temp = itemArray(0)
			itemArray(0) = itemArray(1)
			itemArray(1) = temp
			Exit Function
		End If
	ElseIf ubound(itemArray) > 1 Then
        For j=0 to ubound(itemArray)
			For i=0 to ubound(itemArray)-1
				If itemArray(i)>itemArray(i+1) Then
					temp = itemArray(i)
					itemArray(i) = itemArray(i+1)
					itemArray(i+1) = temp
				End If
			Next
		Next
	End If
End Function

'! This function returns sorted array in descending order
'! @param itemArray Input - Name of array
'! @param itemArray Output - Name of array
'! @remarks
'! @Return None
'! @author Aflac IT QA - NIIT Automation Team – Shakti
'! @version V1.0
'! @date 05/05/2015
Public Function SortDescendingOrder(ByRef itemArray)
	If ubound(itemArray) = 0 Then
		ReportMessage "FAIL", "Type mismatch, variable is not an Array", False, "N"
		Exit Function
	ElseIf ubound(itemArray) = 1 Then
		If itemArray(0)<itemArray(1) Then
			temp = itemArray(0)
			itemArray(0) = itemArray(1)
			itemArray(1) = temp
			Exit Function
		End If
	ElseIf ubound(itemArray) > 1 Then
        For j=0 to ubound(itemArray)
			For i=0 to ubound(itemArray)-1
				If itemArray(i)<itemArray(i+1) Then
					temp = itemArray(i)
					itemArray(i) = itemArray(i+1)
					itemArray(i+1) = temp
				End If
			Next
		Next
	End If
End Function

'! This function creates a descriptive object at run time based on oit property'!s name and value
'! @param propertyName Input  - Array name of object properties
'! @param propertyValue Input  - Array name of object propertie's values
'! @remarks N/A
'! @return descriptive object
'! @author Aflac IT QA - NIIT Automation Team – Shakti
'! @version V1.0
'! @date 05/05/2015
Public Function CreateDescObject(ByVal propertyName, ByVal propertyValue)
	Dim descObject:Set descObject = Description.Create()
	For propNum = 0 to ubound(propertyName)
		descObject(propertyName(propNum)).Value = propertyValue(propNum)
	Next
	Set	CreateDescObject = descObject
End Function

'! This function is used to create a new dictionary object
'!
'!@remarks
'!@Return Created dictionary object
'!@author Aflac IT QA - NIIT Automation Team – Vikas
'!@version V1.0
'!date 05/05/2015
Public Function CreateDict()
	Set CreateDict = CreateObject("Scripting.Dictionary")
End Function

'! This function is used to add the items into a dictionary object
'!
'!@param keyVal - Key of the dictionary object
'!@param itemVal - Value that need to be added to the dictionary object
'!@param arrDict - Dictionary object in which the itemVal is added
'!@remarks
'!@Return Dictionary Object
'!@author Aflac IT QA - NIIT Automation Team – Vikas
'!@version V1.0
'!date 05/05/2015

Public Function AddDictItem(ByRef arrDict, ByVal keyVal, ByVal itemVal)
 	If Not(IsObject(arrDict)) Then
		Set arrDict = CreateDict()
	End If
	arrDict.add keyVal, itemVal
End Function

'! This function is used to retrieves the specific item from the dictionary object stored at a specific location
'!
'!@param keyVal - Key of the dictionary object
'!@param arrDict - Dictionary object in which the itemVal is added
'!@remarks
'!@Return Item value stored in the dictionary object specific to that key
'!@author Aflac IT QA - NIIT Automation Team – Vikas
'!@version V1.0
'!date 05/05/2015
Public Function GetDictItem(ByVal arrDict, ByVal keyVal)
 	If IsObject(arrDict) and arrDict.Exists(keyVal) Then
		GetDictItem = arrDict.Item(keyVal)
	Else
		GetDictItem = ""
	End If
End Function

'! This function is used to delete the item from the dictionary object correcponding to a specific key
'!
'!@param keyVal Key of the dictionary object
'!@param arrDict Dictionary object in which the itemVal is added
'!@remarks
'!@Return Dictionary object
'!@author Aflac IT QA - NIIT Automation Team – Vikas
'!@version V1.0
'!date 05/05/2015
Public Function DeleteDictItem(ByRef arrDict, ByVal keyVal)
	If IsObject(arrDict) and arrDict.Exists(keyVal) Then
		arrDict.remove keyVal
	End If
End Function

'! This function is used return the date in a formatted way
'!@param dateStr Input date which needs to be formatted
'!@param format Conversion format
'!@remarks Conversion format is like "MM/DD/YYYY"
'!@Return Formatted date

'!@author Aflac IT QA - NIIT Automation Team – Vikas
'!@version V1.0
'!date 07/21/2015
Public Function GetDateFormatted(ByVal dateStr, ByVal format)
	monthVal = Month(dateStr)
	If Len(monthVal) = 1 Then
		monthVal = "0" & monthVal
	End If
	dateVal = Day(dateStr)
	If Len(dateVal) = 1 Then
		dateVal = "0" & dateVal
	End If
	yearVal = Year(dateStr)

	If GetRegexMatchCount(format, "mm/dd/yyyy|MM/DD/YYYY") > 0 Then
		GetDateFormatted = monthVal & "/" & dateVal & "/" & yearVal
	ElseIf GetRegexMatchCount(format, "dd/mm/yyyy|DD/MM/YYYY") > 0 Then
		GetDateFormatted = dateVal & "/" & monthVal & "/" & yearVal
	ElseIf GetRegexMatchCount(format, "mmddyyyy|MMDDYYYY") > 0 Then
		GetDateFormatted = monthVal & dateVal & yearVal
	ElseIf GetRegexMatchCount(format, "ddmmyyyy|DDMMYYYY") > 0 Then
		GetDateFormatted = dateVal & monthVal & yearVal
	ElseIf GetRegexMatchCount(format, "mm/dd/yy|MM/DD/YY") > 0 Then
		GetDateFormatted = monthVal & "/" & dateVal & "/" & Right(yearVal, 2)
	ElseIf GetRegexMatchCount(format, "dd/mm/yy|DD/MM/YY") > 0 Then
		GetDateFormatted = dateVal & "/" & monthVal & "/" & Right(yearVal, 2)
	ElseIf GetRegexMatchCount(format, "mmddyy|MMDDYY") > 0 Then
		GetDateFormatted = monthVal & dateVal & Right(yearVal, 2)
	ElseIf GetRegexMatchCount(format, "ddmmyy|DDMMYY") > 0 Then
		GetDateFormatted = dateVal & monthVal & Right(yearVal, 2)
	ElseIf GetRegexMatchCount(format, "mm-dd-yyyy|MM-DD-YYYY") > 0 Then
		GetDateFormatted = monthVal & "-" & dateVal & "-" & yearVal
	ElseIf GetRegexMatchCount(format, "yyyymmdd|YYYYMMDD") > 0 Then
		GetDateFormatted = yearVal & monthVal & dateVal
	ElseIf GetRegexMatchCount(format, "yyyy-mm-dd|YYYY-MM-DD") > 0 Then
		GetDateFormatted = yearVal & "-" & monthVal & "-" & dateVal 
	ElseIf GetRegexMatchCount(format, "mmyy|MMYY") > 0 Then
		GetDateFormatted = monthVal &Right(yearVal, 2)
	ElseIf GetRegexMatchCount(format, "mm/yy|MM/YY") > 0 Then
		GetDateFormatted = monthVal &"/"&Right(yearVal, 2)
	ElseIf GetRegexMatchCount(format, "mm.dd.yyyy|MM.DD.YYYY") > 0 Then
		GetDateFormatted = monthVal & "." & dateVal & "." & yearVal
	End If
End Function

'!This function is used to send text on an object
'!
'!@param text - Input ByVal
'!@remarks
'!@Return None
'!@author Shakti
'!@version V1.0
'!@date 05/29/2015
Public Function SendKey(ByVal text)
	Set WshShell = CreateObject("WScript.Shell")
	WshShell.SendKeys text
	wait 1
	Set WshShell = Nothing
	
End Function

'=============================================================================================================================
' Method to generate Random Names as per provided total number of names
'! Method to generate Random Names as per provided total number of names
'! @param propertyName Input  - Array name of object properties
'! @param propertyValue Input  - Array name of object propertie's values
'! @remarks N/A
'! @return descriptive object
'! @author Aflac IT QA - NIIT Automation Team – Shakti
'! @version V1.0
'! @date 05/05/2015
Public Function GetRandomNames(ByVal totalNumOfNames)
 	If  totalNumOfNames<1 OR totalNumOfNames>500 Then
		ReportMessage "FAIL", "Total number of name is out of range", False, "N"
		GetRandomNames = -1
		Exit Function
	End If
	Dim nameArray(500)
	nameVowel = Array("a", "e", "i", "o", "u")'0-4
	nameAlpha = Array("b", "c", "d", "f", "g", "h", "j", "k", "l", "m", "n", "p", "q", "r", "s", "t", "v", "w", "x", "y", "z")'0-20
	For nameItr = 0 to totalNumOfNames-1
		fName = GetFirstName(nameVowel, nameAlpha)
		lName = GetLastName(nameVowel, nameAlpha)
		nameArray(nameItr) = UCase(fName) & "," & Ucase(lName) 
	Next
	GetRandomNames = nameArray
End Function	
'====================================================================================================================================================
'Generating First Name
Public Function GetFirstName(nameVowel, nameAlpha)
	fNameString = ""
	rnum = ""
	For i= 1 to 2 
	   'rnum = Int((20 - 0 + 1) * Rnd + 0)
		rnum = RandomNumber(LBound(nameAlpha),UBound(nameAlpha))
		fNameString = fNameString & nameAlpha(rnum)
		rnum = ""
		'rnum = Int((4 - 0 + 1) * Rnd + 0)
		rnum = RandomNumber(LBound(nameVowel),UBound(nameVowel))
		fNameString = fNameString & nameVowel(rnum)
	Next
	GetFirstName = fNameString
End Function
'====================================================================================================================================================
'Generating Last Name
Public Function GetLastName(nameVowel, nameAlpha)
   	lNameString = ""
	rnum = ""
	For i= 1 to 3 
	   rnum = Int((20 - 0 + 1) * Rnd + 0)
		'lNameString = lNameString & nameAlpha(rnum)
		rnum = RandomNumber(LBound(nameAlpha),UBound(nameAlpha))
		lNameString = lNameString & nameAlpha(rnum)
		rnum = ""
		'rnum = Int((4 - 0 + 1) * Rnd + 0)
		rnum = RandomNumber(LBound(nameVowel),UBound(nameVowel))
		lNameString = lNameString & nameVowel(rnum)
	Next
	GetLastName = lNameString
End Function
'====================================================================================================================================================

'! This function is used to return the random first name from the database
'!@param gender Policy holder's gender
'!@remarks NA
'!@Return String refering to as FirstName
'!@author Aflac IT QA - NIIT Automation Team – Vikas
'!@version V1.0
'!date 08/12/2015
Public function GetFirstNameDB(ByVal gender)
	Dim driverName, databaseName, dbLinkName, recordCount, randNo

	If gender = "F" Then
		query = "Select Records from Names_Recordcount  where Table='Names_Female'"
	Else
		query = "Select Records from Names_Recordcount  where Table='Names_Male'"
	End If
'	driverName = "Driver={Microsoft Access Driver (*.mdb)};"
'	databaseName = "Dbq=\\ntfs3\picodep\NIIT Automation\Misc\NameDatabase\Names.mdb;"
	driverName="Driver={Microsoft Access Driver (*.mdb, *.accdb)};"
	databaseName = "\\ntfs3\picodep\NIIT Automation\Misc\NameDatabase\Names and Addresses.accdb;"
	
	dbLinkName = "Records"
	recordCount = ExecuteQuery(driverName, databaseName, query, dbLinkName)
	randNo = RandomNumber(1, recordCount)

	If UCASE(gender)="F" Then
		query = "Select Name from Names_Female where Index=" & randNo 
	Else
		query = "Select Name from Names_Male where Index=" & randNo 
	End If
	dbLinkName = "Name"
	GetFirstNameDB = ExecuteQuery(driverName, databaseName, query, dbLinkName)
End Function

'! This function is used to return the random last name from the database
'!@remarks NA
'!@Return String refering to as LastName
'!@author Aflac IT QA - NIIT Automation Team – Vikas
'!@version V1.0
'!date 08/12/2015
Public function GetSurNameDB()
	query = "Select Records from Names_Recordcount  where Table='Names_Surname'"
'	driverName = "Driver={Microsoft Access Driver (*.mdb)};"
	driverName="Driver={Microsoft Access Driver (*.mdb, *.accdb)};"
	databaseName = "\\ntfs3\picodep\NIIT Automation\Misc\NameDatabase\Names and Addresses.accdb;"
	dbLinkName = "Records"
	recordCount = ExecuteQuery(driverName, databaseName, query, dbLinkName)
	randNo = RandomNumber(1, recordCount)

	query = "Select Name from Names_Surname where Index=" & randNo 
	dbLinkName = "Name"
	GetSurNameDB = ExecuteQuery(driverName, databaseName, query, dbLinkName)
End Function

'! This function is used to execute query on the database and retreive the name information
'!@param driverName Database driver name
'!@param databaseName Data base name
'!@param query Query to execute on database
'!@param dbLinkName Database link name
'!@remarks NA
'!@Return String/Number depending on the query
'!@author Aflac IT QA - NIIT Automation Team – Vikas
'!@version V1.0
'!date 08/12/2015
Public Function ExecuteQuery(ByVal driverName, ByVal databaseName, ByVal query, ByVal dbLinkName)
	Dim connectionObj, recordSetObj
		
	Set connectionObj=CreateObject("ADODB.Connection")
	With connectionObj
		.Provider = "Microsoft.Ace.OLEDB.12.0"		'This line is added by Amit Garg on 10/18/2017 to fix the connection issue happened because of windows update KB4041678.
		.ConnectionString = "Data Source=" & databaseName
		.Open
	End With
	Set recordSetObj = connectionObj.Execute(query)
	
	If (recordSetObj.EOF) Then
		Reporter.ReportEvent micFail,"DB Query","No Rows retrieved"
	Else
		While (Not recordSetObj.EOF) 
			checkpoint_status = true 
			var=recordSetObj.Fields(dbLinkName)'
			recordSetObj.MoveNext 
		Wend
		Reporter.ReportEvent micPass,"DB Query","Rows retrieved"
	End If
	
	connectionObj.Close
	
	Set recordSetObj = Nothing
	Set connectionObj = Nothing

	ExecuteQuery=var
	
End Function

'********************** Below function is commented by Amit Garg on 05/13/2020 as this function is not able to connect to a database and find the record on Windows 10 Machine due to database driver issue. Updated function is written above. 

'Public Function ExecuteQuery(ByVal driverName, ByVal databaseName, ByVal query, ByVal dbLinkName)
'	Dim connectionObj, recordSetObj
'
'	Set connectionObj = CreateObject("ADODB.Connection") 
'	connectionObj.commandtimeout=300
'	Set recordSetObj=CreateObject("ADODB.recordset")
'	connectionObj.Open driverName & databaseName & "Uid=admin;" &  "Pwd="
'	recordSetObj.Open query,connectionObj
'	checkpoint_status = Not(IsNull(recordSetObj))
'	checkpoint_status = False
'	If (recordSetObj.EOF) Then
'		Reporter.ReportEvent micFail,"DB Query","No Rows retrieved"
'	Else
'		While (Not recordSetObj.EOF) 
'			checkpoint_status = true 
'			var=recordSetObj.Fields(dbLinkName)'
'			recordSetObj.MoveNext 
'		Wend
'		Reporter.ReportEvent micPass,"DB Query","Rows retrieved"
'	End If
'	Set recordSetObj = Nothing
'	Set connectionObj = Nothing
'
'	ExecuteQuery=var
'End Function
'
'==========================================================================================================================================


Public Function getRandomSSN()
	Dim intDay, intMonth, intHour, intMinutes, intSeconds, randomSSN

	intDay = Day(Now)
	' Converting Day to 2 digits
	If instr(1, intDay, "9", 1) <> 0 Then
		intDay = RandomNumber(1, 8)
	End If
	' Get the current Month	
	intMonth = Month(Now)
	' Converting Month to 2 digits
	If intMonth < 10 And Len(intMonth) = 1 Then
		intMonth = "0" & intMonth
	End If
	' Get the current Hour
	intHour = Hour(Now)
	' Converting Hour to 2 digits
	If intHour < 10 And Len(intHour) = 1 Then
		intHour = "0" & intHour
	End If
	' Get the current Minute
	intMinutes = Minute(Now)
	' Converting Minute to 2 digits
	If intMinutes < 10 And Len(intMinutes) = 1 Then
		intMinutes = "0" & intMinutes
	End If
	' Get the current Second
	intSeconds = Second(Now)
	' Converting seconds to 2 digits
	If intSeconds < 10 And Len(intSeconds) = 1 Then
		intSeconds = "0" & intSeconds
	End If

	randomSSN = intDay & intHour & intMonth & intMinutes & intSeconds
	getRandomSSN = Right(randomSSN, 9)
	
End Function

'================================================================================================================
'replaces special chars with .* for regular expression
Public Function removeSpecialCharsFromString(ByVal inputStr)
	Dim objRegExp, outputStr
	Set objRegExp = New Regexp

	objRegExp.IgnoreCase = True
	objRegExp.Global = True
	objRegExp.Pattern = "[(?*"",'|()\\<>&#~%{}+_.@:\/!;]+"
	newStr = objRegExp.Replace(inputStr, ".*")
	removeSpecialCharsFromString = newStr
End Function
'================================================================================================
'Acccepts encrypted password in argument and returns decrypted password - DC 11/9/2017
Public Function DecryptPassword(ByVal encryptedPsw)
	Dim DecPsw
	'TestArgs("Param1")
	set WshShell = CreateObject("WScript.Shell")
    WshShell.Run "Notepad.exe"
    Wait 2
	WshShell.AppActivate "Notepad"
	WshShell.SendKeys "^o"
	'Wait 2
	Dialog("micclass:=Dialog", "text:=Open").WaitProperty "Visible", TRUE
	Dialog("micclass:=Dialog", "text:=Open").Resize 300, 300
	Dialog("micclass:=Dialog", "text:=Open").Move 0, 0
	Dialog("micclass:=Dialog", "text:=Open").Activate
	'encryptedPswd= crypt.Encrypt(encryptedPsw)
	Dialog("micclass:=Dialog", "text:=Open").WinEdit("micclass:=WinEdit", "window id:=1148").SetSecure encryptedPsw
	DecPsw = Dialog("micclass:=Dialog", "text:=Open").WinEdit("micclass:=WinEdit", "window id:=1148").GetROProperty("text")
	Dialog("micclass:=Dialog", "text:=Open").WinButton("micclass:=WinButton", "window id:=2").Click
	Systemutil.CloseProcessByName "notepad.exe"
	Set WshShell = Nothing
	DecryptPassword = DecPsw
End Function
'================================================================================================


Public Function GenerateRandomCreditCardNumber (strVisaOrMaster)
	
	Select Case UCase(strVisaOrMaster)
	
		Case "VISA"
		
			strCCNumber = "4" & fnRandomNumber(15)
			While checkLuhn(strCCNumber) = False
			    strCCNumber = "4" & fnRandomNumber(15)
			Wend	
					
		Case "MASTER"
		
			strCCNumber = "5" & fnRandomNumber(15)
			While checkLuhn(strCCNumber) = False
			    strCCNumber = "5" & fnRandomNumber(15)
			Wend	
		
		Case "AMEX"
		
			strCCNumber = "34" & fnRandomNumber(13)
			While checkLuhn(strCCNumber) = False
			    strCCNumber = "34" & fnRandomNumber(13)
			Wend	
		
	End Select
	
	GenerateRandomCreditCardNumber = strCCNumber
	
End Function
	
Public Function checkLuhn(ByVal strCCNumber)
	
'	Dim sum : sum = Mid(strCCNumber, len(strCCNumber) - 1, 1)
'	Dim nDigits : nDigits = len(strCCNumber)
'	
'	Dim parity : parity = nDigits Mod 2
'	Dim digit
'	
'	For i = 1 To nDigits - 1 Step 1
'		digit = Mid(strCCNumber, i, 1)
'		
'		If i Mod 2 = parity Then
'			digit = digit * 2
'		End If
'		
'		If digit > 9 Then
'			digit = digit - 9
'		End If
'		
'		sum = sum + digit
'	
'	Next
'Updated by Chandrakant Tyagi
	Sum1 = 0
	Sum2 = 0
	For i = 1 To Len(strCCNumber) Step 2
	
		Sum1 = Sum1+ CInt(Mid(strCCNumber,i,1))
		
	Next
	
	For i = 2 To Len(strCCNumber) Step 2
		
		digit = CInt(Mid(strCCNumber, i, 1))*2
		If digit > 9 Then
			digit = CInt(Mid(digit,1,1)) + CInt(Mid(digit,2,1))
		End If
		
		Sum2 = Sum2 + digit	
	Next
	
	Sum = Sum1+Sum2
	
	If sum Mod 10 = 0 Then
		checkLuhn = True
	Else
		checkLuhn = False
	End If
	
End Function

Function fnRandomNumber(LengthOfRandomNumber)

	Dim sMaxVal : sMaxVal = ""
	Dim iLength : iLength = LengthOfRandomNumber
	'Find the maximum value for the given number of digits
	For iL = 1 to iLength
		sMaxVal = sMaxVal & "9"
	Next
	sMaxVal = Int(sMaxVal)
	'Find Random Value
	Randomize
	iTmp = Int((sMaxVal * Rnd) + 1)
	'Add Trailing Zeros if required
	iLen = Len(iTmp)
	fnRandomNumber = iTmp * (10 ^(iLength - iLen))
End Function

Public Function LPad (ByVal strValue, ByVal charForPadding, ByVal intLength)
	LPad = Right(String(intLength, charForPadding) & strValue, intLength)
End Function

Public Function RPad (ByVal strValue, ByVal charForPadding, ByVal intLength)
	RPad = Left(strValue & String(intLength, charForPadding), intLength)
End Function


Function generateTestData(strType, StrLng)
	Dim str
	Dim varReqNum, varResult, i
	Const strLetters = "abcdefghijklmnopqrstuvwxyz"    
	Select Case strType
		Case "alpha"        	 'generate string test data with required lenght
			For i = 1 to StrLng        
				str = str & Mid( strLetters, RandomNumber( 1, Len( strLetters ) ), 1 )   
			Next    
			generateTestData= str
		Case "alphaNumeric"	'generate alphanumeric test data with required lenght
			Randomize
			For i = 1 To StrLng
				If (Int((1 - 0 + 1) * Rnd + 0)) Then
					generateTestData = generateTestData & Chr(Int((90 - 65 + 1) * Rnd + 65))
				Else
					generateTestData = generateTestData & Chr(Int((57 - 48 + 1) * Rnd + 48))
				End If
			Next
		Case "Numeric"	'generate numeric test data with required lenght
			varReqNum = ""
			For i = 1 to StrLng
				varReqNum = varReqNum & RandomNumber(0,9)
			Next
			generateTestData =  varReqNum
	End Select
End Function

