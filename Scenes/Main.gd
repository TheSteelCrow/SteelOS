extends Control

var SearchEngine
var Menu

func _ready():
	Menu = get_node("Menu")
	SearchEngine = get_node("SearchEngine")

func HideAll():
	Menu.hide()
	SearchEngine.hide()
