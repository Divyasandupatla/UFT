from multiprocessing.connection import wait
from pywinauto.application import Application
from pywinauto.keyboard import send_keys, KeySequenceError
import time
from pywinauto.keyboard import send_keys
from pyautogui import press, typewrite, hotkey
import pywinauto
from pywinauto.keyboard import send_keys, KeySequenceError

# Connect Application
app = Application().connect(handle=134408)
objLogin = app.top_window()
objLogin.print_control_identifiers(2, "C:\\t1\\t1.txt")
# except:
#     pass



# try:
#     app = Application().connect(title="AppealClaimNumberPopUp")
#     objLogin = app.top_window()
# #     objLogin.set_focus()
# #     objLogin.wait('visible', timeout=120)
# #     objLogin.wait('ready')
# #     objLogin.child_window(auto_id="tbAppealClaimNumber", control_type="System.Windows.Forms.TextBox").set_text("000178288")
# #     objLogin.child_window(auto_id="tbAppealSheetNbr", control_type="System.Windows.Forms.TextBox").set_text("0101")
# #     objLogin.child_window(title="Submit", auto_id="btnSubmit", control_type="System.Windows.Forms.Button").click_input()
# # except:
# #     pass
#     # reportMessage("Info", "Unable to click on save Button for Pend screen", True)


# try:
#     app = Application().connect(title_re="CPS - Warning*")
#     objLogin = app.top_window()
#     objLogin.set_focus()
#     objLogin.wait('visible', timeout=120)
#     objLogin.wait('ready')
#     if(objLogin.child_window(title="OK", class_name="Button")):
#         objLogin.child_window(title="OK", class_name="Button").click_input()  
#     # reportMessage("Pass", "Click on OK Button for Multiple recent claims from history contain Claim Remarks PopUp", True)
#     del objLogin
# except:
#     Pass