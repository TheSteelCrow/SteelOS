extends Panel

@onready var Pages = [$Colour, $Tool, $General, $Other]
@onready var tabBar = $TabBar
@onready var ArtApp = get_parent()
@onready var SideWindowToggle = $SideWindowToggle

var OpenDownIcon
var CloseUpIcon

func _on_side_window_toggle_toggled(button_pressed):
	if(button_pressed == true):
		print("Small")
		size.y = 40
		HideAllPages()
		SideWindowToggle.icon = OpenDownIcon
		
		for i in range(0, tabBar.tab_count):
			tabBar.set_tab_disabled(i, true)
	elif(button_pressed == false):
		print("Big")
		size.y = 640
		HideAllPages()
		Pages[tabBar.current_tab].show()
		SideWindowToggle.icon = CloseUpIcon
		for i in range(0, tabBar.tab_count):
			tabBar.set_tab_disabled(i, false)
func HideAllPages():
	for Page in Pages:
		Page.hide()

func _ready():
	OpenDownIcon = preload("res://Images/tracking_horizontal_down.png")
	CloseUpIcon = preload("res://Images/tracking_horizontal_up.png")
	HideAllPages()
	Pages[tabBar.current_tab].show()
	Pages[0].get_node("ColorPicker").position = Vector2(8,8)

func _on_tab_bar_tab_changed(tab):
	HideAllPages()
	Pages[tab].show()

func _on_locate_canvas_pressed():
	ArtApp.LocateCanvas()

func _on_zoom_by_top_left_toggled(button_pressed):
	ArtApp.ZoomByTopLeft = button_pressed

func _on_set_backdrop_pressed():
	ArtApp.get_node("Backdrop").color = Pages[0].get_node("ColorPicker").color
