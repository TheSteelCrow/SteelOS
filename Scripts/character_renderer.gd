extends Panel

# with randi() % int, always add one to the int. eg 1-100 is 1-101

var MAXIMUM_AGE = 65 + 1
var MINIMUM_AGE = 18

var random = RandomNumberGenerator.new()

var ManNames = ["Liam", "Noah", "Oliver", "Elijah", "William", "James", "Benjamin", "Lucas", "Henry", "Alexander", "Mason", "Michael", "Ethan", "Daniel", "Jacob", "Logan", "Jackson", "Levi", "Sebastian", "Mateo", "Jack", "Owen", "Theodore", "Aiden", "Samuel", "Joseph", "John", "David", "Wyatt", "Matthew", "Luke", "Asher", "Carter", "Julian", "Grayson", "Leo", "Jayden", "Gabriel", "Isaac", "Lincoln", "Anthony", "Hudson", "Dylan", "Ezra", "Thomas", "Charles", "Christopher", "Jaxon", "Maverick", "Josiah"]
var WomanNames = ["Olivia", "Emma", "Ava", "Sophia", "Isabella", "Mia", "Amelia", "Harper", "Evelyn", "Abigail", "Emily", "Ella", "Elizabeth", "Camila", "Luna", "Sofia", "Avery", "Mila", "Aria", "Scarlett", "Penelope", "Layla", "Chloe", "Victoria", "Madison", "Eleanor", "Grace", "Nora", "Riley", "Zoey", "Hannah", "Hazel", "Lily", "Ellie", "Violet", "Lillian", "Zoe", "Stella", "Aurora", "Natalie", "Emilia", "Everly", "Leah", "Aubrey", "Willow", "Addison", "Lucy", "Audrey", "Bella", "Nova"]

var Age
var YearsOfWork
var AWZName
var CharacterName
var NumberOfChildren

@onready var Info = $Info

func Generate():
	Info.text = ""
	random.randomize()
	Age = random.randi_range(MINIMUM_AGE, MAXIMUM_AGE)
	
	random.randomize()
	YearsOfWork = int((Age/25) + (random.randi_range(1, 3)))
	
	var RandomPercentage = random.randi_range(1, 100)
	if(RandomPercentage < 31):
		NumberOfChildren = 0
	elif(RandomPercentage > 31 and RandomPercentage < 45):
		NumberOfChildren = 1
	elif(RandomPercentage > 45 and RandomPercentage < 73):
		NumberOfChildren = 2
	elif(RandomPercentage > 73 and RandomPercentage < 88):
		NumberOfChildren = 3
	elif(RandomPercentage > 88 and RandomPercentage < 95):
		NumberOfChildren = 4
	elif(RandomPercentage > 95 and RandomPercentage < 100):
		NumberOfChildren = 5
	else:
		NumberOfChildren = 0
	
	random.randomize()
	var AWZBinary = random.randi_range(0, 1) # it was pretty hard to find a variable name for this one
	
	random.randomize()
	if(AWZBinary == 0):
		AWZName = "Man"
		CharacterName = ManNames[random.randi_range(0, ManNames.size()-1)]
	elif(AWZBinary == 1):
		AWZName = "Woman"
		CharacterName = WomanNames[random.randi_range(0, WomanNames.size()-1)]
		
	Info.text += "\nAWZ: " + AWZName
	
	for BodyPart in get_children():
		if(BodyPart.name.contains("Shirt") or BodyPart.name.contains("Hair") or BodyPart.name.contains("Pant")):
			BodyPart.hide()
	
	#Choose Face
	get_node("Face").frame = randi() % 4
	#Choose Skin Tone
	var SkinTone = randi() % 8
	Info.text += "\nSkin Tone: " + str(SkinTone+1) + "/" + "8"
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
	
	#Pants
	
	random.randomize()
	var PantsColour = random.randi_range(0, 11)
	random.randomize()
	var PantsType = random.randi_range(0, 2)
	random.randomize()
	var StripType = random.randi_range(0, 3)
	var PantsTypeName
	
	var LeftPant
	var RightPant
	
	if(PantsType == 0):
		PantsTypeName = "Short"
	elif(PantsType == 1):
		PantsTypeName = "Medium"
	elif(PantsType == 2):
		PantsTypeName = "Long"
	
	LeftPant = get_node("Pants" + PantsTypeName + "Left")
	RightPant = get_node("Pants" + PantsTypeName + "Right")
	
	LeftPant.show()
	RightPant.show()
	
	LeftPant.frame = PantsColour
	RightPant.frame = PantsColour
	
	var PantsMiddle = get_node("PantsMiddle")
	PantsMiddle.show()
	
	PantsMiddle.frame = StripType  + (4 * PantsColour)
	
	#Shirt Middle
	
	var ShirtMiddle = get_node("ShirtMiddleMan")
	ShirtMiddle.show()
	ShirtMiddle.frame = (randi() % 8) + (8 * ShirtColour)
	
	Info.text += "\nAge: " + str(Age)
	var Old
	var Hair
	
	print(Age)
	if(Age >= 50):
		
		Old = true
		Info.text += "\nIsOld: yes"
		random.randomize()
		
		if(AWZName == "Man"):
			Hair = get_node("HairMan")
			Hair.frame = random.randi_range(49, 63)
		elif(AWZName == "Woman"):
			Hair = get_node("HairWoman")
			Hair.frame = random.randi_range(30, 47)
			
		Hair.show()
	elif(Age < 50):
		
		Old = false
		Info.text += "\nIsOld: no"
		random.randomize()
		
		if(AWZName == "Man"):
			Hair = get_node("HairMan")
			Hair.frame = random.randi_range(0, 48)
		elif(AWZName == "Woman"):
			Hair = get_node("HairWoman")
			Hair.frame = random.randi_range(0, 29)
		
		Hair.show()
	
	var ShoeLeft = get_node("ShoeLeft")
	var ShoeRight = get_node("ShoeRight")
	random.randomize()
	var ShoeColour = random.randi_range(0, 34)
	ShoeLeft.frame = ShoeColour
	ShoeRight.frame = ShoeColour
