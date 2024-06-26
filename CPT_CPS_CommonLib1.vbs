'@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
'@@@@				***********************  Function Library  **********************											    @@@@
'@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
'@@@@				Function Library Name  :  CPT_CPS_CommonLib																			@@@@
'@@@@				Function Library Path  :  "[ALM\Resources] Resources\Test Automation Resources\Functional Library\CPS\			@@@
'@@@											CPT_CPS_CommonLib.qfl																	@@@
'@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
''**************************Declare the Global Variable with public/ Private scope***************************************************************
Public policyEffectiveDate, cpsDataTableDictObj, cpsDataTablePath, defaultSheetName, varCPSApplicationPath
Set cpsDataTableDictObj = CreateDict() 'Create Dictionary for scenarios.
Private claimNum_
Public ClaimNumber 'For Claim Number processing.
Public PolicyNumber  'For the Policy Number storage.
Private CPS_DiagCode  'For Diagnosis Code capture after generated.
cpsDataTablePath = TestArgs("CPSDatatablePath") ' Data table path from the Input Parameter
defaultSheetName =  TestArgs("DefaultSheetName")  ' Sheet Name  from the Input Parameter
varCPSApplicationPath=TestArgs("CPSApplicationPath")  'Application Path from the Input Parameter
summaryAdditionalData = "Policy Number: "&PolicyNumber
' Claim Central and Client Central Application Path
var_ClaimCentralAppPath=TestArgs("ClaimCentralAppPath")
var_ClientCentralAppPath=TestArgs("ClientCentralAppPath")
'var_ClaimCentralAppPath="\\scwclm01a\Aflac\ClaimsCentral\1.5\ClaimsCentral\Clients\Aflac.ClaimsCentral.Client.application"
'var_ClientCentralAppPath="C:\Program Files\Aflac\Client Central 2.0\Aflac.InformationCenter.UI.exe"
var_CPS_Latest_Build_Path="\\pcnfs09\TFSBuild\CPS\CPS"
Public polDate:polDate = ""
'########################################################################################################################################
'Function Name				: 	CPSStartUp
'Purpose					:	Function is working in CPS scripts,This function for start up 
'Pre-Condition				:	Cliam Number should be generated Successfully
'Post-Condition				:	None
'-----------------------------------------------------------------------------------------------------------------------------------------
'Input Parameters			:  	Claim Number
'Output Parameters			:	None
'Return Type				: 	None
'Author						:	Vinay Yadav
'Date Written				:	
'Date Modified				:
'Modification details		:
'##########################################################################################################################################
Public Function CPSStartUp(rowNum)
				If LaunchCPSApplication(rowNum) = -1 Then
					SetIterStatusFailure()
					Exit Function
				Else
					SetIterStatusSuccess()
				End If
				If PolicyClaimSearch(rowNum) = -1 Then
					SetIterStatusFailure()
					Exit Function
				Else
					SetIterStatusSuccess()
				End If
				If PopulatePolicyData(rowNum)= -1 Then
					SetIterStatusFailure()
					Exit Function
				Else
					SetIterStatusSuccess()
				End If
				If PopulateClaimData(rowNum)= -1 Then
					SetIterStatusFailure()
					Exit Function
				Else
					SetIterStatusSuccess()
					If GetDictItem(cpsDataTableDictObj, "ScenarioName#" & rowNum)="CLM_CPS_ICD10 DC Invalid 8 AlphaNumeric Char LOB AD_03" Then
						summaryAdditionalData = "Policy Number: "&GetDictItem(cpsDataTableDictObj, "PolicyNumber#" & rowNum)
						Exit Function
					End If
				End If			
				If GetDictItem(cpsDataTableDictObj, "ValidateDiagCode#" & rowNum)="3Y" OR  GetDictItem(cpsDataTableDictObj, "ValidateDiagCode#" & rowNum)="7Y" or GetDictItem(cpsDataTableDictObj, "ValidateDiagCode#" & rowNum)="8Y" Then
					'Validation of Diagnosis Code from CLient Central and Claim Central Application
					If Validate_Diagnosis_Code(rowNum)= -1 Then
						SetIterStatusFailure()
						Exit Function
					Else
						SetIterStatusSuccess()
					End If	
				Else
					' Research claim
'					If ResearchClaim(rowNum)= -1 Then
'						SetIterStatusFailure()
'						Exit Function
'					Else
'						SetIterStatusSuccess()
'					End If	
				End If
End Function
'########################################################################################################################################
'Function Name				: 	LaunchCPSApplication
'Purpose					:	Function is working in CPS scripts,This function for launch CPS Application
'Pre-Condition				:	Cliam Number should be generated Successfully
'Post-Condition				:	None
'-----------------------------------------------------------------------------------------------------------------------------------------
'Input Parameters			:  	Claim Number
'Output Parameters			:	None
'Return Type				: 	None
'Author						:	Vinay Yadav
'Date Written				:	
'Date Modified				:
'Modification details		:
'##########################################################################################################################################
Public Function LaunchCPSApplication(rowNum)
	'SystemUtil.Run varCPSApplicationPath
	SystemUtil.Run "G:\NIIT Automation\Claims_347_Automation\CPS_Launch_BatchFile\CPS_Launch.bat"
	SystemUtil.CloseProcessByName "cmd.exe"
	
	If WpfWindow("ClaimsPaymentSystem").Exist Then
'	WpfWindow("ClaimsPaymentSystem").Activate

'	If ValidateObject(WpfWindow("Claims Payment System"),20)=0 Then
'	WpfWindow("Claims Payment System").Activate
		ReportMessage "Info", "Claims Payment System application launched from " & TestArgs("CPSApplicationPath") & " path. ", True, "N"
		LaunchCPSApplication=0
	Else
		ReportMessage "Fail", "Claims Payment System application Not launched.", True, "N"
		LaunchCPSApplication=-1
		Exit Function
	End If
'	WpfWindow("wpfwin_CPSLogin").Maximize
	WpfWindow("ClaimsPaymentSystem").Maximize
'	WpfWindow("Claims Payment System").Maximize
	If WpfWindow("ClaimsPaymentSystem").SwfButton("LogonBtn").Exist(10) Then
	
'	If ValidateObject(WpfWindow("Claims Payment System").WinObject("L"),10)=0 Then
'	If ValidateObject(WpfWindow("Claims Payment System").WinObject("L_3"),10)=0 Then

'WpfWindow("Claims Payment System").WinObject("L_2").Click
'WpfWindow("Claims Payment System").SwfObject("SwfObject").SwfObject("elementHost1").WpfWindow("WpfWindow").SwfObject("SwfObject").SwfButton("L").Click
'WpfWindow("Claims Payment System").WinObject("L_3").Click
'
'
'WpfWindow("ClaimsPaymentSystem").SwfEdit("UserID").Set
'WpfWindow("ClaimsPaymentSystem").SwfEdit("Password").Set
	
'	If WpfWindow("Claims Payment System").SwfObject("SwfObject").SwfObject("elementHost1").WpfWindow("WpfWindow").SwfObject("SwfObject").SwfButton("L").Exist(10) Then
	

'	WpfWindow("Claims Payment System").SwfObject("SwfObject").SwfObject("elementHost1").WpfWindow("WpfWindow").SwfObject("SwfObject").SwfEdit("UserID").Set
'WpfWindow("Claims Payment System").SwfObject("SwfObject").SwfObject("elementHost1").WpfWindow("WpfWindow").SwfObject("SwfObject").SwfEdit("Password").Set


'	If ValidateObject(WpfWindow("Claims Payment System").SwfObject("SwfObject").SwfObject("elementHost1").WpfWindow("WpfWindow").SwfObject("SwfObject").SwfButton("L"),10)=0 Then
'		WpfWindow("wpfwin_CPSLogin").SwfEdit("swfedt_UserID").Set TestArgs("UserID")
		WpfWindow("ClaimsPaymentSystem").SwfEdit("UserID").Set TestArgs("UserID")
'		WpfWindow("Claims Payment System").SwfObject("SwfObject").SwfObject("elementHost1").WpfWindow("WpfWindow").SwfObject("SwfObject").SwfEdit("UserID").Set TestArgs("UserID")


'		WpfWindow("wpfwin_CPSLogin").SwfEdit("swfedt_Password").SetSecure TestArgs("Password")
		WpfWindow("ClaimsPaymentSystem").SwfEdit("Password").SetSecure TestArgs("Password")
'		WpfWindow("Claims Payment System").SwfObject("SwfObject").SwfObject("elementHost1").WpfWindow("WpfWindow").SwfObject("SwfObject").SwfEdit("Password").SetSecure TestArgs("Password")

'		WpfWindow("wpfwin_CPSLogin").SwfComboBox("swfcom_Region").Select GetDictItem(cpsDataTableDictObj, "Region#" & rowNum)
'		WpfWindow("Claims Payment System").SwfObject("SwfObject").SwfObject("elementHost1").WpfWindow("WpfWindow").SwfObject("SwfObject").SwfComboBox("AltRegion").Select GetDictItem(cpsDataTableDictObj, "Region#" & rowNum)
'		WpfWindow("Claims Payment System").SwfObject("SwfObject").SwfObject("elementHost1").WpfWindow("WpfWindow").SwfObject("SwfObject").SwfComboBox("AltRegion").Select
		WpfWindow("ClaimsPaymentSystem").SwfComboBox("LogontoReg").Select
		WpfWindow("ClaimsPaymentSystem").SwfButton("LogonBtn").Click

'		WpfWindow("wpfwin_CPSLogin").SwfButton("swfbtn_Logon").Click
''		WpfWindow("Claims Payment System").WinObject("L").Click
'		WpfWindow("Claims Payment System").WinObject("L_3").Click
'		WpfWindow("Claims Payment System").SwfObject("SwfObject").SwfObject("elementHost1").WpfWindow("WpfWindow").SwfObject("SwfObject").SwfButton("L").Click
'		WpfWindow("Claims Payment System").SwfObject("SwfObject").SwfObject("elementHost1").WpfWindow("WpfWindow").SwfObject("SwfObject").SwfButton("L").Click



		
		ReportMessage "Info", "Clicked on Logon after entering UserID - <b>'" & TestArgs("UserID") & "'</b>, Password - <b>'******'</b> and Region - <b>'" & GetDictItem(cpsDataTableDictObj, "Region#" & rowNum) &"'</b>" , True, "N"
	End If
'	If ValidateObject(WpfWindow("wpfwin_PolicySearch").SwfEdit("swfedt_PolicyNumber"),30)=0 Then
	If ValidateObject(WpfWindow("Claims Payment System").SwfObject("SwfObject").SwfObject("elementHost1").WpfWindow("WpfWindow").SwfObject("SwfObject").SwfEdit("PolicyNumber"),30)=0 Then
	WpfWindow("Claims Payment System").SwfObject("SwfObject").SwfObject("elementHost1").WpfWindow("WpfWindow").SwfObject("SwfObject").SwfEdit("PolicyNumber").Set
'	WpfWindow("Claims Payment System").SwfObject("SwfObject").SwfObject("elementHost1").WpfWindow("WpfWindow").SwfObject("SwfObject").SwfEdit("PolicyNumber").Set

		ReportMessage "Pass", "User Successfully logon to the Claims Payment System application", True, "Y"
		LaunchCPSApplication=0
		Else
		ReportMessage "Fail", "User does not Successfully logon to the Claims Payment System application", True, "Y"
		LaunchCPSApplication=-1
		Exit Function
	End If	
End Function
'########################################################################################################################################
'Function Name				: 	PolicyClaimSearch
'Purpose					:	Function is working in CPS scripts,This function for Claim Search
'Pre-Condition				:	Cliam Number should be generated Successfully
'Post-Condition				:	None
'-----------------------------------------------------------------------------------------------------------------------------------------
'Input Parameters			:  	Claim Number
'Output Parameters			:	None
'Return Type				: 	None
'Author						:	Vinay Yadav
'Date Written				:	
'Date Modified				:
'Modification details		:
'##########################################################################################################################################
Public Function PolicyClaimSearch(ByVal rowNumber)
		Dim polClaimNumber
		pDate = WpfWindow("wpfwin_PolicySearch").SwfEdit("swfedt_DateReceived").GetROProperty("text")
		pDate = split(pDate, "/")
		polDate = pDate(0) & "/" & pDate(1) & "/" & mid(pDate(2), 3, 4) 
		
		If GetDictItem(cpsDataTableDictObj, "PolicyNumber#" & rowNumber) <> "" Then
			polClaimNumber = GetDictItem(cpsDataTableDictObj, "PolicyNumber#" & rowNumber)
			WpfWindow("wpfwin_PolicySearch").SwfEdit("swfedt_PolicyNumber").Set polClaimNumber
			Wait 1
			strSetPolNumber = WpfWindow("wpfwin_PolicySearch").SwfEdit("swfedt_PolicyNumber").GetROProperty("text")
			If Trim(polClaimNumber) <> Trim(strSetPolNumber) Then
				WpfWindow("wpfwin_PolicySearch").SwfEdit("swfedt_PolicyNumber").Type polClaimNumber
				Wait 1
			End If
			ReportMessage "Info", "Entered Policy Number as: " & polClaimNumber, True, "Y"			
			WpfWindow("wpfwin_PolicySearch").SwfButton("swfbtn_Submit").Click
			PolicyNumber=polClaimNumber
			
			'=====================================================================================================================
			'By Shakti
			If SwfWindow("CPSPolicyRemarksInquiryWin").SwfButton("CloseBtn").Exist(5)  Then
				ReportMessage "Info", "CPS policy remark inquiry window displayed, clicking Close window button", False, "Y"
				SwfWindow("CPSPolicyRemarksInquiryWin").SwfButton("CloseBtn").Click
			End If
		
			If SwfWindow("CPSPolicyExeptionPopup").SwfButton("CloseBtn").Exist(5) Then
				ReportMessage "Info", "Policy execption popup displayed, closing it", False, "Y"
				SwfWindow("CPSPolicyExeptionPopup").SwfButton("CloseBtn").Click
			End If	
			'=====================================================================================================================
			
			If Dialog("CPS - FYI:_2").WinButton("OK").Exist(1) Then
				Dialog("CPS - FYI:_2").WinButton("OK").Click
			End If
			

			
'			If Dialog("CPS - FYI:_2").WinButton("OK").Exist(1) Then
'				Dialog("CPS - FYI:_2").WinButton("OK").Click
'			End If

			
'			SwfWindow("Claims Payment System_5").SwfButton("C").Click

			
			If SwfWindow("CPS_PolicyRemarks").SwfButton("CloseWindow").Exist(5) Then
					SwfWindow("CPS_PolicyRemarks").SwfButton("CloseWindow").Click	
			End If
			
			If SwfWindow("CPSClaimHistoryWin").SwfButton("CloseBtn").Exist(5) Then
					SwfWindow("CPSClaimHistoryWin").SwfButton("CloseBtn").Click	
			End If
			

			'Added by Chandrakant on 2-Dec 2019
'			If SwfWindow("CPS_GroupRemarks").Exist(7) Then
'				SwfWindow("CPS_GroupRemarks").SwfButton("CloseWindow").Click	
'
'				If SwfWindow("CPS_PolicyRemarks").Exist(3) Then
'					SwfWindow("CPS_PolicyRemarks").SwfButton("CloseWindow").Click	
'				End If	
'				
'			End If		
		
			If WpfWindow("wpfwin_PolicySearch").Dialog("dlg_CPSStop").WinButton("winbtn_OK").Exist(2) Then
				ReportMessage "Fail", "Unable to retrieve the policy, getting error on the page. ", True, "Y"
				WpfWindow("wpfwin_PolicySearch").Dialog("dlg_CPSStop").WinButton("winbtn_OK").Click
				PolicyClaimSearch=-1
				Exit Function
			End If
			ReportMessage "Pass", "Enter the policy number - <b>'" & polClaimNumber & "'</b> on the Policy Search screen and click on Submit button. ", True, "Y"
        Else 
			ReportMessage "Fail", "Policy Number should not be blank, Please Enter policy Number and run again", True, "N"
			PolicyClaimSearch=-1
		End If
End Function
'########################################################################################################################################
'Function Name				: 	PopulatePolicyData
'Purpose					:	Function is working in CPS scripts,This function for policy data
'Pre-Condition				:	Cliam Number should be generated Successfully
'Post-Condition				:	None
'-----------------------------------------------------------------------------------------------------------------------------------------
'Input Parameters			:  	Claim Number
'Output Parameters			:	None
'Return Type				: 	None
'Author						:	Vinay Yadav
'Date Written				:	
'Date Modified				:
'Modification details		:
'##########################################################################################################################################
Public Function PopulatePolicyData(ByVal rowNumber)
	Dim policyType
	If WpfWindow("wpfwin_PolicyData").SwfEdit("swfedt_PolicyType").Exist(2)<> True Then
		HandleDialog
	End If 
	If WpfWindow("wpfwin_PolicyData").SwfEdit("swfedt_PolicyType").Exist(2)<> True Then
		If ValidateObject(SwfWindow("swfwin_PolicyException").SwfButton("swfbtn_CloseButton"),3)=0 Then
			ReportMessage "Info", "Clicked on Close button on Policy Exception screen. ", True, "Y"
			SwfWindow("swfwin_PolicyException").SwfButton("swfbtn_CloseButton").Click
		End If
		
		If SwfWindow("CPS_newOverridePopup").SwfButton("OKbtn").Exist(10) Then
			SwfWindow("CPS_newOverridePopup").SwfButton("OKbtn").click()
			
		End If
	End If 
	If WpfWindow("wpfwin_PolicyData").SwfEdit("swfedt_PolicyType").Exist(5)<> True Then
		If ValidateObject(SwfWindow("swfwin_ClaimHistory").SwfButton("swfbtn_CloseWindow"),3)=0 Then
			ReportMessage "Info", "Claim History screen loaded, closing that and moving ahead with the claim submission. ", True, "Y"
'			SwfWindow("swfwin_ClaimHistory").SwfButton("swfbtn_CloseWindow").Click
			SwfWindow("swfwin_ClaimHistory").Activate
			Wait 1
			Sendkey "%c"
		End If
	End If
	
	If ValidateObject(WpfWindow("wpfwin_PolicyData").SwfEdit("swfedt_OrigEffDate"),5)=0 Then
		policyEffectiveDate = WpfWindow("wpfwin_PolicyData").SwfEdit("swfedt_OrigEffDate").GetROProperty("text")
		policyType = WpfWindow("wpfwin_PolicyData").SwfEdit("swfedt_PolicyType").GetROProperty("text")
		If TextExistinString (GetDictItem(cpsDataTableDictObj, "PolicyType#" & rowNumber), policyType) = -1 Then
			PopulatePolicyData=-1
			Exit Function
		End If
		
		If ValidateObject(WpfWindow("wpfwin_PolicyData").WpfButton("wpfbtn_ClaimData"),10)=0 Then
			WpfWindow("wpfwin_PolicyData").WpfButton("wpfbtn_ClaimData").Click
			PopulatePolicyData=0
		Else
			ReportMessage "Fail", "Claim Data tab is not displayed, Please change Policy and run again.", True, "Y"
			PopulatePolicyData=-1
			Exit Function
		End If
		wait 1
		
		If SwfWindow("CPS_newOverridePopup").SwfButton("OKbtn").Exist(10) Then
			SwfWindow("CPS_newOverridePopup").SwfButton("OKbtn").click()
			
		End If
		
		
		
		If SwfWindow("swfwin_ClaimRemarksList").SwfButton("swfbtn_CloseWindow").Exist(5) Then
			CloseClaimRemarks()
		End If
			HandleDialog
		ReportMessage "Info", "Policy data tab loaded, movng to the Claim data screen. ", True, "Y"
		PopulatePolicyData=0
	Else
		ReportMessage "Info", "Policy data tab Not loaded Successfully", True, "Y"
		PopulatePolicyData=-1
		Exit Function
	End If
	
	If SwfWindow("CPS_newOverridePopup").SwfButton("OKbtn").Exist(10) Then
			SwfWindow("CPS_newOverridePopup").SwfButton("OKbtn").click()
			
		End If
End Function
'########################################################################################################################################
'Function Name				: 	PopulateClaimData
'Purpose			
'Function is working in CPS scripts,This function for claim data
'Pre-Condition				:	Cliam Number should be generated Successfully
'Post-Condition				:	None
'-----------------------------------------------------------------------------------------------------------------------------------------
'Input Parameters			:  	Claim Number
'Output Parameters			:	None
'Return Type				: 	None
'Author						:	Vinay Yadav
'Date Written				:	
'Date Modified				:
'Modification details		:
'##########################################################################################################################################
Public Function PopulateClaimData(ByVal rowNumber)
		 

		If ValidateObject(SwfWindow("swfwin_PreAuditClaimHistory").SwfButton("swfbtn_CloseWindow"),4)=0 Then
			ReportMessage "Info", "Pre Audit claim history screen loaded, clicking on Close Window button. ", True, "Y"
			SwfWindow("swfwin_PreAuditClaimHistory").SwfButton("swfbtn_CloseWindow").Click
		End If
		If GetRegexMatchCount(GetDictItem(cpsDataTableDictObj, "PolicyType#" & rowNumber), "SD-SHORT TERM") > 0 Then
			If PopulateDataForSTD(rowNumber)=-1 Then
				PopulateClaimData=-1
				Exit Function
			End If
		ElseIf GetRegexMatchCount(GetDictItem(cpsDataTableDictObj, "PolicyType#" & rowNumber), "AD-ACCIDENT|VS-VISION") > 0 Then
			If PopulateDataForAccidentVision(rowNumber)=-1 Then
				PopulateClaimData=-1
				Exit Function
			End If
		Else
			If PopulateDataForOtherLOBs(rowNumber)=-1 then
				PopulateClaimData=-1
				Exit Function
			End If
		End If			
		
		If GetDictItem(cpsDataTableDictObj, "ScenarioName#" & rowNumber)="CLM_CPS_ICD10 DC Invalid 8 AlphaNumeric Char LOB AD_03" Then
			PopulateClaimData=0
			Exit Function
		End If
		If ValidateObject(SwfWindow("swfwin_ClaimRemarkAudit").SwfButton("swfbtn_CloseWindow"),10)=0 Then
			CheckClaimRemarks()
		Else
			PopulateClaimData=-1
			Exit Function
		End If
End Function
'########################################################################################################################################
'Function Name				: 	CheckClaimRemarks
'Purpose					:	Function is working in CPS scripts,This function for check claim remarks
'Pre-Condition				:	Cliam Number should be generated Successfully
'Post-Condition				:	None
'-----------------------------------------------------------------------------------------------------------------------------------------
'Input Parameters			:  	Claim Number
'Output Parameters			:	None
'Return Type				: 	None
'Author						:	Vinay Yadav
'Date Written				:	
'Date Modified				:
'Modification details		:
'##########################################################################################################################################
Public Function CheckClaimRemarks()
	Dim claimNumberArr, remark
 	While SwfWindow("swfwin_ClaimRemarkAudit").SwfButton("swfbtn_CloseWindow").Exist(4)
		remark = SwfWindow("swfwin_ClaimRemarkAudit").SwfEditor("swfedt_GeneratedRemarks").GetROProperty("text")
		ReportMessage "Info", "Claim Remark appeared as - " & remark, True, "Y"
		wait 1
		If SwfWindow("swfwin_ClaimRemarkAudit").SwfButton("swfbtn_CloseWindow").GetROProperty("enabled") = True Then
			SwfWindow("swfwin_ClaimRemarkAudit").SwfButton("swfbtn_CloseWindow").Click
		Else
			SwfWindow("swfwin_ClaimRemarkAudit").Close
		End If
	Wend
	'SwfWindow("Claims Completed Summary").Activate
'SwfWindow("Claims Completed Summary").SwfButton("OK").Click

	
	'Added by Amit to handle the 'Claim Payment Notes Summary' dialog.
	If SwfWindow("Claims Payment System_4").SwfButton("CloseWindow").Exist(5) Then
		SwfWindow("Claims Payment System_4").SwfButton("CloseWindow").Click
	End If
	If SwfWindow("ClaimsCompletedSummary").Exist(2) Then
	    ReportMessage "Info", "Claim completed summary screen appeared", True, "Y"
		SwfWindow("ClaimsCompletedSummary").Close
	End If

	'Addition from Amit ends.
	
	'Added by Amit Garg on 08/14/2018 to handle the PEND and DENY actions.
	If Environment.Value("var_Action") <> "PAY" Then
		If Dialog("CPS - FYI:").Exist(5) Then
			ReportMessage "Info", "A dialog with Text: '" & Dialog("CPS - FYI:").Static("StaticMessage").GetROProperty("text") & "' appeared. Clicking on 'NO' button on this dialog.", true, "Y"
			Dialog("CPS - FYI:").WinButton("No").Click
		End If
		
		If Dialog("CPS - FYI:").Exist(5) Then
			ReportMessage "Info", "A dialog with Text: '" & Dialog("CPS - FYI:").Static("StaticMessage").GetROProperty("text") & "' appeared. Clicking on 'NO' button on this dialog.", true, "Y"
			Dialog("CPS - FYI:").WinButton("No").Click
		End If
	End If
	'Updates by  Amit Garg ends.
	
	If ValidateObject(WpfWindow("wpfwin_PolicySearch").SwfEdit("swfedt_NewClaimNumber"),5)=0 Then
		ReportMessage "Info", "Checking if the Policy search screen is loaded or not. ", True, "N"
		'Below line Commented by Amit 
		'SetClaimNumber WpfWindow("wpfwin_PolicySearch").SwfEdit("swfedt_NewClaimNumber").GetVisibleText()
		'Added by Amit
		SetClaimNumber WpfWindow("wpfwin_PolicySearch").SwfEdit("swfedt_NewClaimNumber").GetROProperty("text")
		'Addition Ended by Amit
		
		summaryAdditionalData = "Policy Number: "&PolicyNumber&"  Claim Number : " & GetClaimNumber()
			If GetClaimNumber() <> "" Then
				ReportMessage "Pass", "Claim number " & GetClaimNumber() & " is generated successfully. ", True, "Y"
				CheckClaimRemarks=0
			Else
				ReportMessage "Fail", "Claim number is not generated. ", True, "Y"
				CheckClaimRemarks=-1
				Exit Function
			End If
	Else
		ReportMessage "Fail", "Claim number is not generated. ", True, "Y"
		CheckClaimRemarks=-1
		Exit Function
	End If
