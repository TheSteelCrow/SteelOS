extends Control

var GraphImage
var GraphImageFormat = Image.FORMAT_RGB8
var GraphResolution
var GraphTextureFilter = CanvasItem.TEXTURE_FILTER_NEAREST

var GraphXLines = 5
var GraphYLines = 10

@onready var GraphRenderer = $GraphRenderer

func GenerateGraph():
	print("Generating Graph.")
	GraphImage = null
	GraphResolution = GraphRenderer.size
	GraphImage = Image.new().create(GraphResolution.x, GraphResolution.y, false, GraphImageFormat)
	GraphRenderer.texture_filter = GraphTextureFilter
	
	var SpaceBetweenLinesHorizontally = GraphResolution.x / GraphXLines
	var SpaceBetweenLinesVertically = GraphResolution.y / GraphYLines
	
	for Line in range(1, GraphXLines):
		for y in range(0, GraphResolution.y):
			GraphImage.set_pixel(Line*SpaceBetweenLinesHorizontally, y, Color("000000"))
	
	
	GraphRenderer.texture = ImageTexture.create_from_image(GraphImage)

func _ready():
	GenerateGraph()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
