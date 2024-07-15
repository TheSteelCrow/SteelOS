extends Button

#@onready var DeleteButton = $Delete
#@onready var ScanButton = $Scan
#@onready var InfoButton = $Info
#@onready var MarkAsReadButton = $MarkAsRead

@onready var ButtonsPanel = $ButtonsPanel
@onready var Text = $RichTextLabel

var ShouldShowButtons = false

var Buttons

var Code = "None"
var Subject = "No Subject"
var Content = "None"
var Sender = "Unknown"

var Mail

func _ready():
	Mail = get_parent().get_parent()
	
	Text.text = "[b] %s | %s |[/b] %s" % [Sender, Subject, Content]
	
	Buttons = ButtonsPanel.get_children()
	
	var new_style = StyleBoxFlat.new()
	new_style.bg_color = Color("9cb1be")
	add_theme_stylebox_override("normal", new_style)
	add_theme_stylebox_override("hover", new_style)
	add_theme_stylebox_override("pressed", new_style)
	add_theme_stylebox_override("focus", new_style)
	ButtonsPanel.add_theme_stylebox_override("panel", new_style)
	
	if(Mail.LoadedEmails[Code][3] == true):
		new_style.bg_color = Color("495b65")
	
	button_up.connect(func():
		Mail.OpenEmail(Code)
		new_style.bg_color = Color("495b65")
		ShouldShowButtons = false
		Mail.LoadedEmails[Code][3] = true
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
