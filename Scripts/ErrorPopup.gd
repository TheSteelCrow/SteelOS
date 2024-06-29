extends Panel

var MouseButton1Down = false
var MouseInZone = false
var Dragging = false
var offset = Vector2(0,0)
var ScreenSize 

func _ready():
	ScreenSize = get_viewport_rect().size / get_canvas_transform().get_scale()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	MouseButton1Down = Input.is_mouse_button_pressed(1)
	var MousePosition = get_viewport().get_mouse_position()
	
	if(MouseInZone && MouseButton1Down && Dragging == false):
		Dragging = true
		offset = position - MousePosition
		#Set Offset
	elif(MouseButton1Down == false && Dragging == true):
		Dragging = false
	elif(Dragging == true):
		if(not (MousePosition.x > ScreenSize.x || MousePosition.x < 0 || MousePosition.y > ScreenSize.y || MousePosition.y < 0 )):
			position = get_viewport().get_mouse_position() + offset
		#MoveWindow
	

func _on_file_explorer_button_button_up():
	print("File Explorer Button Pressed")
	if(visible):
		hide()
	else:
		show()
		move_to_front()


func _on_panel_mouse_entered():
	MouseInZone = true
	
func _on_panel_mouse_exited():
	MouseInZone = false
