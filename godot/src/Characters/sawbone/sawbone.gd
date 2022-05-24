class_name Sawbone
extends KinematicBody2D

var attacked = false
var leaving = false

var timeout = "timeout"
var method = "_on_timer_timeout"

var direction = Vector2()
var target_pos = Vector2.ZERO
var velocity = Vector2()

export (NodePath) var sawboneGuarded
onready var alertArea: Area2D = get_node(sawboneGuarded)
onready var tweenNode = get_node("tween")
onready var player = get_parent().get_node("runner")
onready var path = get_node("bodyPivot/navigation2D")

const SPEED = 1000

var looking_at = 1

enum STATES {
	IDLE, 
	ALERTED, 
	WATCH, 
	ATTACK, 
	CUT,
	LEAVE, 
	}
var state = STATES.IDLE

const WATCH_TIME = 4
var watch_timer = WATCH_TIME

func _ready():
	set_physics_process(true)

func _physics_process(delta):
	if target_pos:
		if state == STATES.ALERTED:
			
			move_to(target_pos)
			if position.distance_to(target_pos) <= 300:
				go_to_state(STATES.WATCH)
				
		if state == STATES.WATCH:
			direction = (player.position - position).normalized()

		if state == STATES.ATTACK:
			if position.distance_to(target_pos) > 30 and not attacked:
				move_to(target_pos, Tween.TRANS_ELASTIC)
			else:
				go_to_state(STATES.CUT)
		
		if state == STATES.CUT:
			if position.distance_to(target_pos) > 10 and not leaving:
				move_to(target_pos, Tween.TRANS_ELASTIC)
			else:
				go_to_state(STATES.LEAVE)
		
		if state == STATES.LEAVE:
			if position.distance_to(target_pos) > 10:
				move_to(target_pos, Tween.TRANS_BACK)
			else:
				go_to_state(STATES.IDLE)
			
func display_state(new_state):
	print($timer.wait_time)
	if new_state == 0:
		print("IDLE")
	if new_state == 1:
		print("ALERTED")
	if new_state == 2:
		print("ATTACK")
	if new_state == 3:
		print("WATCH")
	if new_state == 4:
		print("LEAVE")

func move_to(target, type = Tween.TRANS_ELASTIC):
	tweenNode.interpolate_property(self, "position", position, target, 2, type, Tween.EASE_OUT)
	tweenNode.start()
	
func go_to_state(new_state):
	state = new_state
	display_state(state)
	var pos = player.position

	if new_state == STATES.ALERTED:
		adjust_focus(pos)
		pos.y -= 300
		pos.x += 300 * looking_at
		target_pos = pos

	if new_state == STATES.WATCH:
		adjust_focus(pos)
		if not $timer.is_connected(timeout, self, method):
			$timer.connect(timeout, self, method)

	if new_state == STATES.ATTACK:
		print("IN GOTOSTATE")
		adjust_focus(pos)
		target_pos = pos
		
	if new_state == STATES.CUT:
		attacked = true
		var new_position = Vector2(pos.x + (200 * looking_at), pos.y - 100)
		target_pos = new_position
		
	if new_state == STATES.LEAVE:
		adjust_focus(pos)
		if leaving:
			var goLeft = Vector2(position.x - position.x, position.y)
			target_pos = goLeft
		else:
			leaving = true
			var goUp = Vector2(position.x, position.y - 300)
			target_pos = goUp		
		
func adjust_focus(player_pos):
	looking_at = -1 if player_pos.x < position.x else 1
	$bodyPivot.set_scale(Vector2(looking_at, 1))
		
func _on_area2D_body_entered(body):
	go_to_state(STATES.ALERTED)

# this get's activated during the WATCH STATE
func _on_timer_timeout():
	go_to_state(STATES.LEAVE)
	
func _on_visibilityEnabler2D_viewport_exited(viewport):
	tweenNode.reset(self, "position")

		
