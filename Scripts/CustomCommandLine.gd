extends Panel

@onready var UserInput = $UserInput
var Output

var IsFullscreen = false

var HackableWebsites = {
	#"WebsiteURL" : [LastAttemptTime]
	"www.turbonews.com" : [0],
	"www.aloftia.govt" : [0]
}

var Commands = ["/help", "/hack"]
var DevCommands = ["/example"]

var HelpInfo = "\n----\n/help - Lists commands\n/hack - Initiates hacking mode\n------"
var Main
var Mode = "Default"

var CanRecieveCommand = true

var MinutesBetweenHacks = 3
var SecondsBetweenHacks = MinutesBetweenHacks * 60

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
	if(CanRecieveCommand == false):
		pass
	
	if(Command in Commands): # If command is valid
		UserInput.text = ""
		Output.text += "\nRunning Command " + Command
		if(Commands.find(Command,0) == 0): # If command is /hack
			Output.text += HelpInfo
		if(Commands.find(Command,0) == 1): # If command is /hack
			CanRecieveCommand = false
			Output.text += "\nInitiating hack."
			await get_tree().create_timer(0.3).timeout
			Output.text += "\n."
			await get_tree().create_timer(0.3).timeout
			Output.text += "\n.."
			await get_tree().create_timer(0.3).timeout
			Output.text += "\n..."
			await get_tree().create_timer(0.3).timeout
			Output.text += "\nPlease enter the URL of the target website."
			Mode = "Hack"
			CanRecieveCommand = true
	elif(Command in DevCommands and OS.is_debug_build()): # If command is a dev command
		Output.text += "\nRunning DevCommand " + Command
	elif(Command in DevCommands and not OS.is_debug_build()):
		Output.text += "\nUnable to run DevCommand " + Command + " as you are not authorized."
	else: #If command is not a command
		if(Command in HackableWebsites and Mode == "Hack"): # If target is valid and mode is correct
			if((Time.get_unix_time_from_system() - HackableWebsites[Command][0]) > SecondsBetweenHacks): # Stops attack if an attack has occured recently
				Output.text += "\nStarting cyber attack targeted at " + Command
				Main.get_node("HackTask/AppBaseComponent").Open()
				get_node("AppBaseComponent").Close()
				HackableWebsites[Command][0] = Time.get_unix_time_from_system()
			else:
				Output.text += "\nThis website has been hacked recently and is offline awaiting repairs."
	UserInput.text = ""
