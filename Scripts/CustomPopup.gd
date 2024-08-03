extends Panel
signal response_signal

var PopupCreatorName = "None"
var Description = "None"
var UserResponse = "Unknown"
var Type = "Unknown"

func Setup():
	if(Type == "Error"):
		get_node("TopPanel/TypeLabel").text = Type.to_upper()
	elif(Type == "Query"):
		get_node("TopPanel/TypeLabel").text = PopupCreatorName
	
	get_node("MainPanel/DescriptionLabel").text = Description

func _on_negative_response_button_button_up():
	SubmitResponse(false)

func _on_positive_response_button_button_up():
	SubmitResponse(true)

func _on_close_button_button_up():
	SubmitResponse(false)
	
func SubmitResponse(Response):
	UserResponse = Response
	response_signal.emit(Response)
	queue_free()
