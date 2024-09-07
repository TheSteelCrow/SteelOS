extends Panel

var Main

# Called when the node enters the scene tree for the first time.
func _ready():
	Main = get_tree().root.get_child(0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_restart_button_up():
	hide()
	Main._on_restart_button_up()

func _on_continue_button_up():
	hide()
	get_parent().hide()
	
	for App in Main.get_children(): # Gets all objects in main
		if(App.get_node("AppBaseComponent")): # Removes non apps
			App.get_node("AppBaseComponent").Close() # Closes all apps

func _on_quit_button_up():
	hide()
	Main._on_shut_down_button_up()
