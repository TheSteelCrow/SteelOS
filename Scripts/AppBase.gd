extends Node

var Main

var AppRunning = false
var AppVisible = false

var CloseButton
var MinimiseButton
var AppButton
var AppIconOnTaskbar
var AppName
var App

var AppVisualTransition

var AppPreviousPosition

# Called when the node enters the scene tree for the first time.

func Close():
	SetTaskbarIcon("Close")
	AppRunning = false
	AppVisible = false
	App.hide()
	App.Reset()

func Open():
	App.Open()
	AppRunning = true
	App.position = Vector2(0,0)
	App.scale = Vector2(1,1)
	App.show()
	App.OnAppVisible()
	
func SetTaskbarIcon(State):
	if(State == "Open"):
		AppIconOnTaskbar.get_node("IndicatorOpened").show()
		AppIconOnTaskbar.get_node("IndicatorMinimised").hide()
	elif(State == "Minimise"):
		AppIconOnTaskbar.get_node("IndicatorOpened").hide()
		AppIconOnTaskbar.get_node("IndicatorMinimised").show()
	elif(State == "Close"):
		AppIconOnTaskbar.get_node("IndicatorOpened").hide()
		AppIconOnTaskbar.get_node("IndicatorMinimised").hide()

func _ready():
	print("Main Running")
	Main = get_tree().root.get_child(0)
	
	App = get_parent()
	AppName = App.name
	AppVisualTransition = App.get_node("AppVisualTransitionComponent")
	
	CloseButton = App.get_node("TopPanel").get_node("CloseButton")
	MinimiseButton = App.get_node("TopPanel").get_node("MinimiseButton")
	if(App.get_parent().get_node("Taskbar/IconArranger/" + AppName + "Backdrop")):
		AppIconOnTaskbar = App.get_parent().get_node("Taskbar/IconArranger/" + AppName + "Backdrop")
		AppButton = AppIconOnTaskbar.get_node(AppName + "Button")
		
	CloseButton.button_up.connect(Close)
	if(MinimiseButton != null):
		MinimiseButton.button_up.connect(func():
			AppPreviousPosition = App.position
			AppVisible = false
			if(App.IsFullscreen == false):
				AppVisualTransition.Minimise(AppPreviousPosition)
			else:
				AppVisualTransition.Minimise(null)
			SetTaskbarIcon("Minimise")
		)
	if(AppButton != null):
		AppButton.button_up.connect(func():
			if(not AppVisible): # If app is not visible
				SetTaskbarIcon("Open")
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
				SetTaskbarIcon("Minimise")
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
