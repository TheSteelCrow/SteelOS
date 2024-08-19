extends Control

var TopPanel
var App

func _ready():
	App = get_parent()
	TopPanel = App.get_node("TopPanel")
	
	TopPanel.get_node("File").get_popup().id_pressed.connect(func(ID):
		if(ID == 0):
			get_node("Page/TextEdit").text = ""
		if(ID == 1):
			print("Open")
		if(ID == 2):
			print("Save")
	)
