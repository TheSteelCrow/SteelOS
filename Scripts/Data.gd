extends Node

var PreloadedImages = {}

var Data = {
	#"Folder" : {["File Name", [File, Smooth]]}
	"Downloads" : {},
	"Documents" : {},
	"Photos" : {}
}

func _ready():
	PreloadedImages = {
		"adem.jpeg" : load("res://PreloadedImages/adem.jpg").get_image(),
		"beehive.jpeg" : load("res://PreloadedImages/beehive.jpg").get_image(),
		"isaac.jpeg" : load("res://PreloadedImages/isaac.jpg").get_image(),
		"potato(e).jpeg" : load("res://PreloadedImages/potato(e).jpg").get_image(),
		"somewhere.jpeg" : load("res://PreloadedImages/somewhere.jpg").get_image(),
		"whataview.jpeg" : load("res://PreloadedImages/whataview.jpg").get_image(),
		"jayden.jpeg" : load("res://PreloadedImages/jayden.jpg").get_image()
	}
	
	for PreloadedImageName in PreloadedImages.keys():
		Data["Photos"][PreloadedImageName] = [PreloadedImages[PreloadedImageName], true]
