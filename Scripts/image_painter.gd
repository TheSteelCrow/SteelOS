extends Panel

var ImageSize = Vector2(400,300)
var CompressionRate = 10
var Resolution

#var Pixels = {Vector2(1,1) : "red", Vector2(1,2) : "blue"}

var Pixels = {}

var IsHoldingMouse1 = false

var SelectedTool = "Brush"

var TargetPixel

var StartPixel
var EndPixel

var GridEnabled = false
var GridThickness = 0

func SetupPixels():
	Resolution = ImageSize.x * ImageSize.y / CompressionRate
	
	for x in range(0,ImageSize.x / CompressionRate):
		for y in range(0,ImageSize.y / CompressionRate):
			var Pixel = ColorRect.new()
			add_child(Pixel)
			Pixel.position = Vector2(x*CompressionRate, y*CompressionRate)
			Pixel.size = Vector2(CompressionRate, CompressionRate)
			Pixel.color = "ffffff"
			Pixels[Vector2(x, y)] = Pixel
			Pixel.mouse_entered.connect(func():
				TargetPixel = Pixel
				if(SelectedTool == "Brush" and IsHoldingMouse1):
					BrushTool(TargetPixel)
			)
			
			Pixel.mouse_exited.connect(func():
				if(TargetPixel == Pixel):
					TargetPixel = null
			)
			#await get_tree().process_frame

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == 1:
			IsHoldingMouse1 = event.is_pressed()
			
			if(TargetPixel == null):
				return
			
			if(IsHoldingMouse1 == true):
				#StartPixel = Vector2(TargetPixel.position.x / CompressionRate, TargetPixel.position.y / CompressionRate)
				StartPixel = Vector2(round(event.position.x - position.x) / CompressionRate, round(event.position.y - position.y) / CompressionRate)
				if(SelectedTool == "Brush"):
					BrushTool(TargetPixel)
			elif(IsHoldingMouse1 == false):
				#EndPixel = Vector2(TargetPixel.position.x / CompressionRate, TargetPixel.position.y / CompressionRate)
				EndPixel = Vector2(round(event.position.x - position.x) / CompressionRate, round(event.position.y - position.y) / CompressionRate)
				if(SelectedTool == "Rectangle"):
					RectangleTool()

func RectangleTool():
	var XRange
	var YRange
	
	print("Start: " + str(StartPixel))
	print("End: " + str(EndPixel))
	
	if(EndPixel.x <= StartPixel.x+1 and EndPixel.y <= StartPixel.y+1): #Top left
		for x in range(EndPixel.x, StartPixel.x+1):
			for y in range(EndPixel.y, StartPixel.y+1):
				Pixels[Vector2(x, y)].color = get_node("ColorPicker").color
	elif(EndPixel.x >= StartPixel.x and EndPixel.y <= StartPixel.y): #Top right
		for x in range(StartPixel.x, EndPixel.x+1):
			for y in range(EndPixel.y, StartPixel.y+1):
				Pixels[Vector2(x, y)].color = get_node("ColorPicker").color
	elif(EndPixel.x <= StartPixel.x+1 and EndPixel.y >= StartPixel.y+1): #Bottom left
		for x in range(EndPixel.x, StartPixel.x+1):
			for y in range(StartPixel.y, EndPixel.y+1):
				Pixels[Vector2(x, y)].color = get_node("ColorPicker").color
	elif(EndPixel.x+1 >= StartPixel.x and EndPixel.y+1 >= StartPixel.y): #Bottom right
		for x in range(StartPixel.x, EndPixel.x+1):
			for y in range(StartPixel.y, EndPixel.y+1):
				Pixels[Vector2(x, y)].color = get_node("ColorPicker").color

func BrushTool(PixelToBrush):
	PixelToBrush.color = get_node("ColorPicker").color

func _ready():
	SetupPixels()
	
	for ToolButton in get_node("Tools").get_children():
		ToolButton.button_up.connect(func():
			SelectedTool = ToolButton.name
		)

func Render():
	pass
	#for Pixel

func UpdateGrid():
	if(GridEnabled):
		for Pixel in Pixels:
			Pixels[Pixel].size = Vector2(CompressionRate-GridThickness, CompressionRate-GridThickness)
	else:
		for Pixel in Pixels:
			Pixels[Pixel].size = Vector2(CompressionRate, CompressionRate)

func _on_grid_thickness_value_changed(value):
	print(value)
	GridThickness = value
	UpdateGrid()
	
func _on_grid_toggle_toggled(button_pressed):
	GridEnabled = button_pressed
	UpdateGrid()
