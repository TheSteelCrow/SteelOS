extends Node



var MenuPanel
var MenuOpen = false

# Called when the node enters the scene tree for the first time.
func _ready():
	MenuPanel = get_parent().get_node("Menu")
	MenuPanel.hide()
	var time = Time.get_time_dict_from_system()
	print(time)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var TimeText = get_node("TimeText")
	var DateText = get_node("DateText")
	TimeText.text = ""
	var SystemTime = Time.get_time_dict_from_system()
	var SystemDate = Time.get_date_dict_from_system()
	if(SystemTime.hour > 12):
		TimeText.text = "[right]" + str(SystemTime.hour - 12) + ":" + str(SystemTime.minute) + " pm" + "[/right]"
	else:
		TimeText.text = "[right]" + str(SystemTime.hour) + ":" + str(SystemTime.minute) + " am" + "[/right]"
		
	if(SystemDate.month < 10):
		DateText.text = "[right]" + str(SystemDate.day) + "/0" + str(SystemDate.month) + "/" + str(SystemDate.year) + "[/right]"
	else:
		DateText.text = "[right]" + str(SystemDate.day) + "/" + str(SystemDate.month) + "/" + str(SystemDate.year) + "[/right]"

func _on_menu_button_button_up():
	print("Menu Button Pressed")
	if(MenuOpen):
		MenuOpen = !MenuOpen
		MenuPanel.hide()
	else:
		MenuOpen = !MenuOpen
		MenuPanel.show()
