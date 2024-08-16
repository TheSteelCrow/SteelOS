extends Control

var SHUTDOWN_TIME = 2
var RESTART_TIME = 2

var SearchEngine
var Menu
var FileExplorer
var CustomPopup

var WindowInstanceSelected = false

var OpenedApp

var AnimationsMultiplier = 1

var ShuttingDown = false
@onready var SystemLoadingScreen = $SystemLoadingScreen
@onready var Taskbar = $Taskbar
@onready var Mail = $Mail
@onready var MailData = $Mail/MailData
@onready var Notifications = $Notifications
@onready var FileSelector = $FileSelector

func InstallApp(AppName):
	var AppButton = Taskbar.get_node("IconHolder/" + AppName + "Backdrop")
	Taskbar.get_node("IconHolder").remove_child(AppButton)
	Taskbar.get_node("IconArranger").add_child(AppButton)
	
	var NewAppPrefab = load("res://Apps/" + AppName.to_lower() + ".tscn")
	var NewAppWindow = NewAppPrefab.instantiate()
	add_child(NewAppWindow)

func GeneratePopup(PopupCreatorName, Description, Type, PopupPosition):
	var NewPopup = CustomPopup.instantiate()
	add_child(NewPopup)
	NewPopup.move_to_front()
	
	NewPopup.PopupCreatorName = PopupCreatorName
	NewPopup.Description = Description
	NewPopup.Type = Type
	NewPopup.position = PopupPosition
	NewPopup.Setup()
	
	return NewPopup

func _ready():
	SystemLoadingScreen.show()
	var ImageRendererPrefab = preload("res://Prefabs/image_painter.tscn")
	CustomPopup = preload("res://Prefabs/popup.tscn")
	Menu = get_node("Menu")
	SearchEngine = get_node("SearchEngine")
	FileExplorer = get_node("FileExplorer")

func StartGameEvents():
	await get_tree().create_timer(3).timeout
	MailData.LoadedEmails[1][3] = true
	Notifications.SendMailNotification(MailData.LoadedEmails[1][2], MailData.LoadedEmails[1][7], 1)
	
	await get_tree().create_timer(3).timeout
	
	MailData.LoadedEmails[2][3] = true
	Notifications.SendMailNotification(MailData.LoadedEmails[2][2], MailData.LoadedEmails[2][7], 2)

func _on_shut_down_button_up():
	ShuttingDown = true
	SystemLoadingScreen.move_to_front()
	SystemLoadingScreen.show()
	SystemLoadingScreen.get_node("ShutDownRestartScreen").show()
	SystemLoadingScreen.get_node("ShutDownRestartScreen/Text").text = "[center]Shutting Down...[/center]"
	await get_tree().create_timer(SHUTDOWN_TIME).timeout
	get_tree().quit()

func _on_restart_button_up():
	ShuttingDown = true
	SystemLoadingScreen.move_to_front()
	SystemLoadingScreen.show()
	SystemLoadingScreen.get_node("ShutDownRestartScreen").show()
	SystemLoadingScreen.get_node("ShutDownRestartScreen/Text").text = "[center]Restarting...[/center]"
	await get_tree().create_timer(SHUTDOWN_TIME).timeout
	get_tree().reload_current_scene()
	
func WindowSelected():
	if(WindowInstanceSelected == false):
		WindowInstanceSelected = true
	else:
		print("A window has already been selected")
	
func WindowDeselected():
	WindowInstanceSelected = false
