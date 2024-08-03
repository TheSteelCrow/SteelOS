extends Control

var CurrentImage
var IsHoldingMouse1
var SelectedColor
var MousePosition
@onready var ArtCanvas = $ArtCanvas
#var CompressionRate = 10
var ScaleBy = 8
#var ImageResolution = Vector2(1920, 1080)
var ImageResolution = Vector2(1920/ScaleBy, 1080/ScaleBy)
#var ImageSize = Vector2(500, 400)
var ScreenSize

var MoveCanvas = false
var MouseOffsetFromCanvas

# Called when the node enters the scene tree for the first time.
func _ready():
	ScreenSize = get_viewport().size
	CurrentImage = Image.new().create(ImageResolution.x,ImageResolution.y,false, Image.FORMAT_RGB8)
	CurrentImage.fill("ffffff")
	ArtCanvas.size = Vector2(ImageResolution.x*ScaleBy, ImageResolution.y*ScaleBy)
	
	ArtCanvas.position = Vector2(424,145)

func Render():
	var MyTexture = ImageTexture.new().create_from_image(CurrentImage)
	ArtCanvas.texture = MyTexture

func _on_color_picker_color_changed(color):
	SelectedColor = color
	#CurrentImage.fill(color)
	#Render()

func PaintLocation():
	var NewMouseX = MousePosition.x - ArtCanvas.position.x
	var NewMouseY = MousePosition.y - ArtCanvas.position.y
	
	var x = NewMouseX/ArtCanvas.size.x
	var y = NewMouseY/ArtCanvas.size.y
	
	print("|x: " + str(x) + ", y: " + str(y) + "|")
	
	CurrentImage.set_pixel(ImageResolution.x*x, ImageResolution.y*y, SelectedColor)
	
func _process(delta):
	var MouseButton1Down = Input.is_mouse_button_pressed(1)
	MousePosition = get_viewport().get_mouse_position()

	if(MouseButton1Down):
		PaintLocation()
		Render()
		
	if(MoveCanvas):
		ArtCanvas.position = MousePosition + MouseOffsetFromCanvas
	else:
		MouseOffsetFromCanvas = ArtCanvas.position - MousePosition

func _input(event):
	if event is InputEventMouseButton:
		if(event.is_pressed()):
			if(event.button_index == MOUSE_BUTTON_WHEEL_DOWN):
				
				
				ArtCanvas.size.x /= 1.1
				ArtCanvas.size.y /= 1.1
			elif(event.button_index == MOUSE_BUTTON_WHEEL_UP):
				#ArtCanvas.position.x += ((ArtCanvas.size.x * 1.1) - (ArtCanvas.size.x)) / 2
				#ArtCanvas.position.y += ((ArtCanvas.size.y * 1.1) - (ArtCanvas.size.y)) / 2
				#try Parent it to another node and move that parent node. It will effectively act as a pivot.
				ArtCanvas.size.x *= 1.1
				ArtCanvas.size.y *= 1.1
			elif(event.button_index == MOUSE_BUTTON_MIDDLE):
				MoveCanvas = true
				print("Start Movin")
		elif(event.is_released()):
			if(event.button_index == MOUSE_BUTTON_MIDDLE):
				MoveCanvas = false
				print("Stop Movin")
