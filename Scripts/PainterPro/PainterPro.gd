extends Panel

var IsFullscreen = false
@onready var FileMenu = $TopOptions/File
@onready var EditMenu = $TopOptions/File
@onready var ViewMenu = $TopOptions/File
@onready var ImageMenu = $TopOptions/File

var Main
var DataHolder
var PPF #PainterPro_Functionality

var ExportNumber = 1

func _ready():
	Main = get_tree().root.get_child(0)
	DataHolder = Main.get_node("FileExplorer/FileExplorerData")
	PPF = $PainterPro
	
	FileMenu.get_popup().id_pressed.connect(func(ID):
		if(ID == 2):
			Export()
	)

func Export():
	var CurrentImage = PPF.CurrentImage
	#var ImageExportFile = Image.new().create(PPF.ImageResolution.x,PPF.ImageResolution.y,false, Image.FORMAT_RGB8)
	var ImageExportFile = CurrentImage.get_region(CurrentImage.get_used_rect())
	DataHolder.Data["Photos"]["NewExport" + str(ExportNumber) + ".png"] = ImageExportFile
	ExportNumber += 1
	print(DataHolder.Data)
	#Main.get_node("Background").texture = ImageTexture.create_from_image(ImageExportFile)

func OnAppVisible():
	pass

func Reset():
	pass

func Open():
	pass

