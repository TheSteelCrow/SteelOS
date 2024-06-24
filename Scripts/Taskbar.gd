extends Node

var MenuPanel
var MenuOpen = false

# Called when the node enters the scene tree for the first time.
func _ready():
	MenuPanel = get_parent().get_node("Menu")
	MenuPanel.hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_menu_button_button_up():
	print("Menu Button Pressed")
	if(MenuOpen):
		MenuOpen = !MenuOpen
		MenuPanel.hide()
	else:
		MenuOpen = !MenuOpen
		MenuPanel.show()
