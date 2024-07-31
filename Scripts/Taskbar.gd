extends Panel

var MenuPanel
var MenuOpen = false
var MainUI

var TaskProgress = 0
var TaskQuota = 10

var ProgressText = "[center]%s/%s[/center]"

@onready var Progress = $Progress

var TaskActive = false
var TaskName = "None"

func StartTask(TaskToStart):
	TaskActive = true
	TaskName = TaskToStart
	Progress.show()

func CancelTask():
	TaskActive = false
	TaskName = "None"
	TaskProgress = 0
	Progress.hide()

func CompleteTask():
	Progress.hide()
	TaskActive = false
	TaskName = "None"
	TaskProgress = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	MenuPanel = get_parent().get_node("Menu")
	MenuPanel.hide()
	MainUI = get_parent()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(MainUI.ShuttingDown == true):
		return
	if(TaskActive == true):
		Progress.show()
		Progress.text = ProgressText % [TaskProgress, TaskQuota]
	
	if(TaskProgress == TaskQuota):
		Progress.add_theme_color_override("default_color", Color("00ff00"))
	else:
		Progress.add_theme_color_override("default_color", Color("ffffff"))
	
	#move_to_front()
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

func _on_menu_button_button_up():
	print("Menu Button Pressed")
	if(MenuPanel.visible):
		MenuPanel.hide()
	else:
		MenuPanel.show()
		MenuPanel.move_to_front()
