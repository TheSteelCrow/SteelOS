extends Panel

var EMAIL_DELAY = 5

@onready var SideBarPanel = $SideBar
var SideBarButtons = []

var OpenedCategory = "Inbox"

var IsFullscreen = false

@onready var MailData = $MailData
@onready var EmailLineContainer = $EmailLineContainer
@onready var EmailViewer = $EmailViewer
@onready var EmailWriter = $EmailWriter
var EmailLinePrefab

var OpenedEmailID

var StartTaskButton
var CancelTaskButton
var CompleteTaskButton
@onready var NewEmailButton = $SideBar/NewEmailPanel/NewEmailButton
var Taskbar

var Main

func OnAppVisible():
	pass

func Reset():
	pass

func Open():
	DisplayEmails()
	EmailViewer.hide()
	EmailWriter.hide()
	EmailLineContainer.show()

# Called when the node enters the scene tree for the first time.
func _ready():
	StartTaskButton = get_node("EmailViewer/StartTaskButton")
	CancelTaskButton = get_node("EmailViewer/CancelTaskButton")
	CompleteTaskButton = get_node("EmailViewer/CompleteTaskButton")
	Taskbar = get_parent().get_node("Taskbar")
	EmailLinePrefab = preload("res://Prefabs/email_line.tscn")
	Main = get_parent()
	
	get_node("TopPanel/RefreshButton").button_up.connect(func():	
		DisplayEmails()
		if(OpenedEmailID != null):
			OpenEmail(OpenedEmailID)
	)
	
	for SideBarButton in SideBarPanel.get_children():
		if(SideBarButton is Button):
			SideBarButtons.append(SideBarButton)
			SideBarButton.button_up.connect(func():
				for Obj in SideBarButtons:
					Obj.button_pressed = false
					Obj.size.x = 312
				SideBarButton.button_pressed = true
				SideBarButton.size.x = 288
				OpenedCategory = SideBarButton.text
				DisplayEmails()
				get_node("EmailViewer").hide()
				get_node("EmailWriter").hide()
				get_node("EmailLineContainer").show()
			)
	EmailViewer.get_node("TopBar/CloseButton").button_up.connect(func():
		DisplayEmails()
		EmailViewer.hide()
		EmailLineContainer.show()
	)

	EmailWriter.get_node("TopBar/CloseButton").button_up.connect(func():
		DisplayEmails()
		EmailWriter.hide()
		EmailLineContainer.show()
		ShowButton(null)
	)

	StartTaskButton.button_up.connect(func():
		Taskbar.StartTask(MailData.LoadedEmails[OpenedEmailID][6][0]) # Start task on taskbar (show progress etc)
		ShowButton("Cancel")
		if(MailData.LoadedEmails[OpenedEmailID][6][3] != null): # If task has associated app
			get_parent().get_node(MailData.LoadedEmails[OpenedEmailID][6][3]).StartTask() # Start task on associated app
		Taskbar.TaskQuota = MailData.LoadedEmails[OpenedEmailID][6][2]
	)
	CancelTaskButton.button_up.connect(func():
		Taskbar.CancelTask()
		ShowButton("Start")
		if(MailData.LoadedEmails[OpenedEmailID][6][3] != null): # If task has associated app
			get_parent().get_node(MailData.LoadedEmails[OpenedEmailID][6][3]).StopTask() # Stop task on associated app
	)
	CompleteTaskButton.button_up.connect(func():
		var TempOpenedEmailID = OpenedEmailID
		
		Taskbar.CompleteTask()
		MailData.LoadedEmails[TempOpenedEmailID][6][1] = true #Marks task as completed
		ShowButton(null)
		if(MailData.LoadedEmails[OpenedEmailID][6][3] != null): # If task has associated app
			get_parent().get_node(MailData.LoadedEmails[TempOpenedEmailID][6][3]).StopTask() # Stop task on associated app
		MailData.LoadedEmails[TempOpenedEmailID][6] = null # Deletes task info as it is completed, now it will act as a normal email.
		
		if(MailData.LoadedEmails[TempOpenedEmailID+1] != null): #If next email exists
			await get_tree().create_timer(EMAIL_DELAY).timeout
			MailData.LoadedEmails[TempOpenedEmailID+1][3] = true #Sets next email to available
			Main.get_node("Notifications").SendMailNotification(MailData.LoadedEmails[TempOpenedEmailID+1][2], MailData.LoadedEmails[TempOpenedEmailID+1][7], TempOpenedEmailID+1) #Sends notification of new mail
		
		if(MailData.LoadedEmails[TempOpenedEmailID+2] != null): #If next next email exists
			await get_tree().create_timer(EMAIL_DELAY).timeout
			MailData.LoadedEmails[TempOpenedEmailID+2][3] = true #Sets next email to available
			Main.get_node("Notifications").SendMailNotification(MailData.LoadedEmails[TempOpenedEmailID+2][2], MailData.LoadedEmails[TempOpenedEmailID+2][7], TempOpenedEmailID+2) #Sends notification of new mail
		
	)
	
	NewEmailButton.button_up.connect(StartDraft)

