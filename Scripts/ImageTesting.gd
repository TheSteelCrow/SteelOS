extends Control

var CurrentImage
var IsHoldingMouse1
var SelectedColor = Color("000000")
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
var MouseOnCanvas = false

var StartPixel
var EndPixel

#Variables set by SideWindow
var ZoomByTopLeft = false
var SelectedTool = "Brush"

var CheckedPixels = []

func Fill(Location):
	CheckedPixels.clear()
	var ColorToFill = CurrentImage.get_pixel(Location.x, Location.y)
	if(ColorToFill.to_html() != SelectedColor.to_html()):
		CheckNeighbouringPixels(Location, ColorToFill)
		print("Done!")
		Render()
	else:
		print("No can do buckaroo")

func CheckNeighbouringPixels(Location, ColorToFill):
	var pos
	
	if(Location.y < 0 or Location.y > CurrentImage.get_height() or Location.x < 0 or Location.x > CurrentImage.get_width()):
		return
	
	await get_tree().process_frame
	pos = Vector2(Location.x + 1, Location.y)
	if(CurrentImage.get_pixel(pos.x, pos.y) == ColorToFill and pos not in CheckedPixels): # left
		CheckedPixels.append(pos)
		CheckPixel(pos, ColorToFill)

	#await get_tree().process_frame
	pos = Vector2(Location.x - 1, Location.y)
	if(CurrentImage.get_pixel(pos.x, pos.y) == ColorToFill and pos not in CheckedPixels): # left
		CheckedPixels.append(pos)
		CheckPixel(pos, ColorToFill)

	#await get_tree().process_frame
	pos = Vector2(Location.x, Location.y + 1)
	if(CurrentImage.get_pixel(pos.x, pos.y) == ColorToFill and pos not in CheckedPixels): # left
		CheckedPixels.append(pos)
		CheckPixel(pos, ColorToFill)
	
	#await get_tree().process_frame
	pos = Vector2(Location.x, Location.y - 1)
	if(CurrentImage.get_pixel(pos.x, pos.y) == ColorToFill and pos not in CheckedPixels): # left
		CheckedPixels.append(pos)
		CheckPixel(pos, ColorToFill)
	Render()

func CheckPixel(Location, ColorToFill):
	CurrentImage.set_pixel(Location.x, Location.y, SelectedColor)
	#await get_tree().process_frame
	CheckNeighbouringPixels(Location, ColorToFill)

func PaintRectangle(StartLocation, EndLocation, PaintColor):
	if(EndLocation.x <= StartLocation.x+1 and EndLocation.y <= StartLocation.y+1): #Top left
		for x in range(EndLocation.x, StartLocation.x+1):
			for y in range(EndLocation.y, StartLocation.y+1):
				CurrentImage.set_pixel(x, y, PaintColor)
	elif(EndLocation.x >= StartLocation.x and EndLocation.y <= StartLocation.y): #Top right
		for x in range(StartLocation.x, EndLocation.x+1):
			for y in range(EndLocation.y, StartLocation.y+1):
				CurrentImage.set_pixel(x, y, PaintColor)
	elif(EndLocation.x <= StartLocation.x+1 and EndLocation.y >= StartLocation.y+1): #Bottom left
		for x in range(EndLocation.x, StartLocation.x+1):
			for y in range(StartLocation.y, EndLocation.y+1):
				CurrentImage.set_pixel(x, y, PaintColor)
	elif(EndLocation.x+1 >= StartLocation.x and EndLocation.y+1 >= StartLocation.y): #Bottom right
		for x in range(StartLocation.x, EndLocation.x+1):
			for y in range(StartLocation.y, EndLocation.y+1):
				CurrentImage.set_pixel(x, y, PaintColor)
	Render()

