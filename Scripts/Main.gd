extends Control

var SearchEngine
var Menu
var FileExplorer
var ErrorPopup

var WindowInstanceSelected = false

var Cursor1 = load("res://Images/pointer_b.png")
var Cursor2 = load("res://Images/pointer_b_shaded.png")

func _ready():
	#OS.shell_open("https://www.youtube.com/watch?v=dQw4w9WgXcQ")
	Input.set_custom_mouse_cursor(Cursor1, Input.CURSOR_ARROW)
	Input.set_custom_mouse_cursor(Cursor2, Input.CURSOR_POINTING_HAND)
	ErrorPopup = preload("res://Prefabs/error_popup.tscn")
	SpawnError()
	Menu = get_node("Menu")
	SearchEngine = get_node("SearchEngine")
	FileExplorer = get_node("FileExplorer")

func HideAll():
	Menu.hide()
	SearchEngine.hide()
	FileExplorer.hide()

func _on_shut_down_button_up():
	get_tree().quit()
	
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
