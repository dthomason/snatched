extends Timer
signal counted_down(number)
export var _count := 5

func _ready() -> void:
	connect("timeout", self, "_on_timer_timeout")
