extends Panel

var LayoutX_Pixels = [224, 736]
var LayoutY_Pixels = [268, 524]
var layout = Vector2(3,4)

var Steal_File_Download_Prefab

var PossibleFileNames = ["Confidential", "Strictly Confidential", "Top Secret", "Classified", "Restricted", "Unrevealed", "Undisclosed", "Unpublished", "Unknown", "Unknown", "Unknown", "Unknown", "Puppy and Kitten Photos", "Payments", "Receipts", "Orders", "Bills", "Passwords", "Passwords", "Passwords"]

var RNG

var MaxFileSize = 49

var Checkmark

var gbPS = 1

func Start():
	show()
	if(get_children() != null):
		for Child in get_children():
			Child.queue_free()
	
	for x in range(0,layout.x):
		for y in range(0,layout.y):
			var NewFile = Steal_File_Download_Prefab.instantiate()
			add_child(NewFile)
			
			var DownloadButton = NewFile.get_node("DownloadButton")
			var ProgressAnimation = NewFile.get_node("ProgressAnimation")
			
			RNG.randomize()
			
			var NumberOfGigabyte = randi_range(1, MaxFileSize)
			var IrrelevantDecimal = randi_range(0, 99)
			
			NewFile.get_node("FileName").text = PossibleFileNames[randi_range(0, PossibleFileNames.size()-1)]
			NewFile.get_node("FileSize").text = str(NumberOfGigabyte) + "." + str(IrrelevantDecimal) + "gb"
			
			var NewFile_X = LayoutX_Pixels[0] + ((LayoutX_Pixels[1]-LayoutX_Pixels[0])*x)
			var NewFile_Y = 14 + ((LayoutY_Pixels[1]-LayoutY_Pixels[0])*y)
			
			NewFile.position = Vector2(NewFile_X, NewFile_Y)
			
			DownloadButton.button_up.connect(func():
				DownloadButton.hide()
				ProgressAnimation.show()
				ProgressAnimation.play()
				await ProgressAnimation.animation_finished
				ProgressAnimation.queue_free()
				DownloadButton.icon = Checkmark
				DownloadButton.show()
				DownloadButton.disabled = true
			)
			
			ProgressAnimation.speed_scale = ((ProgressAnimation.speed_scale / NumberOfGigabyte) * 10)

func _ready():
	RNG = RandomNumberGenerator.new()
	Checkmark = preload("res://Images/Progress/checkmark.png")
	Steal_File_Download_Prefab = preload("res://Prefabs/steal_file_download_prefab.tscn")
	
	get_parent().hidden.connect(func():
		hide()
		if(get_children() != null):
			for Child in get_children():
				Child.queue_free()
	)
