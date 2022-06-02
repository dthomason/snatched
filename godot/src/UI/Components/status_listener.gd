extends Label

var current_status = ""


# Called when the node enters the scene tree for the first time.
func _ready():
	current_status = "ready"
	pass # Replace with function body.

func _process(_delta):
	self.text = current_status
	

func _on_loginOrCreate_status(status):
	
	current_status = status
