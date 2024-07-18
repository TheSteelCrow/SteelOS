extends Panel

var MouseButton1Down = false
var MouseInZone = false
var Dragging = false
var offset = Vector2(0,0)
var ScreenSize 

var FileRoot
var FolderRoot

var FoldersTree
var FilesTree
var OpenedFolder = "None"

var IsFullscreen = false

var Data = {
	#"Folder" : [["File Name", "FileSize"], ["File Name 2", "FileSize2"]]
	"Downloads" : [["car.txt", 0], ["bike.txt", 0], ["train.txt", 0]],
	"Documents" : [["work.txt", 0], ["hardwork.txt", 0], ["easy.txt", 0]],
	"Photos" : [["cat.gif", 0], ["dog.png", 0], ["fish.jpg", 0]]
}

func Open():
	pass

func Reset():
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	hide()
	
	#print(Data)
	print(Data["Downloads"][2][0])
	
	ScreenSize = get_viewport_rect().size / get_canvas_transform().get_scale()
	FoldersTree = get_node("Folders")
	
	FolderRoot = FoldersTree.create_item()
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

func _on_window_drag_bar_mouse_entered():
	MouseInZone = true
	
func _on_window_drag_bar_mouse_exited():
	MouseInZone = false

func OpenFolder(FolderToOpen):
	FilesTree.clear()
	FileRoot = FilesTree.create_item()
	FileRoot.set_text(0, "OpenedFolder")
	for File in Data[FolderToOpen]:
		var NewFileVisual = FilesTree.create_item(FileRoot)
		NewFileVisual.set_text(0, File[0])

func _on_folders_cell_selected():
	var TempOpenedFolder = FoldersTree.get_selected().get_text(0)
	if(TempOpenedFolder in Data):
		OpenedFolder = TempOpenedFolder
		OpenFolder(OpenedFolder)
