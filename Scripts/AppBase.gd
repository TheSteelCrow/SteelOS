extends Node

var Main

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
	Main = get_tree().root.get_child(0)
	
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
		if(not AppVisible): # If app is not visible
			AppVisible = true
			App.move_to_front()
			Main.OpenedApp = App
		
			if(AppRunning): # If app is not visible and running
				if(App.IsFullscreen == false):
					App.move_to_front()
					AppVisualTransition.Maximise(AppPreviousPosition)
					App.OnAppVisible()
				else: # If app is not visible and not running
					App.move_to_front()
					AppVisualTransition.Maximise(null)
					App.OnAppVisible()
			elif(not AppRunning): # If app is not visible and not running
				App.Open()
				AppRunning = true
				App.position = Vector2(0,0)
				App.scale = Vector2(1,1)
				App.show()
				App.OnAppVisible()
		elif(AppVisible): # If app is visible
			if(Main.OpenedApp == App): # If app is visible and recently opened
				AppPreviousPosition = App.position
				AppVisible = false
			
				if(App.IsFullscreen == false):
					AppVisualTransition.Minimise(AppPreviousPosition)
				else:
					AppVisualTransition.Minimise(null)
			else: # If app is visible and is not recently opened
				App.move_to_front()
				Main.OpenedApp = App
	)
