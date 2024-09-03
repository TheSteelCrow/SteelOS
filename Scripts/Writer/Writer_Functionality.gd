extends Control

var DEFAULT_FONT_SIZE = 30
var DEFAULT_FONT_COLOR = Color("000000")
var DEFAULT_PAGE_COLOR = Color("ffffff")

var TopPanel
var App
var Main
var FileExplorerData

var FontPath = [
	"res://Fonts/Bolshevik.otf",
	"res://Fonts/ConsolaMono-Bold.ttf",
	"res://Fonts/ConsolaMono-Book.ttf",
	"res://Fonts/Digitalt.ttf",
	"res://Fonts/Gontserrat-Light.ttf",
	"res://Fonts/Jackwrite.ttf",
	"res://Fonts/LTSuperior-Regular.otf",
	"res://Fonts/Unispace Rg.otf",
	"res://Fonts/VeraMoBd.ttf",
	"res://Fonts/VeraMono.ttf",
]

func ResetWriter():
	get_node("Page/TextEdit").text = ""
	get_node("Page/TextEdit").remove_theme_font_override("font")
	get_node("Page/TextEdit").add_theme_font_size_override("font_size", DEFAULT_FONT_SIZE)
	get_node("Page/TextEdit").add_theme_color_override("font_color", DEFAULT_FONT_COLOR)
	TopPanel.get_node("FontColor").color = DEFAULT_FONT_COLOR
	TopPanel.get_node("PageColor").color = DEFAULT_PAGE_COLOR
	get_node("Page").self_modulate = DEFAULT_PAGE_COLOR
	TopPanel.get_node("FontDropdown").selected = 0
	TopPanel.get_node("FontSize").value = DEFAULT_FONT_SIZE

func _ready():
	App = get_parent()
	TopPanel = App.get_node("TopPanel")
	Main = get_tree().root.get_child(0)
	FileExplorerData = Main.get_node("FileExplorer/FileExplorerData")
	
	ResetWriter()
	
	TopPanel.get_node("File").get_popup().id_pressed.connect(func(ID):
		if(ID == 0): # New
			ResetWriter()
		if(ID == 1): # Open
			print("Open")
			#Main.FileSelector.Open()
			#await Signal(Main.FileSelector, "SelectionMade")
			#if(Main.FileSelector.TempOpenedFile != null): # If user selected a file
				#Open File
		if(ID == 2): # Save
			App.get_node("SavePopup").show()
	)
	
	TopPanel.get_node("FontSize").value_changed.connect(func(FontSize):
		get_node("Page/TextEdit").add_theme_font_size_override("font_size", FontSize)
	)
	
	TopPanel.get_node("FontDropdown").item_selected.connect(func(ID):
		if(ID == 0):
			get_node("Page/TextEdit").remove_theme_font_override("font")
		else:
			get_node("Page/TextEdit").add_theme_font_override("font", load(FontPath[ID - 1]))
	)
	
	TopPanel.get_node("FontColor").color_changed.connect(func(SelectedColor):
		get_node("Page/TextEdit").add_theme_color_override("font_color", SelectedColor)
	)
	
	TopPanel.get_node("PageColor").color_changed.connect(func(SelectedColor):
		get_node("Page").self_modulate = SelectedColor
	)

func OpenTextFile(TextFileData):
	App.get_node("AppBaseComponent").Open()
	
	#Content
	get_node("Page/TextEdit").text = TextFileData[0]
	#Font Size
	TopPanel.get_node("FontSize").value = TextFileData[1]
	get_node("Page/TextEdit").add_theme_font_size_override("font_size", TextFileData[1])
	#Font
	if(TextFileData[2] == 0):
		get_node("Page/TextEdit").remove_theme_font_override("font")
	else:
		get_node("Page/TextEdit").add_theme_font_override("font", load(FontPath[TextFileData[2] - 1]))
	TopPanel.get_node("FontDropdown").selected = TextFileData[2]
	#FontColor
	get_node("Page/TextEdit").add_theme_color_override("font_color", Color(TextFileData[3]))
	TopPanel.get_node("FontColor").color = Color(TextFileData[3])
	#PageColor
	TopPanel.get_node("PageColor").color = Color(TextFileData[4])
	get_node("Page").self_modulate = Color(TextFileData[4])
	
