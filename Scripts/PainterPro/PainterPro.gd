extends Panel

var IsFullscreen = false
@onready var FileMenu = $TopOptions/File
@onready var EditMenu = $TopOptions/Edit
@onready var ViewMenu = $TopOptions/View
@onready var ImageMenu = $TopOptions/Image

var Main
var DataHolder
var PPF #PainterPro_Functionality

func _ready():
	Main = get_tree().root.get_child(0)
	DataHolder = Main.get_node("FileExplorer/FileExplorerData")
	PPF = $PainterPro
	
	FileMenu.get_popup().id_pressed.connect(func(ID):
		if(ID == 0):
			ExportPopup()
	)

	FileMenu.get_popup().id_pressed.connect(func(ID):
		if(ID == 3):
			NewCanvasPopup()
	)

func NewCanvasPopup(): # Opens new canvas popup
	$NewCanvasPopup.show()

func ExportPopup(): # Opens export canvas popup
	$ExportPopup.show()

# Exports an image and saves in memory
func Export(SaveLocation, FileFormatAsString, FileName, RenderSmooth):
	var ImageToExport = PPF.CurrentImage # Gets canvas
	var ImageExportFile = ImageToExport.get_region(ImageToExport.get_used_rect()) # Gets used area of canvas
	DataHolder.Data[SaveLocation][FileName + FileFormatAsString] = [ImageExportFile, RenderSmooth] # Saves used area of canvas to data

func OnAppVisible(): # On app visible
	pass

func Reset(): # On app reset
	pass

func Open(): # On app open
	pass

