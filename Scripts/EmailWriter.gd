extends Panel

@onready var SubjectLine = $TopBar/SubjectLine
@onready var RecipientLine = $TopBar/RecipientLine
@onready var Content = $Content

func ResetEmailWriter():
	SubjectLine.text = ""
	RecipientLine.text = ""
	Content.text = ""

func SendEmail():
	ResetEmailWriter()

func DiscardEmail():
	ResetEmailWriter()

func _ready():
	get_node("TopBar/DiscardButton").button_up.connect(ResetEmailWriter)
