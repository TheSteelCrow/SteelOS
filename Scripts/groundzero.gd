extends Panel

var IsFullscreen = true

var Cutout
var Main

func OnAppVisible():
	pass

func Reset():
	pass

func Open():
	pass

func _ready():
	Main = get_tree().root.get_child(0)
	Cutout = Main.get_node("LightsCutout")
	Cutout.show()
	Main.get_node("Taskbar").AlmostFront = true

func _process(delta):
	if(Cutout != null):
		var MousePosition = get_viewport().get_mouse_position()
		Cutout.position = MousePosition
		Cutout.move_to_front()
