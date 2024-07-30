extends Panel

var AppRunning = false
var AppVisible = false
var IsFullscreen = false

func OnAppVisible():
	pass

func Open():
	pass

func Reset():
	pass

func _on_disable_animations_toggle_toggled(button_pressed):
	if(button_pressed):
		get_parent().AnimationsMultiplier = 0
	elif(not button_pressed):
		get_parent().AnimationsMultiplier = 1
