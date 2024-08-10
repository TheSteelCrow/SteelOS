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

func NewCanvasPopup():
	$NewCanvasPopup.show()

func ExportPopup():
	$ExportPopup.show()

func Export(SaveLocation, FileFormatAsString, FileName, RenderSmooth):
	var ImageToExport = PPF.CurrentImage
	var ImageExportFile = ImageToExport.get_region(ImageToExport.get_used_rect())
	DataHolder.Data[SaveLocation][FileName + FileFormatAsString] = [ImageExportFile, RenderSmooth]
	print(DataHolder.Data[SaveLocation])

func OnAppVisible():
	pass

func Reset():
	pass

func Open():
	pass

