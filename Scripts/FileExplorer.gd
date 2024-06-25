extends Panel

var MouseButton1Down = false
var MouseInZone = false
var Dragging = false
var offset = Vector2(0,0)
var ScreenSize 

var FileExplorerTree

# Called when the node enters the scene tree for the first time.
func _ready():
	hide()
	
	ScreenSize = get_viewport_rect().size / get_canvas_transform().get_scale()
	FileExplorerTree = get_node("Tree")
	
	var root = FileExplorerTree.create_item()
	root.set_text(0, "My PC")
	FileExplorerTree.hide_root = false
	var DownloadsFolder = FileExplorerTree.create_item(root)
	DownloadsFolder.set_text(0, "Downloads")
	
	var DocumentsFolder = FileExplorerTree.create_item(root)
	DocumentsFolder.set_text(0, "Documents")
	
	var PhotosFolder = FileExplorerTree.create_item(root)
	PhotosFolder.set_text(0, "Photos")
	
	#var subchild1 = FileExplorerTree.create_item(child1)
	#subchild1.set_text(0, "Subchild1")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	MouseButton1Down = Input.is_mouse_button_pressed(1)
	var MousePosition = get_viewport().get_mouse_position()
	
	if(MouseInZone && MouseButton1Down && Dragging == false):
		Dragging = true
		offset = position - MousePosition
		#Set Offset
	elif(MouseButton1Down == false && Dragging == true):
		Dragging = false
	elif(Dragging == true):
		if(not (MousePosition.x > ScreenSize.x || MousePosition.x < 0 || MousePosition.y > ScreenSize.y || MousePosition.y < 0 )):
			position = get_viewport().get_mouse_position() + offset
		#MoveWindow

func _on_color_rect_mouse_entered():
	MouseInZone = true
	
func _on_color_rect_mouse_exited():
	MouseInZone = false

func _on_file_explorer_button_button_up():
	print("File Explorer Button Pressed")
	if(visible):
		hide()
	else:
		show()
		move_to_front()
