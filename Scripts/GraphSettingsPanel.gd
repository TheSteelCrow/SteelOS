extends Panel

var StockMarketManager

# Called when the node enters the scene tree for the first time.
func _ready():
	StockMarketManager = get_parent()
	
	$GenerateGraph.pressed.connect(func():
		StockMarketManager.GenerateGraph()
	)
	$ResolutionX.value_changed(func(value):
		StockMarketManager.GraphResolution.x = value
	)
	$ResolutionY.value_changed(func(value):
		StockMarketManager.GraphResolution.y = value
	)
	$Columns.value_changed(func(value):
		StockMarketManager.GraphXGaps = value
	)
	$Rows.value_changed(func(value):
		StockMarketManager.GraphYGaps = value
	)
	$LineThickness.value_changed(func(value):
		StockMarketManager.LineThickness = value
	)
