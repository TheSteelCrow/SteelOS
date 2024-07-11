extends Button

#@onready var DeleteButton = $Delete
#@onready var ScanButton = $Scan
#@onready var InfoButton = $Info
#@onready var MarkAsReadButton = $MarkAsRead

@onready var ButtonsPanel = $ButtonsPanel
@onready var Text = $RichTextLabel

var ShouldShowButtons = false

var Buttons

var Subject = "No Subject"
var Status = "None"
var Content = "None"
var Sender = "Unknown"

func _ready():
	Text.text = "[b] %s | %s |[/b] %s" % [Sender, Subject, Content]
	
	Buttons = ButtonsPanel.get_children()
	
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
