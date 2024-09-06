extends Panel

var Bar
var FullLength
var PowerPercentage = 100
var Taskbar

# Called when the node enters the scene tree for the first time.
func _ready():
	Bar = get_node("Outline").get_node("Inner").get_node("Bar")
	FullLength = Bar.size.x
	Taskbar = get_parent().get_parent()

func UpdatePercentage():
	if(PowerPercentage >= 0 and PowerPercentage <= 100):
		Bar.size.x = FullLength/100 * PowerPercentage
	elif(PowerPercentage < 0):
		Bar.size.x = 0
	elif(PowerPercentage > 100):
		Bar.size.x = FullLength

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(Taskbar.TaskActive == true):
		tooltip_text = "Battery: " + str(floor(PowerPercentage))
		PowerPercentage -= 0.5 * delta
		UpdatePercentage() # move out of process eventually
	else:
		if(PowerPercentage != 100):
			PowerPercentage = 100
			tooltip_text = "Battery: " + str(floor(PowerPercentage))
