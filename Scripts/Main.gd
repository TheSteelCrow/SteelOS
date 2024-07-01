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
		var SpawnedError = ErrorPopup.instantiate()
		add_child(SpawnedError)
	else:
		print("Failed to load prefab!")

func _on_error_spawner_timeout():
	SpawnError()
