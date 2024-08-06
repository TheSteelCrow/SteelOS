extends Control

var CurrentImage
var IsHoldingMouse1
var SelectedColor = Color("000000")
var MousePosition
@onready var ArtCanvas = $ArtCanvas
#var CompressionRate = 10
var ScaleBy = 4 # 8 works
#var ImageResolution = Vector2(1920, 1080)
var ImageResolution = Vector2(1920/ScaleBy, 1080/ScaleBy)
#var ImageSize = Vector2(500, 400)
var ScreenSize

var MoveCanvas = false
var MouseOffsetFromCanvas
var MouseOnCanvas = false

var StartPixel
var EndPixel

#Variables set by User
var ZoomByTopLeft = false
var SelectedTool = "Brush"
var BrushSize = 1

var CheckedPixels = []

var FillCooldown

var BackgroundColour = "ffffff"

@onready var Buttons = $Buttons
@onready var SideWindow = $SideWindow

func Fill(Location, ReplacementColor):
	if(FillCooldown != null):
		if(FillCooldown.time_left > 0):
			print("Cooldown")
			return
	
	FillCooldown = Timer.new()
	add_child(FillCooldown)
	FillCooldown.one_shot = true
	#FillCooldown.wait_time = 1
	FillCooldown.start(1)
	
	print("No Cooldown")
	
	CheckedPixels.clear()
	var ColorToFill = CurrentImage.get_pixel(Location.x, Location.y)
	if(ColorToFill.to_html() != ReplacementColor.to_html()):
		CheckNeighbouringPixels(Location, ColorToFill, ReplacementColor)
		print("Starting")
		Render()
	else:
		print("No can do buckaroo")

func CheckNeighbouringPixels(Location, ColorToFill, ReplacementColor):
	
	#If checking within the bounds of the image
	if(Location.y < 0 or Location.y > CurrentImage.get_height() or Location.x < 0 or Location.x > CurrentImage.get_width()):
		return

	#Delay to give a satisfying effect and to not crash XD
	await get_tree().process_frame
	FillCooldown.start(1)
	
	#Check the neighbors
	CheckPixel(Vector2(Location.x + 1, Location.y), ColorToFill, ReplacementColor) # Left
	CheckPixel(Vector2(Location.x - 1, Location.y), ColorToFill, ReplacementColor) # Right
	CheckPixel(Vector2(Location.x, Location.y + 1), ColorToFill, ReplacementColor) # Down
	CheckPixel(Vector2(Location.x, Location.y - 1), ColorToFill, ReplacementColor) # Up
	
	Render()

func CheckPixel(Location, ColorToFill, ReplacementColor):
	if(CurrentImage.get_pixel(Location.x, Location.y) == ColorToFill and Location not in CheckedPixels):
		CheckedPixels.append(Location)
		CurrentImage.set_pixel(Location.x, Location.y, ReplacementColor)
		CheckNeighbouringPixels(Location, ColorToFill, ReplacementColor)

func PaintLine(StartLocation, EndLocation, PaintColor):
	if(EndLocation.x <= StartLocation.x+1 and EndLocation.y <= StartLocation.y+1): #Top left
		print("Line in this direction not yet supported")
	elif(EndLocation.x >= StartLocation.x and EndLocation.y <= StartLocation.y): #Top right
		print("Line in this direction not yet supported")
	elif(EndLocation.x <= StartLocation.x+1 and EndLocation.y >= StartLocation.y+1): #Bottom left
		print("Line in this direction not yet supported")
	elif(EndLocation.x+1 >= StartLocation.x and EndLocation.y+1 >= StartLocation.y): #Bottom right
		print("Line in this direction not yet supported")

func IsPixelOutsideBounds(PixelPosition):
	if(PixelPosition.x < 0 or PixelPosition.x > CurrentImage.get_width()):
		return true
	if(PixelPosition.y < 0 or PixelPosition.y > CurrentImage.get_height()):
		return true
	return false

