extends Panel

func _ready():
	get_node("TopPanel/Button").button_down.connect(func():
		queue_free()
	)
