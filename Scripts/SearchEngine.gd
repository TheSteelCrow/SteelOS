extends Panel

var SearchEngineOpen = false

var Mottos = [
	"Parcourir: Where Your Data Finds a New Home.",
	"Parcourir: Your Privacy? What Privacy?",
	"Parcourir: Surf and Surrender Your Secrets.",
	"Parcourir: We Know What You Did Last Session.",
	"Parcourir: The Browser That Keeps a Little for Itself.",
	"Parcourir: Trust Us... Maybe You Shouldn't.",
	"Parcourir: Because Your Data is Our Business.",
	"Parcourir: Browse Boldly, Share Unknowingly.",
	"Parcourir: The Browser with a Hidden Agenda.",
	"Parcourir: Your Window to the Web, Our Door to Your Data."
]

# Called when the node enters the scene tree for the first time.
func _ready():
	hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func ResetSearchBrowserText():
	get_node("Motto").text = "[center]" + Mottos[randf_range(0, Mottos.size())] + "[/center]"

func _on_search_engine_button_button_up():
	print("Search Engine Button Pressed")
	if(visible):
		hide()
	else:
		get_parent().HideAll()
		show()
		move_to_front()
		ResetSearchBrowserText()