func _ready():
	#Input.use_accumulated_input = false
	ScreenSize = get_viewport().size
	CurrentImage = Image.new().create(ImageResolution.x,ImageResolution.y,false, Image.FORMAT_RGB8)
	CurrentImage.fill("ffffff")
	ArtCanvas.size = Vector2(ImageResolution.x*ScaleBy, ImageResolution.y*ScaleBy)
	
	ArtCanvas.position = Vector2(424,145)
	Render()

func Render():
	var MyTexture = ImageTexture.new().create_from_image(CurrentImage)
	ArtCanvas.texture = MyTexture

func _on_color_picker_color_changed(color):
	SelectedColor = color
	#CurrentImage.fill(color)

func ConvertToCanvasSpace():
	var NewMouseX = MousePosition.x - ArtCanvas.position.x
	var NewMouseY = MousePosition.y - ArtCanvas.position.y
	
	var x = NewMouseX/ArtCanvas.size.x
	var y = NewMouseY/ArtCanvas.size.y
	
	return Vector2(ImageResolution.x*x, ImageResolution.y*y)
	
func PaintLocation(x, y, color):
	CurrentImage.set_pixel(x, y, color)
	
func _process(delta):
	var MouseButton1Down = Input.is_mouse_button_pressed(1)
	MousePosition = get_viewport().get_mouse_position()

	if(MouseButton1Down and MouseOnCanvas and SelectedTool == "Brush"):
		var LocationToPaint = ConvertToCanvasSpace()
		PaintLocation(LocationToPaint.x, LocationToPaint.y, SelectedColor)
		Render()
		
	if(MoveCanvas):
		ArtCanvas.position = MousePosition + MouseOffsetFromCanvas
	else:
		MouseOffsetFromCanvas = ArtCanvas.position - MousePosition

func _input(event):
	if event is InputEventMouseButton:
		if(event.is_pressed()):
			if(event.button_index == MOUSE_BUTTON_WHEEL_DOWN):
				if(!ZoomByTopLeft):
					ArtCanvas.position.x += ((ArtCanvas.size.x * 1.1) - (ArtCanvas.size.x)) / 2
					ArtCanvas.position.y += ((ArtCanvas.size.y * 1.1) - (ArtCanvas.size.y)) / 2
				
				ArtCanvas.size.x /= 1.1
				ArtCanvas.size.y /= 1.1
			elif(event.button_index == MOUSE_BUTTON_WHEEL_UP):
				if(!ZoomByTopLeft):
					ArtCanvas.position.x -= ((ArtCanvas.size.x * 1.1) - (ArtCanvas.size.x)) / 2
					ArtCanvas.position.y -= ((ArtCanvas.size.y * 1.1) - (ArtCanvas.size.y)) / 2
				#try Parent it to another node and move that parent node. It will effectively act as a pivot.
				
				ArtCanvas.size.x *= 1.1
				ArtCanvas.size.y *= 1.1
				
			elif(event.button_index == MOUSE_BUTTON_MIDDLE):
				MoveCanvas = true
			elif(event.button_index == MOUSE_BUTTON_LEFT):
				if(MouseOnCanvas and SelectedTool == "Rectangle"):
					StartPixel = ConvertToCanvasSpace()
				if(MouseOnCanvas and SelectedTool == "Fill"):
					Fill(ConvertToCanvasSpace())
		elif(event.is_released()):
			if(event.button_index == MOUSE_BUTTON_MIDDLE):
				MoveCanvas = false
			elif(event.button_index == MOUSE_BUTTON_LEFT):
				if(MouseOnCanvas and SelectedTool == "Rectangle"):
					EndPixel = ConvertToCanvasSpace()
					PaintRectangle(StartPixel, EndPixel, SelectedColor)
		#elif(event.is_)

func LocateCanvas():
	ArtCanvas.size = Vector2(ImageResolution.x*ScaleBy, ImageResolution.y*ScaleBy)
	ArtCanvas.position = Vector2.ZERO

func _on_art_canvas_mouse_entered():
	MouseOnCanvas = true

func _on_art_canvas_mouse_exited():
	MouseOnCanvas = false
