extends Control

var App

# Called when the node enters the scene tree for the first time.
func _ready():
	App = get_parent()



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_scram_button_up():
	App.Cutout.show()
	get_node("StuffyBackgroundNoise").play()
