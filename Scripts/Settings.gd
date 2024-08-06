extends Panel

var AppRunning = false
var AppVisible = false
var IsFullscreen = false

var Difficulties = {
	-2: "Creative",
	-1: "Easy",
	0: "Normal",
	1: "Hard",
	2: "Impossible"
}

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

func _on_h_slider_value_changed(value):
	get_node("Gameplay/Difficulty/Text").text = Difficulties[int(value)]

func _on_spin_box_value_changed(value):
	Engine.max_fps = int(value)

func _on_toggle_vsync_toggled(button_pressed):
	if(button_pressed):
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
	elif(!button_pressed):
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)

func _on_run_factory_reset_button_up():
	get_parent().get_node("Menu/Restart").button_up.emit()
	get_parent().get_node("SystemLoadingScreen/ShutDownRestartScreen/Text").text = "[center]Factory Reset..."

func _on_toggle_fps_label_toggled(button_pressed):
	get_parent().get_node("FPS").visible = button_pressed
