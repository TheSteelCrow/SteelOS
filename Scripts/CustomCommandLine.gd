extends Panel

@onready var UserInput = $UserInput
var Output

var IsFullscreen = false

var Commands = ["/help", "/hack"]
var DevCommands = ["/example"]

var HelpInfo = "\n----\n/help - Lists commands\n/hack - Initiates hacking mode\n------"

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
	get_node("UserInput/PasteButton").button_up.connect(func():UserInput.text += DisplayServer.clipboard_get())

func _on_user_input_text_submitted(Command):
	if(Command in Commands):
		UserInput.text = ""
		Output.text += "\nRunning Command " + Command
		if(Commands.find(Command,0) == 0):
			Output.text += HelpInfo
		elif(Commands.find(Command,0) == 1):
			Main.get_node("HackTask/AppBaseComponent").Open()
	elif(Command in DevCommands and OS.is_debug_build()):
		Output.text += "\nRunning DevCommand " + Command
