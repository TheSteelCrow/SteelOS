extends Panel

var App
var WF #Writer_Functionality

var Temp_FileFormatAsString = ".txt" #txt as default
var Main

func _ready():
	App = get_parent()
	WF = App.get_node("Writer")
	Main = get_tree().root.get_child(0)
	
	$FileFormat.item_selected.connect(func(FormatSelectedAsInt):
		if(FormatSelectedAsInt == 0): # If txt selected from dropdown
			Temp_FileFormatAsString = ".txt"
	)
	
	$Save.button_up.connect(func():
		var Temp_SaveLocation = $Location.get_item_text($Location.selected) # Gets save location from dropdown menu
		var Temp_FileName = $FileName.text # Gets File name from file name input box
		
		if(Temp_FileName != null): # If user has entered a name for the file
			#[Content, FontSize, Font, FontColor, PageColor]
			Main.get_node("FileExplorer/FileExplorerData").Data[Temp_SaveLocation][Temp_FileName + Temp_FileFormatAsString] = [
				WF.get_node("Page/TextEdit").text,
				App.get_node("TopPanel/FontSize").value,
				App.get_node("TopPanel/FontDropdown").selected,
				App.get_node("TopPanel/FontColor").color.to_html(),
				App.get_node("TopPanel/PageColor").color.to_html(),
			]
			hide()
	)
	
	$Cancel.button_up.connect(func(): # Export button cancel
		hide() # Hide export popup
	)
