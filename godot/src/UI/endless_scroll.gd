extends ParallaxBackground

export var speed = 60

func _process(delta):
		scroll_offset.x += speed * delta
