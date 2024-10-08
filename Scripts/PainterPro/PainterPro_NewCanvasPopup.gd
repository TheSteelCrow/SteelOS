extends Panel

var App
var PPF #PainterPro_Functionality

var TempImageFormat = Image.FORMAT_RGB8 #jpeg as default, no transparency

# Called when the node enters the scene tree for the first time.
func _ready():
	App = get_parent()
	PPF = App.get_node("PainterPro")
	
	$ImageFormat.item_selected.connect(func(FormatSelectedAsInt): # Gets item selected by user from dropdown as int
		if(FormatSelectedAsInt == 0):
			TempImageFormat = Image.FORMAT_RGB8 #jpeg
		elif(FormatSelectedAsInt == 1):
			TempImageFormat = Image.FORMAT_RGBA8 #png
	)
	
	$Create.button_up.connect(func(): # On user confirmation recieved
		# Sends user submited settings to PainterPro_Functionality
		PPF.ImageResolution = Vector2($Width.value, $Height.value)
		PPF.ScaleBy = $ScaleBy.value
		PPF.ImageFormat = TempImageFormat
		PPF.SetupCanvas()
		hide()
	)
	
	# Cancels operation
	$Cancel.button_up.connect(func():
		hide()
	)
