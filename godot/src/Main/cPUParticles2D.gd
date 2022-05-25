extends CPUParticles2D

var timeout = "timeout"
var method = "on_Timer_timeout"

func _ready():
	if not $Timer2.is_connected(timeout, self, method):
		$Timer2.connect(timeout, self, method)
		

func _on_Timer2_timeout():
	self.emitting = true
