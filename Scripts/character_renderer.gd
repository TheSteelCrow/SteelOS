extends Panel

# with randi() % int, always add one to the int. eg 1-100 is 1-101

var MAXIMUM_AGE = 65 + 1
var MINIMUM_AGE = 18

var random = RandomNumberGenerator.new()

@onready var Info = $Info

func _on_button_button_up():
	Info.text = ""
	random.randomize()
	var Age = random.randi_range(MINIMUM_AGE, MAXIMUM_AGE)
	
	random.randomize()
	var SexBinary = random.randi_range(0, 1) # it was pretty hard to find a variable name for this one
	var SexName
	
	if(SexBinary == 0):
		SexName = "Man"
	elif(SexBinary == 1):
		SexName = "Woman"
		
	Info.text += "\nSex = " + SexName
	
	for BodyPart in get_children():
		if(BodyPart.name.contains("Shirt")):
			BodyPart.hide()
	
	#Choose Face
	get_node("Face").frame = randi() % 4
	#Choose Skin Tone
	var SkinTone = randi() % 8
	get_node("Head").frame = SkinTone
	get_node("Neck").frame = SkinTone
	get_node("ArmLeft").frame = SkinTone
	get_node("ArmRight").frame = SkinTone
	get_node("HandLeft").frame = SkinTone
	get_node("HandRight").frame = SkinTone
	get_node("LegLeft").frame = SkinTone
	get_node("LegRight").frame = SkinTone
	#Choose Shirt Type
	
	var ShirtColour = randi() % 8
	var ShirtType = randi() % 3
	var ShirtTypeName
	
	var LeftSleeve
	var RightSleeve
	
	if(ShirtType == 0):
		ShirtTypeName = "Short"
	elif(ShirtType == 1):
		ShirtTypeName = "Medium"
	elif(ShirtType == 2):
		ShirtTypeName = "Long"
	
	LeftSleeve = get_node("Shirt" + ShirtTypeName + "Left")
	RightSleeve = get_node("Shirt" + ShirtTypeName + "Right")
	
	LeftSleeve.show()
	LeftSleeve.frame = ShirtColour
	RightSleeve.show()
	RightSleeve.frame = ShirtColour
	# ^ This stuff aint workin cuz I removed the breast ones fix that pls, im too tired
	
	var ShirtMiddle = get_node("ShirtMiddleMan")
	ShirtMiddle.show()
	ShirtMiddle.frame = (randi() % 8) + (8 * ShirtColour)
	
	Info.text += "\nAge: " + str(Age)
	var Old
	
	var Hair = get_node("HairMan")
	
	Hair.hide()
	
	print(Age)
	if(Age >= 50):
		Hair.show()
		Old = true
		Info.text += "\nIsOld = true"
		random.randomize()
		Hair.frame = random.randi_range(49, 63)
	else:
		Hair.show()
		Old = false
		Info.text += "\nIsOld = false"
		random.randomize()
		Hair.frame = random.randi_range(0, 48)
