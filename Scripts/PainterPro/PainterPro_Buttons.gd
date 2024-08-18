extends Panel

var ToolButtons
var SelectedToolButton
@onready var SelectionBox = $SelectionBox
@onready var BrushSize = $BrushSize

# Called when the node enters the scene tree for the first time.
func _ready():
	ToolButtons = get_children()
	ToolButtons.remove_at(0)
	ToolButtons.remove_at(0)
	
	BrushSize.value_changed.connect(func(value):
		get_parent().BrushSize = value
	)
	
	for ToolButton in ToolButtons:
		ToolButton.pressed.connect(func():
			SelectedToolButton = ToolButton
			SelectionBox.position = SelectedToolButton.position
			get_parent().SelectedTool = SelectedToolButton.name
		)
		
		if(ToolButton.disabled):
			ToolButton.modulate = Color("ffffff64")
