extends Panel

var MenuPanel
var MenuOpen = false
var Main

var TaskProgress = 0
var TaskQuota = 10

var ProgressText = "[center]%s/%s[/center]"

var Progress

var TaskActive = false
var TaskName = "None"

var AlmostFront = false # If true, taskbar will have a child value of 1 instead of 0 when moving to front
var TaskReadyForCompletion = false

var Battery

func StartTask(TaskToStart, TaskTimeSeconds):
	Battery.TaskTimeSeconds = TaskTimeSeconds
	Battery.TaskTimeCountdown.start(TaskTimeSeconds)

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

func _ready():
	Progress = get_node("RightSideIcons/Progress")
	MenuPanel = get_parent().get_node("Menu")
	MenuPanel.hide()
	Main = get_parent()
	Battery = get_node("RightSideIcons/Battery")

func _process(delta):
	if(Main.ShuttingDown == true):
		return
	if(Main.SystemLoadingScreen.visible == false):
		move_to_front()
		if(AlmostFront == true):
			get_parent().move_child(self, 1)
	
	if(TaskActive == true):
		Progress.show()
		Progress.text = ProgressText % [TaskProgress, TaskQuota]
	
	if(TaskProgress == TaskQuota && TaskReadyForCompletion == false):
		TaskReadyForCompletion = true
		Progress.add_theme_color_override("default_color", Color("00ff00"))
		var Mail = Main.get_node("Mail")
		Mail.DisplayEmails()
		if(Mail.OpenedEmailID != null):
			Mail.OpenEmail(Mail.OpenedEmailID)
		#Mail.OpenEmail(Mail.CurrentTaskEmail)
	elif(TaskProgress != TaskQuota):
		TaskReadyForCompletion = false
		Progress.add_theme_color_override("default_color", Color("ffffff"))
	
	var TimeText = get_node("RightSideIcons/TimeText")
	var DateText = get_node("RightSideIcons/DateText")
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
