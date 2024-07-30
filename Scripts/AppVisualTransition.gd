extends Node

var Target
var ScreenSize = Vector2(1920,1080)

var Main

func _ready():
	Main = get_tree().root.get_child(0)
	Target = get_parent()
	print("App Visual Transition component for " + Target.name + " functioning.")

func Minimise(StartingPositon):
	
	if(StartingPositon != null):
		Target.position = StartingPositon
	else:
		Target.position = Vector2(0,0)
	
	Target.scale = Vector2(1,1)
	var tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(Target, "scale", Vector2(0,0), 0.1 * Main.AnimationsMultiplier)
	tween.tween_property(Target, "position", Vector2(ScreenSize.x/2, ScreenSize.y/2), 0.1 * Main.AnimationsMultiplier)
	
func Maximise(EndingPosition):
	Target.position = Vector2(ScreenSize.x/2, ScreenSize.y/2)
	Target.scale = Vector2(0,0)
	var tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(Target, "scale", Vector2(1,1), 0.1 * Main.AnimationsMultiplier)
	
	if(EndingPosition != null):
		tween.tween_property(Target, "position", EndingPosition, 0.1 * Main.AnimationsMultiplier)
	else:
		tween.tween_property(Target, "position", Vector2(0,0), 0.1 * Main.AnimationsMultiplier)
