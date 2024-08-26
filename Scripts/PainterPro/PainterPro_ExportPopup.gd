extends Panel

var App
var PPF #PainterPro_Functionality

var Temp_ImageFormatAsString = ".jpeg" #jpeg as default, no transparency

func _ready():
	App = get_parent()
	PPF = App.get_node("PainterPro")
	
	$ImageFormat.item_selected.connect(func(FormatSelectedAsInt):
		if(FormatSelectedAsInt == 0): # If JPEG selected from dropdown
			Temp_ImageFormatAsString = ".jpeg"
		elif(FormatSelectedAsInt == 1): # If PNG selected from dropdown
			Temp_ImageFormatAsString = ".png"
	)
	
	$Export.button_up.connect(func():
		var Temp_SaveLocation = $Location.get_item_text($Location.selected) # Gets save location from dropdown menu
		var Temp_FileName = $FileName.text # Gets File name from file name input box
		var Temp_RenderSmooth = $RenderSmooth.button_pressed # Gets render smooth selection from checkbox
		
		if(Temp_FileName != null): # If user has entered a name for the file
			App.Export(Temp_SaveLocation, Temp_ImageFormatAsString, Temp_FileName, Temp_RenderSmooth) # Send user settings to exporter
			hide()
	)
	
	$Cancel.button_up.connect(func(): # Export button cancel
		hide() # Hide export popup
	)
