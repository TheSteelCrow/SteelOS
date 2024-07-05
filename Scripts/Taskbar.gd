extends Panel

var MenuPanel
var MenuOpen = false
var MainUI

#var SystemTime = Time.get_time_dict_from_system()

# Called when the node enters the scene tree for the first time.
func _ready():
	#SystemTime.hour = 0
	MenuPanel = get_parent().get_node("Menu")
	MenuPanel.hide()
	MainUI = get_parent()
	#var time = Time.get_time_dict_from_system()
	#print(time)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(MainUI.ShuttingDown == true):
		return
	
	move_to_front()
	var TimeText = get_node("TimeText")
	var DateText = get_node("DateText")
	TimeText.text = ""
	var SystemTime = Time.get_time_dict_from_system()
	var SystemDate = Time.get_date_dict_from_system()
	
	if(SystemTime.hour > 12):
		if(SystemTime.minute > 9):
			TimeText.text = "[right]" + str(SystemTime.hour - 12) + ":" + str(SystemTime.minute) + " pm" + "[/right]"
		else:
			TimeText.text = "[right]" + str(SystemTime.hour - 12) + ":0" + str(SystemTime.minute) + " pm" + "[/right]"
	elif (SystemTime.hour == 12):
		if(SystemTime.minute > 9):
			TimeText.text = "[right]" + str(SystemTime.hour) + ":" + str(SystemTime.minute) + " pm" + "[/right]"
		else:
			TimeText.text = "[right]" + str(SystemTime.hour) + ":0" + str(SystemTime.minute) + " pm" + "[/right]"
	elif (SystemTime.hour == 24):
		if(SystemTime.minute > 9):
			TimeText.text = "[right]" + str(SystemTime.hour - 12) + ":" + str(SystemTime.minute) + " pm" + "[/right]"
		else:
			TimeText.text = "[right]" + str(SystemTime.hour - 12) + ":0" + str(SystemTime.minute) + " pm" + "[/right]"
	else:
		if(SystemTime.minute > 9):
			TimeText.text = "[right]" + str(SystemTime.hour) + ":" + str(SystemTime.minute) + " am" + "[/right]"
		else:
			TimeText.text = "[right]" + str(SystemTime.hour) + ":0" + str(SystemTime.minute) + " am" + "[/right]"
		
	if(SystemDate.month < 10):
		DateText.text = "[right]" + str(SystemDate.day) + "/0" + str(SystemDate.month) + "/" + str(SystemDate.year) + "[/right]"
	else:
		DateText.text = "[right]" + str(SystemDate.day) + "/" + str(SystemDate.month) + "/" + str(SystemDate.year) + "[/right]"

#func _physics_process(delta):
#	if Input.is_action_pressed("ui_right"):
#		SystemTime.hour += 1
#	elif Input.is_action_pressed("ui_left"):
#		SystemTime.hour -= 1

func _on_menu_button_button_up():
	print("Menu Button Pressed")
	if(MenuPanel.visible):
		MenuPanel.hide()
	else:
		MenuPanel.show()
		MenuPanel.move_to_front()
