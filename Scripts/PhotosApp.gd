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
	get_parent().GeneratePopup("PhotosApp", "This feature has been disabled due to conflicts with PainterPro, please use PainterPro if you wish to save an image.", "Error", Vector2(100,100))
#	var ImagePainterApp = get_parent().get_node("ImagePainterApp")
#	var ImagePainter = ImagePainterApp.get_node("ImagePainter")
#	var SubViewportObj = ImagePainterApp.get_node("SubViewport")
#
#	SubViewportObj.size = ImagePainter.size
#	ImageRenderer.size = ImagePainter.size
#
#	var PreviousPosition = ImagePainter.position
#
#	ImagePainterApp.remove_child(ImagePainter)
#	SubViewportObj.add_child(ImagePainter)
#	ImagePainter.position = Vector2.ZERO
#
#	await RenderingServer.frame_post_draw
#
#	SubViewportObj.render_target_update_mode = 1
#
#	await RenderingServer.frame_post_draw
#
#	var newtexture = ImageTexture.new()
#	var test = newtexture.create_from_image(SubViewportObj.get_texture().get_image())
#	ImageRenderer.texture = test
#	ImageRenderer.position = Vector2((size.x-ImagePainter.size.x)/2, ImageRenderer.position.y)
#	get_parent().get_node("Background").texture = test
#
#	SubViewportObj.remove_child(ImagePainter)
#	ImagePainterApp.add_child(ImagePainter)
#
#	ImagePainter.SelectedTool = "Brush"
#
#	ImagePainter.position = PreviousPosition

func OpenImage():
	get_node("AppBaseComponent").AppRunning = true
	position = Vector2(0,0)
	scale = Vector2(1,1)
	show()
	move_to_front()
