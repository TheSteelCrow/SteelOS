extends Node

var Target
var ScreenSize = Vector2(1920,1080)

func _ready():
	Target = get_parent()
	print("App Visual Transition component for " + Target.name + " functioning.")

func Minimise():
	Target.scale = Vector2(1,1)
	Target.position = Vector2(0,0)
	var tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(Target, "scale", Vector2(0,0), 0.1)
	tween.tween_property(Target, "position", Vector2(ScreenSize.x/2, ScreenSize.y/2), 0.1)
	
func Maximise():
	Target.scale = Vector2(0,0)
	Target.position = Vector2(ScreenSize.x/2, ScreenSize.y/2)
	var tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(Target, "scale", Vector2(1,1), 0.1)
	tween.tween_property(Target, "position", Vector2(0,0), 0.1)
