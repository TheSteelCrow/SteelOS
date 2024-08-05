extends Control

var GraphImage
var GraphImageFormat = Image.FORMAT_RGB8
var GraphResolution
var GraphTextureFilter = CanvasItem.TEXTURE_FILTER_NEAREST

var GraphXGaps = 20
var GraphYGaps = 20
var LineThickness = 4

var GraphLineColor = Color("00a5ff")
var GraphGridColor = Color("000000")
var GraphBackground = Color("ffffff")

@onready var GraphRenderer = $GraphRenderer

var SpaceBetweenLinesHorizontally
var SpaceBetweenLinesVertically

var GraphLine

var Data = [
	Vector2(0,0),
	Vector2(2,4),
	Vector2(3,7),
	Vector2(5,9),
	Vector2(8,14),
	Vector2(14,20)
]

#Temp fix in future this wont work as number of gaps will be different to the values shown
var MaximumX =  GraphXGaps
var MaximumY = GraphYGaps

func GenerateGraphLine():
	MaximumX =  GraphXGaps
	MaximumY = GraphYGaps
	
	if(GraphLine != null):
		GraphLine.queue_free()
	GraphLine = Line2D.new()
	add_child(GraphLine)
	move_child(GraphLine, 2)
	GraphLine.default_color = GraphLineColor
	for DataPosition in Data:
		if(DataPosition.x <= MaximumX and DataPosition.y <= MaximumY): #If data within bounds of graph
			var DataPysicalPositionX = GraphRenderer.position.x + (DataPosition.x * SpaceBetweenLinesHorizontally)
			var DataPysicalPositionY = GraphRenderer.position.y + ((MaximumY - DataPosition.y) * SpaceBetweenLinesVertically)
		
			GraphLine.add_point(Vector2(DataPysicalPositionX, DataPysicalPositionY))

func GenerateGraph():
	print("Generating Graph.")
	GraphImage = null
	GraphResolution = GraphRenderer.size
	GraphImage = Image.new().create(GraphResolution.x, GraphResolution.y, false, GraphImageFormat)
	GraphImage.fill(GraphBackground)
	GraphRenderer.texture_filter = GraphTextureFilter
	
	SpaceBetweenLinesHorizontally = GraphResolution.x / GraphXGaps
	SpaceBetweenLinesVertically = GraphResolution.y / GraphYGaps
	
	for LineNumber in range(1, GraphXGaps):
		for Offset in range(-(LineThickness/2), (LineThickness/2) + 1):
			DrawLine(LineNumber, "HORIZONTAL", Offset)
	for LineNumber in range(1, GraphYGaps):
		for Offset in range(-(LineThickness/2), (LineThickness/2) + 1):
			DrawLine(LineNumber, "VERTICAL", Offset)
	
	GraphRenderer.texture = ImageTexture.create_from_image(GraphImage)
	
	GenerateText()
	GenerateGraphLine()
	
func DrawLine(LineNumber, Direction, Offset):
	if(Direction == "HORIZONTAL"):
		for y in range(0, GraphResolution.y):
			GraphImage.set_pixel((LineNumber*SpaceBetweenLinesHorizontally) + Offset, y, GraphGridColor)
	elif(Direction == "VERTICAL"):
		for x in range(0, GraphResolution.x):
			GraphImage.set_pixel(x, (LineNumber*SpaceBetweenLinesVertically) + Offset, GraphGridColor)
	

func _ready():
	#GenerateGraph()
	pass

func GenerateText():
	for Text in get_node("TextDisplay").get_children():
		Text.queue_free()
	
	#X Axis Text
	var XIndex = 0
	for LineNumber in range(0, GraphXGaps+1):
		var NewText = Label.new()
		get_node("TextDisplay").add_child(NewText)
		NewText.position.x = GraphRenderer.position.x + (LineNumber * SpaceBetweenLinesHorizontally) - 10
		NewText.position.y = GraphRenderer.position.y + GraphRenderer.size.y + 5
		NewText.text = str(XIndex)
		XIndex+=1

	#Y Axis Text 
	var YIndex = GraphYGaps
	for LineNumber in range(0, GraphYGaps+1):
		var NewText = Label.new()
		get_node("TextDisplay").add_child(NewText)
		NewText.position.y = GraphRenderer.position.y + (LineNumber * SpaceBetweenLinesVertically) - 10
		NewText.position.x = GraphRenderer.position.x - 25
		NewText.text = str(YIndex)
		YIndex-=1
