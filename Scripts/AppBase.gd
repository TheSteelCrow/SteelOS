extends Node

var AppRunning = false
var AppVisible = false

var CloseButton
var MinimiseButton
var AppButton
var AppName
var App

var AppVisualTransition

var AppPreviousPosition

# Called when the node enters the scene tree for the first time.
func _ready():
	App = get_parent()
	AppName = App.name
	AppVisualTransition = App.get_node("AppVisualTransitionComponent")
	
	CloseButton = App.get_node("TopPanel").get_node("CloseButton")
	MinimiseButton = App.get_node("TopPanel").get_node("MinimiseButton")
	AppButton = App.get_parent().get_node("Taskbar").get_node(AppName + "Backdrop").get_node(AppName + "Button")
	
	CloseButton.button_up.connect(func():
		AppRunning = false
		AppVisible = false
		App.hide()
		App.Reset()
	)
	
	MinimiseButton.button_up.connect(func():
		AppPreviousPosition = App.position
		AppVisible = false
		if(App.IsFullscreen == false):
			AppVisualTransition.Minimise(AppPreviousPosition)
		else:
			AppVisualTransition.Minimise(null)
	)
	
	AppButton.button_up.connect(func():
		if(not AppVisible):
			AppVisible = true
			App.move_to_front()
		
			if(AppRunning):
				if(App.IsFullscreen == false):
					AppVisualTransition.Maximise(AppPreviousPosition)
				else:
					AppVisualTransition.Maximise(null)
			elif(not AppRunning):
				App.Open()
				AppRunning = true
				App.position = Vector2(0,0)
				App.scale = Vector2(1,1)
				App.show()
		elif(AppVisible):
			AppPreviousPosition = App.position
			AppVisible = false
			
			if(App.IsFullscreen == false):
				AppVisualTransition.Minimise(AppPreviousPosition)
			else:
				AppVisualTransition.Minimise(null)
	)
