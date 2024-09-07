extends Panel

var Bar
var FullLength
var PowerPercentage = 100
var TaskTimeSeconds
var Taskbar
var TaskTimeCountdown
var Main

# Called when the node enters the scene tree for the first time.
func _ready():
	Main = get_tree().root.get_child(0)
	Bar = get_node("Outline/Inner/Bar")
	FullLength = Bar.size.x
	Taskbar = get_parent().get_parent()
	TaskTimeCountdown = get_node("TaskTimeCountdown")

func UpdatePercentage():
	if(PowerPercentage >= 0 and PowerPercentage <= 100):
		Bar.size.x = FullLength/100 * PowerPercentage
	elif(PowerPercentage < 0):
		Bar.size.x = 0
	elif(PowerPercentage > 100):
		Bar.size.x = FullLength

func _process(delta):
	if(Taskbar.TaskActive == true):
		PowerPercentage = 100 * (TaskTimeCountdown.time_left / TaskTimeSeconds)
		
		#print("You have " + str(TaskTimeCountdown.time_left) + "s of " + str(TaskTimeSeconds) + "s.")
		
		tooltip_text = "Battery: " + str(floor(PowerPercentage)) + "%, Time: " + str(floor(TaskTimeCountdown.time_left)) + "s"
		
		if(PowerPercentage == 0):
			Main.Death()
			PowerPercentage = 100
			Taskbar.TaskActive = false
			Taskbar.CancelTask()
	else:
		if(PowerPercentage != 100):
			PowerPercentage = 100
			tooltip_text = "Battery: " + str(floor(PowerPercentage))
	
	UpdatePercentage()
