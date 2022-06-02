# The game's main menu. Aggregates the LoginForm and RegisterForm.
# Emits signals with relevant information for a parent node to communicate with the game server.
extends Control

var status = []
var textInput: String

signal home_pressed(username, remember_device)
signal online_pressed(username, remember_device)
signal status(status)

onready var device_id = OS.get_unique_id()

func _ready() -> void:
	pass
	
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
	
	$VBoxContainer/Label.text = label_text
	
func _on_home_button_down():
	set_status("Using Device_ID for Auth...")

	
	var p_username = $VBoxContainer/UsernameText.text.strip_edges()
	var session = yield(Online.nakama_client.authenticate_device_async(device_id, p_username = null, true, null), "completed")
	set_status(to_json(session))
	
	if session.is_exception():
		set_status(session.get_exception().message)
	else:
		Online.nakama_session = session
		self.hide()
	


func _on_online_button_down():
	set_status("going online")
	emit_signal("online_pressed")


func _on_UsernameText_text_entered(new_text):
	textInput = new_text

