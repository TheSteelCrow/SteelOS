extends Node

var PreloadedImages = {}

var Data = {
	#"Folder" : {"PhotoName" : [PhotoData, Smooth]}
	#"Folder" : {"TxtFileName" : [Content, FontSize, Font, FontColor, PageColor]}
	"Downloads" : {},
	"Documents" : {},
	"Photos" : {}
}

func LoadImageToMemory(ImageToLoad):
	return load("res://PreloadedImages/" + ImageToLoad).get_image()

func _ready():
	Data["Documents"]["test.txt"] = ["Eve likes apples!", 50, 3, "ffffff", "000000"]
	
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
