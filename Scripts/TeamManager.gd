extends Panel

var IsFullscreen = true

var NewCharacterRenderer

var Character1
var Character2

var ActivityType = "Fire"

var ApproximationWords = ["roughly", "around", "nearly", "just over", "approximately", "almost", "just under"]
var QualityWords = ["good", "good", "good", "good", "decent", "decent", "alright", "bad", "fun", "smart", "intelligent", "hard working", "great", "average", "average", "average", "average"]

var random = RandomNumberGenerator.new()

var CanInteract = true

var Taskbar

func SetupRound():
	RemoveOldCharacters()
	CanInteract = true
	
	if(Taskbar.TaskName == "Fire"):
		get_node("BottomPanel1").get_node("1FireButton").show()
		get_node("BottomPanel2").get_node("2FireButton").show()
		get_node("BottomPanel1").get_node("1HireButton").hide()
		get_node("BottomPanel2").get_node("2HireButton").hide()
	elif(Taskbar.TaskName == "Hire"):
		get_node("BottomPanel1").get_node("1HireButton").show()
		get_node("BottomPanel2").get_node("2HireButton").show()
		get_node("BottomPanel1").get_node("1FireButton").hide()
		get_node("BottomPanel2").get_node("2FireButton").hide()
	
	NewCharacterRenderer = preload("res://Prefabs/new_character_renderer.tscn")
	
	Character1 = NewCharacterRenderer.instantiate()
	Character1.name = "Character1"
	add_child(Character1)
	move_child(Character1, 1)
	Character1.position = Vector2(64,64)
	Character1.Generate()
	GenerateInfo("1")
	
	
	Character2 = NewCharacterRenderer.instantiate()
	Character2.name = "Character2"
	add_child(Character2)
	move_child(Character2, 1)
	Character2.position = Vector2(992,64)
	Character2.Generate()
	GenerateInfo("2")
	

func GenerateInfo(CharacterNumber):
	var InfoOutput = get_node("BottomPanel" + CharacterNumber).get_node("Info")
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
	
	if(InfoInput.SexName == "Man"):
		Pronoun = "He"
	elif(InfoInput.SexName == "Woman"):
		Pronoun = "She"
	
	if(InfoInput.YearsOfWork > 1):
		IncludeS = "s"
	
	if(InfoInput.NumberOfChildren == 0):
		NumberOfChildrenText = "no"
		ParentalStatusText = "has"
	else:
		NumberOfChildrenText = str(InfoInput.NumberOfChildren)
		if(InfoInput.SexName == "Man"):
			ParentalStatusText = "is a father to"
		elif(InfoInput.SexName == "Woman"):
			ParentalStatusText = "is a mother to"
		
	if(InfoInput.NumberOfChildren == 1):
		MakeChildrenPlural = ""
	
	if(RandomQualityWord[0] == "a" or RandomQualityWord[0] == "e" or RandomQualityWord[0] == "i" or RandomQualityWord[0] == "u"):
		IncludeN = "n"
	
	random.randomize()
	InfoOutput.text = InfoUnformated % [InfoInput.CharacterName, IncludeN, RandomQualityWord, ApproximationWords[random.randi_range(0, ApproximationWords.size()-1)], str(InfoInput.YearsOfWork), IncludeS, Pronoun, str(InfoInput.Age), ParentalStatusText, NumberOfChildrenText, MakeChildrenPlural]

	#generate something good and something bad about them, eg they steal office supplies

func Reset():
	SetupRound()

func RemoveOldCharacters():
	if(Character1):
		remove_child(Character1)
		Character1.queue_free()
	if(Character2):
		remove_child(Character2)
		Character2.queue_free()

func Open():
	SetupRound()

func _ready():
	get_node("Warning").show()
	
	Taskbar = get_parent().get_node("Taskbar")
	
	var HireFireButtons = get_node("BottomPanel1").get_children()
	HireFireButtons.append_array(get_node("BottomPanel2").get_children())
	
	for HireFireButton in HireFireButtons:
		if(HireFireButton.name.contains("Button")):
			HireFireButton.button_up.connect(func():HireFireButtonUp(HireFireButton))

func OnAppVisible():
	Reset()
	
	if((Taskbar.TaskActive == true) && (Taskbar.TaskName == "Hire" or Taskbar.TaskName == "Fire") && Taskbar.TaskQuota != Taskbar.TaskProgress):
		get_node("Warning").hide()
	else:
		get_node("Warning").show()

func HireFireButtonUp(HireFireButton):
	if(CanInteract == true):
		if((Taskbar.TaskActive == true) && (Taskbar.TaskName == "Hire" or Taskbar.TaskName == "Fire")):
			Taskbar.TaskProgress += 1
		
		CanInteract = false
		get_node("Character" + str(HireFireButton.name)[0]).get_node(Taskbar.TaskName + "d").show()
		print(HireFireButton.name)
		await get_tree().create_timer(2).timeout
		SetupRound()
		if(Taskbar.TaskProgress == Taskbar.TaskQuota):
			get_node("Warning").show()
