extends Control

@onready var EmailLineButton = $EmailLineButton
@onready var ButtonsPanel = $EmailLineButton/ButtonsPanel
@onready var EmailLineText = $EmailLineButton/EmailLineText


var ShouldShowButtons = false

var Buttons

var EmailID
var Subject = "No Subject"
var Content = "None"
var Sender = "Unknown"
var Type = "Unknown"

var Mail
var MailData

func _ready():
	
	Mail = get_parent().get_parent()
	MailData = Mail.get_node("MailData")
	
	EmailLineText.text = "%s | %s | %s |" % [Sender, Type, Subject]
	
	Buttons = ButtonsPanel.get_children()
	
	EmailLineButton.button_up.connect(func():
		Mail.OpenEmail(EmailID)
		ShouldShowButtons = false
		Mail.get_node("MailData").LoadedEmails[EmailID][5] = true # Set email to has been read
	)
	
	EmailLineButton.mouse_entered.connect(func():
		ShouldShowButtons = true
	)
	
	EmailLineButton.mouse_exited.connect(func():
		ShouldShowButtons = false
	)
	
	for ButtonNode in Buttons:
		ButtonNode.mouse_entered.connect(func():
			ShouldShowButtons = true
		)
		
	for ButtonNode in Buttons:
		ButtonNode.mouse_exited.connect(func():
			ShouldShowButtons = false
		)
	
	Buttons[3].button_up.connect(func(): # On delete button pressed
		MailData.LoadedEmails[EmailID][4] = !MailData.LoadedEmails[EmailID][4]
		Mail.DisplayEmails()
	)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(ShouldShowButtons):
		ButtonsPanel.show()
	elif(not ShouldShowButtons):
		ButtonsPanel.hide()
		
