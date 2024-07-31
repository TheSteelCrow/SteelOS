extends Panel

@onready var UserInput = $UserInput
var Output

var IsFullscreen = false

var Commands = ["/hack", "/tester"]
var DevCommands = ["/example"]

var Main

func OnAppVisible():
	pass

func Open():
	pass

func Reset():
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	Main = get_parent()
	Output = get_node("TextDisplayPanel/TextDisplay")
	Output.text = "Welcome to Command Panel!"

func _on_user_input_text_submitted(Command):
	if(Command in Commands):
		UserInput.text = ""
		Output.text += "\nRunning Command " + Command
		if(Commands.find(Command,0) == 0):
			Main.get_node("HackTask/AppBaseComponent").Open()
		
	elif(Command in DevCommands and OS.is_debug_build()):
		Output.text += "\nRunning DevCommand " + Command
