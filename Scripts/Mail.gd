extends Panel

var POSITION_FROM_WALL = 8

var AppName = "Mail"
var InboxLinePrefab

@onready var Inbox = $Inbox
@onready var EmailViewer = $EmailViewer

var IsFullscreen = true

#	1 : ["Subject", "Content", "Sender", HasBeenRead],
var LoadedEmails = {
	
	1 : [
	"Welcome",
	"Welcome to the game! The game is in the early stages of development. Remember to read your emails, good luck!",
	"CrowOS",
	false
	],
	
	2 : [
	"Congratulations!",
	"Welcome to the company. I have some good news, you have been promoted! You are now one of my Elite™ Employees! Anyway get back to work! Now!\nPS: I'll be sending you tasks to do.", 
	"Boss",
	false
	],
	
	3 : [
	"Task #1",
	"Your first task is simple, even a simple flat brained monkey like yourself can do it! First open the [Team Manager App Name] app, then choose which employees you will be firing. You have until your computer battery reaches 0%, if you don't finish the task in this time, I won't pay you.",
	"Boss",
	false
	]
	
}

func Reset():
	print("Reseting " + AppName)
	for InboxLine in Inbox.get_children():
		Inbox.remove_child(InboxLine)
		InboxLine.queue_free()
	
	CreateInboxLines()

func CreateInboxLines():
	for Email in LoadedEmails:
		var NewInboxLine = InboxLinePrefab.instantiate()
		NewInboxLine.Code = Email
		NewInboxLine.Subject = LoadedEmails[Email][0]
		NewInboxLine.Content = LoadedEmails[Email][1]
		NewInboxLine.Sender = LoadedEmails[Email][2]
		Inbox.add_child(NewInboxLine)
	
	AlignInboxLines()

func OpenEmail(Code):
	EmailViewer.get_node("Content").text = LoadedEmails[Code][1]
	EmailViewer.get_node("TopBar").get_node("SubjectLine").text = LoadedEmails[Code][0]
	EmailViewer.get_node("TopBar").get_node("SenderLine").text = LoadedEmails[Code][2]
	EmailViewer.show()
	Inbox.hide()
	
func _on_close_button_button_up():
	EmailViewer.hide()
	Inbox.show()

func _ready():
	InboxLinePrefab = preload("res://Prefabs/inbox_line.tscn")

func AlignInboxLines():
	var LoadedInboxLines = Inbox.get_children()
	LoadedInboxLines.reverse()
	for i in range(LoadedInboxLines.size()):
		LoadedInboxLines[i].position = (Vector2(8, 8 + 72*i))
