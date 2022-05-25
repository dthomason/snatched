extends Sprite


func _ready():
	pass

func _on_CurveTween_curve_tween(sat):
	scale = sat

func _on_AnimationPlayer_animation_finished(anim_name):
	$scaleDiamond.play(.6, Vector2(0,0), Vector2(.4,.4))
