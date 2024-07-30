extends Panel

var IsFullscreen = true

var NewCharacterRenderer

var Character1
var Character2

var ApproximationWords = ["roughly", "around", "nearly", "just over", "approximately", "almost", "just under"]
var QualityWords = ["good", "good", "good", "good", "decent", "decent", "alright", "bad", "fun", "smart", "intelligent", "hard working", "great", "average", "average", "average", "average"]

var random = RandomNumberGenerator.new()

var CanInteract = true

var Taskbar

var StampOriginPosition
var DraggingStamp = false
var StampOffSetFromMouse
var Stamp
var StampTimeUntilReturn = 1

var Main

func StartTask():
	Stamp.get_node("Button").disabled = false
	get_node("Warning").hide()
	SetupRound()
	get_node("NextButton").text = "NEXT"

func StopTask():
	get_node("Warning").show()
	get_node("NextButton").hide()
	get_node("Hired").hide()
	get_node("Fired").hide()

func SetupRound():
	RemoveOldCharacters()
	CanInteract = true
	
	if(Taskbar.TaskName == "Fire"):
		get_node("Stamp/Fire").show()
		get_node("Stamp/Hire").hide()
	elif(Taskbar.TaskName == "Hire"):
		get_node("Stamp/Fire").hide()
		get_node("Stamp/Hire").show()
	
	NewCharacterRenderer = preload("res://Prefabs/new_character_renderer.tscn")
	
	Character1 = NewCharacterRenderer.instantiate()
	Character1.name = "Character1"
	add_child(Character1)
	move_child(Character1, 1)
	Character1.position = Vector2(52,98)
	Character1.Generate()
	GenerateInfo("1")
	Character1.move_to_front()
	
	Character2 = NewCharacterRenderer.instantiate()
	Character2.name = "Character2"
	add_child(Character2)
	move_child(Character2, 1)
	Character2.position = Vector2(1184, 102)
	Character2.Generate()
	GenerateInfo("2")
	Character2.move_to_front()
	
	get_node("Warning").move_to_front()

func GenerateInfo(CharacterNumber):
	var InfoOutput = get_node("Employee" + CharacterNumber).get_node("Info")
	var InfoInput = get_node("Character" + CharacterNumber)
	
	var InfoUnformated = "%s is a%s %s employee who has worked at the company for %s %s year%s. %s is %s and %s %s child%s."
	
	var Pronoun
	var IncludeS = ""
	var MakeChildrenPlural = "ren"
	var NumberOfChildrenText = ""
	random.randomize()
	var RandomQualityWord = QualityWords[random.randi_range(0, QualityWords.size()-1)]
	var IncludeN = ""
	var ParentalStatusText
	
	if(InfoInput.AWZName == "Man"):
		Pronoun = "He"
	elif(InfoInput.AWZName == "Woman"):
		Pronoun = "She"
	
	if(InfoInput.YearsOfWork > 1):
		IncludeS = "s"
	
	if(InfoInput.NumberOfChildren == 0):
		NumberOfChildrenText = "no"
		ParentalStatusText = "has"
	else:
		NumberOfChildrenText = str(InfoInput.NumberOfChildren)
		if(InfoInput.AWZName == "Man"):
			ParentalStatusText = "is a father to"
		elif(InfoInput.AWZName == "Woman"):
			ParentalStatusText = "is a mother to"
		
	if(InfoInput.NumberOfChildren == 1):
		MakeChildrenPlural = ""
	
	if(RandomQualityWord[0] == "a" or RandomQualityWord[0] == "e" or RandomQualityWord[0] == "i" or RandomQualityWord[0] == "u"):
		IncludeN = "n"
	
	random.randomize()
	InfoOutput.text = InfoUnformated % [InfoInput.CharacterName, IncludeN, RandomQualityWord, ApproximationWords[random.randi_range(0, ApproximationWords.size()-1)], str(InfoInput.YearsOfWork), IncludeS, Pronoun, str(InfoInput.Age), ParentalStatusText, NumberOfChildrenText, MakeChildrenPlural]

	#generate something good and something bad about them, eg they steal office supplies

func Reset():
	pass

func RemoveOldCharacters():
	if(Character1):
		remove_child(Character1)
		Character1.queue_free()
	if(Character2):
		remove_child(Character2)
		Character2.queue_free()

func Open():
	pass

func _ready():
	Main = get_parent()
	get_node("Warning").show()
	get_node("Warning").move_to_front()
	Taskbar = get_parent().get_node("Taskbar")
	
	Stamp = get_node("Stamp")
	StampOriginPosition = Stamp.position
	
	Stamp.get_node("Button").button_down.connect(func():
		DraggingStamp = true
		print("ButtonDown")
		StampOffSetFromMouse = Stamp.position - get_viewport().get_mouse_position()
	)
	Stamp.get_node("Button").button_up.connect(func():
		DraggingStamp = false
		
		if(Stamp.position.x <= 459):
			RunSequence(1)
		elif(Stamp.position.x >= 1093):
			RunSequence(2)
		else:
			Stamp.position = StampOriginPosition
	)
		
func RunSequence(EmployeeToFire):
	#Starting Stamping
	Stamp.get_node("StampSFX").play()
	Stamp.get_node("Button").disabled = true
	var StampMovingPart = Stamp.get_node(Taskbar.TaskName)
	var tween = create_tween()
	tween.tween_property(StampMovingPart, "position", Vector2(StampMovingPart.position.x, StampMovingPart.position.y + 50), 0.1 * Main.AnimationsMultiplier)
	await tween.finished
	var StampImageInk = get_node(Taskbar.TaskName + "d")
	
	#During Stamping
	if(EmployeeToFire == 1):
		StampImageInk.position = Vector2(148,329)
	elif(EmployeeToFire == 2):
		StampImageInk.position = Vector2(1278,329)
	StampImageInk.show()
	StampImageInk.move_to_front()
	Stamp.move_to_front()
	get_node("Warning").move_to_front()
	
	#Finishing Stamping
	var tween2 = create_tween()
	tween2.tween_property(StampMovingPart, "position", Vector2(StampMovingPart.position.x, StampMovingPart.position.y - 50), 0.25 * Main.AnimationsMultiplier)
	await tween2.finished
	
	#After Stamping
	await get_tree().create_timer(StampTimeUntilReturn).timeout
	get_node("NextButton").show()
	Stamp.position = StampOriginPosition

func _process(delta):
	if(DraggingStamp):
		Stamp.position = get_viewport().get_mouse_position() + StampOffSetFromMouse
		Stamp.move_to_front()
		get_node("Warning").move_to_front()

func OnAppVisible():
	pass

func _on_next_button_button_up():
	get_node("NextButton").hide()
	Stamp.get_node("Button").disabled = false
	get_node("Hired").hide()
	get_node("Fired").hide()
	if((Taskbar.TaskActive == true) && (Taskbar.TaskName == "Hire" or Taskbar.TaskName == "Fire")):
		Taskbar.TaskProgress += 1
	if(Taskbar.TaskProgress == Taskbar.TaskQuota):
		get_node("Warning").show()
	elif(Taskbar.TaskProgress == Taskbar.TaskQuota-1):
		get_node("NextButton").text = "FINISH"
		SetupRound()
	else:
		SetupRound()
