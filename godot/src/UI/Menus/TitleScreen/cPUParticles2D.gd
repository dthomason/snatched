extends CPUParticles2D

var timeout = "timeout"
var method = "_on_Timer_timeout"

func _ready():
  if not $Timer.is_connected(timeout, self, method):
    $Timer.connect(timeout, self, method)

func _on_Timer_timeout():
  self.emitting = true
