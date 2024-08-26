extends Panel

var ToolButtons
var SelectedToolButton
@onready var SelectionBox = $SelectionBox
@onready var BrushSize = $BrushSize

func _ready():
	ToolButtons = get_children() # Gets all buttons
	ToolButtons.remove_at(0) # Removes Selection Box as it isn't a button
	ToolButtons.remove_at(0) # Removes Brush Size as it isn't a button
	
	# Sets brush size when spin box changed
	BrushSize.value_changed.connect(func(value):
		get_parent().BrushSize = value
	)
	
	for ToolButton in ToolButtons:
		ToolButton.pressed.connect(func(): # When tool button is pressed
			#Select tool
			SelectedToolButton = ToolButton
			SelectionBox.position = SelectedToolButton.position
			get_parent().SelectedTool = SelectedToolButton.name
		)
		
		# Show visually when tools are disabled
		if(ToolButton.disabled):
			ToolButton.modulate = Color("ffffff64") # Grey
