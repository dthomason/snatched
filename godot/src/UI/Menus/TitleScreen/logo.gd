extends Sprite


func _ready():
	pass

func _on_AnimationPlayer_animation_finished(anim_name):
	$scaleTitle.play(.6, Vector2(0,0), Vector2(1,1))

func _on_scaleTitle_curve_tween(sat):
	scale = sat