End Function
'########################################################################################################################################
'Function Name				: 	ResearchClaim
'Purpose					:	Function is working in CPS scripts,This function is for research claim number
'Pre-Condition				:	Cliam Number should be generated Successfully
'Post-Condition				:	None
'-----------------------------------------------------------------------------------------------------------------------------------------
'Input Parameters			:  	Claim Number
'Output Parameters			:	None
'Return Type				: 	None
'Author						:	Vinay Yadav
'Date Written				:	
'Date Modified				:
'Modification details		:
'##########################################################################################################################################
Public Function ResearchClaim(ByVal rowNumber)
	var_letterCode = GetDictItem(cpsDataTableDictObj, "LetterCode#" & rowNumber) 
	var_Action = GetDictItem(cpsDataTableDictObj, "Action#" & rowNumber) 
	var_Pol = GetDictItem(cpsDataTableDictObj, "PolicyNumber#" & rowNumber) 
	
	'Below lines rae added by Amit Garg on 08/23/2018 to do the payment notes validations
	var_Cd1 = GetDictItem(cpsDataTableDictObj, "Cd1#" & rowNumber) 
	var_Cd2 = GetDictItem(cpsDataTableDictObj, "Cd2#" & rowNumber) 
	var_Cd3 = GetDictItem(cpsDataTableDictObj, "Cd3#" & rowNumber) 
	var_Cd4 = GetDictItem(cpsDataTableDictObj, "Cd4#" & rowNumber) 
	'Addtion from Amit Garg ends.
	
	Dim claimStatus
	If Validateobject(WpfWindow("wpfwin_PolicySearch").WpfButton("wpfbtn_Research"),10)=0 Then
		WpfWindow("wpfwin_PolicySearch").WpfButton("wpfbtn_Research").Click
		ReportMessage "Info", "Checking if the Research screen is loaded or not. ", True, "N"
		
		If ValidateObject(WpfWindow("wpfwin_Research").SwfLabel("swflbl_SearchAllClaims"),20)=0 Then
			ReportMessage "Pass", "Research Tab is loaded successfully", True, "Y"
			ResearchClaim=0
		Else
			ReportMessage "Fail", "Research Tab is not loaded successfully", True, "Y"
			ResearchClaim=-1
			Exit Function
		End If
		WpfWindow("wpfwin_Research").SwfLabel("swflbl_SearchAllClaims").Click
		ReportMessage "Info", "Checking if the Search All claims screen is loaded or not. ", True, "N"
		
		If ValidateObject(SwfWindow("swfwin_SearchAllClaims").SwfButton("swfbtn_Search"),10)=0 Then
			ReportMessage "Pass", "Search All claims screen is loaded successfully.", True, "Y"
			ResearchClaim=0
		else
			ReportMessage "Fail", "Search All claims screen is loaded successfully.", True, "Y"
			ResearchClaim=-1
			Exit Function
		End If
		wait 1
		SwfWindow("swfwin_SearchAllClaims").SwfEdit("swfedt_ClaimNumber").Set GetClaimNumber()
		SwfWindow("swfwin_SearchAllClaims").SwfButton("swfbtn_Search").Click
		ReportMessage "Info", "Checking if the Expanded display screen is loaded or not. ", True, "N"
		If ValidateObject(SwfWindow("swfwnd_ExpandedDisplay").SwfLabel("swflbl_ClaimStatus"),20)=0 Then
			ReportMessage "Pass", "Expanded display screen is Loaded successfully.", True, "Y"
			ResearchClaim=0
		Else
			ReportMessage "Fail", "Expanded display screen is not Loaded successfully.", True, "Y"
			ResearchClaim=-1
			Exit Function
		End If
		wait 1
		claimStatus = SwfWindow("swfwnd_ExpandedDisplay").SwfLabel("swflbl_ClaimStatus").GetROProperty("text")
		If GetRegexMatchCount(claimStatus, GetDictItem(cpsDataTableDictObj, "ClaimStatus#" & rowNumber)) > 0 Then
			ReportMessage "Pass", "Expected Claim Status - " & claimStatus & " appeared on the screen. ", True, "Y"
		Else
			ReportMessage "FAIL", "Expected Claim Status  - " & GetDictItem(cpsDataTableDictObj, "ClaimStatus#" & rowNumber) & " and displayed status - " & claimStatus & " on the screen. ", True, "Y"
			ResearchClaim=-1
			Exit Function
		End If
		
		blnPaymentNotesValidation = fnGetPaymentNotesFromClaimsExpandedDisplay(var_Cd1, var_Cd2, var_Cd3, var_Cd4)
		If blnPaymentNotesValidation = -1 Then
			ResearchClaim=-1
			Exit Function
		End If
		
		ReportMessage "Info", "Closing the Claim Status window. ", True, "N"
		wait 1
		SwfWindow("swfwnd_ExpandedDisplay").Close
		
		'Added by Amit to handle the Pay and Denied claims validations.
		varLetterFound = False
		varInsuredFound = False
		itemNumber = 0
		If var_Action <> "PAY" Then
			WpfWindow("wpfwin_Research").SwfLabel("swflbl_LetterReviewApproval").Click
	
			SwfWindow("Claims Payment System_2").SwfEdit("ClaimNumberTxt").Set var_Pol
			SwfWindow("Claims Payment System_2").SwfButton("Search").Click
			Wait 3	
			strItemsCount = SwfWindow("Claims Payment System_2").SwfListView("LetterMaintListView").GetItemsCount
			
			For i = 0 To strItemsCount - 1 Step 1
				strCurrItemInsured = SwfWindow("Claims Payment System_2").SwfListView("LetterMaintListView").GetSubItem(i,2)	
				If Environment.Value("strPolicyHolderName") = strCurrItemInsured Then
					varInsuredFound = True
					itemNumber = i
					Exit for
				End If
			Next
			
			If varInsuredFound = True Then
				ReportMessage "Pass", "Letter Record found for the Insured: " & Environment.Value("strPolicyHolderName") , True, "Y"
				strCurrItemLetterName = SwfWindow("Claims Payment System_2").SwfListView("LetterMaintListView").GetSubItem(itemNumber,0)
				If strCurrItemLetterName = var_letterCode Then
					ReportMessage "Pass", "Letter Name generated is: " & strCurrItemLetterName & " which is same as expected.", True, "Y"
				Else
					ReportMessage "Fail", "Letter Name generated is: " & strCurrItemLetterName & " which is NOT same as expected " & var_letterCode, True, "Y"
				End If
			Else
				ReportMessage "Fail", "Letter Record is not found for the Insured: " & Environment.Value("strPolicyHolderName") , True, "Y"
			End If					
			'Updates from Amit ends
			
			ResearchClaim=0
		End If	
				
	Else
		ResearchClaim=-1
		ReportMessage "Fail", "Research Tab is not Displaying", True, "Y"
		Exit Function
	End If
End Function
'########################################################################################################################################
'Function Name				: 	PopulateDataForAccidentVision
'Purpose					:	Function is working in CPS scripts,This function is for accident and vision
'Pre-Condition				:	Cliam Number should be generated Successfully
'Post-Condition				:	None
'-----------------------------------------------------------------------------------------------------------------------------------------
'Input Parameters			:  	Claim Number
'Output Parameters			:	None
'Return Type				: 	None
'Author						:	Vinay Yadav
'Date Written				:	21-June-2016
'Date Modified				:
'Modification details		:
'##########################################################################################################################################

Public Function PopulateDataForAccidentVision(ByVal rowNumber)
	Dim var_benefitCode, var_loc, var_event, var_payee, var_inout, var_claimType, var_diagCode, var_BenefitQuestion, var_BenefitQuesAns, var_Action, var_BenefitAmt, benefitCodeNum, getPolicyCreationDate, _
				rowNum, var_proc,var_sheetNumber
	rowNum = 0
	var_descr1=GetDictItem(cpsDataTableDictObj, "Descr1#" & rowNumber)
	var_sheetNumber = GetDictItem(cpsDataTableDictObj, "SheetNumber#" & rowNumber)
	var_benefitCode = GetDictItem(cpsDataTableDictObj, "BenefitCode#" & rowNumber)
	var_loc = GetDictItem(cpsDataTableDictObj, "OnOffJob#" & rowNumber)
	var_event = GetDictItem(cpsDataTableDictObj, "Event#" & rowNumber) 
	var_proc = GetDictItem(cpsDataTableDictObj, "Proc#" & rowNumber) 
	var_payee = GetDictItem(cpsDataTableDictObj, "Payee#" & rowNumber)
	var_provider = 	GetDictItem(cpsDataTableDictObj, "Provider#" & rowNumber)
	var_inout = GetDictItem(cpsDataTableDictObj, "I/O#" & rowNumber) 
	var_quantity = GetDictItem(cpsDataTableDictObj, "Quantity#" & rowNumber) 
	var_claimType = GetDictItem(cpsDataTableDictObj, "ClaimType#" & rowNumber) 
	var_diagCode = GetDictItem(cpsDataTableDictObj, "DiagCd#" & rowNumber) 
	var_chgAmt = GetDictItem(cpsDataTableDictObj, "ChgAmt#" & rowNumber) 
	var_BenefitQuestion = GetDictItem(cpsDataTableDictObj, "BenefitCodeQuestion#" & rowNumber) 
	var_BenefitQuesAns = GetDictItem(cpsDataTableDictObj, "BenefitCodeAnswer#" & rowNumber) 
	'Added by AMit on 08/22/2018
	var_Mod1 = GetDictItem(cpsDataTableDictObj, "Mod1#" & rowNumber) 
	var_Mod2 = GetDictItem(cpsDataTableDictObj, "Mod2#" & rowNumber) 
	var_Mod3 = GetDictItem(cpsDataTableDictObj, "Mod3#" & rowNumber) 
	var_Mod4 = GetDictItem(cpsDataTableDictObj, "Mod4#" & rowNumber) 
	var_Cd1 = GetDictItem(cpsDataTableDictObj, "Cd1#" & rowNumber) 
	var_Cd2 = GetDictItem(cpsDataTableDictObj, "Cd2#" & rowNumber) 
	var_Cd3 = GetDictItem(cpsDataTableDictObj, "Cd3#" & rowNumber) 
	var_Cd4 = GetDictItem(cpsDataTableDictObj, "Cd4#" & rowNumber) 
	'Additions by amit ends.
	var_letterCode = GetDictItem(cpsDataTableDictObj, "LetterCode#" & rowNumber) 
	var_Action = GetDictItem(cpsDataTableDictObj, "Action#" & rowNumber) 
	var_BenefitAmt = GetDictItem(cpsDataTableDictObj, "BenefitAmt#" & rowNumber) 
	occDate = GetDateFormatted(DateAdd("d", cint(GetDictItem(cpsDataTableDictObj, "OccDate#" & rowNumber)), policyEffectiveDate), "MMDDYY")
	eventDate = GetDateFormatted(DateAdd("d", cint(GetDictItem(cpsDataTableDictObj, "EventDate#" & rowNumber)), policyEffectiveDate), "MMDDYY")
	bdp = GetDateFormatted(DateAdd("d",  cint(GetDictItem(cpsDataTableDictObj, "BDP#" & rowNumber)), policyEffectiveDate), "MMDDYY")
	edp = GetDateFormatted(DateAdd("d",  cint(GetDictItem(cpsDataTableDictObj, "EDP#" & rowNumber)), policyEffectiveDate), "MMDDYY")
	stDate = GetDateFormatted(DateAdd("d",  cint(GetDictItem(cpsDataTableDictObj, "BDP#" & rowNumber)), policyEffectiveDate), "MM/DD/YY")
	endDate = GetDateFormatted(DateAdd("d",  cint(GetDictItem(cpsDataTableDictObj, "EDP#" & rowNumber)), policyEffectiveDate), "MM/DD/YY")
	quantity = DateDiff("d", stDate, endDate) + 1
	

'		If WpfWindow("wpfwin_ClaimData").SwfLabel("text:=" & var_benefitCode, "index:=0").Exist(5) Then
''			WpfWindow("swfwnd_PolicyNumber").SwfObject("SwfObject").SwfObject("ScrollingRegion").VScroll micSetPos, 236
''			WpfWindow("swfwnd_PolicyNumber").SwfObject("SwfObject").SwfObject("ScrollingRegion").VScroll micSetPos, 236
'			wait 1
'			On error resume next
'			If WpfWindow("swfwnd_PolicyNumber").SwfObject("SwfObject").SwfObject("ScrollingRegion").Exist(1) Then
'				WpfWindow("swfwnd_PolicyNumber").SwfObject("SwfObject").SwfObject("ScrollingRegion").VScroll micSetPos, 236	
'			End If
'			On error goto 0
'			WpfWindow("wpfwin_ClaimData").SwfLabel("text:=" & var_benefitCode, "index:=0").Object.Focus
'			WpfWindow("wpfwin_ClaimData").SwfLabel("text:=" & var_benefitCode, "index:=0").DblClick 2,2
''			WpfWindow("wpfwin_ClaimData").SwfLabel("text:=" & var_benefitCode, "index:=0").FireEvent "DoubleClick"
''			wait 1
'				HandleDialog

'''''			'Populating the WpfObject with the data
'			err.Clear
'			On error resume next
'			If objDatTableaGrid.GetCellData(rowNum, "Bene")=var_benefitCode Then
'				ReportMessage "Info", "Double clicked on Benefit code <b>'" & var_benefitCode & "'</b> to add that in the grid to start filling the claim. ", True, "Y"
'				PopulateDataForAccidentVision=0
'			End If
'			If err.number<>0 Then
'				ReportMessage "Fail", "Benefit Code is not Selected", True, "Y"
'				PopulateDataForAccidentVision=-1
'				Exit Function
'			End If
'			On error goto 0	
'		Else 
'			ReportMessage "Fail", "Benefit Code: <b>"&var_benefitCode&" </b> not added with the Policy, Please use other policy with the Benefit Code.", True, "Y"
'			PopulateDataForAccidentVision=-1
'			Exit Function
'		End If
		
		If DoubleClickONBenefitCode (var_benefitCode) = 0 Then
			'ReportMessage "Pass", "Benefit Code: <b>"&var_benefitCode&" </b> successfully added with the Policy.", True, "Y"
		Else
			'ReportMessage "Fail", "Benefit Code: <b>"&var_benefitCode&" </b> not added with the Policy. Please check.", True, "Y"
			PopulateDataForAccidentVision=-1
			Exit Function
		End If
		
		Set objDatTableaGrid = UIAWindow("ClaimsPaymentSystemUIA").UIATable("EobItemsGrid")				
		
			'objDatTableaGrid.SetCellData rowNum, "Sheet", var_sheetNumber
			objDatTableaGrid.ActivateCell rowNum, "Sheet"
			Wait 1
			SendKey var_sheetNumber
			If GetRegexMatchCount(GetDictItem(cpsDataTableDictObj, "PolicyType#" & rowNumber), "AD-ACCIDENT") > 0 Then
				objDatTableaGrid.ActivateCell rowNum, "Loc"
				SendKey var_loc
				SendKey strloc
				wait 0,500
				Sendkey "{Tab}"					
			Else
				objDatTableaGrid.ActivateCell rowNum, "Event"
				SendKey var_event
				SendKey strloc
				wait 0,500
				Sendkey "{Tab}"					
			End If
				'====================================================================
				'added by shati
				objDatTableaGrid.ActivateCell rowNum, "Pol Date"
				SendKey polDate
				'====================================================================
				objDatTableaGrid.ActivateCell rowNum, "Event Date"
				SendKey eventDate
				objDatTableaGrid.ActivateCell rowNum, "Occ Date"
				SendKey occDate
				objDatTableaGrid.ActivateCell rowNum, "BDP"
				SendKey bdp
				objDatTableaGrid.ActivateCell rowNum, "EDP"
				SendKey edp			
				
'				
'				SetWpfObjectDate objDatTableaGrid, rowNum, "Event Date", eventDate
'           	 	SetWpfObjectDate objDatTableaGrid, rowNum, "Occ Date", occDate
'				SetWpfObjectDate objDatTableaGrid, rowNum, "BDP", bdp
'				SetWpfObjectDate objDatTableaGrid, rowNum, "EDP", edp
'			
			If (GetDictItem(cpsDataTableDictObj, "BenefitCode#" & rowNumber)="IHA" and GetDictItem(cpsDataTableDictObj, "Region#" & rowNumber)="COLUMBUS" and GetDictItem(cpsDataTableDictObj, "Environment#" & rowNumber)="INTG") OR GetDictItem(cpsDataTableDictObj, "BenefitCode#" & rowNumber)="APL" and GetDictItem(cpsDataTableDictObj, "Region#" & rowNumber)="COLUMBUS" and GetDictItem(cpsDataTableDictObj, "Environment#" & rowNumber)="SYST"Then
				objDatTableaGrid.ActivateCell rowNum, "Descr1"
				Sendkey  var_descr1
				SendKey "{TAB}"
				Wait 1
				ReportMessage "Info", "Screenshot after entering the column Descr1.", True, "Y"
				HandleDialog
			End If
				SelectTextFromWpfObject objDatTableaGrid, rowNum, "Proc", var_proc
				objDatTableaGrid.ActivateCell rowNum, "Payee"
				Sendkey var_payee
				SendKey strloc
				wait 0,500
				Sendkey "{Tab}"					
				'added by Amit to handle the Provide type of Payee
				If UCase(var_payee) = "PROVIDER" Then
					objDatTableaGrid.ActivateCell rowNum, "Provider"
					Sendkey var_provider
					objDatTableaGrid.ActivateCell rowNum, "Patient#"
					Sendkey  CStr(RandomNumber.value(1,999))
				End If
				'updates by Amit ends.
				objDatTableaGrid.ActivateCell rowNum, "I/O"
				SendKey var_inout
				SendKey strloc
				wait 0,500
				Sendkey "{Tab}"	
				
				objDatTableaGrid.ActivateCell rowNum, "Quant"
				Sendkey quantity
				objDatTableaGrid.ActivateCell rowNum, "Type Claim"
				Sendkey var_claimType
				SendKey strloc
				wait 0,500
				Sendkey "{Tab}"					
				objDatTableaGrid.ActivateCell rowNum, "Diag Cd"
				'Auto Generate Diagnosis Code
				CPS_DiagCode=fn_Generate_Diagnosis_Code(rowNumber)
				Sendkey CPS_DiagCode
				SendKey "{TAB}"
				If Len (CPS_DiagCode)>7 Then
					ReportMessage "Info", "Entered data on the Claim Data screen :- <br><br>Event: <b>'" & var_event & "'</b>, <br>Event Date: <b>'" & eventDate & "'</b>, <br>Loc: <b>'" & _
					var_loc & "'</b>, <br>Occ Date: <b>'" & occDate & "'</b>, <br>BDP: <b>'" & bdp & "'</b>, <br>EDP: <b>'" & edp & "'</b>, <br>Payee: <b>'" & var_payee & _
					"'</b>, <br>I/O: <b>'" & var_inout & "'</b>, <br>Quantity: <b>'" & quantity & "'</b>, <br>ClaimType: <b>'" & var_claimType & "'</b>, <br>DiagCd: <b>'" & _
					CPS_DiagCode& "'</b>", True, "N"
					ReportMessage "Pass", "Error message on Pop-up Window: Diagnosis Code Must not contain more than 7 characters, not including the decimal point", True, "Y"
					 HandleDialog
					wait 1
					PopulateDataForAccidentVision=1
					Exit Function 
				Else 
					fn_Verify_Diagnosis_Code CPS_DiagCode
				End If
				
				'Added by Amit on 08/22/2018 to input the Mods
				fnKeyModDetails rowNum, GetDictItem(cpsDataTableDictObj, "PolicyType#" & rowNumber), var_Mod1, var_Mod2, var_Mod3, var_Mod4				
				
				objDatTableaGrid.ActivateCell rowNum, "Chg Amt"
				Sendkey var_chgAmt
				SendKey "{TAB}"
				HandleDialog
'				benefitAmt = objDatTableaGrid.GetCellData(rowNum, "Benefit Amt")
			Set objGrid = WpfWindow("Claims Payment System").SwfObject("SwfObject").SwfObject("elementHost1").WpfWindow("WpfWindow_2").SwfObject("SwfObject").SwfObject("elementHost1").WpfWindow("WpfWindow").WpfTable("EobItemsGrid")
			benefitAmt = objGrid.Object.Items.Item(rowNum).BeneAmt.ToString()
			
			If benefitAmt = "" or (GetRegexMatchCount(benefitAmt, "0") > 0 and Len(benefitAmt) = 1) or (GetRegexMatchCount(benefitAmt, "0.00") > 0 and Len(benefitAmt) = 4) Then
				ReportMessage "Info", "Benefit Amount is not pre-populated for Benefit Code <b>'" & var_benefitCode & "'</b>, so entering the Benefit Amount <b>'" & _
								var_BenefitAmt & "'</b>", False, "N"
'				objDatTableaGrid.ActivateCell rowNum, "Benefit Amt"
				Sendkey var_BenefitAmt
				SendKey "{TAB}"
				HandleDialog
			Else
				If cDbl(benefitAmt) > 1000.00 Then
					ReportMessage "Info", "Benefit Amount is pre-populated for Benefit Code <b>'" & var_benefitCode & "'</b> as " & benefitAmt & ". Changing it to $50.00", True, "Y"
'					objDatTableaGrid.ActivateCell rowNum, "Benefit Amt"
					Sendkey "50.00"
					SendKey "{TAB}"
					HandleDialog
				End If
			End If
			
			objDatTableaGrid.ActivateCell rowNum, "Action"
			SendKey var_Action
			SendKey "{TAB}"
			HandleDialog
			'Below lines are added by Amit Garg to handle the PEND and DENY Scenarios on 08/14/2018
			Environment.Value("var_Action") = Trim(var_Action)
			If var_Action = "PEND" Then
				Wait 1
				objDatTableaGrid.ClickCell rowNum, "Cd1"
				Sendkey "X7"
				SendKey "{TAB}"
				ReportMessage "Info", "Entered data on the Claim Data screen :- <br><br>Event: <b>'" & var_event & "'</b>, <br>Event Date: <b>'" & eventDate & "'</b>, <br>Loc: <b>'" & _
				var_loc & "'</b>, <br>Occ Date: <b>'" & occDate & "'</b>, <br>BDP: <b>'" & bdp & "'</b>, <br>EDP: <b>'" & edp & "'</b>, <br>Payee: <b>'" & var_payee & _
				"'</b>, <br>I/O: <b>'" & var_inout & "'</b>, <br>Quantity: <b>'" & quantity & "'</b>, <br>ClaimType: <b>'" & var_claimType & "'</b>, <br>DiagCd: <b>'" & _
				CPS_DiagCode & "'</b>, <br>BenefitQuestionAnswer: <b>'" & var_BenefitQuesAns & "'</b>, <br>Action: <b>'" & var_Action _
				& "'</b>,<br>Cd1: <b>'" & "X7-PROOF OF PROSTHESIS" _
				& "'</b>", True, "N"
			ElseIf var_Action = "DENY" Then
				Wait 1
				objDatTableaGrid.ClickCell rowNum, "Cd1"
				Sendkey "71"
				SendKey "{TAB}"
				ReportMessage "Info", "Entered data on the Claim Data screen :- <br><br>Event: <b>'" & var_event & "'</b>, <br>Event Date: <b>'" & eventDate & "'</b>, <br>Loc: <b>'" & _
				var_loc & "'</b>, <br>Occ Date: <b>'" & occDate & "'</b>, <br>BDP: <b>'" & bdp & "'</b>, <br>EDP: <b>'" & edp & "'</b>, <br>Payee: <b>'" & var_payee & _
				"'</b>, <br>I/O: <b>'" & var_inout & "'</b>, <br>Quantity: <b>'" & quantity & "'</b>, <br>ClaimType: <b>'" & var_claimType & "'</b>, <br>DiagCd: <b>'" & _
				CPS_DiagCode & "'</b>, <br>BenefitQuestionAnswer: <b>'" & var_BenefitQuesAns & "'</b>, <br>Action: <b>'" & var_Action _
				& "'</b>,<br>Cd1: <b>'" & "71-POLICY LIMITATIONS AND EXCLUSIONS. YOU WILL RECEIVE A LETTER SOON WITH DETAILED INFORMATION." _
				& "'</b>", True, "N"			
			ElseIf var_Action = "PAY" Then
				
				'Added by Amit Garg on 08/23/2018 to handle the Keying of Cd Details
				If NOT (IsNull(var_Cd1) OR IsEmpty(var_Cd1) OR Trim(var_Cd1) = "") Then
					If fnKeyCdDetails (rowNum, GetDictItem(cpsDataTableDictObj, "PolicyType#" & rowNumber), var_Cd1, var_Cd2, var_Cd3, var_Cd4) = -1 Then
						'Exit Function
					End If								
				End If
				'UPdates from Amit Garg ends.
				
				ReportMessage "Info", "Entered data on the Claim Data screen :- <br><br>Event: <b>'" & var_event & "'</b>, <br>Event Date: <b>'" & eventDate & "'</b>, <br>Loc: <b>'" & _
				var_loc & "'</b>, <br>Occ Date: <b>'" & occDate & "'</b>, <br>BDP: <b>'" & bdp & "'</b>, <br>EDP: <b>'" & edp & "'</b>, <br>Payee: <b>'" & var_payee & _
				"'</b>, <br>I/O: <b>'" & var_inout & "'</b>, <br>Quantity: <b>'" & quantity & "'</b>, <br>ClaimType: <b>'" & var_claimType & "'</b>, <br>DiagCd: <b>'" & _
				CPS_DiagCode & "'</b>, <br>BenefitQuestionAnswer: <b>'" & var_BenefitQuesAns & "'</b>, <br>Action: <b>'" & var_Action _
				& "'</b>", True, "N"
			End If		'Updates from Amit ends.		
			
	If WpfWindow("wpfwin_ClaimData").SwfRadioButton("swfrad_InsuredProvider").Exist(1) Then
		WpfWindow("wpfwin_ClaimData").SwfRadioButton("swfrad_InsuredProvider").Set
		ReportMessage "Info", "Select R-Insured/Provider Radio button on Claim Data screen and click on Audit/Process button", True, "N"
	End If
	
	If GetRegexMatchCount(GetDictItem(cpsDataTableDictObj, "PolicyType#" & rowNumber), "AD-ACCIDENT") > 0 Then
		If WpfWindow("wpfwin_ClaimData").SwfButton("swfbtn_Audit").Exist(1) Then
			WpfWindow("wpfwin_ClaimData").SwfButton("swfbtn_Audit").Click
			ReportMessage "Pass", "Clicking Audit button on Claim Data Screen, Process Button is Enabled", True, "Y"
		End If 
		wait 1
		HandleDialog		
	End If	
	
	If WpfWindow("wpfwin_ClaimData").SwfButton("swfbtn_Process").Exist(1) Then
		ReportMessage "Info", "Clicking Process button to process the claim. ", True, "Y"
		WpfWindow("wpfwin_ClaimData").SwfButton("swfbtn_Process").Click
		Wait 2
		ReportMessage "Info", "Screenshot after clicking Process button to process the claim. ", True, "Y"
	End If	
	
	blnNetErrorFlag = False
	Do
		If SwfWindow("Microsoft .NET Framework").SwfButton("Continue").Exist(2) Then
			SwfWindow("Microsoft .NET Framework").SwfButton("Continue").Click
			blnNetErrorFlag = True
		Else
			Exit Do
		End If
	Loop While True
	
	If blnNetErrorFlag = True Then
		WpfWindow("wpfwin_ClaimData").SwfButton("swfbtn_Process").Click
		HandleDialog
	End If
	
	HandleDialog
	If SwfWindow("swfwin_StateSelection").SwfComboBox("swfcmb_State").Exist(10) Then
		statePayingInt = GetDictItem(cpsDataTableDictObj, "StatePayingInt#" & rowNumber)
		SwfWindow("swfwin_StateSelection").SwfComboBox("swfcmb_State").Select statePayingInt
		ReportMessage "Info", "Selected <b>'" & statePayingInt & "'</b> as state where we are paying the interest and then clicked OK. ", True, "N"
		SwfWindow("swfwin_StateSelection").SwfButton("swfbtn_Ok").Click
	End If
	HandleDialog
	
	If Dialog("CPS - Question!").WinButton("Yes").Exist(1) Then
		HandleDialog
		WpfWindow("wpfwin_ClaimData").SwfButton("swfbtn_Process").Click
	End If
	
	If SwfWindow("CPS_newOverridePopup").SwfButton("OKbtn").Exist(1) Then
		SwfWindow("CPS_newOverridePopup").SwfButton("OKbtn").Click
	End If
	
	If SwfWindow("CPS_newOverridePopup").SwfButton("YES").Exist(1) Then
		SwfWindow("CPS_newOverridePopup").SwfButton("YES").Click
	End If



	On error goto 0
	
	fnPendORDenyProcessing var_letterCode
	
	HandleDialog
	
End Function


Public Function PopulateDataForAccidentVision_old(ByVal rowNumber)
	Dim var_benefitCode, var_loc, var_event, var_payee, var_inout, var_claimType, var_diagCode, var_BenefitQuestion, var_BenefitQuesAns, var_Action, var_BenefitAmt, benefitCodeNum, getPolicyCreationDate, _
				rowNum, var_proc,var_sheetNumber
	rowNum = 0
	var_descr1=GetDictItem(cpsDataTableDictObj, "Descr1#" & rowNumber)
	var_sheetNumber = GetDictItem(cpsDataTableDictObj, "SheetNumber#" & rowNumber)
	var_benefitCode = GetDictItem(cpsDataTableDictObj, "BenefitCode#" & rowNumber)
	var_loc = GetDictItem(cpsDataTableDictObj, "OnOffJob#" & rowNumber)
	var_event = GetDictItem(cpsDataTableDictObj, "Event#" & rowNumber) 
	var_proc = GetDictItem(cpsDataTableDictObj, "Proc#" & rowNumber) 
	var_payee = GetDictItem(cpsDataTableDictObj, "Payee#" & rowNumber)
	var_provider = 	GetDictItem(cpsDataTableDictObj, "Provider#" & rowNumber)
	var_inout = GetDictItem(cpsDataTableDictObj, "I/O#" & rowNumber) 
	var_quantity = GetDictItem(cpsDataTableDictObj, "Quantity#" & rowNumber) 
	var_claimType = GetDictItem(cpsDataTableDictObj, "ClaimType#" & rowNumber) 
	var_diagCode = GetDictItem(cpsDataTableDictObj, "DiagCd#" & rowNumber) 
	var_chgAmt = GetDictItem(cpsDataTableDictObj, "ChgAmt#" & rowNumber) 
	var_BenefitQuestion = GetDictItem(cpsDataTableDictObj, "BenefitCodeQuestion#" & rowNumber) 
	var_BenefitQuesAns = GetDictItem(cpsDataTableDictObj, "BenefitCodeAnswer#" & rowNumber) 
	'Added by AMit on 08/22/2018
	var_Mod1 = GetDictItem(cpsDataTableDictObj, "Mod1#" & rowNumber) 
	var_Mod2 = GetDictItem(cpsDataTableDictObj, "Mod2#" & rowNumber) 
	var_Mod3 = GetDictItem(cpsDataTableDictObj, "Mod3#" & rowNumber) 
	var_Mod4 = GetDictItem(cpsDataTableDictObj, "Mod4#" & rowNumber) 
	var_Cd1 = GetDictItem(cpsDataTableDictObj, "Cd1#" & rowNumber) 
	var_Cd2 = GetDictItem(cpsDataTableDictObj, "Cd2#" & rowNumber) 
	var_Cd3 = GetDictItem(cpsDataTableDictObj, "Cd3#" & rowNumber) 
	var_Cd4 = GetDictItem(cpsDataTableDictObj, "Cd4#" & rowNumber) 
	'Additions by amit ends.
	var_letterCode = GetDictItem(cpsDataTableDictObj, "LetterCode#" & rowNumber) 
	var_Action = GetDictItem(cpsDataTableDictObj, "Action#" & rowNumber) 
	var_BenefitAmt = GetDictItem(cpsDataTableDictObj, "BenefitAmt#" & rowNumber) 
	occDate = GetDateFormatted(DateAdd("d", cint(GetDictItem(cpsDataTableDictObj, "OccDate#" & rowNumber)), policyEffectiveDate), "MMDDYY")
	eventDate = GetDateFormatted(DateAdd("d", cint(GetDictItem(cpsDataTableDictObj, "EventDate#" & rowNumber)), policyEffectiveDate), "MMDDYY")
	bdp = GetDateFormatted(DateAdd("d",  cint(GetDictItem(cpsDataTableDictObj, "BDP#" & rowNumber)), policyEffectiveDate), "MMDDYY")
	edp = GetDateFormatted(DateAdd("d",  cint(GetDictItem(cpsDataTableDictObj, "EDP#" & rowNumber)), policyEffectiveDate), "MMDDYY")
	stDate = GetDateFormatted(DateAdd("d",  cint(GetDictItem(cpsDataTableDictObj, "BDP#" & rowNumber)), policyEffectiveDate), "MM/DD/YY")
	endDate = GetDateFormatted(DateAdd("d",  cint(GetDictItem(cpsDataTableDictObj, "EDP#" & rowNumber)), policyEffectiveDate), "MM/DD/YY")
	quantity = DateDiff("d", stDate, endDate) + 1

'		If WpfWindow("wpfwin_ClaimData").SwfLabel("text:=" & var_benefitCode, "index:=0").Exist(5) Then
''			WpfWindow("swfwnd_PolicyNumber").SwfObject("SwfObject").SwfObject("ScrollingRegion").VScroll micSetPos, 236
''			WpfWindow("swfwnd_PolicyNumber").SwfObject("SwfObject").SwfObject("ScrollingRegion").VScroll micSetPos, 236
'			wait 1
'			On error resume next
'			If WpfWindow("swfwnd_PolicyNumber").SwfObject("SwfObject").SwfObject("ScrollingRegion").Exist(1) Then
'				WpfWindow("swfwnd_PolicyNumber").SwfObject("SwfObject").SwfObject("ScrollingRegion").VScroll micSetPos, 236	
'			End If
'			On error goto 0
'			WpfWindow("wpfwin_ClaimData").SwfLabel("text:=" & var_benefitCode, "index:=0").Object.Focus
'			WpfWindow("wpfwin_ClaimData").SwfLabel("text:=" & var_benefitCode, "index:=0").DblClick 2,2
''			WpfWindow("wpfwin_ClaimData").SwfLabel("text:=" & var_benefitCode, "index:=0").FireEvent "DoubleClick"
''			wait 1
'				HandleDialog

'''''			'Populating the WpfObject with the data
'			err.Clear
'			On error resume next
'			If WpfWindow("wpfwin_ClaimData").SwfObject("swfobj_ElementHost").WpfWindow("wpfwin_ElemHost").WpfObject("wpfobj_EobItemsGrid").GetCellData(rowNum, "Bene")=var_benefitCode Then
'				ReportMessage "Info", "Double clicked on Benefit code <b>'" & var_benefitCode & "'</b> to add that in the grid to start filling the claim. ", True, "Y"
'				PopulateDataForAccidentVision=0
'			End If
'			If err.number<>0 Then
'				ReportMessage "Fail", "Benefit Code is not Selected", True, "Y"
'				PopulateDataForAccidentVision=-1
'				Exit Function
'			End If
'			On error goto 0	
'		Else 
'			ReportMessage "Fail", "Benefit Code: <b>"&var_benefitCode&" </b> not added with the Policy, Please use other policy with the Benefit Code.", True, "Y"
'			PopulateDataForAccidentVision=-1
'			Exit Function
'		End If
		
		If DoubleClickONBenefitCode (var_benefitCode) = 0 Then
			'ReportMessage "Pass", "Benefit Code: <b>"&var_benefitCode&" </b> successfully added with the Policy.", True, "Y"
		Else
			'ReportMessage "Fail", "Benefit Code: <b>"&var_benefitCode&" </b> not added with the Policy. Please check.", True, "Y"
			PopulateDataForAccidentVision=-1
			Exit Function
		End If
				
			'WpfWindow("wpfwin_ClaimData").SwfObject("swfobj_ElementHost").WpfWindow("wpfwin_ElemHost").WpfObject("wpfobj_EobItemsGrid").SetCellData rowNum, "Sheet", var_sheetNumber
			WpfWindow("wpfwin_ClaimData").SwfObject("swfobj_ElementHost").WpfWindow("wpfwin_ElemHost").WpfObject("wpfobj_EobItemsGrid").ActivateCell rowNum, "Sheet"
			Wait 1
			SendKey var_sheetNumber
			If GetRegexMatchCount(GetDictItem(cpsDataTableDictObj, "PolicyType#" & rowNumber), "AD-ACCIDENT") > 0 Then
				WpfWindow("wpfwin_ClaimData").SwfObject("swfobj_ElementHost").WpfWindow("wpfwin_ElemHost").WpfObject("wpfobj_EobItemsGrid").ActivateCell rowNum, "Loc"
				SendKey var_loc
			Else
				WpfWindow("wpfwin_ClaimData").SwfObject("swfobj_ElementHost").WpfWindow("wpfwin_ElemHost").WpfObject("wpfobj_EobItemsGrid").ActivateCell rowNum, "Event"
				SendKey var_event
			End If
				WpfWindow("wpfwin_ClaimData").SwfObject("swfobj_ElementHost").WpfWindow("wpfwin_ElemHost").WpfObject("wpfobj_EobItemsGrid").ActivateCell rowNum, "Event Date"
				SendKey eventDate
				WpfWindow("wpfwin_ClaimData").SwfObject("swfobj_ElementHost").WpfWindow("wpfwin_ElemHost").WpfObject("wpfobj_EobItemsGrid").ActivateCell rowNum, "Occ Date"
				SendKey occDate
				WpfWindow("wpfwin_ClaimData").SwfObject("swfobj_ElementHost").WpfWindow("wpfwin_ElemHost").WpfObject("wpfobj_EobItemsGrid").ActivateCell rowNum, "BDP"
				SendKey bdp
				WpfWindow("wpfwin_ClaimData").SwfObject("swfobj_ElementHost").WpfWindow("wpfwin_ElemHost").WpfObject("wpfobj_EobItemsGrid").ActivateCell rowNum, "EDP"
				SendKey edp			
				
