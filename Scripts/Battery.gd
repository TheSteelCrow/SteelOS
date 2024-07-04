extends Panel

var Bar
var FullLength
var PowerPercentage = 100

# Called when the node enters the scene tree for the first time.
func _ready():
	Bar = get_node("Outline").get_node("Inner").get_node("Bar")
	FullLength = Bar.size.x

func UpdatePercentage():
	if(PowerPercentage >= 0 and PowerPercentage <= 100):
		Bar.size.x = FullLength/100 * PowerPercentage
	elif(PowerPercentage < 0):
		Bar.size.x = 0
	elif(PowerPercentage > 100):
		Bar.size.x = FullLength

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	UpdatePercentage() # move out of process eventually
