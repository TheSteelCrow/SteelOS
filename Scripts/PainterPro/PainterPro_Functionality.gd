extends Control

var CurrentImage
var IsHoldingMouse1
var SelectedColor = Color("000000")
var MousePosition
@onready var ArtCanvas = $ArtCanvas
var ScaleBy = 4 # 8 works
var ImageResolution = Vector2(1920, 1080)
var ScreenSize
var ImageFormat = Image.FORMAT_RGB8 #jpeg as default, no transparency

var MoveCanvas = false
var MouseOffsetFromCanvas
var MouseOnCanvas = false

var StartPixel
var EndPixel

var ZoomByTopLeft = false
var SelectedTool = "Brush"
var BrushSize = 1

var CheckedPixels = []

var FillCooldown

var BackgroundColour = "ffffff"

@onready var Buttons = $Buttons
@onready var SideWindow = $SideWindow

func Fill(Location, ReplacementColor):
	# Cooldown System
	if(FillCooldown != null):
		if(FillCooldown.time_left > 0):
			print("Cooldown")
			return
	
	FillCooldown = Timer.new()
	add_child(FillCooldown)
	FillCooldown.one_shot = true
	FillCooldown.start(1)
	
	print("No Cooldown")
	
	CheckedPixels.clear() # Resets list of checked pixels
	var ColorToFill = CurrentImage.get_pixel(Location.x, Location.y)
	
	if(ColorToFill.to_html() != ReplacementColor.to_html()): # If target area color is different to the color used for filling
		CheckNeighbouringPixels(Location, ColorToFill, ReplacementColor) # Checks neighboring pixels of target pixel
		print("Starting")
		Render() # Updates canvas view

func CheckNeighbouringPixels(Location, ColorToFill, ReplacementColor):
	
	#If pixel being checked is within the bounds of the image
	if(Location.y < 0 or Location.y > CurrentImage.get_height() or Location.x < 0 or Location.x > CurrentImage.get_width()):
		return

	#Delay to give a satisfying effect and to not crash
	await get_tree().process_frame
	FillCooldown.start(1) # Resets cooldown timer
	
	#Check the neighbors
	CheckPixel(Vector2(Location.x + 1, Location.y), ColorToFill, ReplacementColor) # Check Left Pixel
	CheckPixel(Vector2(Location.x - 1, Location.y), ColorToFill, ReplacementColor) # Check Right Pixel
	CheckPixel(Vector2(Location.x, Location.y + 1), ColorToFill, ReplacementColor) # Check Down Pixel
	CheckPixel(Vector2(Location.x, Location.y - 1), ColorToFill, ReplacementColor) # Check Up Pixel
	
	Render() # Updates canvas view

func CheckPixel(Location, ColorToFill, ReplacementColor):
	if(CurrentImage.get_pixel(Location.x, Location.y) == ColorToFill and Location not in CheckedPixels): # If pixel matches target pixel color and pixel not checked
		CheckedPixels.append(Location) # Mark pixel as checked
		CurrentImage.set_pixel(Location.x, Location.y, ReplacementColor) # Set pixel color
		CheckNeighbouringPixels(Location, ColorToFill, ReplacementColor) # Check neighbors of current pixel

func PaintLine(StartLocation, EndLocation, PaintColor):
	if(EndLocation.x <= StartLocation.x+1 and EndLocation.y <= StartLocation.y+1): #Top left
		print("Line in this direction not yet supported")
	elif(EndLocation.x >= StartLocation.x and EndLocation.y <= StartLocation.y): #Top right
		print("Line in this direction not yet supported")
	elif(EndLocation.x <= StartLocation.x+1 and EndLocation.y >= StartLocation.y+1): #Bottom left
		print("Line in this direction not yet supported")
	elif(EndLocation.x+1 >= StartLocation.x and EndLocation.y+1 >= StartLocation.y): #Bottom right
		print("Line in this direction not yet supported")

