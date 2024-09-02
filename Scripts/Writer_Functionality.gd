extends Control

var TopPanel
var App
var Main
var FileExplorerData

func _ready():
	App = get_parent()
	TopPanel = App.get_node("TopPanel")
	Main = get_tree().root.get_child(0)
	FileExplorerData = Main.get_node("FileExplorer/FileExplorerData")
	
	TopPanel.get_node("File").get_popup().id_pressed.connect(func(ID):
		if(ID == 0): # New
			get_node("Page/TextEdit").text = ""
		if(ID == 1): # Open
			print("Open")
			#Main.FileSelector.Open()
			#await Signal(Main.FileSelector, "SelectionMade")
			#if(Main.FileSelector.TempOpenedFile != null): # If user selected a file
				#Open File
		if(ID == 2): # Save
			print("Save")
	)
