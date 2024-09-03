extends Node

var PreloadedImages = {}

var Data = {
	#"Folder" : {["File Name", [File, Smooth]]}
	"Downloads" : {},
	"Documents" : {},
	"Photos" : {}
}

func LoadImageToMemory(ImageToLoad):
	return load("res://PreloadedImages/" + ImageToLoad).get_image()

func _ready():
	Data["Documents"]["Test.txt"] = "test"
	
	PreloadedImages = [
		"adem.jpg",
		"beehive.jpg",
		"isaac.jpg",
		"potato(e).jpg",
		"somewhere.jpg",
		"whataview.jpg",
		"jayden.jpg"
	]
	
	for PreloadedImageName in PreloadedImages:
		Data["Photos"][PreloadedImageName] = [null, true]