# Checks if passed pixel is inside the bounds of the canvas
func IsPixelOutsideBounds(PixelPosition):
	if(PixelPosition.x < 0 or PixelPosition.x > CurrentImage.get_width()):
		return true
	if(PixelPosition.y < 0 or PixelPosition.y > CurrentImage.get_height()):
		return true
	return false

# Paints a circle based on a start location, end location (start-end=radius)
func PaintCircle(StartLocation, EndLocation, PaintColor, Fill):
	var Radius =  StartLocation.y - EndLocation.y
	if (Radius < 0):
		Radius = -Radius
	
	# Gets all pixels within a square, square is centered at start position and the length is = 2xradius
	for x in range(-Radius, Radius):
		for y in range(-Radius, Radius):
			if(IsPixelOutsideBounds(Vector2(StartLocation.x+x, StartLocation.y+y))): # If pixel is not on canvas
				continue # Skip
			
			var PixelDistanceFromCenter = StartLocation.distance_to(Vector2(StartLocation.x+x,StartLocation.y+y))
			if(Fill == true): # If should fill circle
				if(PixelDistanceFromCenter <= Radius): # If pixel falls within the circle
					CurrentImage.set_pixel(StartLocation.x+x, StartLocation.y+y, PaintColor) # Update pixel to correct color
			elif(Fill == false): # If shouldnt fill circle
				if(PixelDistanceFromCenter <= Radius and PixelDistanceFromCenter >= Radius-BrushSize): # If pixel falls within circle and falls on edge of circle (determined by brush size)
					CurrentImage.set_pixel(StartLocation.x+x, StartLocation.y+y, PaintColor) # Update pixel to correct color
	Render()
	
# Paints a rectangle on canvas based on start and end location
func PaintRectangle(StartLocation, EndLocation, PaintColor):
	# Checks which direction the rectangle is being drawn, the rectangle has to be drawn differently based on which direction it is drawn
	if(EndLocation.x <= StartLocation.x+1 and EndLocation.y <= StartLocation.y+1): #Top left quadrant
		# For each pixel inside rectangle
		for x in range(EndLocation.x, StartLocation.x+1):
			for y in range(EndLocation.y, StartLocation.y+1):
				CurrentImage.set_pixel(x, y, PaintColor) # Set pixel to correct color
	elif(EndLocation.x >= StartLocation.x and EndLocation.y <= StartLocation.y): #Top right quadrant
		for x in range(StartLocation.x, EndLocation.x+1):
			for y in range(EndLocation.y, StartLocation.y+1):
				CurrentImage.set_pixel(x, y, PaintColor)
	elif(EndLocation.x <= StartLocation.x+1 and EndLocation.y >= StartLocation.y+1): #Bottom left quadrant
		for x in range(EndLocation.x, StartLocation.x+1):
			for y in range(StartLocation.y, EndLocation.y+1):
				CurrentImage.set_pixel(x, y, PaintColor)
	elif(EndLocation.x+1 >= StartLocation.x and EndLocation.y+1 >= StartLocation.y): #Bottom right quadrant
		for x in range(StartLocation.x, EndLocation.x+1):
			for y in range(StartLocation.y, EndLocation.y+1):
				CurrentImage.set_pixel(x, y, PaintColor)
	Render()

# Resets and setsup a new canvas
func SetupCanvas():
	# Resulution of image is set by user then scaled down by ScaleBy.
	ImageResolution = Vector2(ImageResolution.x/ScaleBy, ImageResolution.y/ScaleBy)
	ScreenSize = get_viewport().size # Gets the size of the games screen
	CurrentImage = Image.new().create(ImageResolution.x,ImageResolution.y,false, ImageFormat) # Creates canvas using user provided settings
	CurrentImage.fill("ffffff") # sets canvas default color
	ArtCanvas.size = Vector2(ImageResolution.x*ScaleBy, ImageResolution.y*ScaleBy) # Sets canvas object size
	
	ArtCanvas.position = Vector2(424,145) # Moves canvas into view
	Render() # Updates canvas

