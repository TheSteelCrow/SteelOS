extends Label

func _process(delta):
	move_to_front()
	set_text("FPS: " + str(Engine.get_frames_per_second()))
