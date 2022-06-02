extends VBoxContainer

var regex := RegEx.new()

var email: String = ''
var password: String = ''
var verify_password: String = ''
var remember_me: bool = false
onready var email_field = $Email


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

