extends "res://src/Main/Screen.gd"

onready var create_account_menu = $Create
onready var login_menu = $Login
onready var login_email_field := $Login/Email
onready var login_password_field := $Login/Password

enum MENU {LOGIN, CREATE_ACCOUNT}
var menu = MENU.LOGIN
var default_screen = "ConnectionScreen"

const CREDENTIALS_FILENAME = 'user://credentials.json'

var email: String = ''
var password: String = ''

var _reconnect: bool = false
var _next_screen

func _ready() -> void:
	login_menu.visible = true
	create_account_menu.visible = false
	
	var file = File.new()
	if file.file_exists(CREDENTIALS_FILENAME):
		file.open(CREDENTIALS_FILENAME, File.READ)
		var result := JSON.parse(file.get_as_text())
		if result.result is Dictionary:
			email = result.result['email']
			password = result.result['password']
			login_email_field.text = email
			login_password_field.text = password
		file.close()

func logout() -> void:
	_clear_credentials()
		# Clear stored email and password, but leave the fields alone so the
	# user can attempt to correct them.
	email = ''
	password = ''
	
	# We always set Online.nakama_session in case something is yielding
	# on the "session_changed" signal.
	Online.nakama_session = null
	
	ui_layer.hide_screen()
	ui_layer.show_screen("TitleScreen")
	ui_layer.show_screen("ConnectionScreen")
	

func _save_credentials() -> void:
	var file = File.new()
	file.open(CREDENTIALS_FILENAME, File.WRITE)
	var credentials = {
		email = email,
		password = password,
	}
	file.store_line(JSON.print(credentials))
	file.close()
	
func _clear_credentials() -> void:
	var file = File.new()
	file.open(CREDENTIALS_FILENAME, File.WRITE)
	var credentials = {
		email = '',
		password = '',
	}
	file.store_line(JSON.print(credentials))
	file.close()

func _show_screen(info: Dictionary = {}) -> void:
	_reconnect = info.get('reconnect', false)
	_next_screen = info.get('next_screen', 'MatchScreen')
	
	# If we have a stored email and password, attempt to login straight away.
	if email != '' and password != '':
		
		do_login(true)

func _on_Submit_pressed():
	
	var email = $Login/Email.text.strip_edges()
	var password = $Login/Password.text.strip_edges()
	var remember_me = $Login/RememberMe.pressed
	
	var session = yield(Online.nakama_client.authenticate_email_async(email, password, null, false), "completed")
	if session.is_exception():
		print(session.get_exception().message)
	Online.nakama_session = session
	self.hide()
	pass 

func do_login(save_credentials: bool = false) -> void:
	visible = false
	
	if _reconnect:
		ui_layer.show_message("Session expired! Reconnecting...")
	else:
		ui_layer.show_message("Logging in...")
	
	var nakama_session = yield(Online.nakama_client.authenticate_email_async(email, password, null, false), "completed")
	
	if nakama_session.is_exception():
		visible = true
		ui_layer.show_message("Login failed!")
		
		# Clear stored email and password, but leave the fields alone so the
		# user can attempt to correct them.
		email = ''
		password = ''
		
		# We always set Online.nakama_session in case something is yielding
		# on the "session_changed" signal.
		Online.nakama_session = null
	else:
		if save_credentials:
			_save_credentials()
		Online.nakama_session = nakama_session
		ui_layer.set_username(nakama_session["username"])
		ui_layer.show_message("Welcome Back " + nakama_session["username"])
		
		if _next_screen:
			ui_layer.show_screen(_next_screen)

func _on_Login_pressed() -> void:
	email = login_email_field.text.strip_edges()
	password = login_password_field.text.strip_edges()
	do_login($Login/RememberMe.pressed)

func _on_CreateAccount_pressed() -> void:
	email = $Create/Email/Email.text.strip_edges()
	password = $Create/Password/Password.text.strip_edges()
	
	var username = $Create/Username/Username.text.strip_edges()
	var save_credentials = $Create/RememberMe.pressed
	
	if email == '':
		ui_layer.show_message("Must provide email")
		return
	if password == '':
		ui_layer.show_message("Must provide password")
		return
	if username == '':
		ui_layer.show_message("Must provide username")
		return
	
	visible = false
	ui_layer.show_message("Creating account...")

	var nakama_session = yield(Online.nakama_client.authenticate_email_async(email, password, username, true), "completed")
	
	if nakama_session.is_exception():
		visible = true
		
		var msg = nakama_session.get_exception().message
		# Nakama treats registration as logging in, so this is what we get if the
		# the email is already is use but the password is wrong.
		if msg == 'Invalid credentials.':
			msg = 'E-mail already in use.'
		elif msg == '':
			msg = "Unable to create account"
		ui_layer.show_message(msg)
		
		# We always set Online.nakama_session in case something is yielding
		# on the "session_changed" signal.
		Online.nakama_session = null
	else:
		if save_credentials:
			_save_credentials()
		Online.nakama_session = nakama_session
		ui_layer.show_message("Welcome " + nakama_session["username"])
		ui_layer.show_screen("MatchScreen")

func _toggle_login_menu():
	login_menu.visible = not login_menu.visible
	create_account_menu.visible = not create_account_menu.visible

func _on_CreateTab_pressed():
	login_menu.visible = false
	create_account_menu.visible = true
	ui_layer.show_message("CreateTab")


func _on_Nevermind_pressed():
	create_account_menu.visible = false
	login_menu.visible = true
	ui_layer.show_message("NEVERMIND")


func _on_SignOut_pressed():
	logout()

