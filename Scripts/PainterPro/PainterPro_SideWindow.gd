extends Panel

@onready var Pages = [$Colour, $Tool, $General, $Other] # Pages of side window
@onready var tabBar = $TabBar
@onready var ArtApp = get_parent()
@onready var SideWindowToggle = $SideWindowToggle # Button

var OpenDownIcon
var CloseUpIcon

func _on_side_window_toggle_toggled(button_pressed):
	if(button_pressed == true):
		size.y = 40 # Makes side window small
		HideAllPages() # Hides all side window pages
		SideWindowToggle.icon = OpenDownIcon # Swaps icon for icon which shows that it is openable
		
		# Disables all tabs
		for i in range(0, tabBar.tab_count):
			tabBar.set_tab_disabled(i, true)
	elif(button_pressed == false):
		size.y = 640 # Makes side window big
		HideAllPages() # Hides all side window pages
		Pages[tabBar.current_tab].show() # Shows selected page of side window
		SideWindowToggle.icon = CloseUpIcon # Swaps icon for icon which shows that it is closable
		# Enables all tabs
		for i in range(0, tabBar.tab_count):
			tabBar.set_tab_disabled(i, false)

# Hides all side window pages
func HideAllPages():
	for Page in Pages:
		Page.hide()

func _ready():
	# Gets icons
	OpenDownIcon = preload("res://Images/tracking_horizontal_down.png")
	CloseUpIcon = preload("res://Images/tracking_horizontal_up.png")
	HideAllPages()
	Pages[tabBar.current_tab].show() # Show selected tab
	Pages[0].get_node("ColorPicker").position = Vector2(8,8) # Resets color picker position (Godot has a bug where the color pickher occasionally moves)

func _on_tab_bar_tab_changed(tab): # On tab selected
	HideAllPages()
	Pages[tab].show() # Show selected tab

func _on_locate_canvas_pressed(): # Locate canvas button within side window
	ArtApp.LocateCanvas()

func _on_zoom_by_top_left_toggled(button_pressed):
	ArtApp.ZoomByTopLeft = button_pressed

func _on_set_backdrop_pressed():
	ArtApp.get_node("Backdrop").color = Pages[0].get_node("ColorPicker").color # Sets backdrop color to color picker value
