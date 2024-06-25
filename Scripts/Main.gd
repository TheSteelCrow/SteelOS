extends Control

var SearchEngine
var Menu
var FileExplorer

func _ready():
	Menu = get_node("Menu")
	SearchEngine = get_node("SearchEngine")
	FileExplorer = get_node("FileExplorer")

func HideAll():
	Menu.hide()
	SearchEngine.hide()
	FileExplorer.hide()

func _on_shut_down_button_up():
	get_tree().quit()