func PaintCircle(StartLocation, EndLocation, PaintColor, Fill):
	var Radius =  StartLocation.y - EndLocation.y
	#var Radius =  snapped(StartLocation.y - EndLocation.y, 1)
	if (Radius < 0):
		Radius = -Radius
	print(Radius)
	
	for x in range(-Radius, Radius):
		for y in range(-Radius, Radius):
			if(IsPixelOutsideBounds(Vector2(StartLocation.x+x, StartLocation.y+y))):
				continue
			
			var PixelDistanceFromCenter = StartLocation.distance_to(Vector2(StartLocation.x+x,StartLocation.y+y))
			if(Fill == true):
				if(PixelDistanceFromCenter <= Radius):
					CurrentImage.set_pixel(StartLocation.x+x, StartLocation.y+y, PaintColor)
			elif(Fill == false):
				if(PixelDistanceFromCenter <= Radius and PixelDistanceFromCenter >= Radius-BrushSize):
					CurrentImage.set_pixel(StartLocation.x+x, StartLocation.y+y, PaintColor)
	Render()
	

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
	if(IsPixelOutsideBounds(Vector2(x, y)) == false):
		CurrentImage.set_pixel(x, y, color)

func _process(delta):
	var MouseButton1Down = Input.is_mouse_button_pressed(1)
	MousePosition = get_viewport().get_mouse_position()

	if(MouseButton1Down and MouseOnCanvas):
		if(SelectedTool == "Brush"):
			var LocationToPaint = ConvertToCanvasSpace()
			PaintLocation(LocationToPaint.x, LocationToPaint.y, SelectedColor)
			Render()
		if(SelectedTool == "Eraser"):
			var LocationToPaint = ConvertToCanvasSpace()
			PaintLocation(LocationToPaint.x, LocationToPaint.y, BackgroundColour)
			Render()
		elif(SelectedTool == "Picker"):
			var LocationToPaint = ConvertToCanvasSpace()
			SelectedColor = CurrentImage.get_pixel(LocationToPaint.x, LocationToPaint.y)
			SideWindow.Pages[0].get_node("ColorPicker").color = SelectedColor
		elif(SelectedTool == "BigBrush"):
			var LocationToPaint = ConvertToCanvasSpace()
			PaintLocation(LocationToPaint.x, LocationToPaint.y, SelectedColor)
			PaintLocation(LocationToPaint.x+1, LocationToPaint.y, SelectedColor)
			PaintLocation(LocationToPaint.x-1, LocationToPaint.y, SelectedColor)
			PaintLocation(LocationToPaint.x, LocationToPaint.y+1, SelectedColor)
			PaintLocation(LocationToPaint.x, LocationToPaint.y-1, SelectedColor)
			Render()
		elif(SelectedTool == "VeryBigBrush"):
			var LocationToPaint = ConvertToCanvasSpace()
			for PixelX in range(-BrushSize, BrushSize):
				for PixelY in range(-BrushSize, BrushSize):
					PaintLocation(LocationToPaint.x + PixelX, LocationToPaint.y + PixelY, SelectedColor)
			
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
				if(MouseOnCanvas and SelectedTool == "Fill"):
					Fill(ConvertToCanvasSpace(), SelectedColor)
				else:
					StartPixel = ConvertToCanvasSpace()
		elif(event.is_released()):
			if(event.button_index == MOUSE_BUTTON_MIDDLE):
				MoveCanvas = false
			elif(event.button_index == MOUSE_BUTTON_LEFT):
				if(MouseOnCanvas and SelectedTool == "Rectangle"):
					EndPixel = ConvertToCanvasSpace()
					PaintRectangle(StartPixel, EndPixel, SelectedColor)
				if(MouseOnCanvas and SelectedTool == "CircleFilled"):
					EndPixel = ConvertToCanvasSpace()
					PaintCircle(StartPixel, EndPixel, SelectedColor, true)
				if(MouseOnCanvas and SelectedTool == "Circle"):
					EndPixel = ConvertToCanvasSpace()
					PaintCircle(StartPixel, EndPixel, SelectedColor, false)
				elif(MouseOnCanvas and SelectedTool == "Line"):
					EndPixel = ConvertToCanvasSpace()
					PaintLine(StartPixel, EndPixel, SelectedColor)

func LocateCanvas():
	ArtCanvas.size = Vector2(ImageResolution.x*ScaleBy, ImageResolution.y*ScaleBy)
	ArtCanvas.position = Vector2.ZERO

func _on_art_canvas_mouse_entered():
	MouseOnCanvas = true

func _on_art_canvas_mouse_exited():
	MouseOnCanvas = false
