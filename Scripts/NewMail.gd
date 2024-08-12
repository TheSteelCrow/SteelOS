extends Panel

@onready var SideBarPanel = $SideBar
var SideBarButtons = []

var OpenedCategory = "Inbox"

var IsFullscreen = false

func OnAppVisible():
	pass

func Reset():
	pass

func Open():
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	for SideBarButton in SideBarPanel.get_children():
		if(SideBarButton is Button):
			SideBarButtons.append(SideBarButton)
			SideBarButton.button_up.connect(func():
				for Obj in SideBarButtons:
					Obj.button_pressed = false
					Obj.size.x = 312
				SideBarButton.button_pressed = true
				SideBarButton.size.x = 288
			)
			
	print(SideBarButtons)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
