extends KinematicBody2D

export var speed = 5
var angle = Vector2(1,0)
var velocity = Vector2()
var direction = Vector2()

onready var body = $bodyPivot
onready var animatedSprite = $bodyPivot/animatedSprite

func _physics_process(delta):
	pass

func _on_Timer_timeout():
	animatedSprite.play("stall")

func _on_animatedSprite_animation_finished():
	animatedSprite.play("fly")
