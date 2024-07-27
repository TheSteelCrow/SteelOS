extends Panel

var IsFullscreen = false

@onready var ImageRenderer = $ImageRenderer
var ImageFile
var SubViewportObj

func OnAppVisible():
	pass

func Reset():
	pass

func Open():
	pass

func ExportImage():
	var ImagePainterApp = get_parent().get_node("ImagePainterApp")
	var ImagePainter = ImagePainterApp.get_node("ImagePainter")
	var SubViewportObj = ImagePainterApp.get_node("SubViewport")
	
	SubViewportObj.size = ImagePainter.size
	ImageRenderer.size = ImagePainter.size
	
	var PreviousPosition = ImagePainter.position
	
	ImagePainterApp.remove_child(ImagePainter)
	SubViewportObj.add_child(ImagePainter)
	ImagePainter.position = Vector2.ZERO
	
	await RenderingServer.frame_post_draw
	
	SubViewportObj = get_parent().get_node("ImagePainterApp/SubViewport")
	SubViewportObj.render_target_update_mode = 1
	if(ImageRenderer.texture == null):
		ImageRenderer.texture = SubViewportObj.get_texture()
	get_parent().get_node("Background").texture = SubViewportObj.get_texture()
	
	await RenderingServer.frame_post_draw
	
	SubViewportObj.remove_child(ImagePainter)
	ImagePainterApp.add_child(ImagePainter)
	ImagePainter.position = PreviousPosition
	
	get_parent().get_node("ImagePainterApp/SubViewport")

func _input(Event):
	if Event is InputEventKey:
		if Event.pressed and Event.keycode == KEY_KP_ENTER and OS.is_debug_build():
			ExportImage()
		if Event.pressed and Event.keycode == KEY_KP_0 and OS.is_debug_build():
			get_node("AppBaseComponent").AppRunning = true
			position = Vector2(0,0)
			scale = Vector2(1,1)
			show()
			move_to_front()
			#ImageRenderer.texture = get_viewport().get_texture().get_image()
			#ImageFile = get_viewport().get_texture().get_image().save_png("res://test_image.png")
			
			#ImageRenderer.texture = load("res://test_image.png")
			#ImageRenderer.texture = Image.load_from_file("res://test_image.png")
