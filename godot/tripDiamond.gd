extends Polygon2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.



func _on_CurveTween_curve_tween(sat):
	pass # Replace with function body.


func _on_AnimationPlayer_animation_changed(old_name, new_name):
	if new_name == "trip":
		$CurveTween.play(.6, Vector2(150, 755), Vector2(350, 750))
