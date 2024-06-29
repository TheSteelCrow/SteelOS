extends Control

var SearchEngine
var Menu
var FileExplorer
var ErrorPopup

func _ready():
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
		# Create an instance of the Packed Scene
		var SpawnedError = ErrorPopup.instance()
		
		# Add the instance to the scene tree
		add_child(SpawnedError)
		
		# Optionally, you can set properties on the instance here
		# For example, set the position
		SpawnedError.position = Vector2(100, 100)
	else:
		print("Failed to load prefab!")
