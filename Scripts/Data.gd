extends Node

var PreloadedImages = {}

var Data = {
	#"Folder" : {"PhotoName" : [PhotoData, Smooth], "PhotoName2" : [PhotoData2, Smooth2]}
	#"Folder" : {"TxtFileName" : [FileData, FontSize], "TxtFileName2" : [FileData2, FontSize2]}
	"Downloads" : {},
	"Documents" : {},
	"Photos" : {}
}

func LoadImageToMemory(ImageToLoad):
	return load("res://PreloadedImages/" + ImageToLoad).get_image()

func _ready():
	Data["Documents"]["test.txt"] = ["Adam likes apples !", 5]
	
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
