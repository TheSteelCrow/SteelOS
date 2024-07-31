extends Control

var SHUTDOWN_TIME = 2
var RESTART_TIME = 2

var SearchEngine
var Menu
var FileExplorer
var ErrorPopup

var WindowInstanceSelected = false

var OpenedApp

var AnimationsMultiplier = 1

var ShuttingDown = false
@onready var SystemLoadingScreen = $SystemLoadingScreen

func _ready():
	SystemLoadingScreen.show()
	var ImageRendererPrefab = preload("res://Prefabs/image_painter.tscn")
	ErrorPopup = preload("res://Prefabs/error_popup.tscn")
	Menu = get_node("Menu")
	SearchEngine = get_node("SearchEngine")
	FileExplorer = get_node("FileExplorer")

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

func SpawnError():
	if ErrorPopup:
		var SpawnedError = ErrorPopup.instantiate()
		add_child(SpawnedError)
	else:
		print("Failed to load prefab!")

func _on_error_spawner_timeout():
	SpawnError()
	
func WindowSelected():
	if(WindowInstanceSelected == false):
		WindowInstanceSelected = true
	else:
		print("A window has already been selected")
	
func WindowDeselected():
	WindowInstanceSelected = false
