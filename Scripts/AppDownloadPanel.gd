extends Panel

@onready var ViewButton = $ViewButton

var ViewIcon
var ReadIcon 
var Checkmark

var NumberOfGigabyte

@export var App : String

# Called when the node enters the scene tree for the first time.
func _ready():
	NumberOfGigabyte = get_meta("AppSize")
	$FileSize.text = str(NumberOfGigabyte) + ".0gb"
	
	ReadIcon = preload("res://Images/newbarsHorizontal.png")
	ViewIcon = preload("res://Images/look_c.png")
	Checkmark = preload("res://Images/Progress/checkmark.png")
	
	$ViewButton.toggled.connect(func(button_pressed):
		$Thumbnail.visible = button_pressed
		if(button_pressed):
			ViewButton.icon = ReadIcon
		else:
			ViewButton.icon = ViewIcon
	)
	
	var DownloadButton = $DownloadButton
	var ProgressAnimation = $ProgressAnimation
	
	DownloadButton.button_up.connect(func():
		ProgressAnimation.speed_scale = ((ProgressAnimation.speed_scale / NumberOfGigabyte) * 10)
		DownloadButton.hide()
		ProgressAnimation.show()
		ProgressAnimation.play()
		await ProgressAnimation.animation_finished
		ProgressAnimation.queue_free()
		DownloadButton.icon = Checkmark
		DownloadButton.show()
		DownloadButton.disabled = true
		get_tree().root.get_child(0).InstallApp(App)
	)
