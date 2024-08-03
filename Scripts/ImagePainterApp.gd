extends Panel

var IsFullscreen = true

@onready var ImagePainter = $ImagePainter
var PhotosApp
var Main

func _ready():
	Main = get_parent()
	PhotosApp = get_parent().get_node("PhotosApp")

func Open():
	get_node("ColorPicker").position = Vector2(1568,112)

func Reset():
	pass

func OnAppVisible():
	pass

func _on_new_button_up():
	var QueryPopup = Main.GeneratePopup("VectorPainter", "Are you sure you want to generate a new canvas? This will overwrite any existing canvas, and may cause lag on slower devices!", "Query", Vector2(672, 384))
	
	await QueryPopup.response_signal
	
	if(QueryPopup.UserResponse == true):
		ImagePainter.SetupPixels()
	else:
		return

func _on_open_button_up():
	PhotosApp.OpenImage()

func _on_save_button_up():
	PhotosApp.ExportImage()
