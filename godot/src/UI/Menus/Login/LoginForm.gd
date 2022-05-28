# Control panel that manages logging into an existing account.
extends Menu

signal register_pressed
signal login_pressed(email, password, do_remember_email)



onready var remember_email := $RememberEmail

onready var email_field := $Email/LineEditValidate
onready var password_field := $Password/LineEditValidate
onready var login_button := $HBoxContainer/LoginButton
onready var register_button := $HBoxContainer/RegisterButton
onready var status_panel := $StatusPanel


func _ready() -> void:
  email_field.text = Online.NakamaApi..get_last_email()
  if not username.text.empty():
    remember_device.pressed = true

  email_field.grab_focus()


func set_is_enabled(value: bool) -> void:
  .set_is_enabled(value)
  if not email_field:
    yield(self, "ready")
  remember_device.disabled = not is_enabled
  submit.disabled = not is_enabled


func set_status(text: String) -> void:
  .set_status(text)
  status_panel.text = text


func reset() -> void:
  .reset()
  self.status = ""
  
  if not remember_device.pressed:
    email_field.text = ""


func attempt_login() -> void:
  if not email_field.is_valid:
    status_panel.text = "The email address is not valid"
    return
  if password_field.text == "":
    status_panel.text = "Please enter your password to log in"
    return
  if password_field.text.length() < 8:
    status_panel.text = "The password should be at least 8 characters long"
    return

  emit_signal("login_pressed", email_field.text, password_field.text, remember_email.pressed)
  status_panel.text = "Authenticating..."
  
  
  #only need a username, no need for a password.  Eventually tie in with apple and google #auth
  # for that to work we'll need to search the db for duplicates
  #  flow
  # username
  # searching...
  # not available sorry, offer a suggested username
  # send store time of creation for unique hash identity
  
  
## Authenticate a user with a custom id.
## @param p_id - A custom identifier usually obtained from an external authentication service.
## @param p_username - A username used to create the user. May be `null`.
## @param p_create - If the user should be created when authenticated.
## @param p_vars - Extra information that will be bundled in the session token.
## Returns a task which resolves to a session object.
#func authenticate_custom_async(p_id : String, p_username = null, p_create : bool = true, p_vars = null) -> NakamaSession:
#  return _parse_auth(yield(_api_client.authenticate_custom_async(server_key, "",
#    NakamaAPI.ApiAccountCustom.create(NakamaAPI, {
#      "id": p_id,
#      "vars": p_vars
#    }), p_create, p_username), "completed"))


func _on_LoginButton_pressed() -> void:
  attempt_login()


func _on_RegisterButton_pressed() -> void:
  emit_signal("register_pressed")


func _on_LineEditValidate_text_entered(_new_text: String) -> void:
  attempt_login()


func _on_open() -> void:
  email_field.grab_focus()
