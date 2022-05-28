extends Sprite


func _ready():
	pass


func _on_AnimationPlayer_animation_finished(anime_name):
	if anime_name == "title_jet_pak":
		$CurveTween.play(.6, Vector2(0,0), Vector2(.4,.4))

func _on_CurveTween_curve_tween(sat):
	scale = sat
