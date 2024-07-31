extends Panel

var FADE_IN_TIME = 1
var FADE_OUT_TIME = 1
var TRANSITION_INTERVAL = 1.5

var Frames
var Main

var StartUpSound

func _ready():
	StartUpSound = get_parent().get_node("StartUpSound")
	Main = get_tree().root.get_child(0)
	Frames = get_children()
	Frames.remove_at(0)
	RunSequence()

func RunSequence():
	get_parent().move_to_front()
	StartUpSound.play()
	for Frame in Frames:
		Frame.modulate = Color(1, 1, 1, 0)
	
	for Frame in Frames:
		var FadeIn = create_tween()
		FadeIn.tween_property(Frame, "modulate", Color(1, 1, 1, 1), FADE_IN_TIME * Main.AnimationsMultiplier)
		await FadeIn.finished
		
		await get_tree().create_timer(TRANSITION_INTERVAL).timeout
		
		var FadeOut = create_tween()
		FadeOut.tween_property(Frame, "modulate", Color(1, 1, 1, 0), FADE_OUT_TIME * Main.AnimationsMultiplier)
		await FadeOut.finished
		
		await get_tree().create_timer(TRANSITION_INTERVAL/2).timeout
	
	var FadeOutBackground = create_tween()
	FadeOutBackground.tween_property(self, "modulate", Color(1, 1, 1, 0), FADE_OUT_TIME * Main.AnimationsMultiplier)
	
	var FadeOutMusic = create_tween()
	FadeOutMusic.tween_property(StartUpSound, "volume_db", -80, FADE_OUT_TIME * Main.AnimationsMultiplier)
	
	await FadeOutBackground.finished
	hide()
	get_parent().hide()
	
	await FadeOutMusic.finished
	StartUpSound.stop()
	
	StartUpSound.queue_free()
	self.queue_free()



func _on_skip_button_up():
	get_parent().hide()
	StartUpSound.queue_free()
	self.queue_free()
