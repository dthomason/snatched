extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func debug(log_name, object, log_ref, is_method):
	status.append([log_name, object, log_ref, is_method])

func set_status(value: String) -> void:
	var label_text = ""
	status.push_back(value)
	var recent_five = []
	
	if len(status) > 5:
		var first_index = len(status) - 5
		recent_five = status.slice(first_index, len(status), 1, false)
	
	for message in recent_five:
		label_text += message + "\n"
	
#	$VBoxContainer/Label.text = label_text
