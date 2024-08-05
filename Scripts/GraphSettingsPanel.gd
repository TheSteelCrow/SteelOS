extends Panel

var StockMarketManager

# Called when the node enters the scene tree for the first time.
func _ready():
	StockMarketManager = get_parent()
	
	$GenerateGraph.pressed.connect(func():
		StockMarketManager.GenerateGraph()
	)
	$LineColor.pressed.connect(func():
		StockMarketManager.GraphLineColor = $ColorPicker.color
	)
	$GridColor.pressed.connect(func():
		StockMarketManager.GraphGridColor = $ColorPicker.color
	)
	$Background.pressed.connect(func():
		StockMarketManager.GraphBackground = $ColorPicker.color
	)
	
	$ResolutionX.value_changed.connect(func(value):
		StockMarketManager.GraphResolution.x = value
	)
	$ResolutionY.value_changed.connect(func(value):
		StockMarketManager.GraphResolution.y = value
	)
	$Columns.value_changed.connect(func(value):
		StockMarketManager.GraphXGaps = value
	)
	$Rows.value_changed.connect(func(value):
		StockMarketManager.GraphYGaps = value
	)
	$LineThickness.value_changed.connect(func(value):
		StockMarketManager.LineThickness = value
	)
	$ToggleSettings.toggled.connect(func(button_pressed):
		$ColorPicker.visible = button_pressed
	)
	
	
	get_parent().get_node("ToggleSettings").toggled.connect(func(button_pressed):
		visible = button_pressed
	)
