extends Light2D

export (NodePath) var joystickRightPath
onready var joystickRight : VirtualJoystick = get_node(joystickRightPath)
onready var bodyPivot = get_parent().get_node("bodyPivot")
var rotationSpeed = 0.1

func _physics_process(delta: float) -> void:
	# Rotation:
	if joystickRight and joystickRight.is_pressed():
		rotation = lerp_angle(rotation, joystickRight.get_output().angle(), rotationSpeed)
		
		if rotation < -1.57 or rotation > 1.57:
			bodyPivot.set_scale(Vector2(sign(-1), 1))
		else:
			bodyPivot.set_scale(Vector2(sign(1), 1))