'				
'				SetWpfObjectDate WpfWindow("wpfwin_ClaimData").SwfObject("swfobj_ElementHost").WpfWindow("wpfwin_ElemHost").WpfObject("wpfobj_EobItemsGrid"), rowNum, "Event Date", eventDate
'           	 	SetWpfObjectDate WpfWindow("wpfwin_ClaimData").SwfObject("swfobj_ElementHost").WpfWindow("wpfwin_ElemHost").WpfObject("wpfobj_EobItemsGrid"), rowNum, "Occ Date", occDate
'				SetWpfObjectDate WpfWindow("wpfwin_ClaimData").SwfObject("swfobj_ElementHost").WpfWindow("wpfwin_ElemHost").WpfObject("wpfobj_EobItemsGrid"), rowNum, "BDP", bdp
'				SetWpfObjectDate WpfWindow("wpfwin_ClaimData").SwfObject("swfobj_ElementHost").WpfWindow("wpfwin_ElemHost").WpfObject("wpfobj_EobItemsGrid"), rowNum, "EDP", edp
'			
			If (GetDictItem(cpsDataTableDictObj, "BenefitCode#" & rowNumber)="IHA" and GetDictItem(cpsDataTableDictObj, "Region#" & rowNumber)="COLUMBUS" and GetDictItem(cpsDataTableDictObj, "Environment#" & rowNumber)="INTG") OR GetDictItem(cpsDataTableDictObj, "BenefitCode#" & rowNumber)="APL" and GetDictItem(cpsDataTableDictObj, "Region#" & rowNumber)="COLUMBUS" and GetDictItem(cpsDataTableDictObj, "Environment#" & rowNumber)="SYST"Then
				WpfWindow("wpfwin_ClaimData").SwfObject("swfobj_ElementHost").WpfWindow("wpfwin_ElemHost").WpfObject("wpfobj_EobItemsGrid").ActivateCell rowNum, "Descr1"
				Sendkey  var_descr1
				SendKey "{TAB}"
				Wait 1
				ReportMessage "Info", "Screenshot after entering the column Descr1.", True, "Y"
				HandleDialog
			End If
				SelectTextFromWpfObject WpfWindow("wpfwin_ClaimData").SwfObject("swfobj_ElementHost").WpfWindow("wpfwin_ElemHost").WpfObject("wpfobj_EobItemsGrid"), rowNum, "Proc", var_proc
				WpfWindow("wpfwin_ClaimData").SwfObject("swfobj_ElementHost").WpfWindow("wpfwin_ElemHost").WpfObject("wpfobj_EobItemsGrid").ActivateCell rowNum, "Payee"
				Sendkey var_payee
				'added by Amit to handle the Provide type of Payee
				If UCase(var_payee) = "PROVIDER" Then
					WpfWindow("wpfwin_ClaimData").SwfObject("swfobj_ElementHost").WpfWindow("wpfwin_ElemHost").WpfObject("wpfobj_EobItemsGrid").ActivateCell rowNum, "Provider"
					Sendkey var_provider
					WpfWindow("wpfwin_ClaimData").SwfObject("swfobj_ElementHost").WpfWindow("wpfwin_ElemHost").WpfObject("wpfobj_EobItemsGrid").ActivateCell rowNum, "Patient#"
					Sendkey  CStr(RandomNumber.value(1,999))
				End If
				'updates by Amit ends.
				WpfWindow("wpfwin_ClaimData").SwfObject("swfobj_ElementHost").WpfWindow("wpfwin_ElemHost").WpfObject("wpfobj_EobItemsGrid").ActivateCell rowNum, "I/O"
				SendKey var_inout
				WpfWindow("wpfwin_ClaimData").SwfObject("swfobj_ElementHost").WpfWindow("wpfwin_ElemHost").WpfObject("wpfobj_EobItemsGrid").ActivateCell rowNum, "Quant"
				Sendkey quantity
				WpfWindow("wpfwin_ClaimData").SwfObject("swfobj_ElementHost").WpfWindow("wpfwin_ElemHost").WpfObject("wpfobj_EobItemsGrid").ActivateCell rowNum, "Type Claim"
				Sendkey var_claimType
				WpfWindow("wpfwin_ClaimData").SwfObject("swfobj_ElementHost").WpfWindow("wpfwin_ElemHost").WpfObject("wpfobj_EobItemsGrid").ActivateCell rowNum, "Diag Cd"
				'Auto Generate Diagnosis Code
				CPS_DiagCode=fn_Generate_Diagnosis_Code(rowNumber)
				Sendkey CPS_DiagCode
				SendKey "{TAB}"
				If Len (CPS_DiagCode)>7 Then
					ReportMessage "Info", "Entered data on the Claim Data screen :- <br><br>Event: <b>'" & var_event & "'</b>, <br>Event Date: <b>'" & eventDate & "'</b>, <br>Loc: <b>'" & _
					var_loc & "'</b>, <br>Occ Date: <b>'" & occDate & "'</b>, <br>BDP: <b>'" & bdp & "'</b>, <br>EDP: <b>'" & edp & "'</b>, <br>Payee: <b>'" & var_payee & _
					"'</b>, <br>I/O: <b>'" & var_inout & "'</b>, <br>Quantity: <b>'" & quantity & "'</b>, <br>ClaimType: <b>'" & var_claimType & "'</b>, <br>DiagCd: <b>'" & _
					CPS_DiagCode& "'</b>", True, "N"
					ReportMessage "Pass", "Error message on Pop-up Window: Diagnosis Code Must not contain more than 7 characters, not including the decimal point", True, "Y"
					 HandleDialog
					wait 1
					PopulateDataForAccidentVision=1
					Exit Function 
				Else 
					fn_Verify_Diagnosis_Code CPS_DiagCode
				End If
				
				'Added by Amit on 08/22/2018 to input the Mods
				fnKeyModDetails rowNum, GetDictItem(cpsDataTableDictObj, "PolicyType#" & rowNumber), var_Mod1, var_Mod2, var_Mod3, var_Mod4				
				
				WpfWindow("wpfwin_ClaimData").SwfObject("swfobj_ElementHost").WpfWindow("wpfwin_ElemHost").WpfObject("wpfobj_EobItemsGrid").ActivateCell rowNum, "Chg Amt"
				Sendkey var_chgAmt
				SendKey "{TAB}"
				HandleDialog
				benefitAmt = WpfWindow("wpfwin_ClaimData").SwfObject("swfobj_ElementHost").WpfWindow("wpfwin_ElemHost").WpfObject("wpfobj_EobItemsGrid").GetCellData(rowNum, "Benefit Amt")
			If benefitAmt = "" or (GetRegexMatchCount(benefitAmt, "0") > 0 and Len(benefitAmt) = 1) or (GetRegexMatchCount(benefitAmt, "0.00") > 0 and Len(benefitAmt) = 4) Then
				ReportMessage "Info", "Benefit Amount is not pre-populated for Benefit Code <b>'" & var_benefitCode & "'</b>, so entering the Benefit Amount <b>'" & _
								var_BenefitAmt & "'</b>", False, "N"
				WpfWindow("wpfwin_ClaimData").SwfObject("swfobj_ElementHost").WpfWindow("wpfwin_ElemHost").WpfObject("wpfobj_EobItemsGrid").ActivateCell rowNum, "Benefit Amt"
				Sendkey var_BenefitAmt
				SendKey "{TAB}"
				HandleDialog
			Else
				If cDbl(benefitAmt) > 1000.00 Then
					ReportMessage "Info", "Benefit Amount is pre-populated for Benefit Code <b>'" & var_benefitCode & "'</b> as " & benefitAmt & ". Changing it to $50.00", True, "Y"
					WpfWindow("wpfwin_ClaimData").SwfObject("swfobj_ElementHost").WpfWindow("wpfwin_ElemHost").WpfObject("wpfobj_EobItemsGrid").ActivateCell rowNum, "Benefit Amt"
					Sendkey "50.00"
					SendKey "{TAB}"
					HandleDialog
				End If
			End If
			
			WpfWindow("wpfwin_ClaimData").SwfObject("swfobj_ElementHost").WpfWindow("wpfwin_ElemHost").WpfObject("wpfobj_EobItemsGrid").ActivateCell rowNum, "Action"
			SendKey var_Action
			SendKey "{TAB}"
			HandleDialog
			'Below lines are added by Amit Garg to handle the PEND and DENY Scenarios on 08/14/2018
			Environment.Value("var_Action") = Trim(var_Action)
			If var_Action = "PEND" Then
				Wait 1
				WpfWindow("wpfwin_ClaimData").SwfObject("swfobj_ElementHost").WpfWindow("wpfwin_ElemHost").WpfObject("wpfobj_EobItemsGrid").ActivateCell rowNum, "Cd1"
				Sendkey "X7"
				SendKey "{TAB}"
				ReportMessage "Info", "Entered data on the Claim Data screen :- <br><br>Event: <b>'" & var_event & "'</b>, <br>Event Date: <b>'" & eventDate & "'</b>, <br>Loc: <b>'" & _
				var_loc & "'</b>, <br>Occ Date: <b>'" & occDate & "'</b>, <br>BDP: <b>'" & bdp & "'</b>, <br>EDP: <b>'" & edp & "'</b>, <br>Payee: <b>'" & var_payee & _
				"'</b>, <br>I/O: <b>'" & var_inout & "'</b>, <br>Quantity: <b>'" & quantity & "'</b>, <br>ClaimType: <b>'" & var_claimType & "'</b>, <br>DiagCd: <b>'" & _
				CPS_DiagCode & "'</b>, <br>BenefitQuestionAnswer: <b>'" & var_BenefitQuesAns & "'</b>, <br>Action: <b>'" & var_Action _
				& "'</b>,<br>Cd1: <b>'" & "X7-PROOF OF PROSTHESIS" _
				& "'</b>", True, "N"
			ElseIf var_Action = "DENY" Then
				Wait 1
				WpfWindow("wpfwin_ClaimData").SwfObject("swfobj_ElementHost").WpfWindow("wpfwin_ElemHost").WpfObject("wpfobj_EobItemsGrid").ActivateCell rowNum, "Cd1"
				Sendkey "71"
				SendKey "{TAB}"
				ReportMessage "Info", "Entered data on the Claim Data screen :- <br><br>Event: <b>'" & var_event & "'</b>, <br>Event Date: <b>'" & eventDate & "'</b>, <br>Loc: <b>'" & _
				var_loc & "'</b>, <br>Occ Date: <b>'" & occDate & "'</b>, <br>BDP: <b>'" & bdp & "'</b>, <br>EDP: <b>'" & edp & "'</b>, <br>Payee: <b>'" & var_payee & _
				"'</b>, <br>I/O: <b>'" & var_inout & "'</b>, <br>Quantity: <b>'" & quantity & "'</b>, <br>ClaimType: <b>'" & var_claimType & "'</b>, <br>DiagCd: <b>'" & _
				CPS_DiagCode & "'</b>, <br>BenefitQuestionAnswer: <b>'" & var_BenefitQuesAns & "'</b>, <br>Action: <b>'" & var_Action _
				& "'</b>,<br>Cd1: <b>'" & "71-POLICY LIMITATIONS AND EXCLUSIONS. YOU WILL RECEIVE A LETTER SOON WITH DETAILED INFORMATION." _
				& "'</b>", True, "N"			
			ElseIf var_Action = "PAY" Then
				
				'Added by Amit Garg on 08/23/2018 to handle the Keying of Cd Details
				If NOT (IsNull(var_Cd1) OR IsEmpty(var_Cd1) OR Trim(var_Cd1) = "") Then
					If fnKeyCdDetails (rowNum, GetDictItem(cpsDataTableDictObj, "PolicyType#" & rowNumber), var_Cd1, var_Cd2, var_Cd3, var_Cd4) = -1 Then
						'Exit Function
					End If								
				End If
				'UPdates from Amit Garg ends.
				
				ReportMessage "Info", "Entered data on the Claim Data screen :- <br><br>Event: <b>'" & var_event & "'</b>, <br>Event Date: <b>'" & eventDate & "'</b>, <br>Loc: <b>'" & _
				var_loc & "'</b>, <br>Occ Date: <b>'" & occDate & "'</b>, <br>BDP: <b>'" & bdp & "'</b>, <br>EDP: <b>'" & edp & "'</b>, <br>Payee: <b>'" & var_payee & _
				"'</b>, <br>I/O: <b>'" & var_inout & "'</b>, <br>Quantity: <b>'" & quantity & "'</b>, <br>ClaimType: <b>'" & var_claimType & "'</b>, <br>DiagCd: <b>'" & _
				CPS_DiagCode & "'</b>, <br>BenefitQuestionAnswer: <b>'" & var_BenefitQuesAns & "'</b>, <br>Action: <b>'" & var_Action _
				& "'</b>", True, "N"
			End If		'Updates from Amit ends.		
			
	If WpfWindow("wpfwin_ClaimData").SwfRadioButton("swfrad_InsuredProvider").Exist(1) Then
		WpfWindow("wpfwin_ClaimData").SwfRadioButton("swfrad_InsuredProvider").Set
		ReportMessage "Info", "Select R-Insured/Provider Radio button on Claim Data screen and click on Audit/Process button", True, "N"
	End If
	If GetRegexMatchCount(GetDictItem(cpsDataTableDictObj, "PolicyType#" & rowNumber), "AD-ACCIDENT") > 0 Then
		If WpfWindow("wpfwin_ClaimData").SwfButton("swfbtn_Audit").Exist(1) Then
			WpfWindow("wpfwin_ClaimData").SwfButton("swfbtn_Audit").Click
			ReportMessage "Pass", "Clicking Audit button on Claim Data Screen, Process Button is Enabled", True, "Y"
		End If 
		wait 1
		HandleDialog		
	End If	
	If WpfWindow("wpfwin_ClaimData").SwfButton("swfbtn_Process").Exist(1) Then
		ReportMessage "Info", "Clicking Process button to process the claim. ", True, "Y"
		WpfWindow("wpfwin_ClaimData").SwfButton("swfbtn_Process").Click
		Wait 2
		ReportMessage "Info", "Screenshot after clicking Process button to process the claim. ", True, "Y"
	End If	
	
	blnNetErrorFlag = False
	Do
		If SwfWindow("Microsoft .NET Framework").SwfButton("Continue").Exist(2) Then
			SwfWindow("Microsoft .NET Framework").SwfButton("Continue").Click
			blnNetErrorFlag = True
		Else
			Exit Do
		End If
	Loop While True
	
	If blnNetErrorFlag = True Then
		WpfWindow("wpfwin_ClaimData").SwfButton("swfbtn_Process").Click
		HandleDialog
	End If
	HandleDialog
	If SwfWindow("swfwin_StateSelection").SwfComboBox("swfcmb_State").Exist(2) Then
		statePayingInt = GetDictItem(cpsDataTableDictObj, "StatePayingInt#" & rowNumber)
		SwfWindow("swfwin_StateSelection").SwfComboBox("swfcmb_State").Select statePayingInt
		ReportMessage "Info", "Selected <b>'" & statePayingInt & "'</b> as state where we are paying the interest and then clicked OK. ", True, "N"
		SwfWindow("swfwin_StateSelection").SwfButton("swfbtn_Ok").Click
	End If
	HandleDialog
	
	If Dialog("CPS - Question!").WinButton("Yes").Exist(1) Then
		HandleDialog
		WpfWindow("wpfwin_ClaimData").SwfButton("swfbtn_Process").Click
	End If
	On error goto 0
	
	fnPendORDenyProcessing var_letterCode
	
	HandleDialog
	
End Function
'########################################################################################################################################
'Function Name				: 	PopulateDataForOtherLOBs
'Purpose					:	Function is working in CPS scripts,This function is for LOB other than accident and vision
'Pre-Condition				:	Cliam Number should be generated Successfully
'Post-Condition				:	None
'-----------------------------------------------------------------------------------------------------------------------------------------
'Input Parameters			:  	Claim Number
'Output Parameters			:	None
'Return Type				: 	None
'Author						:	Vinay Yadav
'Date Written				:	21-June-2016
'Date Modified				:
'Modification details		:
'##########################################################################################################################################
Public Function PopulateDataForOtherLOBs(ByVal rowNumber)
	Dim var_benefitCode, var_event, var_payee, var_inout, var_claimType, var_diagCode, var_BenefitAmt, var_Action, benefitCodeNum, eventDate, occDate, bdp, edp, questionText, _
					getPolicyCreationDate, rowNum, cd1Val, var_sheetNumber
	rowNum = 1
	var_sheetNumber = GetDictItem(cpsDataTableDictObj, "SheetNumber#" & rowNumber)
	var_benefitCode = GetDictItem(cpsDataTableDictObj, "BenefitCode#" & rowNumber)
	var_event = GetDictItem(cpsDataTableDictObj, "Event#" & rowNumber)
	var_payee = GetDictItem(cpsDataTableDictObj, "Payee#" & rowNumber)
	var_provider = 	GetDictItem(cpsDataTableDictObj, "Provider#" & rowNumber)
	var_inout = GetDictItem(cpsDataTableDictObj, "I/O#" & rowNumber)
	var_claimType = GetDictItem(cpsDataTableDictObj, "ClaimType#" & rowNumber)
	var_diagCode = GetDictItem(cpsDataTableDictObj, "DiagCd#" & rowNumber)
	var_BenefitQuestion = GetDictItem(cpsDataTableDictObj, "BenefitCodeQuestion#" & rowNumber)
	var_BenefitQuesAns = GetDictItem(cpsDataTableDictObj, "BenefitCodeAnswer#" & rowNumber)
	var_Action = GetDictItem(cpsDataTableDictObj, "Action#" & rowNumber)
	var_BenefitAmt = GetDictItem(cpsDataTableDictObj, "BenefitAmt#" & rowNumber)
	eventDateArr = GetDictItem(cpsDataTableDictObj, "EventDate#" & rowNumber)
	occDateArr = GetDictItem(cpsDataTableDictObj, "OccDate#" & rowNumber)
	bdpArr = GetDictItem(cpsDataTableDictObj, "BDP#" & rowNumber)
	edpArr = GetDictItem(cpsDataTableDictObj, "EDP#" & rowNumber)
	var_Mod1=GetDictItem(cpsDataTableDictObj, "Mod1#" & rowNumber)
	'Added by CHandrakant on 25/11/2019
	var_Path=GetDictItem(cpsDataTableDictObj, "Path#" & rowNumber)
	'Added by AMit on 08/22/2018
	var_Mod1 = GetDictItem(cpsDataTableDictObj, "Mod1#" & rowNumber) 
	var_Mod2 = GetDictItem(cpsDataTableDictObj, "Mod2#" & rowNumber) 
	var_Mod3 = GetDictItem(cpsDataTableDictObj, "Mod3#" & rowNumber) 
	var_Mod4 = GetDictItem(cpsDataTableDictObj, "Mod4#" & rowNumber) 
	var_Cd1 = GetDictItem(cpsDataTableDictObj, "Cd1#" & rowNumber) 
	var_Cd2 = GetDictItem(cpsDataTableDictObj, "Cd2#" & rowNumber) 
	var_Cd3 = GetDictItem(cpsDataTableDictObj, "Cd3#" & rowNumber) 
	var_Cd4 = GetDictItem(cpsDataTableDictObj, "Cd4#" & rowNumber) 
	strPolicyType = GetDictItem(cpsDataTableDictObj, "PolicyType#" & rowNumber) 
	'Additions by amit ends.
	'Added by Amit on 08/16/2018 to handle the PEND and DENY cases
	var_letterCode = GetDictItem(cpsDataTableDictObj, "LetterCode#" & rowNumber) 
	'Updates from Amit Garg ended.
	
	'Below lines are Added by Amit Garg to add the Claimant Information.
	Dim strClaimant : strClaimant = GetDictItem(cpsDataTableDictObj, "Claimant#" & rowNumber)				
	Dim strClaimantName : strClaimantName = GetDictItem(cpsDataTableDictObj, "ClaimantName#" & rowNumber)				
	Dim strClaimantDOB : strClaimantDOB = GetDictItem(cpsDataTableDictObj, "ClaimantDOB#" & rowNumber)				
	Dim strClaimantSex : strClaimantSex = GetDictItem(cpsDataTableDictObj, "ClaimantSex#" & rowNumber)	
	Dim strDateOfDeath : strDateOfDeath = GetDictItem(cpsDataTableDictObj, "DateOfDeath#" & rowNumber)				
	
	'Below lines are Added by Amit Garg to move the Claimant Information from sheet CPS to CPSDATA
	If Instr(strPolicyType, "LIFE") > 0 Then
		SelectClaimant strClaimant,rowNumber
