extends Panel

var App
var PPF #PainterPro_Functionality

var Temp_ImageFormatAsString = ".jpeg" #jpeg as default, no transparency

# Called when the node enters the scene tree for the first time.
func _ready():
	App = get_parent()
	PPF = App.get_node("PainterPro")
	
	$ImageFormat.item_selected.connect(func(FormatSelectedAsInt):
		if(FormatSelectedAsInt == 0):
			Temp_ImageFormatAsString = ".jpeg"
		elif(FormatSelectedAsInt == 1):
			Temp_ImageFormatAsString = ".png"
	)
	
	$Export.button_up.connect(func():
		var Temp_SaveLocation = $Location.get_item_text($Location.selected)
		var Temp_FileName = $FileName.text
		var Temp_RenderSmooth = $RenderSmooth.button_pressed
		
		if(Temp_FileName != null):
			App.Export(Temp_SaveLocation, Temp_ImageFormatAsString, Temp_FileName, Temp_RenderSmooth)
			hide()
	)
	
	$Cancel.button_up.connect(func():
		hide()
	)
