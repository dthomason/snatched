extends KinematicBody2D

var direction = Vector2()
var target_pos = Vector2()

onready var tweenNode = $tween
onready var player = get_tree().get_root().get_node("./game/seeker")

enum STATES { IDLE, ALERTED, ATTACK, REST }
var state = IDLE

const REST_TIME = 2.0
var rest_timer = REST_TIME

const ALERT_TIME = 4.0
var alert_timer = ALERT_TIME

func _ready():
	set_physics_process(true)
	
func _physics_process(delta):
	# When not resting, look towards the player if in the light
	if state in [IDLE, REST]:
		direction = (player.get_pos() - get_pos()).normalized()
		
	if state == IDLE and player.is_idle():
		go_to_state(PREPARE)
	


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
