extends Sprite


func _input(event):
	if Input.get_action_strength("ui_accept"):
		$rotate.play(5, 0, 5)
		$scale.play(2, Vector2(0,0), Vector2(1,1))

func _on_CurveTween_curve_tween(sat):
	rotation = sat


func _on_scale_curve_tween(sat):
	scale = sat