'		If SelectClaimantNew (strClaimant, strClaimantName, strClaimantDOB, strClaimantSex, strDateOfDeath) = -1 Then
'			SubsequentClaim=-1
'			Exit Function
'		End If
	Else
		
	End If
	'Addition from Amit ends.
	
	'Addition ended from Amit Garg
	
	
	If DoubleClickONBenefitCode (var_benefitCode) = 0 Then
		'ReportMessage "Pass", "Benefit Code: <b>"&var_benefitCode&" </b> successfully added with the Policy.", True, "Y"
	Else
		'ReportMessage "Fail", "Benefit Code: <b>"&var_benefitCode&" </b> not added with the Policy. Please check.", True, "Y"
		PopulateDataForOtherLOBs=-1
		Exit Function
	End If
'	
'	'Updated by Amit
'	Set objDescBenCode = Description.Create
'	objDescBenCode("micclass").value = "SwfLabel"
'	objDescBenCode("text").value = var_benefitCode
'	
'	'Set objBenCodeParent = WpfWindow("swfwnd_PolicyNumber").SwfObject("SwfObject").SwfObject("elementHost1").WpfWindow("WpfWindow").SwfObject("SwfObject")
'	Set objBenCodeParent = WpfWindow("swfwnd_PolicyNumber").SwfObject("SwfObject").SwfObject("elementHost1").WpfWindow("WpfWindow")
'	
'	If objBenCodeParent.Exist(10) Then
'		Set objBenCodeChilds = objBenCodeParent.ChildObjects(objDescBenCode)
'	
'		'If WpfWindow("wpfwin_ClaimData").SwfLabel("text:=" & var_benefitCode, "index:=0").Exist(5) Then
'		If objBenCodeChilds.Count() > 0 Then
'			objBenCodeChilds(objBenCodeChilds.Count() - 1).DblClick 12,8
'			'objBenCodeChilds(objBenCodeChilds.Count() - 1).FireEvent "DoubleClick"
'			Wait 5
'		End If		
'			
''			On error resume next
''			If WpfWindow("swfwnd_PolicyNumber").SwfObject("SwfObject").SwfObject("ScrollingRegion").Exist(1) Then
''				WpfWindow("swfwnd_PolicyNumber").SwfObject("SwfObject").SwfObject("ScrollingRegion").VScroll micSetPos, 236	
''			End If
''			On error goto 0
''			WpfWindow("wpfwin_ClaimData").SwfLabel("text:=" & var_benefitCode, "index:=0").Object.Focus
'			
'			
'			'WpfWindow("wpfwin_ClaimData").SwfLabel("text:=" & var_benefitCode, "index:=0").DblClick 2,2
'			
'			
'			'Updates ended by Amit
'			
''			WpfWindow("wpfwin_ClaimData").SwfLabel("text:=" & var_benefitCode, "index:=0").FireEvent "DoubleClick"
'			HandleDialog			
'			wait 1
'			err.clear
'			On error resume next
'			If WpfWindow("wpfwin_ClaimData").SwfTable("swftbl_DetailLines").GetCellData(rowNum, "Bene")=var_benefitCode Then
'				ReportMessage "Info", "Double clicked on Benefit code <b>'" & var_benefitCode & "'</b> to add that in the grid to start filling the claim. ", True, "Y"
'				PopulateDataForOtherLOBs=0
'			End If
'			If err.number<>0 then
'				PopulateDataForOtherLOBs=-1
'				ReportMessage "Info", "Benefit Code is not selected", True, "Y"
'				Exit Function
'			End If
			
			
			
			getPolicyCreationDate = WpfWindow("wpfwin_ClaimData").SwfTable("swftbl_DetailLines").GetCellData(rowNum, "POL Date")
			If getPolicyCreationDate <> "" Then
				edp = GetDateFormatted(DateAdd("d", cint(edpArr), getPolicyCreationDate), "MM/DD/YY")
				occDate = GetDateFormatted(DateAdd("d", cint(occDateArr), getPolicyCreationDate), "MM/DD/YY")
				eventDate = GetDateFormatted(DateAdd("d", cint(eventDateArr), getPolicyCreationDate), "MM/DD/YY")
				bdp = GetDateFormatted(DateAdd("d", cint(bdpArr), getPolicyCreationDate), "MM/DD/YY")
			Else
				edp = GetDateFormatted(DateAdd("d", cint(edpArr), Date()), "MM/DD/YY")
				occDate = GetDateFormatted(DateAdd("M", cint(occDateArr), edp), "MM/DD/YY")
				eventDate = GetDateFormatted(DateAdd("d", cint(eventDateArr), edp), "MM/DD/YY")
				bdp = GetDateFormatted(DateAdd("d", cint(bdpArr), edp), "MM/DD/YY")
			End If
			quantity = DateDiff("d", bdp, edp) + 1
			'Populating the SWFTable with the data
			WpfWindow("wpfwin_ClaimData").SwfTable("swftbl_DetailLines").SetCellData rowNum, "Sheet", var_sheetNumber
			WpfWindow("wpfwin_ClaimData").SwfTable("swftbl_DetailLines").SetCellData rowNum, "Event", var_event
			WpfWindow("wpfwin_ClaimData").SwfTable("swftbl_DetailLines").SetCellData rowNum, "POL Date", polDate
			WpfWindow("wpfwin_ClaimData").SwfTable("swftbl_DetailLines").SetCellData rowNum, "Event Date", eventDate
			WpfWindow("wpfwin_ClaimData").SwfTable("swftbl_DetailLines").SetCellData rowNum, "Occ Date", occDate
			WpfWindow("wpfwin_ClaimData").SwfTable("swftbl_DetailLines").SetCellData rowNum, "BDP", bdp
			WpfWindow("wpfwin_ClaimData").SwfTable("swftbl_DetailLines").SetCellData rowNum, "EDP", edp
			WpfWindow("wpfwin_ClaimData").SwfTable("swftbl_DetailLines").SetCellData rowNum, "Payee", var_payee
			
			'Added by chandrakant to select Path
			fnSelectModInColumnBasedOnPartialText rowNum, "Path", var_Path
			
			'added by Amit to handle the Provide type of Payee
			If UCase(var_payee) = "PROVIDER" Then
				WpfWindow("wpfwin_ClaimData").SwfTable("swftbl_DetailLines").SetCellData rowNum, "Provider", var_provider
				WpfWindow("wpfwin_ClaimData").SwfTable("swftbl_DetailLines").SetCellData rowNum, "Patient#", CStr(RandomNumber.value(1,999))  
			End If
			'updates by Amit ends.
			WpfWindow("wpfwin_ClaimData").SwfTable("swftbl_DetailLines").SetCellData rowNum, "I/O", var_inout
			WpfWindow("wpfwin_ClaimData").SwfTable("swftbl_DetailLines").SetCellData rowNum, "Quantity", quantity
			WpfWindow("wpfwin_ClaimData").SwfTable("swftbl_DetailLines").SetCellData rowNum, "Type Claim", var_claimType
			CPS_DiagCode=fn_Generate_Diagnosis_Code(rowNumber)
			WpfWindow("wpfwin_ClaimData").SwfTable("swftbl_DetailLines").SetCellData rowNum, "Diag Cd", CPS_DiagCode
			
			'Added by Amit on 08/22/2018 to input the Mods
			fnKeyModDetails rowNum, GetDictItem(cpsDataTableDictObj, "PolicyType#" & rowNumber), var_Mod1, var_Mod2, var_Mod3, var_Mod4		
			'Updates by Amit ends.
			
			WpfWindow("wpfwin_ClaimData").SwfTable("swftbl_DetailLines").SelectCell 1, "Chg Amt"	
			SendKey "{TAB}"
			Wait 1, 500
			SendKey "{TAB}"
			HandleDialog
			'WpfWindow("wpfwin_ClaimData").SwfTable("swftbl_DetailLines").SetCellData rowNum, "Benefit Amt", var_BenefitAmt
			'WpfWindow("wpfwin_ClaimData").SwfTable("swftbl_DetailLines").SelectCell rowNum, "Benefit Amt"	
			
			If var_benefitCode="MCP" OR  var_benefitCode="CEP" Then
				WpfWindow("wpfwin_ClaimData").SwfTable("swftbl_DetailLines").SetCellData rowNum, "Mod1", var_Mod1
			End If			
			
			If SwfWindow("swfwin_BenefitAmt").SwfButton("swfbtn_Submit").Exist(5) Then
				questionText = Replace(SwfWindow("swfwin_BenefitAmt").SwfEditor("swfedt_Question").GetVisibleText(), vbnewline, "")
				If GetRegexMatchCount(questionText, var_BenefitQuestion) > 0 Then
					ReportMessage "Pass", "Benefit Question " & questionText & " displayed correct on the window. ", True, "Y"
				Else
					ReportMessage "Fail", "Benefit Question expected is " & var_BenefitQuestion & " but displayed is " & questionText, True, "Y"
				End If
				SwfWindow("swfwin_BenefitAmt").SwfComboBox("swfcmb_CBOQuestion").Select var_BenefitQuesAns
				SwfWindow("swfwin_BenefitAmt").SwfButton("swfbtn_Submit").Click
				HandleDotNetDialog "Info", ""
				If Dialog("CPS - Stop!").WinButton("OK").Exist(2) Then
					ReportMessage "Fail", "Please select another Policy.", True, "Y"
					HandleDotNetDialog "CPS - Stop", ""
					PopulateDataForOtherLOBs=-1
					Exit Function 
				End If
				wait 1
			ElseIf SwfWindow("swfwin_BenefitAmt").Exist(2) Then
				If GetRegexMatchCount(var_BenefitQuesAns, "air") > 0 Then
					ReportMessage "Pass", "Clicking on Air button on the screen to show the mode of transportation. ", True, "Y"
					SwfWindow("swfwin_BenefitAmt").SwfButton("swfbtn_Air").Click
				Else
					ReportMessage "Pass", "Clicking on Ground button on the screen to show the mode of transportation. ", True, "Y"
					SwfWindow("swfwin_BenefitAmt").SwfButton("swfbtn_Ground").Click
				End If
				'HandleDotNetDialog "Info", ""
				HandleDialog
			End If
			benefitAmt = WpfWindow("wpfwin_ClaimData").SwfTable("swftbl_DetailLines").GetCellData(rowNum, "Benefit Amt")
			If benefitAmt = "" or (GetRegexMatchCount(benefitAmt, "0") > 0 and Len(benefitAmt) = 1) or (GetRegexMatchCount(benefitAmt, "0.00") > 0 and Len(benefitAmt) = 4) Then
				ReportMessage "Info", "Benefit Amount is not pre-populated for Benefit Code <b>'" & var_benefitCode & "'</b>, so entering the Benefit Amount <b>'" & _
								var_BenefitAmt & "'</b>", True, "N"
				WpfWindow("wpfwin_ClaimData").SwfTable("swftbl_DetailLines").SetCellData rowNum, "Benefit Amt", var_BenefitAmt
			End If
			
			'below lines are commeneted by Amit 
'			WpfWindow("wpfwin_ClaimData").SwfTable("swftbl_DetailLines").ActivateCell rowNum, "Action"
'			WpfWindow("wpfwin_ClaimData").SwfTable("swftbl_DetailLines").SetCellData rowNum, "Action", var_Action
			
			'Below lines are added as a replacement of above commented lines. 
'			fnSelectModInColumnBasedOnPartialText rowNum, "Action", var_Action
			WpfWindow("wpfwin_ClaimData").SwfTable("swftbl_DetailLines").SetCellData rowNum, "Action", var_Action
			Wait 3		
			
			'Below lines are added by Amit Garg to handle the PEND and DENY Scenarios on 08/14/2018
			Environment.Value("var_Action") = Trim(var_Action)
			If var_Action = "PEND" Then
				Wait 1
				WpfWindow("wpfwin_ClaimData").SwfTable("swftbl_DetailLines").ActivateCell rowNum, "Cd1"
				WpfWindow("wpfwin_ClaimData").SwfTable("swftbl_DetailLines").SetCellData 1, "Cd1", "ZB-DETAILS OF STROKE                                                          ZB"
				
				ReportMessage "Info", "Entered data on the Claim Data screen - <br><br>Event: <b>'" & var_event & "'</b>, <br>Event Date: <b>'" & eventDate & _
					"'</b>, <br>Occ Date: <b>'" & occDate & "'</b>, <br>BDP: <b>'" & bdp & "'</b>, <br>EDP: <b>'" & edp & "'</b>, <br>Payee: <b>'" & var_payee & _
					"'</b>, <br>I/O: <b>'" & var_inout & "'</b>, <br>Quantity: <b>'" & quantity & "'</b>, <br>ClaimType: <b>'" & var_claimType _
					& "'</b>, <br>DiagCd: <b>'" & CPS_DiagCode & "'</b>, <br>BenefitQuestionAnswer: <b>'" & var_BenefitQuesAns & _
					"'</b>, <br>Action: <b>'" & var_Action & "'</b>,<br>Cd1: <b>'" & "ZB-DETAILS OF STROKE                                                          ZB" _
					, True, "N"

			ElseIf var_Action = "DENY" Then
				Wait 1
				WpfWindow("wpfwin_ClaimData").SwfTable("swftbl_DetailLines").ActivateCell rowNum, "Cd1"
				WpfWindow("wpfwin_ClaimData").SwfTable("swftbl_DetailLines").SetCellData 1, "Cd1", "71-POLICY LIMITATIONS AND EXCLUSIONS. YOU WILL RECEIVE A LETTER SOON WITH     DETAILED INFORMATION."

				ReportMessage "Info", "Entered data on the Claim Data screen - <br><br>Event: <b>'" & var_event & "'</b>, <br>Event Date: <b>'" & eventDate & _
					"'</b>, <br>Occ Date: <b>'" & occDate & "'</b>, <br>BDP: <b>'" & bdp & "'</b>, <br>EDP: <b>'" & edp & "'</b>, <br>Payee: <b>'" & var_payee & _
					"'</b>, <br>I/O: <b>'" & var_inout & "'</b>, <br>Quantity: <b>'" & quantity & "'</b>, <br>ClaimType: <b>'" & var_claimType _
					& "'</b>, <br>DiagCd: <b>'" & CPS_DiagCode & "'</b>, <br>BenefitQuestionAnswer: <b>'" & var_BenefitQuesAns & _
					"'</b>, <br>Action: <b>'" & var_Action & "'</b>,<br>Cd1: <b>'" & "71-POLICY LIMITATIONS AND EXCLUSIONS. YOU WILL RECEIVE A LETTER SOON WITH     DETAILED INFORMATION." _
					, True, "N"		
			Else
			
				'Added by Amit Garg on 08/23/2018 to handle the Keying of Cd Details
				If NOT (IsNull(var_Cd1) OR IsEmpty(var_Cd1) OR Trim(var_Cd1) = "") Then
					If fnKeyCdDetails (rowNum, GetDictItem(cpsDataTableDictObj, "PolicyType#" & rowNumber), var_Cd1, var_Cd2, var_Cd3, var_Cd4) = -1 Then
						'Exit Function
					End If								
				End If
				'UPdates from Amit Garg ends.
				
				ReportMessage "Info", "Entered data on the Claim Data screen :- <br><br>Event: <b>'" & var_event & "'</b>, <br>Event Date: <b>'" & eventDate & "'</b>, <br>Loc: <b>'" & _
				var_loc & "'</b>, <br>Occ Date: <b>'" & occDate & "'</b>, <br>BDP: <b>'" & bdp & "'</b>, <br>EDP: <b>'" & edp & "'</b>, <br>Payee: <b>'" & var_payee & _
				"'</b>, <br>I/O: <b>'" & var_inout & "'</b>, <br>Quantity: <b>'" & quantity & "'</b>, <br>ClaimType: <b>'" & var_claimType & "'</b>, <br>DiagCd: <b>'" & _
				CPS_DiagCode & "'</b>, <br>BenefitQuestionAnswer: <b>'" & var_BenefitQuesAns & "'</b>, <br>Action: <b>'" & var_Action _
				& "'</b>", True, "N"
			End If		'Updates from Amit ends.		
			
'			
'			ReportMessage "Info", "Entered data on the Claim Data screen - <br><br>Event: <b>'" & var_event & "'</b>, <br>Event Date: <b>'" & eventDate & _
'								"'</b>, <br>Occ Date: <b>'" & occDate & "'</b>, <br>BDP: <b>'" & bdp & "'</b>, <br>EDP: <b>'" & edp & "'</b>, <br>Payee: <b>'" & var_payee & _
'								"'</b>, <br>I/O: <b>'" & var_inout & "'</b>, <br>Quantity: <b>'" & quantity & "'</b>, <br>ClaimType: <b>'" & var_claimType _
'								& "'</b>, <br>DiagCd: <b>'" & CPS_DiagCode & "'</b>, <br>BenefitQuestionAnswer: <b>'" & var_BenefitQuesAns & _
'								"'</b>, <br>Action: <b>'" & var_Action & "'</b>", True, "N"
								
								
'		Else 
'			ReportMessage "Fail", "Benefit Code: <b>"&var_benefitCode&" </b> not added with the Policy, Please use policy with the Benefit Code.", True, "Y"
'			SetIterStatusFailure()
'			Exit Function
'		End If
	
	If WpfWindow("wpfwin_ClaimData").SwfRadioButton("swfrad_InsuredProvider").Exist(1) Then
		WpfWindow("wpfwin_ClaimData").SwfRadioButton("swfrad_InsuredProvider").Set
		ReportMessage "Info", "Select R-Insured/Provider Radio button on Claim Data screen and click on Audit/Process button", True, "N"
	End If
	ReportMessage "Info", "Clicking Process button to process the claim. ", True, "Y"
	WpfWindow("wpfwin_ClaimData").SwfButton("swfbtn_Process").Click
	
	ReportMessage "Info", "Screenshot after clicking Process button to process the claim. ", True, "Y"
	
	'Below code is added by Amit Garg to handle the Email Window. 
	If SwfWindow("EmailClaim").SwfButton("CloseWindow").Exist(3) Then
		ReportMessage "Info", "Email Claim Window appeared. Clicking on Close Window screen. ", True, "Y"
		SwfWindow("EmailClaim").SwfButton("CloseWindow").Click
		HandleDialog
	End If	
	'Addition from Amit ends.
	
	blnNetErrorFlag = False
	Do
		If SwfWindow("Microsoft .NET Framework").SwfButton("Continue").Exist(2) Then
			SwfWindow("Microsoft .NET Framework").SwfButton("Continue").Click
			blnNetErrorFlag = True
		Else
			Exit Do
		End If
	Loop While True
	
	If blnNetErrorFlag = True Then
		WpfWindow("wpfwin_ClaimData").SwfButton("swfbtn_Process").Click
		HandleDialog
	End If
	HandleDialog	


	If SwfWindow("swfwin_StateSelection").SwfComboBox("swfcmb_State").Exist(2) Then
		statePayingInt = GetDictItem(cpsDataTableDictObj, "StatePayingInt#" & rowNumber)
		SwfWindow("swfwin_StateSelection").SwfComboBox("swfcmb_State").Select statePayingInt
		ReportMessage "Info", "Selected <b>'" & statePayingInt & "'</b> as state where we are paying the interest and then clicked OK. ", True, "N"
		SwfWindow("swfwin_StateSelection").SwfButton("swfbtn_Ok").Click
	End If
	
	If SwfWindow("CPS_newReviewAllPagesPopup").SwfLabel("reviewTxt").Exist(5) Then
		ReportMessage "Info", "Clicking YES for review all pages", True, "Y"
		SwfWindow("CPS_newReviewAllPagesPopup").SwfButton("YESbtn").Click
	End If
	
	If SwfWindow("CPS_newOverridePopup").SwfButton("OKbtn").Exist(5) Then
		ReportMessage "Info", "Clicking OK for Override popup", True, "Y"
'		wfWindow("CPS_newOverridePopup").SwfButton("OKbtn").Click
		SwfWindow("CPS_newOverridePopup").SwfButton("OKbtn").Click
	End If
	
	If SwfWindow("CPS_newOverridePopup").SwfButton("YES").Exist(1) Then
		SwfWindow("CPS_newOverridePopup").SwfButton("YES").Click
	End If
	

	
'	If SwfWindow("CPS_newOverridePopup").SwfButton("YES").Exist Then
'		SwfWindow("CPS_newOverridePopup").SwfButton("YES").Click
'	End If
	
	If SwfWindow("CPS_newWarningPopup").SwfLabel("The First Occurrence Benefit").Exist(5) Then
		ReportMessage "Info", "Clicking OK for Warning popup for: The First Occurrence Benefit has not been paid", True, "Y"
		SwfWindow("CPS_newWarningPopup").SwfButton("YES").Click
	End If
	
	
	'HandleDialog
	If Dialog("CPSWellnessAlertpopup").WinButton("No").Exist(5) Then
		ReportMessage "Info", "Clicking No button for Wellness Alert popup to review", True, "Y"
		Dialog("CPSWellnessAlertpopup").WinButton("No").Click
	End If
	

	
	
'	'added by amit to handle SE
'	benefitAmt = WpfWindow("wpfwin_ClaimData").SwfTable("swftbl_DetailLines").GetCellData(rowNum, "Benefit Amt")
'	If benefitAmt = "" or (GetRegexMatchCount(benefitAmt, "0") > 0 and Len(benefitAmt) = 1) or (GetRegexMatchCount(benefitAmt, "0.00") > 0 and Len(benefitAmt) = 4) Then
'		ReportMessage "Info", "Benefit Amount is not pre-populated for Benefit Code <b>'" & var_benefitCode & "'</b>, so entering the Benefit Amount <b>'" & _
'						var_BenefitAmt & "'</b>", True, "N"
'		WpfWindow("wpfwin_ClaimData").SwfTable("swftbl_DetailLines").SetCellData rowNum, "Benefit Amt", var_BenefitAmt
'		WpfWindow("wpfwin_ClaimData").SwfButton("swfbtn_Process").Click
'		HandleDialog
'	End If
'	'update from amit ends
	If Dialog("CPS - Stop!").WinButton("OK").Exist(3) Then
		Dialog("CPS - Stop!").WinButton("OK").Click
		wait 1
		WpfWindow("wpfwin_ClaimData").SwfTable("swftbl_DetailLines").ActivateCell rowNum, "Benefit Amt"
		Sendkey var_BenefitAmt
		WpfWindow("wpfwin_ClaimData").SwfButton("swfbtn_Process").Click
		HandleDialog
	End If
	
	fnPendORDenyProcessing var_letterCode
	
	On error goto 0
End Function
'########################################################################################################################################
'Function Name				: 	PopulateDataForSTD
'Purpose					:	Function is working in CPS scripts,This function is for STD LOB
'Pre-Condition				:	Cliam Number should be generated Successfully
'Post-Condition				:	None
'-----------------------------------------------------------------------------------------------------------------------------------------
'Input Parameters			:  	Claim Number
'Output Parameters			:	None
'Return Type				: 	None
'Author						:	Vinay Yadav
'Date Written				:	10-June-2016
'Date Modified				:
'Modification details		:
'##########################################################################################################################################
Public Function PopulateDataForSTD(ByVal rowNumber)
	Dim claimCategory, diagCode, disabilityType, onoffJob, fullPartTime, payee, phyStartDate, phyEndDate, empStartDate, empEndDate, eventDate, index, pendDenyReason
	index = 0
	pendDenyReason = ""
On error resume next
	claimCategory = GetDictItem(cpsDataTableDictObj, "ClaimType#" & rowNumber)
	disabilityType = GetDictItem(cpsDataTableDictObj, "Event#" & rowNumber)
	onoffJob = GetDictItem(cpsDataTableDictObj, "OnOffJob#" & rowNumber)
	fullPartTime = GetDictItem(cpsDataTableDictObj, "FullPartTime#" & rowNumber)
	payee = GetDictItem(cpsDataTableDictObj, "Payee#" & rowNumber)
	
	phyStartDate = GetDictItem(cpsDataTableDictObj, "PhysicialStartDate#" & rowNumber)
	empEndDate = GetDictItem(cpsDataTableDictObj, "EmployeeEndDate#" & rowNumber)
	phyEndDate = GetDictItem(cpsDataTableDictObj, "PhysicialEndDate#" & rowNumber)
	empStartDate = GetDictItem(cpsDataTableDictObj, "EmployeeStartDate#" & rowNumber)
	
	eliminationPeriod = GetDictItem(cpsDataTableDictObj, "EliminationPeriod#" & rowNumber)
	eventDateVal = GetDictItem(cpsDataTableDictObj, "EventDate#" & rowNumber)
	var_OccDate = GetDateFormatted(DateAdd("d", cint(GetDictItem(cpsDataTableDictObj, "OccDate#" & rowNumber)), policyEffectiveDate), "MMDDYY")
	phyStartDate = GetDateFormatted(DateAdd("d", cint(phyStartDate), policyEffectiveDate), "MMDDYY")
	phyEndDate = GetDateFormatted(DateAdd("d", cint(phyEndDate), policyEffectiveDate), "MMDDYY")
	empStartDate = GetDateFormatted(DateAdd("d", cint(empStartDate), policyEffectiveDate), "MMDDYY")
	empEndDate = GetDateFormatted(DateAdd("d", cint(empEndDate), policyEffectiveDate), "MMDDYY")
	
	eventDate = GetDateFormatted(DateAdd("d", cint(eventDateVal), policyEffectiveDate), "MMDDYY")
	'Added by Amit on 08/16/2018 to handle the PEND and DENY cases
	var_Action = GetDictItem(cpsDataTableDictObj, "Action#" & rowNumber)
	'Added by AMit on 08/22/2018
	var_Mod1 = GetDictItem(cpsDataTableDictObj, "Mod1#" & rowNumber) 
	var_Mod2 = GetDictItem(cpsDataTableDictObj, "Mod2#" & rowNumber) 
	var_Mod3 = GetDictItem(cpsDataTableDictObj, "Mod3#" & rowNumber) 
	var_Mod4 = GetDictItem(cpsDataTableDictObj, "Mod4#" & rowNumber) 
	var_Cd1 = GetDictItem(cpsDataTableDictObj, "Cd1#" & rowNumber) 
	var_Cd2 = GetDictItem(cpsDataTableDictObj, "Cd2#" & rowNumber) 
	var_Cd3 = GetDictItem(cpsDataTableDictObj, "Cd3#" & rowNumber) 
	var_Cd4 = GetDictItem(cpsDataTableDictObj, "Cd4#" & rowNumber) 
	'Additions by amit ends.
	var_letterCode = GetDictItem(cpsDataTableDictObj, "LetterCode#" & rowNumber) 
	'Updates from Amit Garg ended.
	
	var_BenefitCode = GetDictItem(cpsDataTableDictObj, "BenefitCode#" & rowNumber)