func DisplayEmails():
	for EmailLine in EmailLineContainer.get_children():
		EmailLineContainer.remove_child(EmailLine)
		EmailLine.queue_free()
		
	for EmailID in MailData.LoadedEmails:
		if(MailData.LoadedEmails[EmailID][3] == true): #If email is availabe
			if(MailData.LoadedEmails[EmailID][4] == true and OpenedCategory == "Deleted"): #If email is deleted and category is deleted
				CreateEmailLine(EmailID)
			elif(MailData.LoadedEmails[EmailID][4] == false and OpenedCategory != "Deleted"): #If email is not deleted and category is not deleted
				if(OpenedCategory == "Inbox"):
					CreateEmailLine(EmailID)
				elif(OpenedCategory == MailData.LoadedEmails[EmailID][7] + "s"):
					CreateEmailLine(EmailID)

func CreateEmailLine(EmailID):
	var NewEmailLine = EmailLinePrefab.instantiate()
	NewEmailLine.EmailID = EmailID
	NewEmailLine.Subject = MailData.LoadedEmails[EmailID][0]
	NewEmailLine.Content = MailData.LoadedEmails[EmailID][1]
	NewEmailLine.Sender = MailData.LoadedEmails[EmailID][2]
	NewEmailLine.Type = MailData.LoadedEmails[EmailID][7]
	EmailLineContainer.add_child(NewEmailLine)
	EmailLineContainer.move_child(NewEmailLine, 0)
	if(MailData.LoadedEmails[EmailID][5] == true):
		NewEmailLine.get_node("EmailLineButton").self_modulate = Color("c3def0")

func ShowButton(ButtonToShow):
	StartTaskButton.hide()
	CancelTaskButton.hide()
	CompleteTaskButton.hide()
	if(ButtonToShow != null):
		get_node("EmailViewer/" + ButtonToShow + "TaskButton").show()

func OpenEmail(EmailID):
	OpenedEmailID = EmailID
	
	if(MailData.LoadedEmails[EmailID][6] != null):#If Email has task data
		if(Taskbar.TaskActive == true and Taskbar.TaskName == MailData.LoadedEmails[EmailID][6][0]): #Sets taskname on taskbar to taskname
			if(Taskbar.TaskProgress == Taskbar.TaskQuota):
				ShowButton("Complete")
			else:
				ShowButton("Cancel")
		elif(Taskbar.TaskName == "None"):
			ShowButton("Start")
		else:
			ShowButton(null)
	else:
		ShowButton(null)
	
	EmailViewer.get_node("Content").text = MailData.LoadedEmails[EmailID][1]
	EmailViewer.get_node("TopBar").get_node("SubjectLine").text = MailData.LoadedEmails[EmailID][0]
	EmailViewer.get_node("TopBar").get_node("SenderLine").text = MailData.LoadedEmails[EmailID][2]
	EmailViewer.show()
	EmailLineContainer.hide()

func StartDraft():
	get_node("EmailWriter").show()
	get_node("EmailViewer").hide()
	get_node("EmailLineContainer").hide()
