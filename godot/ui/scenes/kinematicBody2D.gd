extends KinematicBody2D

export var speed = 5
var angle = Vector2(1,0)
var velocity = Vector2()
var direction = Vector2()

onready var body = $bodyPivot

func _physics_process(delta):
	set_input_direction()
	if direction == Vector2(0,0):
		return

	velocity = direction.normalized() * speed
	angle = direction.angle()

	handle_movement()

func set_input_direction():
	direction.x = int(Input.get_action_strength("move_right")) - int(Input.get_action_strength("move_left"))
	direction.y = int(Input.get_action_strength("move_down")) - int(Input.get_action_strength("move_up"))

func handle_movement():
	if Input.is_action_pressed("move_left"):
		global_position.x -= speed
	if Input.is_action_pressed("move_right"):
		global_position.x += speed
	if Input.is_action_pressed("move_up"):
		global_position.y -= speed
	if Input.is_action_pressed("move_down"):
		global_position.y += speed

	move_and_slide(velocity)
	if direction.x == 0:
		return
	$bodyPivot.set_scale(Vector2(direction.x, 1))
