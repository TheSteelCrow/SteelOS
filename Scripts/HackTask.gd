extends Panel

var IsFullscreen = true

@onready var InterceptorsHolder = $InterceptorsHolder
var Interceptors
var InterceptorsMaximumY = [560, 624, 672, 720, 752]
var BottomHit = [137, 201, 249, 297, 303]
var TopHit = 443
var CurrentInterceptor

var StartingHeight = 16
var CurrentMaximumY
var Direction = 1
var TaskDone = false
var Speed = 1000

var Wins = 0

var TaskActive = false

func _process(Delta):
	if(TaskActive):
		if(CurrentInterceptor.position.y <= StartingHeight): #If below starting height
			Direction = 1
		elif(CurrentInterceptor.position.y >= CurrentMaximumY): #If above ending height
			Direction = -1
		if(TaskDone == false):
			CurrentInterceptor.position.y += Direction*Delta*Speed
		else:
			return

func _ready():
	Interceptors = InterceptorsHolder.get_children()
	
	for i in range(0,Interceptors.size()):
		CurrentInterceptor = Interceptors[i]
		CurrentMaximumY = InterceptorsMaximumY[i]
		await InterceptorsHolder.button_down
		
		if(CurrentInterceptor.position.y <= TopHit and CurrentInterceptor.position.y >= BottomHit[i]):
			print("WIN!")
			Wins+=1
		else:
			print("LOSE!")
		if(i == Interceptors.size()-1):
			TaskDone = true
			if(Wins == 5):
				get_node("DataPipelineGreen").show()
				get_node("DataPipelineRed").hide()

func OnAppVisible():
	pass

func Open():
	TaskActive = true

func Reset():
	pass

