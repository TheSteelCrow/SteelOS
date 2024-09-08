extends Panel

@onready var SubjectLine = $TopBar/SubjectLine
@onready var RecipientLine = $TopBar/RecipientLine
@onready var Content = $Content

@onready var AddedFilesHolder = $AddedFilesHolder

var Main
var AddedFilePrefab

func ResetEmailWriter():
	SubjectLine.text = ""
	RecipientLine.text = "boss@email.com"
	Content.text = ""
	
	for AddedFile in AddedFilesHolder.get_children():
		AddedFile.queue_free()

func SendEmail():
	ResetEmailWriter()
	get_parent().Open()
	get_parent().get_node("EmailSent").play()
	
	if(RecipientLine.text == "boss@email.com" and AddedFilesHolder.get_children().size() > 0):
		if(Main.get_node("Taskbar").TaskName == "Draw"):
			Main.get_node("Taskbar").TaskProgress += 1
		elif(Main.get_node("Taskbar").TaskName == "Write"):
			Main.get_node("Taskbar").TaskProgress += 1

func AddFile():
	if(get_node("AddedFilesHolder").get_children().size() == 3):
		Main.GeneratePopup("Mail", "File attachment limit reached. To add more files, remove existing files.", "Error", Vector2(640, 380))
		return
	
	Main.FileSelector.Open()
	await Signal(Main.FileSelector, "SelectionMade")
	if(Main.FileSelector.TempOpenedFile != null):
		var AddedFile = AddedFilePrefab.instantiate()
		get_node("AddedFilesHolder").add_child(AddedFile)
		AddedFile.get_node("Panel/FileName").text = Main.FileSelector.TempOpenedFile
		AddedFile.get_node("Panel/RemoveFileButton").button_up.connect(func():
			AddedFile.queue_free()
		)

func DiscardEmail():
	ResetEmailWriter()

func _ready():
	Main = get_tree().root.get_child(0)
	AddedFilePrefab = preload("res://Prefabs/added_file.tscn")
	
	get_node("TopBar/DiscardButton").button_up.connect(ResetEmailWriter)
	get_node("SendButton").button_up.connect(SendEmail)
	get_node("AddFileButton").button_up.connect(AddFile)