'	bdp = GetDateFormatted(DateAdd("d",  cint(GetDictItem(cpsDataTableDictObj, "BDP#" & rowNumber)), policyEffectiveDate), "MMDDYY")
'	edp = GetDateFormatted(DateAdd("d",  cint(GetDictItem(cpsDataTableDictObj, "EDP#" & rowNumber)), policyEffectiveDate), "MMDDYY")
	var_chgAmt = GetDictItem(cpsDataTableDictObj, "ChgAmt#" & rowNumber) 
	If ValidateObject(WpfWindow("wpfwin_ClaimData").SwfComboBox("swfcom_ClaimCategory"),10)=0 Then
		ReportMessage "Pass", "Claim Category dropdown is displayed. ", True, "N"
		PopulateDataForSTD=0
	Else
		ReportMessage "Fail", "Claim Category dropdown is not displayed. ", True, "Y"
		PopulateDataForSTD=-1
		Exit Function
	End If
	WpfWindow("wpfwin_ClaimData").SwfComboBox("swfcom_ClaimCategory").Select claimCategory
	CPS_DiagCode=fn_Generate_Diagnosis_Code(rowNumber)
	WpfWindow("wpfwin_ClaimData").SwfEdit("swfedt_DiagnosisCode").Set CPS_DiagCode
	WpfWindow("wpfwin_ClaimData").SwfComboBox("swfcom_DisabilityType").Select disabilityType
	WpfWindow("wpfwin_ClaimData").SwfComboBox("swfcom_OnOffJob").Select onoffJob
	WpfWindow("wpfwin_ClaimData").SwfComboBox("swfcom_FullPartTime").Select fullPartTime
	WpfWindow("wpfwin_ClaimData").SwfRadioButton("swfrad_AfterTax").Set
	WpfWindow("wpfwin_ClaimData").SwfComboBox("swfcom_Payee").Select payee
	WpfWindow("wpfwin_ClaimData").SwfEdit("swfedt_PhysiciansStartDate").Set phyStartDate
	WpfWindow("wpfwin_ClaimData").SwfEdit("swfedt_PhysiciansEndDate").Set phyEndDate
	WpfWindow("wpfwin_ClaimData").SwfEdit("swfedt_EmployersStartDate").Set empStartDate
	WpfWindow("wpfwin_ClaimData").SwfEdit("swfedt_EmployersEndDate").Set empEndDate
	WpfWindow("wpfwin_ClaimData").SwfEdit("swfedit_EventDate").Set eventDate
	strYearDropped = Year(WpfWindow("wpfwin_ClaimData").SwfEdit("swfedt_PhysiciansStartDate").GetROProperty("text"))
	
	ReportMessage "Info", "Entered data on Claim data screen for Policy Type SD Claim Category - <br>" & claimCategory & "<br> Diag Code - " & diagCode & "<br> DisabilityType - " & disabilityType & _
					"<br> On/Off Job - " & onoffJob & "<br> Full/Part Time - " & fullPartTime & "<br> Payee - " & payee & "<br> Physician Start Date - " & phyStartDate & "<br> Physician End Date - " & phyEndDate & _
					"<br>Employer's Start Date - " & empStartDate & "<br> Employer's End Date - " & empEndDate & "<br> and Event Date - " & eventDate, True, "N"
	If WpfWindow("wpfwin_ClaimData").SwfRadioButton("swfrad_InsuredProvider").Exist(1) Then
		WpfWindow("wpfwin_ClaimData").SwfRadioButton("swfrad_InsuredProvider").Set
		ReportMessage "Pass", "Selected R-Insured/Provider Radio button on Claim Data screen.", True, "N"
	End If
	
	'Added by Amit on 08/16/2018 to handle the PEND and DENY cases
	Environment.Value("var_Action") = Trim(var_Action)
	If UCASE(var_Action) = "PAY" Then
		WpfWindow("wpfwin_ClaimData").SwfButton("swfbtn_ManualPay").Click
		ReportMessage "Info", "Clicked on 'Manual Pay' button on the Claim Data screen. ", True, "N"
		wait 1		
	ElseIf UCASE(var_Action) = "PEND" Then
		WpfWindow("wpfwin_ClaimData").SwfButton("swfbtn_PeNd").Click
		ReportMessage "Info", "Clicked on 'PeNd' button on the Claim Data screen. ", True, "N"
		wait 1	
	ElseIf UCASE(var_Action) = "DENY" Then
		WpfWindow("wpfwin_ClaimData").SwfButton("swfbtn_DeNy").Click
		ReportMessage "Info", "Clicked on 'Deny' button on the Claim Data screen. ", True, "N"
		wait 1	
	End If
	'Updates from Amit ended.
	
	If SwfWindow("swfwin_EliminationPeriod").SwfEdit("swfedt_EliminationPd").Exist(5) Then
		SwfWindow("swfwin_EliminationPeriod").SwfEdit("swfedt_EliminationPd").Set eliminationPeriod
		ReportMessage "Info", "Entered Elimination Period as '" & eliminationPeriod & "' and clicked on Submit button", True, "Y"
		SwfWindow("swfwin_EliminationPeriod").SwfButton("swfbtn_Submit").Click
				
		'Added by Amit Garg on 08/23/2018 to handle the Keying of Cd Details
		If NOT (IsNull(var_Cd1) OR IsEmpty(var_Cd1) OR Trim(var_Cd1) = "") Then
			If fnKeyCdDetails (rowNum, GetDictItem(cpsDataTableDictObj, "PolicyType#" & rowNumber), var_Cd1, var_Cd2, var_Cd3, var_Cd4) = -1 Then
				'Exit Function
			End If								
		End If
		
		If SwfWindow("CPS - Audit Results").Exist(15) Then
			SwfWindow("CPS - Audit Results").SwfButton("CloseWindow").Click
		End If
		
		'UPdates from Amit Garg ends.	
		
		HandleDialog
		If SwfWindow("CPS - Audit Question?").SwfButton("Save").Exist(3) Then
			SwfWindow("CPS - Audit Question?").SwfComboBox("FirstMonthDropped").Select "Jan"
			SwfWindow("CPS - Audit Question?").SwfComboBox("FirstYearDropped").Select CSTR(strYearDropped)
			SwfWindow("CPS - Audit Question?").SwfComboBox("LastMonthDropped").Select "Dec"
			SwfWindow("CPS - Audit Question?").SwfComboBox("LastYearDropped").Select CSTR(strYearDropped)
			SwfWindow("CPS - Audit Question?").SwfButton("Save").Click
		End If
	End If
	If SwfWindow("swfwin_AuditResponseEntry").SwfButton("swfbtn_Save").Exist(2) Then
		SwfWindow("swfwin_AuditResponseEntry").SwfEdit("swfedit_Salary").Set "50"
		ReportMessage "Info", "CPS Audit Question Window is Displayed and Enter the Slary Value as : 50. Clicking on Save Button", True, "Y"
		SwfWindow("swfwin_AuditResponseEntry").SwfButton("swfbtn_Save").Click
		If SwfWindow("CPS - Audit Question?").SwfButton("Save").Exist(3) Then
			SwfWindow("CPS - Audit Question?").SwfComboBox("FirstMonthDropped").Select "Jan"
			SwfWindow("CPS - Audit Question?").SwfComboBox("FirstYearDropped").Select CSTR(strYearDropped)
			SwfWindow("CPS - Audit Question?").SwfComboBox("LastMonthDropped").Select "Dec"
			SwfWindow("CPS - Audit Question?").SwfComboBox("LastYearDropped").Select CSTR(strYearDropped)
			SwfWindow("CPS - Audit Question?").SwfButton("Save").Click
		End If
	End If
	'wait 2
	If SwfWindow("swfwin_CPSAuditQuestionSTD").SwfButton("CloseButton").Exist(4) Then
		If SwfWindow("swfwin_CPSAuditQuestionSTD").SwfRadioButton("rbtNone").Exist(2) Then
			SwfWindow("swfwin_CPSAuditQuestionSTD").SwfRadioButton("rbtNone").Set
			SwfWindow("swfwin_CPSAuditQuestionSTD").SwfButton("swfbtn_Save").Click
			If SwfWindow("CPS - Audit Question?").SwfButton("Save").Exist(3) Then
				SwfWindow("CPS - Audit Question?").SwfComboBox("FirstMonthDropped").Select "Jan"
				SwfWindow("CPS - Audit Question?").SwfComboBox("FirstYearDropped").Select CSTR(strYearDropped)
				SwfWindow("CPS - Audit Question?").SwfComboBox("LastMonthDropped").Select "Dec"
				SwfWindow("CPS - Audit Question?").SwfComboBox("LastYearDropped").Select CSTR(strYearDropped)
				SwfWindow("CPS - Audit Question?").SwfButton("Save").Click
			End If
		End If
		If SwfWindow("swfwin_CPSAuditQuestionSTD").SwfEdit("swfEdit_NewOccurenceDate").Exist(2) Then
			SwfWindow("swfwin_CPSAuditQuestionSTD").SwfEdit("swfEdit_NewOccurenceDate").Type empStartDate
			ReportMessage "Info", "Entered New Occurence Date as '" & empStartDate & "' and clicked on Submit button", True, "Y"
			SwfWindow("swfwin_CPSAuditQuestionSTD").SwfButton("swfbtn_Save").Click
			If SwfWindow("CPS - Audit Question?").SwfButton("Save").Exist(3) Then
				SwfWindow("CPS - Audit Question?").SwfComboBox("FirstMonthDropped").Select "Jan"
				SwfWindow("CPS - Audit Question?").SwfComboBox("FirstYearDropped").Select CSTR(strYearDropped)
				SwfWindow("CPS - Audit Question?").SwfComboBox("LastMonthDropped").Select "Dec"
				SwfWindow("CPS - Audit Question?").SwfComboBox("LastYearDropped").Select CSTR(strYearDropped)
				SwfWindow("CPS - Audit Question?").SwfButton("Save").Click
			End If
		End If			
	End If
	'If SwfWindow("swfwin_CPSAuditQuestionSTD").Exist(2) Then
		
	'End If
	wait 2
	HandleDialog
	
	If UCASE(var_Action) = "PEND" OR UCASE(var_Action) = "DENY" Then
		fnPendORDenyProcessing var_letterCode
		PopulateDataForSTD=0
		Exit Function
	End If

	If SwfWindow("swfwin_CPSAuditResults").SwfButton("swfbtn_CloseWindow").Exist(2) Then
		ReportMessage "Info", "CPS Audit Result Window is displayed, Click on Close Window button to close window.", True, "Y"
		SwfWindow("swfwin_CPSAuditResults").SwfButton("swfbtn_CloseWindow").Click
	End If
	wait 2	
	
	If ValidateObject(WpfWindow("wpfwin_Research").SwfEdit("swfedit_BenefitCodeLine"),10)=0 Then
		ReportMessage "Pass", "Benefit Code line field displayed.", True, "N"
		PopulateDataForSTD=0
	Else
		ReportMessage "Fail", "Benefit Code line field does not displayed.", True, "Y"
		PopulateDataForSTD=-1
		Exit Function
	End If
		bdp=WpfWindow("wpfwin_ClaimData").SwfEdit("BeginningDateofService").GetROProperty("text")
		bdp=GetDateFormatted(bdp, "MMDDYY")			'Commented by Amit on 10182018
		WpfWindow("wpfwin_Research").SwfEdit("swfedit_BenefitCodeLine").Set var_BenefitCode	
		WpfWindow("wpfwin_Research").SwfEdit("swfedit_BeginningDatePaidLine").Set bdp
		WpfWindow("wpfwin_Research").SwfEdit("swfedit_EndingDatePaidLine").Set bdp
		WpfWindow("wpfwin_Research").SwfEdit("swfedit_DaysLine").Set 1
		SendKey "{TAB}"
		wait 1
		HandleDotNetDialog "CPS - Question", "Yes"
		WpfWindow("wpfwin_Research").SwfEdit("swfedit_AmountLine").Set var_chgAmt
		WpfWindow("wpfwin_Research").SwfEdit("swfedit_UnitsOfCoverageLine").Set 1

		ReportMessage "Info", "Entered data on Claim data screen for Claim Generation - <br> Benefit Code : " & var_BenefitCode & "<br> Beginning Date Paid - " & bdp & "<br> Ending Date Paid - " & bdp & _
					"<br> Days - 1 <br> Amount  - " & var_chgAmt & "<br> UnitsOfCoverage - 1 <br>", True, "N"
					
		If ValidateObject(WpfWindow("wpfwin_ClaimData").SwfButton("swfbtn_IssueCheck"),10)=0 Then
			WpfWindow("wpfwin_ClaimData").SwfButton("swfbtn_IssueCheck").Click
			ReportMessage "Info", "Clicked on Issue Check button to issue the check. ", True, "N"
		End If
		HandleDialog 
		If ValidateObject(WpfWindow("wpfwin_ClaimData").SwfButton("swfbtn_IssueCheck"),10)=0 Then
			WpfWindow("wpfwin_ClaimData").SwfButton("swfbtn_IssueCheck").Click
			ReportMessage "Info", "Clicked on Issue Check button to issue the check. ", True, "N"
		End If
		HandleDialog 
		If ValidateObject(WpfWindow("wpfwin_ClaimData").SwfButton("swfbtn_IssueCheck"),10)=0 Then
			WpfWindow("wpfwin_ClaimData").SwfButton("swfbtn_IssueCheck").Click
			ReportMessage "Info", "Clicked on Issue Check button to issue the check. ", True, "N"
		End If
		HandleDialog 
On error goto 0	
End Function
Public Function SetWpfObjectDate(ByVal obj, ByVal rowNum, ByVal columnName, ByVal dateText)
	obj.SelectCell rowNum, columnName
	SendKey "+{TAB}"
	SendKey "{TAB}"
	SendKey dateText
End Function
'########################################################################################################################################
'Function Name				: 	SelectTextFromWpfObject
'Purpose					:	Function is working in CPS scripts,
'Pre-Condition				:	Cliam Number should be generated Successfully
'Post-Condition				:	None
'-----------------------------------------------------------------------------------------------------------------------------------------
'Input Parameters			:  	Claim Number
'Output Parameters			:	None
'Return Type				: 	None
'Author						:	Vinay Yadav
'Date Written				:	21-June-2016
'Date Modified				:
'Modification details		:
'##########################################################################################################################################
Public Function SelectTextFromWpfObject(ByVal obj, ByVal rowNum, ByVal columnName, ByVal text)
 	obj.SelectCell rowNum, columnName
	SendKey text
End Function'########################################################################################################################################
'Function Name				: 	Validate_Diagnosis_Code
'Purpose					:	Function is working in CPS scripts,This function Validate diagnosis code
'Pre-Condition				:	Cliam Number should be generated Successfully
'Post-Condition				:	None
'-----------------------------------------------------------------------------------------------------------------------------------------
'Input Parameters			:  	Claim Number
'Output Parameters			:	None
'Return Type				: 	None
'Author						:	Vinay Yadav
'Date Written				:	21-June-2016
'Date Modified				:
'Modification details		:
'##########################################################################################################################################

Public Function Validate_Diagnosis_Code (ByVal rowNumber)
		claimflag=""
		clientflag=""
		
		'added by Amit
		p010flag = ""
		If ValidateFromClaimP010(rowNumber)=-1 Then
			p010flag=-1
		Else
			p010flag=0
		End If		
		'addition by Amit ends.
		
		If ValidateFromClientCentral(rowNumber)=-1 Then
			clientflag=-1
		Else
			clientflag=0
		End If
		If ValidateFromClaimCentral(rowNumber)=-1 Then
			claimflag=-1
		Else
			claimflag=0
		End If 
		If claimflag=0 and clientflag=0 and p010flag=0 Then
			Validate_Diagnosis_Code=0
		Else
			Validate_Diagnosis_Code=-1
		End If
End Function
Public Function ValidateFromClaimCentral(rowNumber)


'	'Launch Claim Central Application
'		SystemUtil.Run var_ClaimCentralAppPath
'		ReportMessage "Info", "Claim Central application launched Trigerred from <b> " &var_ClaimCentralAppPath  & " </b> path. ", True, "Y"
'		If ValidateObject(WpfWindow("swfwin_ClaimsCentral").WpfEdit("swfedt_BoxSearch"),100)=0 Then		
'		
'			ReportMessage "Pass", "Claim Central application launched successfully. ", True, "Y"
'			On error Resume Next
'			
'			'Added by Amit to to open the Claim Central in SYST or INTG as per the test case.
'			If GetDictItem(cpsDataTableDictObj, "Environment#" & rowNum) = "SYST" Then
'				WpfWindow("swfwin_ClaimsCentral").WpfButton("appMenuButton").Set "On"
'				WpfWindow("swfwin_ClaimsCentral").WpfComboBox("swfcom_Environment").Select "System Test"
'				WpfWindow("swfwin_ClaimsCentral").WpfButton("appMenuButton").Set "Off"
'				ReportMessage "Info", "Changed the Environment of Claim Central application to 'System Test'.", True, "Y"
'			ElseIf GetDictItem(cpsDataTableDictObj, "Environment#" & rowNum) = "INTG" Then	
'				WpfWindow("swfwin_ClaimsCentral").WpfButton("appMenuButton").Set "On"
'				WpfWindow("swfwin_ClaimsCentral").WpfComboBox("swfcom_Environment").Select "Integration"
'				WpfWindow("swfwin_ClaimsCentral").WpfButton("appMenuButton").Set "Off"
'				ReportMessage "Info", "Changed the Environment of Claim Central application to 'Integration'.", True, "Y"
'			End If
'			'Updates by Amit ends.	

	
	If GetDictItem(cpsDataTableDictObj, "Environment#" & rowNumber) = "SYST" Then
		ClaimsCentralUrl = "http://claimscentral-syst.nt.lab.com/ClaimsCentral/1.5/ClaimsCentral/Clients/Aflac.ClaimsCentral.Client.application"
	ElseIf GetDictItem(cpsDataTableDictObj, "Environment#" & rowNumber) = "INTG" Then	
		ClaimsCentralUrl = "http://claimscentral-Int.nt.lab.com/ClaimsCentral/1.5/ClaimsCentral/Clients/Aflac.ClaimsCentral.Client.application"
	End If
	
	'Launch Claims Central Application.
	If LaunchClaimsCentral(ClaimsCentralUrl) = -1 Then
		ValidateFromClaimCentral = -1
		Exit Function
	End If

	ReportMessage "Info", "Entering the Claim number <b>"&ClaimNumber& "</b> on the claim central screen and click on search button. ", True, "N"
	WpfWindow("swfwin_ClaimsCentral").Activate
	Wait 1
	WpfWindow("swfwin_ClaimsCentral").WpfComboBox("swfcom_cboType").Select "Clm #"
	Wait 1
	WpfWindow("swfwin_ClaimsCentral").WpfEdit("swfedt_BoxSearch").Set ClaimNumber 
	ReportMessage "Info", "Screenshot after entering claim number.", True, "Y"
	SendKey "{TAB}"
	' Check for the NEW YORK Region in Claim Central
	If GetDictItem(cpsDataTableDictObj, "Region#" & rowNumber)="NEW YORK" Then
		WpfWindow("swfwin_ClaimsCentral").WpfCheckBox("swfchk_NY").Set "ON"
		ReportMessage "Info", "Screenshot after checking the 'NY' checkbox.", True, "Y"
	End If
	
	WpfWindow("swfwin_ClaimsCentral").WpfButton("swfbtn_Search").Click 'Click on Search Button on the Clain Central Screen
	
	If ValidateObject(WpfWindow("swfwin_ClaimsCentral").WpfEdit("txtFilter"),40)=0 Then
		ReportMessage "Pass", "System is displayed all the details on the Claim Central Screen", True, "Y"
		WpfWindow("swfwin_ClaimsCentral").WpfEdit("txtFilter").Set ClaimNumber 
		Wait 0,500
		SendKey "{ENTER}"
		Wait 5
		var_DiagCode_Claim=WpfWindow("swfwin_ClaimsCentral").WpfEdit("swfedit_DiagCode").GetROProperty("text")
		var_DiagCode_Claim=Replace (var_DiagCode_Claim,".","")
		If var_DiagCode_Claim=CPS_DiagCode Then
			ReportMessage "Info", "<br><br>Diagnosis Code displayed in Claim Central:  <b> "&var_DiagCode_Claim&" </b> <br>Diagnosis Code Provided in CPS application while raising a claim:  "& CPS_DiagCode, True, "Y"
			ReportMessage "Pass", "System is displayed all the details.", True, "Y"
			ValidateFromClaimCentral=0
		Else 
			ReportMessage "Fail", "<br><br>Diagnosis Code displayed in Claim Central:  <b> "&var_DiagCode_Claim&" </b> <br>Diagnosis Code Provided in CPS application while raising a claim: <b>  "& CPS_DiagCode &" </b>", True, "Y"
			ValidateFromClaimCentral=-1
			CloseAllApplicationsByName "Aflac.ClaimsCentral.Client.exe"
			Exit Function
		End If
	Else
		ReportMessage "Fail", "Claim Central System is not displaying the details.", True, "Y"
		ValidateFromClaimCentral=-1
		CloseAllApplicationsByName "Aflac.ClaimsCentral.Client.exe"
		Exit Function
	End If
'		'Closethe Claim Central Application
'		CloseAllApplicationsByName "Aflac.ClaimsCentral.Client.exe"
'		wait(2)
'		If WpfWindow("wpfwin_SystemMessage").WpfButton("Ok").Exist(1)Then
'			WpfWindow("wpfwin_SystemMessage").WpfButton("Ok").Click
'		End If
'	Else 
'		ReportMessage "Fail", "Claim Central application not launched ", True, "Y"
'		'Closethe Claim Central Application
'		'CloseAllApplicationsByName "Aflac.ClaimsCentral.Client.exe"
'		wait(2)
'		If WpfWindow("wpfwin_SystemMessage").WpfButton("Ok").Exist(1)Then
'			WpfWindow("wpfwin_SystemMessage").WpfButton("Ok").Click
'		End If
'		ValidateFromClaimCentral=-1
'		CloseAllApplicationsByName "Aflac.ClaimsCentral.Client.exe"
'		Exit Function
'	End If
'	On error goto 0
	CloseAllApplicationsByName "Aflac.ClaimsCentral.Client.exe"
End Function
Public Function ValidateFromClientCentral(rowNumber)
		' Launch Client Central Application	
		CloseAllApplicationsByName "Aflac.InformationCenter.UI.exe"
		Dim var_Extension:var_Extension=RandomNumber.value(1000,9999)
		Dim var_Environment
		
		If GetDictItem(cpsDataTableDictObj, "Environment#" & rowNumber) = "SYST" Then
			var_Environment = "SYST"
		ElseIf GetDictItem(cpsDataTableDictObj, "Environment#" & rowNumber) = "INTG" Then	
			var_Environment = "INTG"
		End If
		
		wait 4
		SystemUtil.Run var_ClientCentralAppPath
		ReportMessage "Info", "Launched Client Central Application from location " & var_ClientCentralAppPath, True, "Y"
		Wait 5		
		If Dialog("dialog_ApplicationError").WinButton("winbtn_OK").Exist(100) OR WpfWindow("wpfwin_Login").WpfEdit("wpfedit_Extension").Exist (300) Then
			If Dialog("dialog_ApplicationError").WinButton("winbtn_OK").Exist(2) Then
				Dialog("dialog_ApplicationError").Activate				
			End If
			ReportMessage "PASS", "Successfully Launched Client Central Application", True, "Y"
			ValidateFromClientCentral = 0
		Else
			ReportMessage "FAIL", "Unable to Launch Client Central Application", True, "Y"
			ValidateFromClientCentral = -1
		End If
		
'		If ValidateObject(WpfWindow("swfwin_ClientCentral"),100)=0 Then
'			ReportMessage "Pass", "Client Central application launched from <b> " &var_ClientCentralAppPath  & " </b> path. ", True, "Y"
'			ValidateFromClientCentral=0
'		Else 
'			ReportMessage "Fail", "Client Central application not launched successfully.", True, "Y"
'			ValidateFromClientCentral=-1
'			Exit Function 
'		End If
		On error resume next
'				If ValidateObject(Dialog("Application Error").WinButton("winbutton_OK"),5)=0 Then
'					Dialog("Application Error").WinButton("winbutton_OK").Click
'				End IF

	' Verify the Login window, Put extension and click on the Login Button
		Dim intCnt : intCnt = 0
		While Dialog("Application Error").WinButton("winbutton_OK").Exist(4) And intCnt < 5
			Dialog("Application Error").WinButton("winbutton_OK").Click
			intCnt = intCnt + 1
		Wend 		
		wait 2
		
		If WpfWindow("wpfwin_CommonDialog").WpfButton("wpfbtn_Notryagain").Exist(6) Then
			WpfWindow("wpfwin_CommonDialog").WpfButton("wpfbtn_Notryagain").Click
		End If
		wait 2
		
		' Verify the Login window, Put extension and click on the Login Button
		If WpfWindow("wpfwin_Login").WpfEdit("wpfedit_Extension").Exist(10) Then
			WpfWindow("wpfwin_Login").WpfComboBox("wpfcbo_AppMode").Select "Normal"
			WpfWindow("wpfwin_Login").WpfEdit("wpfedit_Extension").set cstr(var_Extension)
			WpfWindow("wpfwin_Login").WpfEdit("wpfedit_Extension").Click
			SendKey var_Extension
			WpfWindow("wpfwin_Login").WpfComboBox("wpfcbo_Environment").Select var_Environment
			ReportMessage "Info", "Enter values for the Login : Application Mode: "&var_ApplicationMode&" , Extension: "&var_Extension&" , Environment: "&var_Environment, True, "Y"
			
			If ValidateObject(WpfWindow("wpfwin_Login").WpfButton("wpfbtn_Login"),20)=0 and WpfWindow("wpfwin_Login").WpfButton("wpfbtn_Login").GetROProperty("enabled")=True Then
				WpfWindow("wpfwin_Login").WpfButton("wpfbtn_Login").Click
			Else 
				ReportMessage "FAIL", "Client Central Application does not Login Successfully..", True, "Y"
				ValidateFromClientCentral = -1
				Exit Function
			End If
		End If
		
		intCnt = 0
		While Dialog("dialog_ApplicationError").WinButton("winbtn_OK").Exist(4) And intCnt < 5
			Dialog("dialog_ApplicationError").WinButton("winbtn_OK").Click
			intCnt = intCnt + 1
		Wend 
				
'		If WpfWindow("wpfwin_Login_Client_Central").WpfEdit("wpfedt_TextBox_pwd").Exist(1) Then
'			WpfWindow("wpfwin_Login_Client_Central").WpfEdit("wpfedt_TextBox_pwd").set CStr(RandomNumber.value(1000,9999))
'			If WpfWindow("wpfwin_Login_Client_Central").WpfObject("wpf_Login").Exist(2) Then
'				WpfWindow("wpfwin_Login_Client_Central").WpfObject("wpf_Login").Click	
'			End If
'		End If
		
