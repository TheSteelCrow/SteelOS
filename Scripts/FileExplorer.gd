extends Panel

var MouseButton1Down = false
var MouseInZone = false
var Dragging = false
var offset = Vector2(0,0)
var ScreenSize 

var FoldersTree
var FilesTree

var Data = {
	#"Folder" : [["File Name", "FileSize"], ["File Name 2", "FileSize2"]]
	"Downloads" : [["car.txt", 0], ["bike.txt", 0], ["train.txt", 0]],
	"Documents" : [["work.txt", 0], ["hardwork.txt", 0], ["easy.txt", 0]],
	"Photos" : [["cat.gif", 0], ["dog.png", 0], ["fish.jpg", 0]]
}

# Called when the node enters the scene tree for the first time.
func _ready():
	hide()
	
	#print(Data)
	print(Data["Downloads"][2][0])
	
	ScreenSize = get_viewport_rect().size / get_canvas_transform().get_scale()
	FoldersTree = get_node("Folders")
	
	var FolderRoot = FoldersTree.create_item()
	FolderRoot.set_text(0, "My PC")
	FoldersTree.hide_root = false
	var DownloadsFolder = FoldersTree.create_item(FolderRoot)
	DownloadsFolder.set_text(0, "Downloads")
	
	var DocumentsFolder = FoldersTree.create_item(FolderRoot)
	DocumentsFolder.set_text(0, "Documents")
	
	var PhotosFolder = FoldersTree.create_item(FolderRoot)
	PhotosFolder.set_text(0, "Photos")
	
	#var subchild1 = FoldersTree.create_item(child1)
	#subchild1.set_text(0, "Subchild1")
	
	FilesTree = get_node("Files")
	var FileRoot = FilesTree.create_item()
	FileRoot.set_text(0, "Downloads")
	var File1 = FilesTree.create_item(FileRoot)
	File1.set_text(0, "CoolFile1")


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
