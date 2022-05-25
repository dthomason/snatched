extends Sprite

var timeout = "timeout"
var method = "on_Timer_timeout"

func _ready():
	if not $Timer.is_connected(timeout, self, method):
		$Timer.connect(timeout, self, method)
		
func _on_CurveTween_curve_tween(sat):
	scale = sat


func _on_Timer_timeout():
	$CurveTween.play(.6, Vector2(0,0), Vector2(.4,.4))
