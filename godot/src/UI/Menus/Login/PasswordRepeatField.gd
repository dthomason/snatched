tool
extends LineEditValidate

onready var password_field: LineEdit = get_parent().get_parent().get_node("Password/Password")


func _ready() -> void:
	yield(self, "ready")
	if not password_field:
		printerr("%s: Missing Password Field Path NodePath" % [get_path()])


func _get_configuration_warning() -> String:
	return "You must set the Password Field" if not password_field else ""


func _validate(text: String) -> bool:
	if not password_field:
		return false
	return password_field.text == text


