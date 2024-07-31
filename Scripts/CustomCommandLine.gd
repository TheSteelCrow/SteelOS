extends Panel

@onready var UserInput = $UserInput
var Output

var IsFullscreen = false

var Commands = ["/hack"]
var DevCommands = ["/example"]

func OnAppVisible():
	pass

func Open():
	pass

func Reset():
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	Output = get_node("TextDisplayPanel/TextDisplay")
	Output.text = "Welcome to Command Panel!"

func _on_user_input_text_submitted(Command):
	if(Command in Commands):
		Output.text += "\nRunning Command " + Command
	elif(Command in DevCommands and OS.is_debug_build()):
		Output.text += "\nRunning DevCommand " + Command
