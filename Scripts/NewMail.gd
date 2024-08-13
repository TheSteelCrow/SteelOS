extends Panel

@onready var SideBarPanel = $SideBar
var SideBarButtons = []

var OpenedCategory = "Inbox"

var IsFullscreen = false

@onready var MailData = $MailData
@onready var EmailLineContainer = $EmailLineContainer
var EmailLinePrefab

func OnAppVisible():
	pass

func Reset():
	pass

func Open():
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
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
			)

func DisplayEmails():
	for EmailLine in EmailLineContainer.get_children():
		EmailLineContainer.remove_child(EmailLine)
		EmailLine.queue_free()
		
	for EmailID in MailData.LoadedEmails:
		if(MailData.LoadedEmails[EmailID][3] == true): #If email is availabe
			if(MailData.LoadedEmails[EmailID][4] == true and OpenedCategory == "Deleted"): #If email is deleted and category is deleted
				CreateEmailLine(EmailID)
			elif(MailData.LoadedEmails[EmailID][4] == false and OpenedCategory != "Deleted"): #If email is not deleted and category is not deleted
				CreateEmailLine(EmailID)

func CreateEmailLine(EmailID):
	var NewEmailLine = EmailLinePrefab.instantiate()
	NewEmailLine.Code = EmailID
	NewEmailLine.Subject = MailData.LoadedEmails[EmailID][0]
	NewEmailLine.Content = MailData.LoadedEmails[EmailID][1]
	NewEmailLine.Sender = MailData.LoadedEmails[EmailID][2]
	EmailLineContainer.add_child(NewEmailLine)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
