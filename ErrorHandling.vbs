
'! @brief This variable stores the Iter status as "SUCCESS"
Public ITER_STATUS_SUCCESS:ITER_STATUS_SUCCESS = "Success"
'! @brief This variable stores the Iter status as "Failure"
Public ITER_STATUS_FAILURE:ITER_STATUS_FAILURE = "Failure"
'! @brief This variable stores the Iter status as "SuccessGoNoFurther"
Public ITER_STATUS_SUCCESS_GO_NO_FURTHER:ITER_STATUS_SUCCESS_GO_NO_FURTHER = "SuccessGoNoFurther"
'! @brief This variable stores the Iter last status
Private lastIterStatus


'! This function is used to set the Current Iter status as either Success, Failure or SuccessGoNoFurther
'! @param iterStatus Input - Value for the current Iter to be set
'! @remarks  Setter function
'! @return NA
'! @author Aflac IT QA - NIIT Automation Team – Vikas
'! @version V1.0
'! @date 05/29/2015
public function SetIterStatus(ByVal iterStatus)
	lastIterStatus = iterStatus
End Function

'! This function is used to return the Current Iter status
'! @remarks  Getter function
'! @return This function returns value from lastIterStatus private variable
'! @author Aflac IT QA - NIIT Automation Team – Vikas
'! @version V1.0
'! @date 05/29/2015
public function GetIterStatus()
	GetIterStatus = lastIterStatus
End Function

'! This function is used to set the Current Iter status to Success
'! @remarks  Setter function
'! @return NA
'! @author Aflac IT QA - NIIT Automation Team – Vikas
'! @version V1.0
'! @date 05/29/2015
public function SetIterStatusSuccess()
	lastIterStatus = ITER_STATUS_SUCCESS
End Function

'! This function is used to check Current Iter status to see if iter is Success or not
'! @remarks  Getter function
'! @return 'True' in case iter status is success and 'False' for failure
'! @author Aflac IT QA - NIIT Automation Team – Vikas
'! @version V1.0
'! @date 05/29/2015
public function IsIterStatusSuccess()
	If GetIterStatus() = ITER_STATUS_SUCCESS Then
		IsIterStatusSuccess = True
		Exit Function
	End If
	IsIterStatusSuccess = False
End Function

'! This function is used to set the Current Iter status to Failure
'! @remarks  Setter function
'! @return NA
'! @author Aflac IT QA - NIIT Automation Team – Vikas
'! @version V1.0
'! @date 05/29/2015
public function SetIterStatusFailure()
   ReportMessage "Fail", "Setting the iter status as Fail", False, "N"
	lastIterStatus = ITER_STATUS_FAILURE
End Function

'! This function is used to check Current Iter status to see if iter is Failure or not 
'! @remarks  Getter function
'! @return 'True' in case iter status is failure and 'False' for success
'! @author Aflac IT QA - NIIT Automation Team – Vikas
'! @version V1.0
'! @date 05/29/2015
public function IsIterStatusFailure()
	If GetIterStatus() = ITER_STATUS_FAILURE Then
		IsIterStatusFailure = True
		Exit Function
	End If
	IsIterStatusFailure = False
End Function

'! This function is used to set the Current Iter status to success but iter should not go further in the execution 
'! @remarks  Setter function
'! @return NA
'! @author Aflac IT QA - NIIT Automation Team – Vikas
'! @version V1.0
'! @date 05/29/2015
public function SetIterStatusSuccessGoNoFurther()
	ReportMessage "Info", "Setting the iter status as Success Go No Further", False, "N"
	lastIterStatus = ITER_STATUS_SUCCESS_GO_NO_FURTHER
End Function

'! This function is used to check Current Iter status to see if iter is set to Success Go No Further
'! @remarks  Getter function
'! @return 'True' if iter status is success go no further else it will be return 'False'
'! @author Aflac IT QA - NIIT Automation Team – Vikas
'! @version V1.0
'! @date 05/29/2015
public function IsIterStatusSuccessGoNoFurther()
	If GetIterStatus() = ITER_STATUS_SUCCESS_GO_NO_FURTHER Then
		IsIterStatusSuccessGoNoFurther = True
		Exit Function
	End If
	IsIterStatusSuccessGoNoFurther = False
End Function
