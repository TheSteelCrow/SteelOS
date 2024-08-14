extends Panel

@onready var SideBarPanel = $SideBar
var SideBarButtons = []

var OpenedCategory = "Inbox"

var IsFullscreen = false

@onready var MailData = $MailData
@onready var EmailLineContainer = $EmailLineContainer
@onready var EmailViewer = $EmailViewer
var EmailLinePrefab

var OpenedEmailID

var StartTaskButton
var CancelTaskButton
var CompleteTaskButton

var Taskbar

func OnAppVisible():
	pass

func Reset():
	pass

func Open():
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	StartTaskButton = get_node("EmailViewer/StartTaskButton")
	CancelTaskButton = get_node("EmailViewer/CancelTaskButton")
	CompleteTaskButton = get_node("EmailViewer/CompleteTaskButton")
	Taskbar = get_parent().get_node("Taskbar")
	EmailLinePrefab = preload("res://Prefabs/email_line.tscn")
	
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
			)
	EmailViewer.get_node("TopBar/CloseButton").button_up.connect(func():
		DisplayEmails()
		EmailViewer.hide()
		EmailLineContainer.show()
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
		get_parent().get_node(MailData.LoadedEmails[OpenedEmailID][6][3]).StopTask() # Stop task on associated app
	)
	CompleteTaskButton.button_up.connect(func():
		Taskbar.CompleteTask()
		MailData.LoadedEmails[OpenedEmailID][6][1] = true #Marks task as completed
		if(MailData.LoadedEmails[OpenedEmailID+1] != null): #If next task exists
			MailData.LoadedEmails[OpenedEmailID+1][3] = true #Sets next task to available
		
		ShowButton(null)
		get_parent().get_node(MailData.LoadedEmails[OpenedEmailID][6][3]).StopTask() # Stop task on associated app
	)

func DisplayEmails():
	for EmailLine in EmailLineContainer.get_children():
		EmailLineContainer.remove_child(EmailLine)
		EmailLine.queue_free()
		
	for EmailID in MailData.LoadedEmails:
		if(MailData.LoadedEmails[EmailID][3] == true): #If email is availabe
			if(MailData.LoadedEmails[EmailID][4] == true and OpenedCategory == "Deleted"): #If email is deleted and category is deleted
				CreateEmailLine(EmailID)
				print("show an email that is deleted")
			elif(MailData.LoadedEmails[EmailID][4] == false and OpenedCategory != "Deleted"): #If email is not deleted and category is not deleted
				CreateEmailLine(EmailID)
				print("show an email that is deleted")

func CreateEmailLine(EmailID):
	var NewEmailLine = EmailLinePrefab.instantiate()
	NewEmailLine.EmailID = EmailID
	NewEmailLine.Subject = MailData.LoadedEmails[EmailID][0]
	NewEmailLine.Content = MailData.LoadedEmails[EmailID][1]
	NewEmailLine.Sender = MailData.LoadedEmails[EmailID][2]
	NewEmailLine.Type = MailData.LoadedEmails[EmailID][7]
	EmailLineContainer.add_child(NewEmailLine)
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
