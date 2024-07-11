extends Panel

var POSITION_FROM_WALL = 8

var AppName = "Mail"

@onready var Inbox = $Inbox

func Reset():
	print("Reseting " + AppName)

# Called when the node enters the scene tree for the first time.
func _ready():
	AlignInboxLines()

func AlignInboxLines():
	var InboxLines = Inbox.get_children()
	InboxLines.reverse()
	
	for i in range(InboxLines.size()):
		InboxLines[i].position = (Vector2(8, 8 + 72*i))
