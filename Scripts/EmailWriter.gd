extends Panel

@onready var SubjectLine = $TopBar/SubjectLine
@onready var RecipientLine = $TopBar/RecipientLine
@onready var Content = $Content

var Main

func ResetEmailWriter():
	SubjectLine.text = ""
	RecipientLine.text = ""
	Content.text = ""

func SendEmail():
	ResetEmailWriter()

func AddFile():
	Main.FileSelector.Open()
	await Signal(Main.FileSelector, "SelectionMade")
	if(Main.FileSelector.TempOpenedFile != null):
		print("Opening File " + Main.FileSelector.TempOpenedFile)

func DiscardEmail():
	ResetEmailWriter()

func _ready():
	Main = get_tree().root.get_child(0)
	
	get_node("TopBar/DiscardButton").button_up.connect(ResetEmailWriter)
	get_node("SendButton").button_up.connect(SendEmail)
	get_node("AddFileButton").button_up.connect(AddFile)
