extends Panel

var TopPanelObjects

@onready var NewsPanels = [$WorldNews, $SprintNews, $AloftiaNews, $OtherNews]

# Called when the node enters the scene tree for the first time.
func _ready():
	TopPanelObjects = get_node("TopPanel").get_children()
	for Obj in TopPanelObjects:
		if(Obj is Button): #If child of top panel is button
			Obj.button_up.connect(func(): # When button clicked
				for NewsPanel in NewsPanels:
					NewsPanel.hide()# Hide coresponding panels
				get_node(str(Obj.name)).show() # Show the panel coresponding to the button pressed
			)