'		If Dialog("Application Error").WinButton("winbutton_OK").Exist(2) Then
'			Dialog("Application Error").WinButton("winbutton_OK").Click
'		End If
'		intCnt = 0
'		While Dialog("Application Error").WinButton("winbutton_OK").Exist(4) And intCnt < 5
'			Dialog("Application Error").WinButton("winbutton_OK").Click
'			intCnt = intCnt + 1
'		Wend 
		wait 2
		If WpfWindow("swfwin_CommonDialog_ClientCentral").WpfButton("swfbtn_YesContinue").Exist(1) Then
			WpfWindow("swfwin_CommonDialog_ClientCentral").WpfButton("swfbtn_YesContinue").Click
		End If
		
		' Verify and CLick on Add Hoc Call Button
		If ValidateObject(WpfWindow("swfwin_ClientCentral").WpfButton("swfbtn_StartAdHocCall"),10)=0 Then
			ReportMessage "Pass", "Start Add Hoc Call Button is displayed, Click the button to start call", True, "Y"
			WpfWindow("swfwin_ClientCentral").WpfButton("swfbtn_StartAdHocCall").Click
			ReportMessage "Info", "Call information column shows call time.", True, "Y"
			ValidateFromClientCentral=0
		Else
			ReportMessage "Fail", "Start Add Hoc Call Button is not displayed", True, "Y"
			ValidateFromClientCentral=-1
			Exit Function 
		End If

		ReportMessage "Info", "Select policyholder and Enter Claim for search record.", True, "N"
		If WpfWindow("swfwin_ClientCentral").WpfComboBox("swfcomSearchTypes").Exist(1) Then
			WpfWindow("swfwin_ClientCentral").WpfComboBox("swfcomSearchTypes").Select "Policyholder"
		End If
		If WpfWindow("swfwin_ClientCentral").WpfComboBox("swfcom_SearchColumnList").Exist(1) Then
			WpfWindow("swfwin_ClientCentral").WpfComboBox("swfcom_SearchColumnList").Select "Claim #"
			wait 1
		End If		
		If WpfWindow("swfwin_ClientCentral").WpfEdit("swftxt_TextBox").Exist(1) Then
			WpfWindow("swfwin_ClientCentral").WpfEdit("swftxt_TextBox").Set ClaimNumber
			'WpfWindow("swfwin_ClientCentral").WpfEdit("swftxt_TextBox").Set	"039395856"
		End If
		If WpfWindow("swfwin_ClientCentral").WpfButton("swfbtn_btnSearch").Exist(1) Then
			WpfWindow("swfwin_ClientCentral").WpfButton("swfbtn_btnSearch").Click
		End If
		If ValidateObject(WpfWindow("swfwin_ClientCentral").WpfEdit("wpftxtName"),10)=0 Then
			WpfWindow("swfwin_ClientCentral").WpfEdit("wpftxtName").Click 42,13,1
			wait 1
			WpfWindow("swfwin_ClientCentral").WpfEdit("wpftxtAddress").Click 57,16,1
			ReportMessage "Pass", "Right Click on the Name, ? Icon becomes green and Verify HIPPA button is enabled. ", True, "Y"
			ValidateFromClientCentral=0
		Else
			ReportMessage "Fail", "Search Result is not Displayed", True, "Y"
			ValidateFromClientCentral=-1
			Exit Function
		End If
		If ValidateObject(WpfWindow("swfwin_ClientCentral").WpfButton("swfbtn_VerifyHIPAA"),10)=0 Then
			WpfWindow("swfwin_ClientCentral").WpfButton("swfbtn_VerifyHIPAA").Click
			wait 2
			ReportMessage "Pass", "Click on the Verify HIPPA button", True, "Y"
			ValidateFromClientCentral=0
		Else
			ReportMessage "Fail", "Not able to Click on Verify HIPPA button", True, "Y"
			ValidateFromClientCentral=-1
			Exit Function
		End IF 
		If WpfWindow("swfwin_ClientCentral").WpfTabStrip("swftab_tabsClaim").Exist(1) Then
			WpfWindow("swfwin_ClientCentral").WpfTabStrip("swftab_tabsClaim").Select "Sheets"
			Wait 2
			ReportMessage "Info", "Select Sheet tab on the Client Central Screen.", True, "Y"
		End If
		var_DiagCode=WpfWindow("swfwin_ClientCentral").WpfEdit("swfedit_DiagCode").GetROProperty("text")
		var_DiagCode=Replace(var_DiagCode,".","")
		If var_DiagCode=CPS_DiagCode Then
			ReportMessage "Info", "<br><br>Diagnosis Code displayed <b> "&var_DiagCode&" </b> <br>Diagnosis Code Provided in CPS application while raising a claim:  <b>"& CPS_DiagCode&"</b>", True, "N"
			WpfWindow("swfwin_ClientCentral").WpfEdit("swfedit_DiagCode").highlight
			wait 1
			ReportMessage "Pass", "Diagnosis Code value is displayed same as provided in CPS application while raising a claim", True, "Y"
			ValidateFromClientCentral=0
		Else 
			ReportMessage "Fail", "<br><br>Diagnosis Code displayed in Client Central:  <b> "&var_DiagCode&" </b> <br>Diagnosis Code Provided in CPS application while raising a claim: <b>  "& CPS_DiagCode &" </b>", True, "N"
			ValidateFromClientCentral=-1
			Exit Function
		End If
		On error goto 0
		SystemUtil.CloseProcessByName "Aflac.InformationCenter.UI.exe"
End Function
'########################################################################################################################################
'Function Name				: 	fn_Close_ClientCentralCall
'Purpose					:	Function is working in CPS scripts,This function Close call central call
'Pre-Condition				:	Cliam Number should be generated Successfully
'Post-Condition				:	None
'-----------------------------------------------------------------------------------------------------------------------------------------
'Input Parameters			:  	Claim Number
'Output Parameters			:	None
'Return Type				: 	None
'Author						:	Vinay Yadav
'Date Written				:	21-June-2016
'Date Modified				:
'Modification details		:
'##########################################################################################################################################
Public Function fn_Close_ClientCentralCall()
		
		If WpfWindow("swfwin_ClientCentral").WpfButton("swfbtn_ReviewCall").Exist(2) Then
			WpfWindow("swfwin_ClientCentral").WpfButton("swfbtn_ReviewCall").Click
			If WpfWindow("swfwin_CallReviewandCloseout").WpfButton("swfbtn_DiscardCall").Exist(5) Then
				WpfWindow("swfwin_CallReviewandCloseout").WpfButton("swfbtn_DiscardCall").Click
				If WpfWindow("swfwin_CommonDialog_ClientCentral").WpfButton("swfbtn_YesDiscard").Exist(5) Then
					WpfWindow("swfwin_CommonDialog_ClientCentral").WpfButton("swfbtn_YesDiscard").Click
					CloseAllApplicationsByName "Aflac.InformationCenter.UI.exe"
				End If
			End If
		End If
	
End Function
'########################################################################################################################################
'Function Name				: 	fn_Install_Latest_CPS_Build
'Purpose					:	Function is working in CPS scripts,This function Install latest CPS Build
'Pre-Condition				:	Cliam Number should be generated Successfully
'Post-Condition				:	None
'-----------------------------------------------------------------------------------------------------------------------------------------
'Input Parameters			:  	Claim Number
'Output Parameters			:	None
'Return Type				: 	None
'Author						:	Vinay Yadav
'Date Written				:	21-June-2016
'Date Modified				:
'Modification details		:
'##########################################################################################################################################
Public Function fn_Install_Latest_CPS_Build(ByVal strFolderPath,ByVal strEnvent)
	Dim strLastModFolder,strCPS_AppPath,strCPS_Intg_ConfigPath,strCPS_Prod_ConfigPath,strCPS_Syst_ConfigPath
	strLastModFolder=GetLastModifiedFile(strFolderPath)
	strCPS_AppPath=strLastModFolder&"\Deployment\CPS_App.exe"
	strCPS_Intg_ConfigPath=strLastModFolder&"\Deployment\CPS_Intg_Config.exe"
	strCPS_Prod_ConfigPath=strLastModFolder&"\Deployment\CPS_Prod_Config.exe"
	strCPS_Syst_ConfigPath=strLastModFolder&"\Deployment\CPS_Syst_Config.exe"
		Select Case strEnvent
			Case "SYST"
				SystemUtil.Run strCPS_Syst_ConfigPath
				ReportMessage "Info", "SYST Config EXE is executed from the Path: <b>"&strCPS_Syst_ConfigPath&"</b>", True, "N"
				wait 1
				SystemUtil.Run strCPS_AppPath
				ReportMessage "Info", "SYST APP EXE is executed from the Path: <b>"&strCPS_AppPath&"</b>", True, "N"
			Case "INTG"
				SystemUtil.Run strCPS_Intg_ConfigPath
				ReportMessage "Info", "SYST Config EXE is executed from the Path: <b>"&strCPS_Intg_ConfigPath&"</b>", True, "N"
				wait 1
				SystemUtil.Run strCPS_AppPath
				ReportMessage "Info", "SYST APP EXE is executed from the Path: <b>"&strCPS_AppPath&"</b>", True, "N"				
			Case "PROD"
				SystemUtil.Run strCPS_Prod_ConfigPath
				ReportMessage "Info", "SYST Config EXE is executed from the Path: <b>"&strCPS_Prod_ConfigPath&"</b>", True, "N"
				wait 1
				SystemUtil.Run strCPS_AppPath
				ReportMessage "Info", "SYST APP EXE is executed from the Path: <b>"&strCPS_AppPath&"</b>", True, "N"
		End Select
		Wait 5
End Function

'########################################################################################################################################
'Function Name				: 	fn_Install_Specific_CPS_Build
'Purpose					:	Function is working in CPS scripts,This function Install 
'Pre-Condition				:	Cliam Number should be generated Successfully
'Post-Condition				:	None
'-----------------------------------------------------------------------------------------------------------------------------------------
'Input Parameters			:  	Claim Number
'Output Parameters			:	None
'Return Type				: 	None
'Author						:	Vinay Yadav
'Date Written				:	21-June-2016
'Date Modified				:
'Modification details		:
'##########################################################################################################################################
Public Function fn_Install_Specific_CPS_Build(ByVal strFolderPath,ByVal strEnvent)

	Dim strLastModFolder,strCPS_AppPath,strCPS_Intg_ConfigPath,strCPS_Prod_ConfigPath,strCPS_Syst_ConfigPath
	'strLastModFolder=GetLastModifiedFile(strFolderPath)
	If Right(strFolderPath,1) = "\" Then
		strFolderPath = Left(strFolderPath, len(strFolderPath) - 1)
	End If	
	strCPS_AppPath=strFolderPath&"\Deployment\CPS_App.exe"
	strCPS_Intg_ConfigPath=strFolderPath&"\Deployment\CPS_Intg_Config.exe"
	strCPS_Prod_ConfigPath=strFolderPath&"\Deployment\CPS_Prod_Config.exe"
	strCPS_Syst_ConfigPath=strFolderPath&"\Deployment\CPS_Syst_Config.exe"
		Select Case strEnvent
			Case "SYST"
				SystemUtil.Run strCPS_Syst_ConfigPath
				ReportMessage "Info", "SYST Config EXE is executed from the Path: <b>"&strCPS_Syst_ConfigPath&"</b>", True, "N"
				wait 1
				SystemUtil.Run strCPS_AppPath
				ReportMessage "Info", "SYST APP EXE is executed from the Path: <b>"&strCPS_AppPath&"</b>", True, "N"
			Case "INTG"
				SystemUtil.Run strCPS_Intg_ConfigPath
				ReportMessage "Info", "SYST Config EXE is executed from the Path: <b>"&strCPS_Intg_ConfigPath&"</b>", True, "N"
				wait 1
				SystemUtil.Run strCPS_AppPath
				ReportMessage "Info", "SYST APP EXE is executed from the Path: <b>"&strCPS_AppPath&"</b>", True, "N"				
			Case "PROD"
				SystemUtil.Run strCPS_Prod_ConfigPath
				ReportMessage "Info", "SYST Config EXE is executed from the Path: <b>"&strCPS_Prod_ConfigPath&"</b>", True, "N"
				wait 1
				SystemUtil.Run strCPS_AppPath
				ReportMessage "Info", "SYST APP EXE is executed from the Path: <b>"&strCPS_AppPath&"</b>", True, "N"
		End Select
		Wait 5
End Function

'########################################################################################################################################
'Function Name				: 	GetLastModifiedFile
'Purpose					:	Function is working in CPS scripts,This function return last modified file/folder
'Pre-Condition				:	Cliam Number should be generated Successfully
'Post-Condition				:	None
'-----------------------------------------------------------------------------------------------------------------------------------------
'Input Parameters			:  	Claim Number
'Output Parameters			:	None
'Return Type				: 	None
'Author						:	Vinay Yadav
'Date Written				:	21-June-2016
'Date Modified				:
'Modification details		:
'##########################################################################################################################################
Public Function GetLastModifiedFile(ByVal sFolderPath) 
		  Dim FSO, objFolder 
		  Dim objFolderResult, longDateTime 
		  Dim boolRC 
		  Set FSO = CreateObject("Scripting.FileSystemObject") 
		  Set objFolder = FSO.GetFolder(sFolderPath) 
		  Set objFolderResult = Nothing 
		  longDateTime = CDate(0) 
		  Set fc=objFolder.SubFolders
		  For Each f1 in fc
		  	If f1.DateLastModified > longDateTime Then 
		    	Set objFolderResult = f1 
		      	longDateTime = f1.DateLastModified 
		    End If 
		  Next 
		  Set FSO = Nothing 
		  Set objFolder = Nothing 
		  GetLastModifiedFile = objFolderResult 
End Function 
'########################################################################################################################################
'Function Name				: 	fn_Verify_Diagnosis_Code
'Purpose					:	Function is working in CPS scripts,This function Verify Diagnosis Code
'Pre-Condition				:	Cliam Number should be generated Successfully
'Post-Condition				:	None
'-----------------------------------------------------------------------------------------------------------------------------------------
'Input Parameters			:  	Claim Number
'Output Parameters			:	None
'Return Type				: 	None
'Author						:	Vinay Yadav
'Date Written				:	21-June-2016
'Date Modified				:
'Modification details		:
'##########################################################################################################################################
Public Function fn_Verify_Diagnosis_Code(strDiagCode)
		If IsIterStatusSuccess() Then
			char1=mid(strDiagCode,1,1)
			char2=mid(strDiagCode,2,1)
			char3=mid(strDiagCode,3,1)
			If ((asc(char1)>64 and asc(char1)<91 ) OR (asc(char1)>96 and asc(char1)<123 )) and Isnumeric(char2) and Isnumeric(char3) Then
				ReportMessage "Info", "Enter Diagnosis Code: "&strDiagCode&" is As per the ICD10 Standard", True, "N"
			Else
				ReportMessage "Info", "Enter Diagnosis Code: "&strDiagCode&"  is As per the ICD9 Standard", True, "N"
			End IF
		End IF
End Function
'########################################################################################################################################
'Function Name				: 	fn_Generate_Diagnosis_Code
'Purpose					:	Function is working in CPS scripts,This function Generate diagnosis code
'Pre-Condition				:	Cliam Number should be generated Successfully
'Post-Condition				:	None
'-----------------------------------------------------------------------------------------------------------------------------------------
'Input Parameters			:  	Claim Number
'Output Parameters			:	None
'Return Type				: 	None
'Author						:	Vinay Yadav
'Date Written				:	21-June-2016
'Date Modified				:
'Modification details		:
'##########################################################################################################################################
Public Function fn_Generate_Diagnosis_Code(rowNum)
	Dim lstChar,strDiagCode
	strDiagCode=""
	lstchar = "ABCDEFGHIJKLMNOPQRSWXYZ"
	lstAlphaChar="ABCDEFGHIJKLMNOPQRSTVWXYZ1234567890"
	Randomize
	If GetDictItem(cpsDataTableDictObj, "ValidateDiagCode#" & rowNum)="3Y" Then
	 	strDiagCode = strDiagCode&Mid(lstchar,Int((24*Rnd)+1),1)
	 	strDiagCode = strDiagCode& int((9*rnd)+0)
	 	strDiagCode = strDiagCode& int((9*rnd)+0)
		fn_Generate_Diagnosis_Code=strDiagCode
	ElseIf GetDictItem(cpsDataTableDictObj, "ValidateDiagCode#" & rowNum)="8Y" Then
		strDiagCode = strDiagCode&Mid(lstchar,Int((24*Rnd)+1),1)
	 	strDiagCode = strDiagCode& int((9*rnd)+0)
	 	strDiagCode = strDiagCode& int((9*rnd)+0)
	 	For i = 1 To 5
	 		strDiagCode = strDiagCode& Mid(lstAlphaChar,Int((35*Rnd)+1),1)
	 	Next
	 	fn_Generate_Diagnosis_Code=strDiagCode
	 ElseIf GetDictItem(cpsDataTableDictObj, "ValidateDiagCode#" & rowNum)="7Y" Then
		strDiagCode = strDiagCode&Mid(lstchar,Int((24*Rnd)+1),1)
	 	strDiagCode = strDiagCode& int((9*rnd)+0)
	 	strDiagCode = strDiagCode& int((9*rnd)+0)
	 	For i = 1 To 4
	 		strDiagCode = strDiagCode& Mid(lstAlphaChar,Int((35*Rnd)+1),1)
	 	Next
	 	fn_Generate_Diagnosis_Code=strDiagCode
	Else
		strDiagCode = strDiagCode&Mid(lstchar,Int((24*Rnd)+1),1)
	 	strDiagCode = strDiagCode& int((9*rnd)+0)
	 	strDiagCode = strDiagCode& int((9*rnd)+0)
	 	For i = 1 To 2
	 		strDiagCode = strDiagCode& Mid(lstAlphaChar,Int((35*Rnd)+1),1)
	 	Next
	 	fn_Generate_Diagnosis_Code=strDiagCode
	End If
End Function
'########################################################################################################################################
'Function Name				: 	SetClaimNumber
'Purpose					:	Function is working in CPS scripts,This function set the Claim Number Generated
'Pre-Condition				:	Cliam Number should be generated Successfully
'Post-Condition				:	None
'-----------------------------------------------------------------------------------------------------------------------------------------
'Input Parameters			:  	Claim Number
'Output Parameters			:	None
'Return Type				: 	None
'Author						:	Vinay Yadav
'Date Written				:	21-June-2016
'Date Modified				:
'Modification details		:
'##########################################################################################################################################
Public Function SetClaimNumber(ByVal claimNum)
	claimNum_ = claimNum
	ClaimNumber=claimNum
End Function
Public Function GetClaimNumber()
   GetClaimNumber = claimNum_
End Function
Public Function CloseClaimRemarks()
	If SwfWindow("swfwin_ClaimRemarksList").SwfButton("swfbtn_CloseWindow").Exist(1) Then
		ReportMessage "Info", "Claim Remarks list screen loaded, closing that and moving with Claim data screen. ", True, "Y"
'		SwfWindow("swfwin_ClaimRemarksList").SwfButton("swfbtn_CloseWindow").Click
		SwfWindow("swfwin_ClaimRemarksList").Activate
		Wait 1
		Sendkey "%c"
	End If
End Function
Public Function ValidateObject(ByVal objName, ByVal syncTime)
 	For i = 1 to syncTime
		If objName.Exist(0) Then
'			ReportMessage "PASS", "Object: : " & objName.toString() & " displayed successfully", True, "Y"
			ValidateObject = 0
			Exit Function
		End If
		Wait 1
	Next
'	ReportMessage "FAIL", "Unable to locate: " & objName.toString() & " Object", True, "Y"
	ValidateObject = -1
End Function
'Public Function HandleDialog(ByVal dialogText, ByVal buttonText)
'		dialogBoxText=""
'		While Dialog("text:=.*" & dialogText & ".*", "index:=0").WinButton("text:=.*" & buttonText).Exist(2)
'			dialogBoxText = GetDialogBoxText(Dialog("text:=.*" & dialogText & ".*", "index:=0"))
'			Dialog("text:=.*" & dialogText & ".*", "index:=0").WinButton("text:=.*" & buttonText).Click
'			If dialogBoxText <> "" Then
'				ReportMessage "Info", "Clicked on<b> '" & buttonText & "' </b>button on the dialog box having title -<b> '" & dialogText & "' </b>and with text - '" & dialogBoxText & "'", True, "N"
'			Else
'				ReportMessage "Info", "Clicked on <b>'" & buttonText & "' </b> button on the dialog box having title -<b> '" & dialogText & "'</b>", True, "N"
'			End If
''			wait 1
'		Wend
'End Function
Public Function LaunchCCApplication()
	'Launch ClientCetral Application
	SystemUtil.Run ClientCentralAppPath
	wait 5
	If Dialog("dialog_ApplicationError").WinButton("winbtn_OK").Exist(60) OR WpfWindow("wpfwin_Login").WpfEdit("wpfedit_Extension").Exist (60) Then
			If Dialog("dialog_ApplicationError").WinButton("winbtn_OK").Exist(2) Then
				Dialog("dialog_ApplicationError").Activate				
			End If
		ReportMessage "PASS", "Successfully Launched Client Central Application", True, "Y"
		LaunchCCApplication = 0
	Else
		ReportMessage "FAIL", "Unable to Launch Client Central Application", True, "Y"
		LaunchCCApplication = -1
	End If
End Function

Public Function LoginCCApplication(rowNum)
	Dim var_ApplicationMode:var_ApplicationMode="Normal"
	Dim var_Extension:var_Extension=RandomNumber.value(1000,9999)
	Dim var_Environment:var_Environment=GetDictItem(cpsDataTableDictObj, "Environment#" & rowNum)
	ReportMessage "Info", "<B>Login Client Central...</B>", True, "N"
	wait 5
			If Dialog("dialog_ApplicationError").WinButton("winbtn_OK").Exist(10) Then
					Dialog("dialog_ApplicationError").Activate
					Dialog("dialog_ApplicationError").WinButton("winbtn_OK").Click
			End IF
			wait 2
			If WpfWindow("wpfwin_CommonDialog").WpfButton("wpfbtn_Notryagain").Exist(2) Then
				WpfWindow("wpfwin_CommonDialog").WpfButton("wpfbtn_Notryagain").Click
			End If
			wait 2
		' Verify the Login window, Put extension and click on the Login Button
			If WpfWindow("wpfwin_Login").WpfEdit("wpfedit_Extension").Exist(1) Then
				WpfWindow("wpfwin_Login").WpfComboBox("wpfcbo_AppMode").Select var_ApplicationMode
				WpfWindow("wpfwin_Login").WpfEdit("wpfedit_Extension").set cstr(var_Extension)
				WpfWindow("wpfwin_Login").WpfEdit("wpfedit_Extension").Click
				SendKey var_Extension
				WpfWindow("wpfwin_Login").WpfComboBox("wpfcbo_Environment").Select var_Environment
				ReportMessage "Info", "Enter values for the Login : Application Mode: "&var_ApplicationMode&" , Extension: "&var_Extension&" , Environment: "&var_Environment, True, "Y"
				
				If ValidateObject(WpfWindow("wpfwin_Login").WpfButton("wpfbtn_Login"),20)=0 and WpfWindow("wpfwin_Login").WpfButton("wpfbtn_Login").GetROProperty("enabled")=True Then
					WpfWindow("wpfwin_Login").WpfButton("wpfbtn_Login").Click
				Else 
				ReportMessage "FAIL", "Client Central Application does not Login Successfully...", True, "Y"
				LoginCCApplication = -1
				Exit Function
				End If
			End If
	If ValidateObject(Dialog("dialog_ApplicationError").WinButton("winbtn_OK"),10)=0 Then
			Dialog("dialog_ApplicationError").WinButton("winbtn_OK").Click
		End IF
		wait 1
		If WpfWindow("wpfwin_CommonDialog").WpfButton("wpfbtn_Yescontinue").Exist(1) Then
			WpfWindow("wpfwin_CommonDialog").WpfButton("wpfbtn_Yescontinue").Click
		End If
		
	If  validateobject(WpfWindow("wpfwin_ClientCentral").WpfButton("wpfbtn_Startadhoccall"),10)=0 Then
		ReportMessage "PASS", "Client Central Application Login Successfully...", True, "Y"
		LoginCCApplication = 0
	Else
		ReportMessage "FAIL", "Client Central Application does not Login Successfully...", True, "Y"
		LoginCCApplication = -1
		Exit Function
	End If
End Function

Public Function GetRowCountOfBenCodeGrid ()

	Set objGrid1 = WpfWindow("Claims Payment System").SwfObject("SwfObject").SwfObject("elementHost1").WpfWindow("WpfWindow").SwfObject("SwfObject").SwfTable("DetailLines")
	Set objGrid2 = WpfWindow("Claims Payment System").SwfObject("SwfObject").SwfObject("elementHost1").WpfWindow("WpfWindow_2").SwfObject("SwfObject").SwfObject("elementHost1").WpfWindow("WpfWindow").WpfTable("EobItemsGrid")
	
	If objGrid1.Exist (2) Then
		GetRowCountOfBenCodeGrid = objGrid1.RowCount
	ElseIf objGrid2.Exist (2) Then
'		GetRowCountOfBenCodeGrid = objGrid2.RowCount
		GetRowCountOfBenCodeGrid = objGrid2.Object.Items.Count
	End If	
	
	Set objGrid1 = Nothing
	Set objGrid2 = Nothing
	
End Function
Public Function DoubleClickONBenefitCode(ByVal strBenCode)
	
	Dim blnStatus : blnStatus = False
	Dim intInitRowCount : intInitRowCount = 0
	Dim intFinalRowCount : intFinalRowCount = 0
	Dim intCount : intCount = 0
	
	intInitRowCount = GetRowCountOfBenCodeGrid()	

	Do
		var_benefitCode = strBenCode
		Set objDescBenCode = Description.Create
		objDescBenCode("micclass").value = "SwfLabel"
		objDescBenCode("text").value = var_benefitCode
		
		Set objDescBenCodeWithOutBenCode = Description.Create
		objDescBenCodeWithOutBenCode("micclass").value = "SwfLabel"
		objDescBenCodeWithOutBenCode("text").value = "[A-Z][A-Z][A-Z]"
			
		Set objBenCodeParent1 = WpfWindow("Claims Payment System").SwfObject("SwfObject").SwfObject("elementHost1").WpfWindow("WpfWindow").SwfObject("SwfObject")
		Set objBenCodeParent2 = WpfWindow("Claims Payment System").SwfObject("SwfObject").SwfObject("elementHost1").WpfWindow("WpfWindow_2").SwfObject("SwfObject")
		
		If objBenCodeParent1.Exist(2) Then
			Set objBenCodeChilds = objBenCodeParent1.ChildObjects(objDescBenCode)
			Set objBenCodeChildsAll = objBenCodeParent1.ChildObjects(objDescBenCodeWithOutBenCode)
		ElseIf objBenCodeParent2.Exist(2) Then
			Set objBenCodeChilds = objBenCodeParent2.ChildObjects(objDescBenCode)
			Set objBenCodeChildsAll = objBenCodeParent2.ChildObjects(objDescBenCodeWithOutBenCode)
		End If
		
		If objBenCodeChilds.Count() > 0 Then
			ScrollBarDown
			objBenCodeChilds(objBenCodeChilds.Count() - 1).DblClick 12,8		
		Else
			ReportMessage "Info", "Benefit Code: <b>"&strBenCode&" </b> not added with the Policy as it does not exist on screen.", True, "Y"
			
			'blnStatus = True
			'Exit Do
			
			If objBenCodeChildsAll.Count() > 0 Then
				objBenCodeChildsAll(objBenCodeChildsAll.Count() - 1).DblClick 12,8
				ReportMessage "Info", "Clicked on 1st Benefit Code.", True, "Y"
			End If
		End If		
		
		If SwfWindow("CPS_newquestionPopup").SwfLabel("The selected Benefit may").Exist(10) Then
				ReportMessage "Info", "Popup displayed for multi plans for selected benifit code, clicking NO button", True, "Y"
				SwfWindow("CPS_newquestionPopup").SwfButton("NO").Click
		End If
		
		HandleDialog
		Wait 5
		intFinalRowCount = GetRowCountOfBenCodeGrid()
		
		If intFinalRowCount > intInitRowCount Then
			blnStatus = True
			ReportMessage "Pass", "Successfully clicked on Benefit Code in try: " & intCount+ 1, True, "Y"
			Exit Do
		Else
			ReportMessage "Info", "Couldn't click on Benefit Code in try: " & intCount + 1, True, "Y"
		End If
		
		intCount = intCount + 1
		
	Loop While intCount < 5
	
	If blnStatus Then
		DoubleClickONBenefitCode = 0
	Else
		DoubleClickONBenefitCode = -1
	End If
	ScrollBarUp
	Set objBenCodeParent1 = Nothing
	Set objBenCodeParent2 = Nothing
	Set objDescBenCode = Nothing
	Set objBenCodeChilds = Nothing
	
End Function