func Render():
	var MyTexture = ImageTexture.new().create_from_image(CurrentImage) # Gets texture from canvas image
	ArtCanvas.texture = MyTexture # Applies texture to canvas object

# Sets selected color to color when color is selected by user using color picker
func _on_color_picker_color_changed(color):
	SelectedColor = color

# Finds the mouse position relative to the canvas
# To understand this function refer to the image provided in OneNote
func ConvertToCanvasSpace():
	var NewMouseX = MousePosition.x - ArtCanvas.position.x
	var NewMouseY = MousePosition.y - ArtCanvas.position.y
	
	var x = NewMouseX/ArtCanvas.size.x
	var y = NewMouseY/ArtCanvas.size.y
	
	return Vector2(ImageResolution.x*x, ImageResolution.y*y)

# Paints the specified location if it is within the bounds of the canvas
func PaintLocation(x, y, color):
	if(IsPixelOutsideBounds(Vector2(x, y)) == false):
		CurrentImage.set_pixel(x, y, color)

func _process(delta):
	var MouseButton1Down = Input.is_mouse_button_pressed(1)
	MousePosition = get_viewport().get_mouse_position()

	if(MouseButton1Down and MouseOnCanvas): # If user is interacting with canvas
		if(SelectedTool == "Brush"):
			var LocationToPaint = ConvertToCanvasSpace() # Converts mouse position to canvas position
			PaintLocation(LocationToPaint.x, LocationToPaint.y, SelectedColor)
			Render() # Updates canvas to show change
		if(SelectedTool == "Eraser"):
			var LocationToPaint = ConvertToCanvasSpace() # Converts mouse position to canvas position
			PaintLocation(LocationToPaint.x, LocationToPaint.y, BackgroundColour)
			Render() # Updates canvas to show change
		elif(SelectedTool == "Picker"):
			var LocationToPaint = ConvertToCanvasSpace() # Converts mouse position to canvas position
			SelectedColor = CurrentImage.get_pixel(LocationToPaint.x, LocationToPaint.y) # Gets color of target pixel
			SideWindow.Pages[0].get_node("ColorPicker").color = SelectedColor # Sets color picker color to color selected by custom color picker
		elif(SelectedTool == "BigBrush"):
			var LocationToPaint = ConvertToCanvasSpace() # Converts mouse position to canvas position
			# Paints nearby pixels to target pixel
			PaintLocation(LocationToPaint.x, LocationToPaint.y, SelectedColor)
			PaintLocation(LocationToPaint.x+1, LocationToPaint.y, SelectedColor)
			PaintLocation(LocationToPaint.x-1, LocationToPaint.y, SelectedColor)
			PaintLocation(LocationToPaint.x, LocationToPaint.y+1, SelectedColor)
			PaintLocation(LocationToPaint.x, LocationToPaint.y-1, SelectedColor)
			Render() # Updates canvas to show change
		elif(SelectedTool == "VeryBigBrush"):
			var LocationToPaint = ConvertToCanvasSpace() # Converts mouse position to canvas position
			# Draws a rectangle around the target pixel based on its apothem (apothem = distance from center of square to face of square at right angle)
			for PixelX in range(-BrushSize, BrushSize): # Brush size acts as apothem
				for PixelY in range(-BrushSize, BrushSize):
					PaintLocation(LocationToPaint.x + PixelX, LocationToPaint.y + PixelY, SelectedColor) # Set pixel color
			
			Render() # Updates canvas to show change
		
	if(MoveCanvas): # If middle mouse button down
		ArtCanvas.position = MousePosition + MouseOffsetFromCanvas # Set canvas object position to mouse position + mouse offset from canvas when movement started
	else:
		MouseOffsetFromCanvas = ArtCanvas.position - MousePosition # Updates mouse offset from canvas

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
