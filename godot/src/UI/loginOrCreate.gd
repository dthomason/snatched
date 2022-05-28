# The game's main menu. Aggregates the LoginForm and RegisterForm.
# Emits signals with relevant information for a parent node to communicate with the game server.
extends Control

signal home_pressed(username, remember_device)
signal online_pressed(username, remember_device)

var status = ""
var textInput: String
const uuid_util = preload('res://uuid.gd')


func _ready() -> void:
	pass

func set_status(value: String) -> void:
	status = value

func get_uuid():
	# check locally for uuid just in case
	var uuid = LocalStorage.load("uuid")
	print("RECEIVED UUID: " + uuid)
	if UUID.is_valid(uuid):
		return uuid
	else:
		uuid = str(UUID.v4())
		#Store
		LocalStorage.save("uuid", uuid)
		return uuid
	

func _on_home_button_down():
	set_status("Authenticating...")
	var unique_id = get_uuid()
	print(unique_id)

	
	var p_username = $VBoxContainer/UsernameText.text.strip_edges()
	var session = yield(Online.nakama_client.authenticate_custom_async(unique_id, p_username, true, null), "completed")
	print(session)
	
	if session.is_exception():
		print(session.get_exception().message)
		set_status(session.get_exception().message)
	else:
		Online.nakama_session = session
		self.hide()
	


func _on_online_button_down():
	set_status("going online")
	emit_signal("online_pressed")


func _on_UsernameText_text_entered(new_text):
	textInput = new_text

