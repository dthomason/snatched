class_name Seeker

extends KinematicBody2D

#const joystickLeft: PackedScene = preload("res://src/UI/Components/joystick/virtual_joystick.tscn")
onready var bodyPivot = $bodyPivot
onready var _animated_sprite = $bodyPivot/spriteAnimation
onready var _seeker_light = $seekerLight
onready var joystickLeft = $PlayerUI/leftJoystick

export var speed : float = 350

func _physics_process(delta: float) -> void:
	if Input.is_action_pressed("ui_select"):
		_animated_sprite.play("bat_slam")	

	if joystickLeft and joystickLeft.is_pressed():
		var direction = joystickLeft.get_output().normalized()
			
		move_and_slide(direction * speed)

		if direction.x == 0:
			return
			
		_animated_sprite.play("run")
		
		bodyPivot.set_scale(Vector2(sign(direction.x), 1))
		
	else:
		_animated_sprite.play("idle")


func _on_e_lvl_promoter_body_exited(body):
	z_index = 10
	set_collision_mask_bit(7, true)


func _on_e_lvl_demoter_body_exited(body):
	z_index = 0
	set_collision_mask_bit(7, false)
	
