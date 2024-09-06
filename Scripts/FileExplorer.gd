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
	
	FilesTree = get_node("Files")
	
	get_node("TopBar/DeleteButton").button_up.connect(func():
		if(FilesTree.get_selected() != null):
			DataHolder.Data[TempOpenedFolder].erase(FilesTree.get_selected().get_text(0))
			OpenFolder(TempOpenedFolder)
	)
	
	while true:
		await get_tree().create_timer(1).timeout
		if(TempOpenedFolder != null and get_node("AppBaseComponent").AppVisible == true and FilesTree.get_selected() == null):
			OpenFolder(TempOpenedFolder)

func OpenFolder(FolderToOpen):
	if(FolderToOpen == "My PC"):
		return
	
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
	
	var FileType = TempOpenedFile.split(".")[1]
	
	if(FileType == "txt"):
		OpenTextFile(TempOpenedFile)
	elif(FileType == "png"):
		OpenImageFile(TempOpenedFile)
	elif(FileType == "jpg"):
		OpenImageFile(TempOpenedFile)
	elif(FileType == "jpeg"):
		OpenImageFile(TempOpenedFile)

func OpenTextFile(File):
	var WriterFunctionality = get_parent().get_node("Writer/Writer")
	WriterFunctionality.OpenTextFile(DataHolder.Data[TempOpenedFolder][File])

func OpenImageFile(File):
	var PhotosApp = get_parent().get_node("PhotosApp")
	PhotosApp.OpenImage()
	
	if(DataHolder.Data[TempOpenedFolder][File][1] == true): # If rendered smooth
		PhotosApp.get_node("ImageRenderer").texture_filter = TEXTURE_FILTER_LINEAR # Smooth
	else:
		PhotosApp.get_node("ImageRenderer").texture_filter = TEXTURE_FILTER_NEAREST # Pixelated
	
	if(DataHolder.Data[TempOpenedFolder][File][0] != null): # If Image file exists
		PhotosApp.get_node("ImageRenderer").texture = ImageTexture.create_from_image(DataHolder.Data[TempOpenedFolder][File][0])
	elif(DataHolder.Data[TempOpenedFolder][File][0] == null): # Else use preloaded images
		PhotosApp.get_node("ImageRenderer").texture = ImageTexture.create_from_image(DataHolder.LoadImageToMemory(File))
