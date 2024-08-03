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
var Speed = 2000

var Wins = 0

var TaskActive = false

@onready var Pipelines = [$DataPipelineRed, $DataPipelineGreen, $DataPipelineBlue]

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

func StartTask():
	SetPipelineColor("Blue")
	
	for i in range(0,Interceptors.size()):
		CurrentInterceptor = Interceptors[i]
		CurrentMaximumY = InterceptorsMaximumY[i]
		
		await InterceptorsHolder.button_down
		print("button")
		
		if(CurrentInterceptor.position.y <= TopHit and CurrentInterceptor.position.y >= BottomHit[i]):
			Wins+=1
		else:
			TaskActive = false
			SetPipelineColor("Red")
			return
		if(i == Interceptors.size()-1):
			TaskDone = true
			if(Wins == 5):
				TaskActive = false
				SetPipelineColor("Green")
				await get_tree().create_timer(2).timeout
				get_node("StealFiles").Start()
				return

func SetPipelineColor(CurrentPipeline):
	for Pipeline in Pipelines:
		Pipeline.hide()
	get_node("DataPipeline" + CurrentPipeline).show()
	
func OnAppVisible():
	pass

func _ready():
	Interceptors = InterceptorsHolder.get_children()

func Open():
	Direction = 1
	
	for Interceptor in Interceptors:
		Interceptor.position.y = StartingHeight
	
	StartTask()
	
	TaskDone = false
	TaskActive = true
	Wins = 0

func Reset():
	pass

