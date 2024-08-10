extends Panel

var FileRoot
var FolderRoot

var FoldersTree
var FilesTree
var OpenedFolder = "None"

var IsFullscreen = false

@onready var DataHolder = $FileExplorerData

var TempOpenedFolder

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
	#print(DataHolder.Data["Downloads"][2][0])
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
	for File in DataHolder.Data[FolderToOpen].keys():
		var NewFileVisual = FilesTree.create_item(FileRoot)
		NewFileVisual.set_text(0, File)

func _on_folders_cell_selected():
	TempOpenedFolder = FoldersTree.get_selected().get_text(0)
	if(TempOpenedFolder in DataHolder.Data):
		OpenedFolder = TempOpenedFolder
		OpenFolder(OpenedFolder)
		

func _on_files_item_activated():
	var TempOpenedFile = FilesTree.get_selected().get_text(0)
	var PhotosApp = get_parent().get_node("PhotosApp")
	PhotosApp.OpenImage()
	if(DataHolder.Data[TempOpenedFolder][TempOpenedFile][1] == true):
		PhotosApp.get_node("ImageRenderer").texture_filter = TEXTURE_FILTER_LINEAR
	else:
		PhotosApp.get_node("ImageRenderer").texture_filter = TEXTURE_FILTER_NEAREST
	
	PhotosApp.get_node("ImageRenderer").texture = ImageTexture.create_from_image(DataHolder.Data[TempOpenedFolder][TempOpenedFile][0])