Public Function HandleDialog()

	Dim dialogBoxText, strExceptionPattern1
	
	dialogBoxText=""
	strExceptionPattern1 = ""
	While Dialog("regexpwndclass:=#32770","ispopupwindow:=True").Exist(5)
		
		dialogBoxText = GetDialogBoxText(Dialog("regexpwndclass:=#32770","ispopupwindow:=True"))
		strExceptionPattern1 = "The selected Benefit may also be payable under the Plan Code/s starting with .*. Do you want to pay under multiple Plan Codes?"
		strExceptionPattern2 = "The maximum benefit amount, .*., has previously been paid. Do you want to delete this detail line?"
		'strExceptionPattern2 = "The maximum benefit amount, .*., has previously been paid. Do you want to delete this detail line?"
		
		If Dialog("regexpwndclass:=#32770","ispopupwindow:=True").WinButton("text:=.*OK").Exist(5) Then
		
			ReportMessage "Info", "Dialog box having text - '" & dialogBoxText & "' appeared. Clicking on <b>OK</b> button.", True, "Y"
			Dialog("regexpwndclass:=#32770","ispopupwindow:=True").WinButton("text:=.*OK").Click
			'Dialog("regexpwndclass:=#32770","ispopupwindow:=True").Activate
			'Sendkey "{ENTER}"
		ElseIf Dialog("regexpwndclass:=#32770","ispopupwindow:=True").WinButton("text:=.*OK").Exist(5) Then
			ReportMessage "Info", "Dialog box having text - '" & dialogBoxText & "' appeared. Clicking on <b>OK</b> button.", True, "Y"
			Dialog("regexpwndclass:=#32770","ispopupwindow:=True").WinButton("text:=.*OK").Click			
		ElseIf Dialog("regexpwndclass:=#32770","ispopupwindow:=True").WinButton("text:=.*Yes").Exist(5) Then
		
			If GetRegexMatchCount ( dialogBoxText, strExceptionPattern1) > 0 Then
				ReportMessage "Info", "Dialog box having text - '" & dialogBoxText & "' appeared. Clicking on <b>NO</b> button.", True, "Y"
				Dialog("regexpwndclass:=#32770","ispopupwindow:=True").WinButton("text:=.*No").Click
			ElseIf GetRegexMatchCount ( dialogBoxText, strExceptionPattern2) > 0 Then
				ReportMessage "Info", "Dialog box having text - '" & dialogBoxText & "' appeared. Clicking on <b>NO</b> button.", True, "Y"
				Dialog("regexpwndclass:=#32770","ispopupwindow:=True").WinButton("text:=.*No").Click
			ElseIf GetRegexMatchCount ( dialogBoxText, "A wellness is available for the Calendar year") > 0 Then
				ReportMessage "Info", "Dialog box having text - '" & dialogBoxText & "' appeared. Clicking on <b>NO</b> button.", True, "Y"
				Dialog("regexpwndclass:=#32770","ispopupwindow:=True").WinButton("text:=.*No").Click
			Else
				ReportMessage "Info", "Dialog box having text - '" & dialogBoxText & "' appeared. Clicking on <b>Yes</b> button.", True, "Y"
				Dialog("regexpwndclass:=#32770","ispopupwindow:=True").WinButton("text:=.*Yes").Click
'				Dialog("regexpwndclass:=#32770","ispopupwindow:=True").Activate
'				SendKey "{ENTER}"
			End If
		
		End If
	Wend
		
End Function


Public Function Exit_Mainframe_InMiddle_New()
	'wait 2
'	If Window("regexpwndtitle:= BlueZone Mainframe Display", "text:=S1 - .* - Secure .* - BlueZone Mainframe Display").Exist(2) Then
'		Window("regexpwndtitle:= BlueZone Mainframe Display", "text:=S1 - .* - Secure .* - BlueZone Mainframe Display").Activate
'		Window("regexpwndtitle:= BlueZone Mainframe Display", "text:=S1 - .* - Secure .* - BlueZone Mainframe Display").WinToolbar("regexpwndclass:=ToolbarWindow32", "index:=2").Highlight
'		wait 1
'		Window("regexpwndtitle:= BlueZone Mainframe Display", "text:=S1 - .* - Secure .* - BlueZone Mainframe Display").WinToolbar("regexpwndclass:=ToolbarWindow32", "index:=2").Press 11
'		wait 1
'		Window("regexpwndtitle:= BlueZone Mainframe Display", "text:=S1 - .* - Secure .* - BlueZone Mainframe Display").WinToolbar("regexpwndclass:=ToolbarWindow32", "index:=2").Press 11
'	End If

	If TeWindow("TeWindow").Exist Then
		TeWindow("TeWindow").WinMenu("Menu").Select "Session;  Disconnect"
		wait(1)
		TeWindow("TeWindow").WinMenu("Menu").Select "Session;  Connect"
	End If
	
End Function


Public Function LoginIntoMainFrameSYST_OR_INTG(strMFUId, strMFPwd, MF_Environment)
	
	Set Process = GetObject("Winmgmts:\\")
	Set oMFProcess = Process.ExecQuery("Select * from Win32_Process where Name = 'bzmd.exe' ")
	If oMFProcess.Count > 0 Then
		Exit_Mainframe_InMiddle_New()
		call keyLoginDetails(strMFUId,strMFPwd)
		
	Else
		If MF_Environment="SYST" Then
			Systemutil.Run "C:\Programdata\Microsoft\Windows\Start Menu\Aflac Apps\Bluezone Systest", "", "", "Open"
		ElseIf MF_Environment="INTG" Then
			Systemutil.Run "C:\Programdata\Microsoft\Windows\Start Menu\Aflac Apps\Bluezone Development", "", "", "Open"
		End If
		'Systemutil.Run strExePath, "", "", "Open"
'		Systemutil.Run Trim(TestArgs("BZPath")), "", "", "Open"
		call keyLoginDetails(strMFUId,strMFPwd)
		
	End If
	
End Function

Public Function Mainframe_Login_OR_Relogin_ClaimP010(ByVal strMFEnv, ByVal strMFCOLorNY)

		Dim strMFUId,strMFPwd
		strMFUId = TestArgs("UserID")
		strMFPwd = TestArgs("Password")
						
		If UCase(Trim(strMFEnv)) = "INTG" Then
			LoginIntoMainFrameSYST_OR_INTG strMFUId,strMFPwd , "INTG"
			If UCASE(Trim(strMFCOLorNY)) = "COL" Then
				MySLabel = getScreenLabel()
				Tewindow("TeWindow").TeScreen("label:="& MySLabel).Sendkey "I CICSQTOR"
				Tewindow("TeWindow").TeScreen("label:="& MySLabel).Sendkey TE_ENTER
				WaitForNextScreen()
				MySLabel = getScreenLabel()
				Tewindow("TeWindow").TeScreen("label:="& MySLabel).Sendkey "CICSQTOR"
				Tewindow("TeWindow").TeScreen("label:="& MySLabel).Sendkey TE_ENTER
				WaitForNextScreen()
			ElseIf UCASE(Trim(strMFCOLorNY)) = "NY" Then
				MySLabel = getScreenLabel()
				Tewindow("TeWindow").TeScreen("label:="& MySLabel).Sendkey "I CICSQNYL"
				Tewindow("TeWindow").TeScreen("label:="& MySLabel).Sendkey TE_ENTER
				WaitForNextScreen()
				MySLabel = getScreenLabel()
				Tewindow("TeWindow").TeScreen("label:="& MySLabel).Sendkey "CICSQNYL"
				Tewindow("TeWindow").TeScreen("label:="& MySLabel).Sendkey TE_ENTER
				WaitForNextScreen()
			End If 
		ElseIf UCase(Trim(strMFEnv)) = "SYST" Then
			LoginIntoMainFrameSYST_OR_INTG strMFUId,strMFPwd , "SYST"
			If UCASE(Trim(strMFCOLorNY)) = "COL" Then
				MySLabel = getScreenLabel()
				Tewindow("TeWindow").TeScreen("label:="& MySLabel).Sendkey "I CICST"
				Tewindow("TeWindow").TeScreen("label:="& MySLabel).Sendkey TE_ENTER
				WaitForNextScreen()
				MySLabel = getScreenLabel()
				Tewindow("TeWindow").TeScreen("label:="& MySLabel).Sendkey "CICST"
				Tewindow("TeWindow").TeScreen("label:="& MySLabel).Sendkey TE_ENTER
				WaitForNextScreen()
			ElseIf UCASE(Trim(strMFCOLorNY)) = "NY" Then
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
		Tewindow("TeWindow").TeScreen("label:="& MySLabel).Sendkey "P010"
		Tewindow("TeWindow").TeScreen("label:="& MySLabel).Sendkey TE_ENTER
		WaitForNextScreen()
		
		MySLabel = getScreenLabel()
		strScreenHeader = Tewindow("TeWindow").TeScreen("label:="& MySLabel).GetText (2,30,2,50)
		If strScreenHeader <> "CLAIMS PAYMENT SYSTEM" Then
			Mainframe_Login_OR_Relogin_ClaimP010 = -1
			fnCloseMainFrame ()
			Exit Function
		Else
			Mainframe_Login_OR_Relogin_ClaimP010 = 0
		End If
End Function
	
	
Public Function ValidateFromClaimP010(rowNumber)

	'fnCloseMainFrame ()
	
	If GetDictItem(cpsDataTableDictObj, "Environment#" & rowNumber) = "SYST" Then
		var_Environment = "SYST"
	ElseIf GetDictItem(cpsDataTableDictObj, "Environment#" & rowNumber) = "INTG" Then	
		var_Environment = "INTG"
	End If

	If GetDictItem(cpsDataTableDictObj, "Region#" & rowNumber) = "COLUMBUS" Then
		var_Region = "COL"
	ElseIf GetDictItem(cpsDataTableDictObj, "Region#" & rowNumber) = "NEW YORK" Then	
		var_Region = "NY"
	End If
	
	If Mainframe_Login_OR_Relogin_ClaimP010 (var_Environment, var_Region) <> 0 Then
		ReportMessage "Fail", "Could not login into Claim P010 System.", True, "Y"
		ValidateFromClaimP010 = -1
		Exit Function
	Else
		ReportMessage "Pass", "Successfully logged into Claim P010 System.", True, "Y"
	End If
	WaitForNextScreen()
	
	MySLabel = getScreenLabel()
	strScreenHeader = Tewindow("TeWindow").TeScreen("label:="& MySLabel).GetText (3,35,3,45)
	If strScreenHeader = "MAIN DRIVER" Then
		MySLabel = getScreenLabel()
		Tewindow("TeWindow").TeScreen("label:="& MySLabel).SetText 32,44, 01
		Tewindow("TeWindow").TeScreen("label:="& MySLabel).SendKey TE_ENTER
		WaitForNextScreen()
	End If
	
	MySLabel = getScreenLabel()
	strScreenHeader = Tewindow("TeWindow").TeScreen("label:="& MySLabel).GetText (3,34,3,45)
	If strScreenHeader = "INQUIRY MENU" Then
		MySLabel = getScreenLabel()
		Tewindow("TeWindow").TeScreen("label:="& MySLabel).SetText 15,49, ClaimNumber
		Tewindow("TeWindow").TeScreen("label:="& MySLabel).SendKey TE_ENTER
		WaitForNextScreen()
	End If
	
	MySLabel = getScreenLabel()
	var_DiagCodeFromP010 = Tewindow("TeWindow").TeScreen("label:="& MySLabel).GetText (12,21,12,28)
	var_DiagCodeFromP010 = Trim(Replace(var_DiagCodeFromP010,".",""))
	
	If var_DiagCodeFromP010 = CPS_DiagCode Then
		ReportMessage "Info", "<br><br>Diagnosis Code displayed in P010 is: <b> "&var_DiagCodeFromP010&" </b>.<br>Diagnosis Code Provided in CPS application while raising a claim:  <b>"& CPS_DiagCode&"</b>", True, "Y"
		ReportMessage "Pass", "Diagnosis Code value displayed on P010 is same as provided in CPS application while raising a claim.", True, "Y"
		ValidateFromClaimP010=0
	Else 
		ReportMessage "Fail", "<br><br>Diagnosis Code displayed in P010:  <b> "&var_DiagCode&" </b> <br>Diagnosis Code Provided in CPS application while raising a claim: <b>  "& CPS_DiagCode &" </b>", True, "Y"
		ValidateFromClaimP010=-1
		'Exit Function
	End If
	
	'fnCloseMainFrame ()
	
End Function



Public Function LaunchClaimsCentral(ByVal URL)
	
	'URL = "http://claimscentral-syst.nt.lab.com/ClaimsCentral/1.5/ClaimsCentral/Clients/Aflac.ClaimsCentral.Client.application"
	LaunchNNavigateURL URL
	
	If WpfWindow("swfwin_ClaimsCentral").Exist(70) Then
		WpfWindow("swfwin_ClaimsCentral").Activate
		ReportMessage "Info", "Successfully Launched Claims Central Application.", True, "Y"
		LaunchClaimsCentral = 0
	Else
		If SwfWindow("Application Run - Security").Exist Then
			ReportMessage "Info", "Claim Central Installation window appeared. Clicking on Run Button.", True, "Y"
			SwfWindow("Application Run - Security").Activate
			SwfWindow("Application Run - Security").SwfButton("Run").Click
		End If
		
		If WpfWindow("swfwin_ClaimsCentral").Exist(50) Then
			WpfWindow("swfwin_ClaimsCentral").Activate
			ReportMessage "Info", "Successfully Launched Claims Central Application.", True, "Y"
			LaunchClaimsCentral = 0
		Else
			ReportMessage "Fail", "Couldn't launch Claims Central Application.", True, "Y"
			LaunchClaimsCentral = -1
		End If

	End If	

End Function

'Added by Amit on 08/14/2018 to handle the PEND and DENY cases.
Public Function fnPendORDenyProcessing (var_letterCode)

	If Environment.Value("var_Action") <> "PAY" Then
			
		If SwfWindow("swfwin_CPSAuditResults").Exist(10) Then
			Reportmessage "Pass", "CPS - Audit Results screen appeared. Now Clicking on Save Button.", True, "Y"
			SwfWindow("swfwin_CPSAuditResults").SwfComboBox("cboReason1").Select 1
			SwfWindow("swfwin_CPSAuditResults").SwfButton("Save").Click
			Reportmessage "Info", "Now Clicking on 'Configure Letter' Link.", True, "Y"
			SwfWindow("Claims Payment System").SwfLabel("Configure Letter").Click
			
			blnNetErrorFlag = False
			Do
				If SwfWindow("Claims Payment System").SwfWindow("Claims Payment System_2").SwfButton("Continue").Exist(3) Then
					SwfWindow("Claims Payment System").SwfWindow("Claims Payment System_2").SwfButton("Continue").Click
					blnNetErrorFlag = True
				Else
					Exit Do
				End If
			Loop While True
			
			Reportmessage "Info", "Now selecting the 'Letter Code' as : " & var_letterCode, True, "Y"
			SwfWindow("Claims Payment System").SwfWindow("Claims Payment System").SwfComboBox("LetterCode").Select var_letterCode
			
			If Environment.Value("var_Action") = "PEND" Then
				'Reportmessage "Info", "Now selecting the 'Paragraph 1' as: AM and 'Paragraph 2' as: AR", True, "Y"
				SwfWindow("Claims Payment System").SwfWindow("Claims Payment System").SwfComboBox("cmb_LanguageSelector").Select 1
				SwfWindow("Claims Payment System").SwfWindow("Claims Payment System").SwfComboBox("cmb_LanguageSelector_2").Select 2
				Reportmessage "Info", "Selected the 'Paragraph 1' and 'Paragraph 2'.", True, "Y"
			ElseIf Environment.Value("var_Action") = "DENY" Then
				'Reportmessage "Info", "Now selecting the 'Paragraph 1' as: A1 and 'Paragraph 2' as: A2", True, "Y"
				SwfWindow("Claims Payment System").SwfWindow("Claims Payment System").SwfComboBox("cmb_LanguageSelector").Select 1
				SwfWindow("Claims Payment System").SwfWindow("Claims Payment System").SwfComboBox("cmb_LanguageSelector_2").Select 2
				Reportmessage "Info", "Selected the 'Paragraph 1' and 'Paragraph 2'.", True, "Y"
			End If			
			Reportmessage "Info", "Screenshot after selecting the Paragraph codes. Now Clicking on 'Save' button.", True, "Y"
			SwfWindow("Claims Payment System").SwfWindow("Claims Payment System").SwfButton("Save").Click
			
			If Dialog("Warning").WinButton("OK").Exist(3) Then
				ReportMessage "Info", "A warning dialog appeared. Clicking on OK button.", True, "Y"
				Dialog("Warning").WinButton("OK").Click
			End If		
			
			strPolicyHolderName = Trim(SwfWindow("Claims Payment System").SwfLabel("PolicyHolderText").GetROProperty("text"))' & generateTestData("Numeric", 3)
			ReportMessage "Info", "PolicyHolder name captured is: " & strPolicyHolderName & ". Now setting this value in the Dear (Name) field.", True, "Y"
			Environment.Value("strPolicyHolderName") = strPolicyHolderName
			SwfWindow("Claims Payment System").SwfEdit("DearName").Set strPolicyHolderName
			Reportmessage "Info", "Screenshot after Clicking on Save Button. Now Clicking on 'Process' button.", True, "Y"
			SwfWindow("Claims Payment System").SwfButton("Process").Click
		End If
	
	End If

End Function

'Added by Amit Garg on 07/27/2018 to do the PSW Validation for Web Methods
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


'Added by Amit Garg on 08/22/2018 to input the Mod1, Mod2, Mod3 and Mod4 fields.
Public Function fnKeyModDetails (rowNum, strPolicyType, strMod1, strMod2, strMod3, strMod4)

	Select Case strPolicyType
		Case "AD-ACCIDENT", "VS-VISION"
			Set objTBLDetailLine = UIAWindow("ClaimsPaymentSystemUIA").UIATable("EobItemsGrid")
			If NOT (IsNull(strMod1) OR IsEmpty(strMod1) OR strMod1 = "")  Then
				objTBLDetailLine.ClickCell rowNum, "Mod1"
				Sendkey strMod1
				wait 0,500
				Sendkey "{Tab}"					
			End If
			If NOT (IsNull(strMod2) OR IsEmpty(strMod2) OR strMod2 = "")  Then
				objTBLDetailLine.ClickCell rowNum, "Mod2"
				Sendkey strMod2
				wait 0,500
				Sendkey "{Tab}"					
			End If
			If NOT (IsNull(strMod3) OR IsEmpty(strMod3) OR strMod3 = "")  Then
				objTBLDetailLine.ClickCell rowNum, "Mod3"
				Sendkey strMod3
				wait 0,500
				Sendkey "{Tab}"					
			End If
			If NOT (IsNull(strMod4) OR IsEmpty(strMod4) OR strMod4 = "")  Then
				objTBLDetailLine.ClickCell rowNum, "Mod4"
				Sendkey strMod4
				wait 0,500
				Sendkey "{Tab}"					
			End If

			Set objGrid = WpfWindow("Claims Payment System").SwfObject("SwfObject").SwfObject("elementHost1").WpfWindow("WpfWindow_2").SwfObject("SwfObject").SwfObject("elementHost1").WpfWindow("WpfWindow").WpfTable("EobItemsGrid")

			Wait 1
			strSelectedMod = objGrid.Object.Items.Item(rowNum).Mod1
			ReportMessage "Info", "Input Mod1: " & strMod1 & " Selected Mod1: " & strSelectedMod, True, "N"
			
			strSelectedMod = objGrid.Object.Items.Item(rowNum).Mod2
			ReportMessage "Info", "Input Mod2: " & strMod2 & " Selected Mod2: " & strSelectedMod, True, "N"
			
			strSelectedMod = objGrid.Object.Items.Item(rowNum).Mod3
			ReportMessage "Info", "Input Mod3: " & strMod3 & " Selected Mod3 " & strSelectedMod, True, "N"
			
			strSelectedMod = objGrid.Object.Items.Item(rowNum).Mod4
			ReportMessage "Info", "Input Mod4: " & strMod4 & " Selected Mod4: " & strSelectedMod, True, "N"

'			WpfWindow("wpfwin_ClaimData").SwfObject("swfobj_ElementHost").WpfWindow("wpfwin_ElemHost").WpfObject("wpfobj_EobItemsGrid").ActivateCell rowNum, "Chg Amt"
'			Wait 1
'			strSelectedMod = WpfWindow("wpfwin_ClaimData").SwfObject("swfobj_ElementHost").WpfWindow("wpfwin_ElemHost").WpfObject("wpfobj_EobItemsGrid").GetCellData (rowNum, "Mod1")
'			ReportMessage "Info", "Input Mod1: " & strMod1 & " Selected Mod1: " & strSelectedMod, True, "N"
'			
'			strSelectedMod = WpfWindow("wpfwin_ClaimData").SwfObject("swfobj_ElementHost").WpfWindow("wpfwin_ElemHost").WpfObject("wpfobj_EobItemsGrid").GetCellData (rowNum, "Mod2")
'			ReportMessage "Info", "Input Mod2: " & strMod2 & " Selected Mod2: " & strSelectedMod, True, "N"
'			
'			strSelectedMod = WpfWindow("wpfwin_ClaimData").SwfObject("swfobj_ElementHost").WpfWindow("wpfwin_ElemHost").WpfObject("wpfobj_EobItemsGrid").GetCellData (rowNum, "Mod3")
'			ReportMessage "Info", "Input Mod3: " & strMod3 & " Selected Mod3 " & strSelectedMod, True, "N"
'			
'			strSelectedMod = WpfWindow("wpfwin_ClaimData").SwfObject("swfobj_ElementHost").WpfWindow("wpfwin_ElemHost").WpfObject("wpfobj_EobItemsGrid").GetCellData (rowNum, "Mod4")
'			ReportMessage "Info", "Input Mod4: " & strMod4 & " Selected Mod4: " & strSelectedMod, True, "N"
	
		Case Else
			If NOT (IsNull(strMod1) OR IsEmpty(strMod1) OR strMod1 = "")  Then
				fnSelectModInColumnBasedOnPartialText rowNum, "Mod1", strMod1
				Wait 1
			End If
			If NOT (IsNull(strMod2) OR IsEmpty(strMod2) OR strMod2 = "")  Then
				fnSelectModInColumnBasedOnPartialText rowNum, "Mod2", strMod2
				Wait 1
			End If
			If NOT (IsNull(strMod3) OR IsEmpty(strMod3) OR strMod3 = "")  Then
				fnSelectModInColumnBasedOnPartialText rowNum, "Mod3", strMod3
				Wait 1
			End If
			If NOT (IsNull(strMod4) OR IsEmpty(strMod4) OR strMod4 = "")  Then
				fnSelectModInColumnBasedOnPartialText rowNum, "Mod4", strMod4
				Wait 1
			End If
			
			strSelectedMod = WpfWindow("wpfwin_ClaimData").SwfTable("swftbl_DetailLines").GetCellData(rowNum, "Mod1")
			ReportMessage "Info", "Input Mod1: " & strMod1 & " Selected Mod1: " & strSelectedMod, True, "N"
			
			strSelectedMod = WpfWindow("wpfwin_ClaimData").SwfTable("swftbl_DetailLines").GetCellData(rowNum, "Mod2")
			ReportMessage "Info", "Input Mod2: " & strMod2 & " Selected Mod2: " & strSelectedMod, True, "N"
			
			strSelectedMod = WpfWindow("wpfwin_ClaimData").SwfTable("swftbl_DetailLines").GetCellData(rowNum, "Mod3")
			ReportMessage "Info", "Input Mod3: " & strMod3 & " Selected Mod3: " & strSelectedMod, True, "N"
			
			strSelectedMod = WpfWindow("wpfwin_ClaimData").SwfTable("swftbl_DetailLines").GetCellData(rowNum, "Mod4")
			ReportMessage "Info", "Input Mod4: " & strMod4 & " Selected Mod4: " & strSelectedMod, True, "N"
			
	End Select
	
End Function


Public Function fnKeyCdDetails (rowNum, strPolicyType, strCd1, strCd2, strCd3, strCd4)

	Dim blnStatus : blnStatus = True
	strNote = "Test data is data which has been specifically identified for use in tests, typically of a computer program. Some data may be used in a confirmatory way, typically to verify that a given set of input to a given function produces some expected result..Test data is data which has been specifically identified for use in tests, typically of a computer program. Some data may be used in a confirmatory way, typically to verify that a given set of input to a given function produces some expected result.."

	Select Case strPolicyType
	
		Case "AD-ACCIDENT", "VS-VISION"
		
			WpfWindow("wpfwin_ClaimData").SwfObject("swfobj_ElementHost").WpfWindow("wpfwin_ElemHost").WpfObject("wpfobj_EobItemsGrid").ActivateCell rowNum, "Cd1"
			SendKey "999-"
			SendKey "{TAB}"
		
		Case "SD-SHORT TERM DISABILITY"
		
		Case Else
			'To select the 999- in the Cd 1 column which will open the Audit results screen.
'			fnSelectModInColumnBasedOnPartialText rowNum, "Cd 1", "999-"
'			Wait 1
'			SendKey "{TAB}"
'			Wait 1
			WpfWindow("wpfwin_ClaimData").SwfTable("swftbl_DetailLines").ActivateCell 1, "Cd 4"
	End Select
	
	If SwfWindow("CPS - Audit Results").Exist Then
		ReportMessage "Pass", "'Select Payment Nodes' screen opened successfully.", True, "Y"
		Wait 1
		If NOT (IsNull(strCd1) OR IsEmpty(strCd1) OR strCd1 = "")  Then
			strSelectedText = SelectByPartTxt (SwfWindow("CPS - Audit Results").SwfComboBox("cboNote1"), strCd1) 					
			strTmpSelection = SwfWindow("CPS - Audit Results").SwfComboBox("cboNote1").GetSelection
			If InStr(strTmpSelection, strCd1) > 0 Then
				ReportMessage "Pass", "Input Cd1: " & strCd1 & " Selected Cd1: " & strTmpSelection, True, "N"
				If InStr(strCd1, "999") > 0 Then 
					SwfWindow("CPS - Audit Results").SwfEditor("Note1Entered").Type strNote
					ReportMessage "Info", "Note1 entered as: ", True, "N"
					ReportMessage "Info", strNote, True, "N"
				End If
			Else
				ReportMessage "Fail", "Input Cd1: " & strCd1 & " Selected Cd1: " & strTmpSelection & ". Please check the input sheet. " & strCd1 & " may not exists in the list box on screen.", True, "Y"
				'fnKeyCdDetails = -1
				'Exit Function
				blnStatus = False
			End If				
			
		End If
		Wait 1
		If NOT (IsNull(strCd2) OR IsEmpty(strCd2) OR strCd2 = "")  Then
			strSelectedText = SelectByPartTxt (SwfWindow("CPS - Audit Results").SwfComboBox("cboNote2"), strCd2) 
			strTmpSelection = SwfWindow("CPS - Audit Results").SwfComboBox("cboNote2").GetSelection					
			If InStr(strTmpSelection, strCd2) > 0 Then
				ReportMessage "Pass", "Input Cd2: " & strCd2 & " Selected Cd2: " & strTmpSelection, True, "N"
				If InStr(strCd2, "999") > 0 Then 
					SwfWindow("CPS - Audit Results").SwfEditor("Note2Entered").Type strNote
					ReportMessage "Info", "Note2 entered as: ", True, "N"
					ReportMessage "Info", strNote, True, "N"
				End If
			Else
				ReportMessage "Fail", "Input Cd2: " & strCd2 & " Selected Cd2: " & strTmpSelection & ". Please check the input sheet. " & strCd2 & " may not exists in the list box on screen.", True, "Y"
'				fnKeyCdDetails = -1
'				Exit Function
				blnStatus = False
			End If		
			
		End If
		Wait 1
		If NOT (IsNull(strCd3) OR IsEmpty(strCd3) OR strCd3 = "")  Then
			strSelectedText = SelectByPartTxt (SwfWindow("CPS - Audit Results").SwfComboBox("cboNote3"), strCd3) 						
			strTmpSelection = SwfWindow("CPS - Audit Results").SwfComboBox("cboNote3").GetSelection
			If InStr(strTmpSelection, strCd3) > 0 Then
				ReportMessage "Pass", "Input Cd3: " & strCd3 & " Selected Cd3: " & strTmpSelection, True, "N"
				If InStr(strCd3, "999") > 0 Then 
					SwfWindow("CPS - Audit Results").SwfEditor("Note3Entered").Type strNote
					ReportMessage "Info", "Note3 entered as: ", True, "N"
					ReportMessage "Info", strNote, True, "N"
				End If
			Else
				ReportMessage "Fail", "Input Cd3: " & strCd3 & " Selected Cd3: " & strTmpSelection & ". Please check the input sheet. " & strCd3 & " may not exists in the list box on screen.", True, "Y"
