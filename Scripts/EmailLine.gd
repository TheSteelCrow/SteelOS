extends Button

@onready var ButtonsPanel = $ButtonsPanel
@onready var EmailLineText = $EmailLineText

var ShouldShowButtons = false

var Buttons

var EmailID = "None"
var Subject = "No Subject"
var Content = "None"
var Sender = "Unknown"
var Type = "Unknown"

var Mail

func _ready():
	
	Mail = get_parent().get_parent()
	
	EmailLineText.text = "%s | %s | %s |" % [Sender, Type, Subject]
	
	Buttons = ButtonsPanel.get_children()
	
	if(Mail.get_node("MailData").LoadedEmails[EmailID][5] == true): # If has been read
		#Modulateself as darker
		print()
	
	button_up.connect(func():
		Mail.OpenEmail(EmailID)
		ShouldShowButtons = false
		Mail.get_node("MailData").LoadedEmails[Mail][5] = true # Set email to has bee read
	)
	
	for ButtonNode in Buttons:
		ButtonNode.mouse_entered.connect(func():
			ShouldShowButtons = true
		)
		
	for ButtonNode in Buttons:
		ButtonNode.mouse_exited.connect(func():
			ShouldShowButtons = false
		)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(ShouldShowButtons):
		ButtonsPanel.show()
	elif(not ShouldShowButtons):
		ButtonsPanel.hide()
		

func _on_mouse_entered():
	ShouldShowButtons = true

func _on_mouse_exited():
	ShouldShowButtons = false
