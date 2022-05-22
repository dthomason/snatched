extends KinematicBody2D

export var speed = 5
var angle = Vector2(1,0)
var velocity = Vector2()
var direction = Vector2()
var rotation_dir = Vector2();
#export (int) var speed = 200
export (float) var rotation_speed = 1.5

onready var body = $bodyPivot

# Example of using angle for direction pointing
onready var seeker_light = $seekerLight

# Example for taking items
#onready var diamond = get_node("../diamond")
#onready var collision = get_node("../diamond/collisionPolygon2D")



func _physics_process(delta):
	set_move_direction()
	if direction == Vector2(0,0):
		return

	velocity = direction.normalized() * speed
	angle = direction.angle()
	rotation_dir = angle

	rotation += rotation_dir * rotation_speed * delta

func set_move_direction():
	direction.x = int(Input.get_action_strength("ui_right")) - int(Input.get_action_strength("ui_left"))
	direction.y = int(Input.get_action_strength("ui_down")) - int(Input.get_action_strength("ui_up"))

# Move and slide
func handle_movement():
	if Input.is_action_pressed("ui_left"):
		global_position.x -= speed
	if Input.is_action_pressed("ui_right"):
		global_position.x += speed
	if Input.is_action_pressed("ui_up"):
		global_position.y -= speed
	if Input.is_action_pressed("ui_down"):
		global_position.y += speed

	
	move_and_slide(velocity)
	get_tree().set_input_as_handled()

func set_right_input_direction():
	direction.x = int(Input.get_action_strength("look_right")) - int(Input.get_action_strength("look_left"))
	direction.y = int(Input.get_action_strength("look_down")) - int(Input.get_action_strength("look_up"))


# Rotation
func handle_rotation():
	velocity = Vector2()
	if Input.is_action_pressed("look_right"):
		rotation_dir += 1
	if Input.is_action_pressed("look_left"):
		rotation_dir -= 1
	if Input.is_action_pressed("look_down"):
		velocity = Vector2(-speed, 0).rotated(rotation)
	if Input.is_action_pressed("look_up"):
		velocity = Vector2(speed, 0).rotated(rotation)
	
	get_tree().set_input_as_handled()

func handle_motion():
	handle_movement()
	handle_rotation()
	#if direction == Vector2(0,0):
	#	return
	seeker_light.rotation = angle
	if direction.x == 0:
		return
	$bodyPivot.set_scale(Vector2(direction.x, 1))



#func _on_diamond_body_entered(body: Node) -> void:
#	collision.disabled = true
#	diamond.queue_free()
