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

func OnAppVisible():
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
