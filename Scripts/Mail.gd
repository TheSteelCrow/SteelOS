extends Panel

var POSITION_FROM_WALL = 8

var AppName = "Mail"
var InboxLinePrefab

@onready var Inbox = $Inbox
@onready var EmailViewer = $EmailViewer

var IsFullscreen = true

var Taskbar

var StartTaskButton
var CancelTaskButton
var CompleteTaskButton

var OpenedEmailCode

@onready var MD = $MailData

func OnAppVisible():
	if(OpenedEmailCode != null):
		OpenEmail(OpenedEmailCode)

func Reset():
	OpenedEmailCode = null

func Open():
	CreateInboxLines()

func CreateInboxLines():
	for InboxLine in Inbox.get_children():
		Inbox.remove_child(InboxLine)
		InboxLine.queue_free()
	
	for Email in MD.LoadedEmails:
		if(MD.LoadedEmails[Email][4] == true): #If email is task
			if(MD.LoadedEmails[Email][5][4] == false): #If task is unavailable
				continue # Skip task if unavailable
		
		var NewInboxLine = InboxLinePrefab.instantiate()
		NewInboxLine.Code = Email
		NewInboxLine.Subject = MD.LoadedEmails[Email][0]
		NewInboxLine.Content = MD.LoadedEmails[Email][1]
		NewInboxLine.Sender = MD.LoadedEmails[Email][2]
		Inbox.add_child(NewInboxLine)
	
	AlignInboxLines()

func ShowButton(ButtonToShow):
	StartTaskButton.hide()
	CancelTaskButton.hide()
	CompleteTaskButton.hide()
	if(ButtonToShow != null):
		get_node("EmailViewer/" + ButtonToShow + "TaskButton").show()

func OpenEmail(Code):
	OpenedEmailCode = Code
	
	if(MD.LoadedEmails[Code][4] == true):#If Email is task
		if(Taskbar.TaskActive == true and Taskbar.TaskName == MD.LoadedEmails[Code][5][0]):
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
	
	EmailViewer.get_node("Content").text = MD.LoadedEmails[Code][1]
	EmailViewer.get_node("TopBar").get_node("SubjectLine").text = MD.LoadedEmails[Code][0]
	EmailViewer.get_node("TopBar").get_node("SenderLine").text = MD.LoadedEmails[Code][2]
	EmailViewer.show()
	Inbox.hide()
	
func _on_start_task_button_button_up():
	Taskbar.StartTask(MD.LoadedEmails[OpenedEmailCode][5][0])
	ShowButton("Cancel")
	if(MD.LoadedEmails[OpenedEmailCode][5][2] != null):
		get_parent().get_node(MD.LoadedEmails[OpenedEmailCode][5][2]).StartTask()
	Taskbar.TaskQuota = MD.LoadedEmails[OpenedEmailCode][5][3]

func _on_cancel_task_button_button_up():
	Taskbar.CancelTask()
	ShowButton("Start")
	get_parent().get_node(MD.LoadedEmails[OpenedEmailCode][5][2]).StopTask()

func _on_complete_task_button_button_up():
	Taskbar.CompleteTask()
	MD.LoadedEmails[OpenedEmailCode][5][1] = true
	MD.LoadedEmails[OpenedEmailCode+1][5][4] = true
	print(MD.LoadedEmails[OpenedEmailCode+1])
	print(MD.LoadedEmails[OpenedEmailCode+1][5][4])
	ShowButton(null)
	get_parent().get_node(MD.LoadedEmails[OpenedEmailCode][5][2]).StopTask()
	
func _on_close_button_button_up():
	OpenedEmailCode = null
	EmailViewer.hide()
	Inbox.show()

func _ready():
	StartTaskButton = get_node("EmailViewer/StartTaskButton")
	CancelTaskButton = get_node("EmailViewer/CancelTaskButton")
	CompleteTaskButton = get_node("EmailViewer/CompleteTaskButton")
	Taskbar = get_parent().get_node("Taskbar")
	InboxLinePrefab = preload("res://Prefabs/inbox_line.tscn")

func AlignInboxLines():
	var LoadedInboxLines = Inbox.get_children()
	#LoadedInboxLines.reverse()
	for i in range(LoadedInboxLines.size()):
		LoadedInboxLines[i].position = (Vector2(8, 8 + 72*i))
