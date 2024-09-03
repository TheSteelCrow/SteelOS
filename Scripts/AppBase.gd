extends Node

## This script acts as a base component for every CrowOS App. This makes the code reusable and allows for easy implimentation of new apps.

var Main

var AppRunning = false # App status
var AppVisible = false # App visibility status

var CloseButton
var MinimiseButton
var AppButton
var AppIconOnTaskbar
var AppName
var App

var AppVisualTransition # Component

var AppPreviousPosition

# Close app
func Close():
	SetTaskbarIcon("Close")
	AppRunning = false
	AppVisible = false
	App.hide()
	App.Reset()

# Opens app
func Open(): 
	App.move_to_front()
	App.Open()
	AppRunning = true
	App.position = Vector2(0,0)
	App.scale = Vector2(1,1)
	App.show()
	App.OnAppVisible()

# Sets app icon on taskbar to passed state
func SetTaskbarIcon(State):
	if(AppIconOnTaskbar != null):
		if(State == "Open"):
			AppIconOnTaskbar.get_node("IndicatorOpened").show() # Indicator opened is the glow
			AppIconOnTaskbar.get_node("IndicatorMinimised").hide() # Indicator minimised is white dot
		elif(State == "Minimise"):
			AppIconOnTaskbar.get_node("IndicatorOpened").hide()
			AppIconOnTaskbar.get_node("IndicatorMinimised").show()
		elif(State == "Close"):
			AppIconOnTaskbar.get_node("IndicatorOpened").hide()
			AppIconOnTaskbar.get_node("IndicatorMinimised").hide()

func _ready():
	Main = get_tree().root.get_child(0) # Gets MainUI
	
	App = get_parent()
	AppName = App.name
	AppVisualTransition = App.get_node("AppVisualTransitionComponent")
	
	CloseButton = App.get_node("TopPanel").get_node("CloseButton")
	MinimiseButton = App.get_node("TopPanel").get_node("MinimiseButton")
	
	if(App.get_parent().get_node("Taskbar/IconArranger/" + AppName + "Backdrop")): # If app has taskbar icon
		AppIconOnTaskbar = App.get_parent().get_node("Taskbar/IconArranger/" + AppName + "Backdrop") # Get task bar icon
		AppButton = AppIconOnTaskbar.get_node(AppName + "Button") # Get app button
		
	CloseButton.button_up.connect(Close)
	
	if(MinimiseButton != null): # If app has minimise button
		MinimiseButton.button_up.connect(func(): # On minimise button pressed
			AppPreviousPosition = App.position # Sets starting position of app for animations
			AppVisible = false
			if(App.IsFullscreen == false): # If app is a fullscreen app, minimise based on app starting position
				AppVisualTransition.Minimise(AppPreviousPosition)
			else: # If app is not a fullscreen app, minimise app to 0,0 (See App Visual Transition component for more info)
				AppVisualTransition.Minimise(null)
			SetTaskbarIcon("Minimise") # Sets taskbar icon to minimsed state
		)
	
	if(AppButton != null): # If app has taskbar button
		AppButton.button_up.connect(func(): # ON app task bar button pressed
			if(not AppVisible): # If app is not visible
				SetTaskbarIcon("Open") # Sets taskbar icon to opened state
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
				if(Main.OpenedApp == App): # If app is visible and recently opened then minimise
					AppPreviousPosition = App.position
					AppVisible = false
					
					if(App.IsFullscreen == false):
						AppVisualTransition.Minimise(AppPreviousPosition)
					else:
						AppVisualTransition.Minimise(null)
				else: # If app is visible and is not recently opened then bring to front
					App.move_to_front()
					Main.OpenedApp = App
		)
