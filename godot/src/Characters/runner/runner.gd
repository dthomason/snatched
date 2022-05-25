# This is a Character, there can be multiple in one game

class_name Runner
extends KinematicBody2D

signal spawned

enum STATES {IDLE, KILLED, UPPER}
var state = STATES.IDLE

var velocity := Vector2.ZERO
var direction := Vector2.ZERO
var username := "" setget _set_username

onready var joystickLeft : VirtualJoystick = $controls/leftJoystick
onready var _animated_sprite = $bodyPivot/spriteAnimation
onready var _rolling_head = $bodyPivot/rollingHead
onready var _animated_player = $animationPlayer

var blood = load("res://src/Props/blood.tscn")


export var speed : float = 350

func _physics_process(delta: float) -> void:
	if state == STATES.KILLED:
		_animated_player.play("fatality")
		_animated_sprite.play("fatality")
		return

	if joystickLeft and joystickLeft.is_pressed():
		direction = joystickLeft.get_output().normalized()
			
		move_and_slide(direction * speed)

		if direction.x == 0:
			return
		
		_animated_sprite.play("run")
		
		$bodyPivot.set_scale(Vector2(sign(direction.x), 1))
		
	else:
		_animated_sprite.play("idle")
	

func _on_e_lvl_promoter_body_exited(body):
	z_index = 10
	set_collision_mask_bit(7, true)


func _on_e_lvl_demoter_body_exited(body):
	z_index = 0
	set_collision_mask_bit(7, false)
	
func spawn() -> void:
	emit_signal("spawned")


func despawn() -> void:
	queue_free()
	
	
func go_to_state(new_state):
	if state != new_state:
		state = new_state
	if new_state == 0:
		print("IDLE")
	if new_state == 2:
		print("KILLED")
		
	if new_state == STATES.IDLE:
		_animated_sprite.play("idle")
		_animated_player.play("idle")

	if new_state == STATES.KILLED:
		var blood_instance = blood.instance()
		get_tree().current_scene.add_child(blood_instance)
		blood_instance.global_position = global_position
		blood_instance.rotation = global_position.angle_to_point(global_position)


func _on_killZone_body_entered(body):
	go_to_state(STATES.KILLED)


func _on_animationPlayer_animation_finished(anim_name):
	if anim_name == "fatality":
		print("fatality")
		go_to_state(STATES.IDLE)
		
		
func _set_username(value: String) -> void:
	username = value

