extends Panel

signal SelectionMade

var FileRoot
var FolderRoot

var FoldersTree
var FilesTree
var OpenedFolder = "None"

var IsFullscreen = false

var DataHolder

var TempOpenedFolder
var TempOpenedFile

@onready var FileNameDisplay = $FileSelectorMenu/BottomPanel/FileNameDisplay

func Open():
	show()
	move_to_front()
	TempOpenedFolder = ""

func _ready():
	DataHolder = get_parent().get_node("FileExplorer/FileExplorerData")
	FoldersTree = get_node("FileSelectorMenu/Folders")
	
	FolderRoot = FoldersTree.create_item()
	FolderRoot.set_text(0, "My PC")
	
	FoldersTree.hide_root = false
	
	var DownloadsFolder = FoldersTree.create_item(FolderRoot)
	DownloadsFolder.set_text(0, "Downloads")
	
	var DocumentsFolder = FoldersTree.create_item(FolderRoot)
	DocumentsFolder.set_text(0, "Documents")
	
	var PhotosFolder = FoldersTree.create_item(FolderRoot)
	PhotosFolder.set_text(0, "Photos")
	
	FilesTree = get_node("FileSelectorMenu/Files")

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

func _on_confirm_button_up():
	if(TempOpenedFile != null):
		SelectionMade.emit()
		TempOpenedFile = null
		hide()

func _on_cancel_button_up():
	TempOpenedFile = null
	SelectionMade.emit()
	hide()

func _on_files_item_selected():
	TempOpenedFile = FilesTree.get_selected().get_text(0)
	$FileSelectorMenu/BottomPanel/FileNameDisplay.text = TempOpenedFile

func _on_files_item_activated():
	TempOpenedFile = FilesTree.get_selected().get_text(0)
	$FileSelectorMenu/BottomPanel/FileNameDisplay.text = TempOpenedFile
	
	if(TempOpenedFolder != null):
		SelectionMade.emit()
		hide()
