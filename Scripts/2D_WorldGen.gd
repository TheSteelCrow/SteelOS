extends Control

@onready var WorldDisplay = $WorldDisplay
@onready var TickInterval_Setting = $TickInterval_Setting
@onready var Seed_Setting = $SeedSetting

var MovementSpeed = 300
var Seed = 0
var TickInterval = 0.1

var CameraPosition = Vector2(0,0)

# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("Generate").button_up.connect(GenerateWorld)
	
	TickInterval_Setting.value_changed.connect(func(value):
		TickInterval = value
	)
	
	Seed_Setting.value_changed.connect(func(value):
		Seed = value
	)
	
	while true:
		await get_tree().create_timer(TickInterval).timeout
		RenderTick()

func GenerateWorld():
	WorldDisplay.texture.noise.seed = Seed

func RenderTick():
	WorldDisplay.texture.noise.offset.x = CameraPosition.x
	WorldDisplay.texture.noise.offset.y = CameraPosition.y

func _process(delta):
	if(Input.is_key_pressed(KEY_LEFT)):
		CameraPosition.x -= MovementSpeed*delta
	elif(Input.is_key_pressed(KEY_RIGHT)):
		CameraPosition.x += MovementSpeed*delta
		
	if(Input.is_key_pressed(KEY_UP)):
		CameraPosition.y -= MovementSpeed*delta
	elif(Input.is_key_pressed(KEY_DOWN)):
		CameraPosition.y += MovementSpeed*delta
		
	var Test = WorldDisplay.texture.get_image()
	var MousePosition = get_global_mouse_position()
	$TargetColor.color = Test.get_pixel(MousePosition.x, MousePosition.y)
	
	$MouseInfo.text = "Mouse Position = (%s , %s)\nMouse World Position = (%s , %s)"  % [MousePosition.x, MousePosition.y, MousePosition.x + WorldDisplay.texture.noise.offset.x, MousePosition.y + WorldDisplay.texture.noise.offset.y]
