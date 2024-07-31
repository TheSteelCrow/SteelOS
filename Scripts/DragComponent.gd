extends Node

var TopPanel

var MouseButton1Down = false
var MouseInZone = false
var Dragging = false
var offset = Vector2(0,0)
var ScreenSize 
var App

func _ready():
	App = get_parent()
	TopPanel = get_parent().get_node("TopPanel")
	ScreenSize = App.get_viewport_rect().size / App.get_canvas_transform().get_scale()
	
	TopPanel.mouse_entered.connect(func():
		MouseInZone = true
	)
	
	TopPanel.mouse_exited.connect(func():
		MouseInZone = false
	)

func _process(delta):
	MouseButton1Down = Input.is_mouse_button_pressed(1)
	var MousePosition = get_viewport().get_mouse_position()
	
	if(MouseInZone && MouseButton1Down && Dragging == false):
		Dragging = true
		offset = App.position - MousePosition
		#Set Offset
	elif(MouseButton1Down == false && Dragging == true):
		Dragging = false
	elif(Dragging == true):
		if(not (MousePosition.x > ScreenSize.x || MousePosition.x < 0 || MousePosition.y > ScreenSize.y || MousePosition.y < 0 )):
			App.position = get_viewport().get_mouse_position() + offset
		#MoveWindow
