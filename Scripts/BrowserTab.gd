extends Button

@onready var CloseTabButton = $CloseTabButton

var ShowCloseTabButton = false

var SearchEngine

var IsSelected = false
var NormalStyle = StyleBoxFlat.new()

func Deselect():
	NormalStyle.bg_color = Color("585858")

func Select():
	NormalStyle.bg_color = Color("303030")

# Called when the node enters the scene tree for the first time.
func _ready():
	var SearchEngine = get_tree().root.get_child(0).get_node("SearchEngine")

	NormalStyle.bg_color = Color("585858")
	NormalStyle.corner_radius_top_left = 10
	NormalStyle.corner_radius_top_right = 10
	add_theme_stylebox_override("normal", NormalStyle)
	
	self.button_up.connect(func():
		IsSelected = true
		SearchEngine.OpenTab(self)
	)
	
	self.mouse_entered.connect(func():
		ShowCloseTabButton = true
	)
	
	self.mouse_exited.connect(func():
		ShowCloseTabButton = false
	)
	
	CloseTabButton.mouse_exited.connect(func():
		ShowCloseTabButton = false
	)
	
	CloseTabButton.mouse_entered.connect(func():
		ShowCloseTabButton = true
	)
	CloseTabButton.button_up.connect(func():
		var Tabs = get_parent().get_children()
		if(Tabs.size() > 1):
			SearchEngine.OpenTab(Tabs[self.get_index()-1])
		else:
			SearchEngine.get_node("AppBaseComponent").Close()
		get_parent().remove_child(self)
		SearchEngine.AlignTabs()
		queue_free()
	)
	
	CloseTabButton.mouse_exited.connect(func():
		ShowCloseTabButton = false
	)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(ShowCloseTabButton == false):
		CloseTabButton.hide()
	else:
		CloseTabButton.show()
