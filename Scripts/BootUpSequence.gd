extends Panel

var Frames
var Main

func _ready():
	Main = get_tree().root.get_child(0)
	Frames = get_children()
	RunSequence()

func RunSequence():
	for Frame in Frames:
		Frame.modulate = Vector4(255, 255, 255, 0)
	
	for Frame in Frames:
		var FadeIn = create_tween()
		FadeIn.tween_property(Frame, "modulate", Vector4(255, 255, 255, 255), 1 * Main.AnimationsMultiplier)
		await FadeIn.finished
		
		var FadeOut = create_tween()
		FadeIn.tween_property(Frame, "modulate", Vector4(255, 255, 255, 0), 1 * Main.AnimationsMultiplier)
		await FadeIn.finished
