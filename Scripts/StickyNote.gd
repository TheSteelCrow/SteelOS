extends Panel

func _ready():
	get_node("Bar/Button").button_down.connect(func():queue_free())
