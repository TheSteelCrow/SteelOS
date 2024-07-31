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

#var Cursor1 = load("res://Images/pointer_b.png")
#var Cursor2 = load("res://Images/pointer_b_shaded.png")

var ShuttingDown = false
@onready var SystemLoadingScreen = $SystemLoadingScreen

func _ready():
	var ImageRendererPrefab = preload("res://Prefabs/image_painter.tscn")
	#var ImageRenderer = ImageRendererPrefab.instantiate()
	#ImageRenderer.position = Vector2(300, 300)
	#add_child(ImageRenderer)
	#OS.shell_open("https://www.youtube.com/watch?v=dQw4w9WgXcQ")
	#Input.set_custom_mouse_cursor(Cursor1, Input.CURSOR_ARROW)
	#Input.set_custom_mouse_cursor(Cursor2, Input.CURSOR_POINTING_HAND)
	ErrorPopup = preload("res://Prefabs/error_popup.tscn")
	#SpawnError()
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
