extends Control

var GraphImage
var GraphImageFormat = Image.FORMAT_RGB8
var GraphResolution
var GraphTextureFilter = CanvasItem.TEXTURE_FILTER_NEAREST

var GraphXGaps = 20
var GraphYGaps = 20
var LineThickness = 4

var GraphLineColor = Color("000000")
var GraphBackground = Color("ffffff")

@onready var GraphRenderer = $GraphRenderer

var SpaceBetweenLinesHorizontally
var SpaceBetweenLinesVertically

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
			print(Offset)
			DrawLine(LineNumber, "HORIZONTAL", Offset)
	for LineNumber in range(1, GraphYGaps):
		for Offset in range(-(LineThickness/2), (LineThickness/2) + 1):
			DrawLine(LineNumber, "VERTICAL", Offset)

	GraphRenderer.texture = ImageTexture.create_from_image(GraphImage)
	
func DrawLine(LineNumber, Direction, Offset):
	if(Direction == "HORIZONTAL"):
		for y in range(0, GraphResolution.y):
			GraphImage.set_pixel((LineNumber*SpaceBetweenLinesHorizontally) + Offset, y, GraphLineColor)
	elif(Direction == "VERTICAL"):
		for x in range(0, GraphResolution.x):
			GraphImage.set_pixel(x, (LineNumber*SpaceBetweenLinesVertically) + Offset, GraphLineColor)
	

func _ready():
	GenerateGraph()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