'				fnKeyCdDetails = -1
'				Exit Function
				blnStatus = False
			End If	
						
		End If
		Wait 1
		If NOT (IsNull(strCd4) OR IsEmpty(strCd4) OR strCd4 = "")  Then
			strSelectedText = SelectByPartTxt (SwfWindow("CPS - Audit Results").SwfComboBox("cboNote4"), strCd4) 					
			strTmpSelection = SwfWindow("CPS - Audit Results").SwfComboBox("cboNote4").GetSelection
			If InStr(strTmpSelection, strCd4) > 0 Then
				ReportMessage "Pass", "Input Cd4: " & strCd4 & " Selected Cd4: " & strTmpSelection, True, "N"
				If InStr(strCd4, "999") > 0 Then 
					SwfWindow("CPS - Audit Results").SwfEditor("Note4Entered").Type strNote
					ReportMessage "Info", "Note4 entered as: ", True, "N"
					ReportMessage "Info", strNote, True, "N"
				End If
			Else
				ReportMessage "Fail", "Input Cd4: " & strCd4 & " Selected Cd4: " & strTmpSelection & ". Please check the input sheet. " & strCd4 & " may not exists in the list box on screen.", True, "Y"
'				fnKeyCdDetails = -1
'				Exit Function
				blnStatus = False
			End If			
			
		End If	
		
		ReportMessage "Info", "'Select Payment Notes' Screen screenshot before clicking on 'Save' button. Now clicking on Save button.", True, "Y"
		SwfWindow("CPS - Audit Results").SwfButton("Save").Click
		While Window("Microsoft Word").WinObject("Spelling: English (U.S.)").WinButton("Cancel").Exist(7)
			ReportMessage "Info", "1 Spell Check Box appeared. Clicking on Cancel button.", True, "Y"
			Window("Microsoft Word").WinObject("Spelling: English (U.S.)").WinButton("Cancel").Click	
		Wend
		
		If blnStatus = True Then
			fnKeyCdDetails = 0
		Else
			fnKeyCdDetails = -1		
		End If
		
	Else
		ReportMessage "Fail", "'Select Payment Nodes' screen did not open. Exiting the test..", True, "Y"
		fnKeyCdDetails = -1	
	End If	
	
End Function


' Function SelectByPartTxt
' -------------------------
' Select the first matching list item by part of its text value
' Returns - Text of selected item - if the item exists
' Author - Amit Garg
'@Description Selects an item in the list by part of its text value
'@Documentation Select item containing &lt;strPartText&gt; in the &lt;Test object name&gt;list
Public Function SelectByPartTxt(obj, strPartText)

	Dim item_count, all_items, arrItems, name_property, selected_text, iSel
	' Get the all items text property from the test object
	all_items = obj.GetROProperty("all items")
	arrItems = Split(all_items, vbLf)
	'name_property = obj.GetTOProperty("Name")
	
	If InStr(all_items, strPartText) > 0 Then
		' Get the item count property from the test object
		item_count = obj.GetROProperty("items count")
		'Select the item containing the partial string
		intItemCounter = 0
		For iSel = 0 to uBound(arrItems)
			If Instr(arrItems(iSel), "-") > 0  Then
				intItemCounter = intItemCounter + 1
			End If
			If Instr(arrItems(iSel), strPartText) > 0 Then
				obj.Select intItemCounter				
				Exit For
			End If
		Next
		selected_text = obj.GetROProperty("selection")
		'Reporter.ReportEvent micPass, "SelectByPartTxt Succeeded", "The item &lt;" & selected_text & "&gt; is selected"
		SelectByPartTxt = selected_text
	Else
		Reporter.ReportEvent micFail, "SelectByPartTxt Failed", "The text &lt;" & strPartText & "&gt; is NOT contained in any selectable item"
		'SelectByPartTxt = ""
	End If
	
End Function

Public Function ModSelectByPartTxt(obj, strPartText)

	Dim item_count, all_items, arrItems, name_property, selected_text, iSel
	' Get the all items text property from the test object
	all_items = obj.GetROProperty("all items")
	arrItems = Split(all_items, vbLf)
	'name_property = obj.GetTOProperty("Name")
	
	If InStr(all_items, strPartText) > 0 Then
		' Get the item count property from the test object
		item_count = obj.GetROProperty("items count")
		'Select the item containing the partial string
		For iSel = 0 to item_count - 1
			If Instr(arrItems(iSel), strPartText) > 0 Then
				obj.Select iSel
				Exit For
			End If
		Next

	Else
		Reporter.ReportEvent micFail, "ModSelectByPartTxt Failed", "The text &lt;" & strPartText & "&gt; is NOT contained in any selectable item"
	End If
	
End Function


Public Function fnGetPaymentNotesFromClaimsExpandedDisplay (strCd1, strCd2, strCd3, strCd4)

	fnGetPaymentNotesFromClaimsExpandedDisplay = 0
	
	Set objDesc = Description.Create
	objDesc("micclass").value = "SwfLabel"
	objDesc("swfname").value = "labelNoteReason.*"
	strNotes = ""
	Set objNotesObjects = SwfWindow("Claims Payment System_3").SwfWindow("Claims Payment System").SwfObject("NoteReasonPanel").ChildObjects(objDesc)
	For i = 0 To objNotesObjects.Count - 1 Step 1
		strNotes = strNotes & " " & Trim(objNotesObjects(i).GetROProperty("text"))
	Next 
	strNotes = Trim(strNotes)
	
	If NOT (IsNull(strCd1) OR IsEmpty(strCd1) OR strCd1 = "")  Then
		If Instr(strNotes, strCd1) > 0 Then
			ReportMessage "Pass", "Payment Note " & strCd1 & " exists on Payment Notes displayed on screen " & strNotes, True, "N"
		Else
			ReportMessage "Fail", "Payment Note " & strCd1 & " does not exist on Payment Notes displayed on screen " & strNotes, True, "N"
			fnGetPaymentNotesFromClaimsExpandedDisplay = -1
		End If
	End If
	
	If NOT (IsNull(strCd2) OR IsEmpty(strCd2) OR strCd2 = "")  Then
		If Instr(strNotes, strCd2) > 0 Then
			ReportMessage "Pass", "Payment Note " & strCd2 & " exists on Payment Notes displayed on screen " & strNotes, True, "N"
		Else
			ReportMessage "Fail", "Payment Note " & strCd2 & " does not exist on Payment Notes displayed on screen " & strNotes, True, "N"
			fnGetPaymentNotesFromClaimsExpandedDisplay = -1
		End If
	End If
	
	If NOT (IsNull(strCd3) OR IsEmpty(strCd3) OR strCd3 = "")  Then
		If Instr(strNotes, strCd3) > 0 Then
			ReportMessage "Pass", "Payment Note " & strCd3 & " exists on Payment Notes displayed on screen " & strNotes, True, "N"
		Else
			ReportMessage "Fail", "Payment Note " & strCd3 & " does not exist on Payment Notes displayed on screen " & strNotes, True, "N"
			fnGetPaymentNotesFromClaimsExpandedDisplay = -1
		End If
	End If
	
	If NOT (IsNull(strCd4) OR IsEmpty(strCd4) OR strCd4 = "")  Then
		If Instr(strNotes, strCd4) > 0 Then
			ReportMessage "Pass", "Payment Note " & strCd4 & " exists on Payment Notes displayed on screen " & strNotes, True, "N"
		Else
			ReportMessage "Fail", "Payment Note " & strCd4 & " does not exist on Payment Notes displayed on screen " & strNotes, True, "N"
			fnGetPaymentNotesFromClaimsExpandedDisplay = -1
		End If
	End If	
		
	Set objDesc = Nothing
	Set objNotesObjects = Nothing
End Function


Public Function fnSelectModInColumnBasedOnPartialText (rowNum, strColName, strPartialValToBeSelected)

	Set objDesc = Description.Create
	objDesc("micclass").value = "SwfComboBox"
	'Wait 2
	WpfWindow("wpfwin_ClaimData").SwfTable("swftbl_DetailLines").ActivateCell rowNum, strColName
	WpfWindow("wpfwin_ClaimData").SwfTable("swftbl_DetailLines").ActivateCell rowNum, strColName
	Wait 1
	Set objChildCombo = WpfWindow("wpfwin_ClaimData").SwfTable("swftbl_DetailLines").ChildObjects(objDesc)
'	ModSelectByPartTxt objChildCombo(0), strPartialValToBeSelected
	Set objDesc = Nothing
	Set objChildCombo = Nothing
	
End Function


Public Function SelectClaimantNew (strClaimant, strClaimantName, strClaimantDOB, strClaimantSex, strDateOfDeath)
	
	strallItems=WpfWindow("wpfwin_Research").SwfComboBox("ClaimantComboBox").GetROProperty("all items")
	arrAllItem=Split(strallItems,vbLf)
	Set objList = WpfWindow("wpfwin_Research").SwfComboBox("ClaimantComboBox")
	
	strTypeOfCoverage = WpfWindow("wpfwin_Research").SwfComboBox("TypeCoverageComboBox").GetSelection
	
	Select Case UCASE(strClaimant)
		Case "INSURED"
		
			If SelectItemBasedOnPartialText (objList, arrAllItem, "1~") = 0 Then
				SelectClaimantNew = 0
			Else
				SelectClaimantNew = -1
			End If
			
		Case "SPOUSE"
			If strTypeOfCoverage = "Individual" OR strTypeOfCoverage = "Single-Parent" Then
				ReportMessage "Fail", "The Type of Coverage for the Policy is 'Individual' or 'Single-Parent'. Spouse details cannot be added.", True, "Y"
				SelectClaimantNew = -1
			Else
				If SelectItemBasedOnPartialText (objList, arrAllItem, "2~") = 0 Then
					SelectClaimantNew = 0
				Else
					SelectClaimantNew = -1
				End If
			End If
			
		Case "CHILD"
			If strTypeOfCoverage = "Individual" OR strTypeOfCoverage = "Husband/Spouse" Then
				ReportMessage "Fail", "The Type of Coverage for the Policy is 'Individual' or 'Husband/Spouse'. Child details cannot be added.", True, "Y"
				SelectClaimantNew = -1
			Else
				WpfWindow("wpfwin_PolicySearch").SwfButton("AddClaimantButton").Click
				If SwfWindow("ClaimPaymentSystem").SwfEdit("ClaimantName").Exist(2) Then
					ReportMessage "Pass", "Claim Payment System for Add Claimant window Open Successfully.", True, "Y"
					SwfWindow("ClaimPaymentSystem").SwfEdit("ClaimantName").Set strClaimantName
					SwfWindow("ClaimPaymentSystem").SwfComboBox("ClaimantRelationship").Select "3-Child"
					SwfWindow("ClaimPaymentSystem").SwfEdit("ClaimantDateOfBirth").Set strClaimantDOB
					SwfWindow("ClaimPaymentSystem").SwfComboBox("ClaimantSex").Select strClaimantSex
					ReportMessage "Pass", "Entered Claimant Name as :<b>"&strClaimantName&"</b> , Claimant Date Of Birth as : <b>"&strClaimantDOB&",</b> Claimant Sex as : <b>"&strClaimantSex&" </b>", True, "Y"
					SwfWindow("ClaimPaymentSystem").SwfButton("SaveClaimant").Click
					
					Wait 2
					strallItems=WpfWindow("wpfwin_Research").SwfComboBox("ClaimantComboBox").GetROProperty("all items")
					arrAllItem=Split(strallItems,vbLf)
					Set objList = WpfWindow("wpfwin_Research").SwfComboBox("ClaimantComboBox")
					
					If SelectItemBasedOnPartialText (objList, arrAllItem, "3~") = 0 Then
						SelectClaimantNew = 0
					Else
						SelectClaimantNew = -1
					End If
				Else
					ReportMessage "Fail", "Claim Payment System for Add Claimant window not Open Successfully.", True, "Y"
					SelectClaimantNew = -1
				End If
			End If
			
		Case "GRANDCHILD"	
			'Not implemented as of now.
			
		Case Else
			ReportMessage "FAIL", "Valid values for Claimant are: Insured, Spouse, Child & Grandchild. Please correct input sheet", True, "N"
			SelectClaimantNew = -1
	End Select
	
	If IsNull(strDateOfDeath) OR IsEmpty(strDateOfDeath) OR Trim(strDateOfDeath) = "" Then
		
	Else	
		WpfWindow("wpfwin_PolicySearch").SwfEdit("DeathDate").Set strDateOfDeath
	End If
	
End Function

Public Function SelectItemBasedOnPartialText (ByVal objList, ByVal arrAllItem, ByVal strPartialToSelect)

	Dim blnItemFound : blnItemFound = False
	
	For i = lBound(arrAllItem) To uBound(arrAllItem) Step 1
		If Instr(arrAllItem(i), strPartialToSelect) > 0 Then
			blnItemFound = True
			objList.Select arrAllItem(i)
			Exit For
		End If
	Next
	
	If blnItemFound = False Then
		ReportMessage "Info", "Couldn't find any Item containing partial text '" & strPartialToSelect & "'", True, "Y"
		SelectItemBasedOnPartialText = -1
	Else
		ReportMessage "Info", "Selected Item: " & arrAllItem(i), True, "Y"
		SelectItemBasedOnPartialText = 0
	End If
	
End Function


Public Function Get_Insured_Detail_FromMainframe(ByVal rowNum)
	Dim strScreen
	'Call LoginIntoMainFrame(TestArgs("UserID"), TestArgs("Password"))
	'WaitForNextScreen()
	strPolicy = GetDictItem(cpsDataTableDictObj, "PolicyNumber#" & rowNum)
	strEnvironment = GetDictItem(cpsDataTableDictObj, "Environment#" & rowNum)
	strRegion = GetDictItem(cpsDataTableDictObj, "Region#" & rowNum)

	Mainframe_Login_OR_ReLogin TestArgs("UserID"), TestArgs("Password"), strEnvironment, strRegion
	
	WaitForNextScreen()
	MySLabel = getScreenLabel()
	Tewindow("TeWindow").TeScreen("label:="& MySLabel).Sendkey "ntro"
	Tewindow("TeWindow").TeScreen("label:="& MySLabel).Sendkey TE_ENTER
	WaitForNextScreen()
	MySLabel = getScreenLabel()
	ReportMessage "Pass", "MAIN MENU SELECTION Screen Open.", True, "Y"
	Tewindow("TeWindow").TeScreen("label:="& MySLabel).SetText 40,39,"68"
	Tewindow("TeWindow").TeScreen("label:="& MySLabel).Sendkey TE_ENTER
	WaitForNextScreen()
	MySLabel = getScreenLabel()
	ReportMessage "Pass", "C U S T O M E R    I D    S Y S T E M Screen Open.", True, "Y"
	Tewindow("TeWindow").TeScreen("label:="& MySLabel).SetText 18,45,strPolicy
	Tewindow("TeWindow").TeScreen("label:="& MySLabel).Sendkey TE_ENTER
	WaitForNextScreen()
	MySLabel = getScreenLabel()
	ReportMessage "Pass", "C U S T O M E R  I N F O R M A T I O N  F I L E Screen Open.", True, "Y"
	strName = trim(Tewindow("TeWindow").TeScreen("label:="& MySLabel).GetText(6,30,6,58))
	strStatus =Tewindow("TeWindow").TeScreen("label:="& MySLabel).GetText(13,61,13,61)
	strDOB = Tewindow("TeWindow").TeScreen("label:="& MySLabel).GetText(13,22,13,31)
	Get_Insured_Detail_FromMainframe = strName&"#"&strStatus&"#"&strDOB
	
End Function


Public Function Mainframe_Login_OR_ReLogin (strMFUId, strMFPwd, strEnv, strRegion)

		strBlueZoneIntg = "C:\ProgramData\Microsoft\Windows\Start Menu\Aflac Apps\BlueZone Development"
		strBlueZoneSyst = "C:\ProgramData\Microsoft\Windows\Start Menu\Aflac Apps\BlueZone Systest"
		
		Set Process = GetObject("Winmgmts:\\")
		Set oMFProcess = Process.ExecQuery("Select * from Win32_Process where Name = 'bzmd.exe' ")
		If oMFProcess.Count > 0 Then
			Exit_Mainframe_InMiddle()
			call keyLoginDetails(strMFUId,strMFPwd)
		Else
			If Instr(lcase(strEnv), "sys") > 0 Then
				Systemutil.Run strBlueZoneSyst, "", "", "Open"
			Else
				Systemutil.Run strBlueZoneIntg, "", "", "Open"
			End If
			call keyLoginDetails(strMFUId,strMFPwd)
		End If
		
		If Instr(lcase(strEnv), "sys") > 0 Then
		
			If Instr(lcase(strRegion), "col") > 0 Then
				MySLabel = getScreenLabel()
				Tewindow("TeWindow").TeScreen("label:="& MySLabel).Sendkey "I CICST"
				Tewindow("TeWindow").TeScreen("label:="& MySLabel).Sendkey TE_ENTER
				WaitForNextScreen()
				MySLabel = getScreenLabel()
				Tewindow("TeWindow").TeScreen("label:="& MySLabel).Sendkey "CICST"
				Tewindow("TeWindow").TeScreen("label:="& MySLabel).Sendkey TE_ENTER
				WaitForNextScreen()
			ElseIf Instr(lcase(strRegion), "ny") > 0 OR Instr(lcase(strRegion), "new") > 0 Then
				MySLabel = getScreenLabel()
				Tewindow("TeWindow").TeScreen("label:="& MySLabel).Sendkey "I CICSPNYL"
				Tewindow("TeWindow").TeScreen("label:="& MySLabel).Sendkey TE_ENTER
				WaitForNextScreen()
				MySLabel = getScreenLabel()
				Tewindow("TeWindow").TeScreen("label:="& MySLabel).Sendkey "CICSPNYL"
				Tewindow("TeWindow").TeScreen("label:="& MySLabel).Sendkey TE_ENTER
				WaitForNextScreen()
			End If 
			
		Else
			
			If Instr(lcase(strRegion), "col") > 0 Then
				MySLabel = getScreenLabel()
				Tewindow("TeWindow").TeScreen("label:="& MySLabel).Sendkey "I CICSQTOR"
				Tewindow("TeWindow").TeScreen("label:="& MySLabel).Sendkey TE_ENTER
				WaitForNextScreen()
				MySLabel = getScreenLabel()
				Tewindow("TeWindow").TeScreen("label:="& MySLabel).Sendkey "CICSQTOR"
				Tewindow("TeWindow").TeScreen("label:="& MySLabel).Sendkey TE_ENTER
				WaitForNextScreen()
			ElseIf Instr(lcase(strRegion), "ny") > 0 OR Instr(lcase(strRegion), "new") > 0 Then
				MySLabel = getScreenLabel()
				Tewindow("TeWindow").TeScreen("label:="& MySLabel).Sendkey "I CICSQNYL"
				Tewindow("TeWindow").TeScreen("label:="& MySLabel).Sendkey TE_ENTER
				WaitForNextScreen()
				MySLabel = getScreenLabel()
				Tewindow("TeWindow").TeScreen("label:="& MySLabel).Sendkey "CICSQNYL"
				Tewindow("TeWindow").TeScreen("label:="& MySLabel).Sendkey TE_ENTER
				WaitForNextScreen()
			End If 
			
		End If

End Function


Public Function SelectClaimant(strClaimant,rowNum)
	strPolicyType = GetDictItem(cpsDataTableDictObj, "PolicyType#" & rowNum)
	strClaimant = GetDictItem(cpsDataTableDictObj, "Claimant#" & rowNum)
	strDateOfDeath = GetDictItem(cpsDataTableDictObj, "DateOfDeath#" & rowNum)
	If Instr(strPolicyType, "LIFE") > 0 Then
		If UCase(strClaimant)="INSURED" Then
			strOutput = Get_Insured_Detail_FromMainframe(rowNum)
			strOutput=Split(strOutput,"#")
			tempClaimant = "1-Insured"
			strClaimantName = Left(strOutput(0),15)
			If strOutput(1)="M" Then
				strClaimantSex="MALE"
			Else
				strClaimantSex="FEMALE"
			End If
			strClaimantDOB = GetDateFormatted( strOutput(2),  "MMDDYY")
		Else
			If UCase(strClaimant)="SPOUSE" Then
				tempClaimant = "2-Spouse"
			ElseIf UCase(strClaimant)="CHILD" Then
				tempClaimant = "3-Child"
			ElseIf UCase(strClaimant)="Grandchild" Then
				tempClaimant = "6-Grandchild"
			End If
			strClaimantName = GetDictItem(cpsDataTableDictObj, "ClaimantName#" & rowNum)
			strClaimantDOB = GetDictItem(cpsDataTableDictObj, "ClaimantDOB#" & rowNum)
			strClaimantSex = GetDictItem(cpsDataTableDictObj, "ClaimantSex#" & rowNum)
		End If
		
		WpfWindow("wpfwin_PolicySearch").SwfButton("AddClaimantButton").Click
		If SwfWindow("ClaimPaymentSystem").SwfEdit("ClaimantName").Exist(2) Then
			ReportMessage "Pass", "Claim Payment System for Add Claimant window Open Successfully.", True, "Y"
			SwfWindow("ClaimPaymentSystem").SwfEdit("ClaimantName").Set strClaimantName
			SwfWindow("ClaimPaymentSystem").SwfComboBox("ClaimantRelationship").Select tempClaimant
			SwfWindow("ClaimPaymentSystem").SwfEdit("ClaimantDateOfBirth").Set strClaimantDOB
			SwfWindow("ClaimPaymentSystem").SwfComboBox("ClaimantSex").Select strClaimantSex
			ReportMessage "Pass", "Enered Claimant Name as :<b>"&strClaimantName&"</b> , Claimant Date Of Birth as : <b>"&strClaimantDOB&",</b> Claimant Sex as : <b>"&strClaimantSex&" </b>", True, "Y"
			SwfWindow("ClaimPaymentSystem").SwfButton("SaveClaimant").Click
		Else
			ReportMessage "Fail", "Claim Payment System for Add Claimant window not Open Successfully.", True, "Y"
		End If
		
		WpfWindow("wpfwin_PolicySearch").SwfEdit("DeathDate").Set strDateOfDeath
	Else
		If UCase(strClaimant)="CHILD" Then
			WpfWindow("wpfwin_PolicySearch").SwfButton("AddClaimantButton").Click
			If SwfWindow("ClaimPaymentSystem").SwfEdit("ClaimantName").Exist(5) Then
				ReportMessage "Pass", "Claim Payment System for Add Child window Open Successfully.", True, "Y"
				SwfWindow("ClaimPaymentSystem").SwfEdit("ClaimantName").Set "Tommy Adolf"
				SwfWindow("ClaimPaymentSystem").SwfComboBox("ClaimantRelationship").Select "3-Child"
				SwfWindow("ClaimPaymentSystem").SwfEdit("ClaimantDateOfBirth").Set "010199"
				SwfWindow("ClaimPaymentSystem").SwfComboBox("ClaimantSex").Select "MALE"
				ReportMessage "Pass", "Enered Claimant Name as :Tommy Adolf, Claimant Date Of Birth as : 01/01/1999, Claimant Sex as : MALE", True, "Y"
				SwfWindow("ClaimPaymentSystem").SwfButton("SaveClaimant").Click
			Else
				ReportMessage "Fail", "Claim Payment System for Add Child window not Open Successfully.", True, "Y"
			End If
		End If
			
'		strClaimantName = GetDictItem(cpsDataTableDictObj, "ClaimantName#" & rowNum)
'		strClaimantRelationship = GetDictItem(cpsDataTableDictObj, "ClaimantRelationship#" & rowNum)
'		strClaimantSex = GetDictItem(cpsDataTableDictObj, "ClaimantSex#" & rowNum)
'		strClaimantAge = GetDictItem(cpsDataTableDictObj, "ClaimantAge#" & rowNum)
'
'		If UCase(strClaimant)="UNKNOWN" and strClaimantName<>""  Then
'			WpfWindow("wpfwin_PolicySearch").SwfButton("AddClaimantButton").Click
'			If SwfWindow("ClaimPaymentSystem").SwfEdit("ClaimantName").Exist(5) Then
'				ReportMessage "Pass", "Claim Payment System for Add Claimant window Open Successfully.", True, "Y"
'				SwfWindow("ClaimPaymentSystem").SwfEdit("ClaimantName").Set strClaimantName
'				SwfWindow("ClaimPaymentSystem").SwfComboBox("ClaimantRelationship").Select strClaimantRelationship
'				SwfWindow("ClaimPaymentSystem").SwfEdit("AgeTextBox").Set strClaimantAge
'				SwfWindow("ClaimPaymentSystem").SwfComboBox("ClaimantSex").Select strClaimantSex
'				ReportMessage "Pass", "Enered Claimant Name as :"&strClaimantName&", Claimant Age as : "&strClaimantAge& ", Claimant Sex as : "&strClaimantSex, True, "Y"
'				SwfWindow("ClaimPaymentSystem").SwfButton("SaveClaimant").Click
'			Else
'				ReportMessage "Fail", "Claim Payment System for Add Claimant window not Open Successfully.", True, "Y"
'			End If
'		End If
		
'		strInsured=""
'		strSpouse=""
'		strChild=""
'		strallItems=WpfWindow("wpfwin_Research").SwfComboBox("ClaimantComboBox").GetROProperty("all items")
'		arrAllItem=Split(strallItems,vbLf)
'		strInsured=arrAllItem(0)
'		If Instr(1,strallItems,"2~")>0 Then
'			strSpouse=arrAllItem(1)
'		End If
'		If Instr(1,strallItems,"3~")>0 and Instr(1,strallItems,"2~")=0 Then
'			strChild=arrAllItem(1)
'		End If
'		If Instr(1,strallItems,"3~")>0 and Instr(1,strallItems,"2~")>0 Then
'			strChild=arrAllItem(2)
'		End If
'		WpfWindow("wpfwin_Research").Activate
'		If UCase(strClaimant)="INSURED" and strInsured<>"" Then
'			WpfWindow("wpfwin_Research").SwfComboBox("ClaimantComboBox").Select strInsured	
'			ReportMessage "Pass", "Selected Insured as  :<b>"&strInsured&"</b>", True, "Y"
'		End If
'		If UCase(strClaimant)="SPOUSE" and strSpouse<>"" Then
'			WpfWindow("wpfwin_Research").SwfComboBox("ClaimantComboBox").Select strSpouse	
'			ReportMessage "Pass", "Selected Spouse as  :<b>"&strSpouse&"</b>", True, "Y"
'		End If
'		If UCase(strClaimant)="CHILD" and strChild<>"" Then
'			WpfWindow("wpfwin_Research").SwfComboBox("ClaimantComboBox").Select strChild	
'			ReportMessage "Pass", "Selected Child as  :<b>"&strChild&"</b>", True, "Y"
'		End If
	End If
End Function

Public Function ScrollBarDown()
	' Scrool bar 	
	WpfWindow("Claims Payment System").Activate
	Wait 1
	x = WpfWindow("Claims Payment System").GetROProperty("abs_x")
	y = WpfWindow("Claims Payment System").GetROProperty("abs_y")
	w = WpfWindow("Claims Payment System").GetROProperty("width")
	h = WpfWindow("Claims Payment System").GetROProperty("height")
	Set objDC = CreateObject("Mercury.DeviceReplay")
	objDC.DragAndDrop  x + w - 17, y + h/2, x + w - 17, y + h, micLeftBtn 
	Set objDC = Nothing
	
End Function
Public Function ScrollBarUp()
	' Scrool bar 	
	WpfWindow("Claims Payment System").Activate
	Wait 1
	x = WpfWindow("Claims Payment System").GetROProperty("abs_x")
	y = WpfWindow("Claims Payment System").GetROProperty("abs_y")
	w = WpfWindow("Claims Payment System").GetROProperty("width")
	h = WpfWindow("Claims Payment System").GetROProperty("height")
	Set objDC = CreateObject("Mercury.DeviceReplay")
	objDC.DragAndDrop  x + w - 17, y + h/2, x + w - 17, y + h/4 , micLeftBtn 
	Set objDC = Nothing
	
End Function
