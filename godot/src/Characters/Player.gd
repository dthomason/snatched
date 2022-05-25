# Extended character that is controlled by the user and does not respond to
# server events. Intead, it sends some of its own to notify the server of certain
# inputs.
class_name Player
extends Runner

var input_locked := false
var accel := Vector2.ZERO
var last_direction := Vector2.ZERO

var is_active := true setget set_is_active

func _ready() -> void:
	#warning-ignore: return_value_discarded
	if not $Timer.is_connected("timeout", self, "_on_Timer_timeout"):
		$Timer.connect("timeout", self, "_on_Timer_timeout")
	
	hide()


func _physics_process(_delta: float) -> void:
	direction = _get_direction()


func setup(username: String, color: Color, position: Vector2, level_limits: Rect2) -> void:
	username = "c@cool.com"
	color = color
	global_position = position
	spawn() 
	set_process(true)
	show()


func spawn() -> void:
	set_process_unhandled_input(false)
	.spawn()
	yield(self, "spawned")
	set_process_unhandled_input(true)


func set_is_active(value: bool) -> void:
	is_active = value
	set_process(value)
	set_process_unhandled_input(value)
	$Timer.paused = not value


func _get_direction() -> Vector2:
	if not is_processing_unhandled_input():
		return Vector2.ZERO

	var new_direction := joystickLeft.get_output().normalized()
	if new_direction != last_direction:
		ServerConnection.send_direction_update(new_direction.x)
		last_direction = new_direction
	return new_direction


func _on_Timer_timeout() -> void:
	ServerConnection.send_position_update(global_position)


func _on_GameUI_chat_edit_started() -> void:
	self.is_active = false


func _on_GameUI_chat_edit_ended() -> void:
	self.is_active = true




