extends Panel

var ToolButtons
var SelectedToolButton
@onready var SelectionBox = $SelectionBox

# Called when the node enters the scene tree for the first time.
func _ready():
	ToolButtons = get_children()
	ToolButtons.remove_at(0)
	ToolButtons.remove_at(0)
	
	for ToolButton in ToolButtons:
		ToolButton.pressed.connect(func():
			SelectedToolButton = ToolButton
			SelectionBox.position = SelectedToolButton.position
			get_parent().SelectedTool = SelectedToolButton.name
		)
		
		if(ToolButton.disabled):
			ToolButton.modulate = Color("ffffff64")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
