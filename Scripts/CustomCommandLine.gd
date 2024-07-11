extends Panel

@onready var UserInput = $TextEdit
var Output

# Called when the node enters the scene tree for the first time.
func _ready():
	Output = get_node("TextPanel").get_node("RichTextLabel")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(Input.is_key_pressed(KEY_ENTER) && visible):
		UserInput.text = ""
		Output.text = "Command Run"
	elif(Input.is_key_pressed(KEY_CTRL) and Input.is_key_pressed(KEY_S)):
		Output.text = "Welcome to Command Panel!"
		show()
	elif(Input.is_key_pressed(KEY_CTRL) and Input.is_key_pressed(KEY_H)):
		Output.text = ""
		hide()
