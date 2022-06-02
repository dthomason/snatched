extends "res://src/main/Screen.gd"

onready var join_match_id_control := $Choices/JoinMatch
onready var matchList := $ItemList

var active_matches = []
var minimum_player_count = 2
func _ready() -> void:
	$Choices/FindMatch.connect("pressed", self, "_on_match_button_pressed", [OnlineMatch.MatchMode.MATCHMAKER])
	$Choices/CreateMatch.connect("pressed", self, "_on_match_button_pressed", [OnlineMatch.MatchMode.CREATE])
	$Choices/JoinMatch.connect("pressed", self, "_on_match_button_pressed", [OnlineMatch.MatchMode.JOIN])
	
	OnlineMatch.connect("matchmaker_matched", self, "_on_OnlineMatch_matchmaker_matched")
	OnlineMatch.connect("match_created", self, "_on_OnlineMatch_created")
	OnlineMatch.connect("match_joined", self, "_on_OnlineMatch_joined")

func _show_screen(_info: Dictionary = {}) -> void:
	join_match_id_control.text = ''

func _on_match_button_pressed(mode) -> void:
	# If our session has expired, show the ConnectionScreen again.
	if Online.nakama_session == null or Online.nakama_session.is_expired():
		ui_layer.show_screen("ConnectionScreen", { reconnect = true, next_screen = null })
		
		# Wait to see if we get a new valid session.
		yield(Online, "session_changed")
		if Online.nakama_session == null:
			return
	
	# Connect socket to realtime Nakama API if not connected.
	if not Online.is_nakama_socket_connected():
		Online.connect_nakama_socket()
		yield(Online, "socket_connected")
	
	ui_layer.show_message("Successfully Connected")
	
	# Call internal method to do actual work.
	match mode:
		OnlineMatch.MatchMode.MATCHMAKER:
			_start_matchmaking()
		OnlineMatch.MatchMode.CREATE:
			_create_match()
		OnlineMatch.MatchMode.JOIN:
			_join_match()

func _start_matchmaking() -> void:
	var min_players = minimum_player_count
	
	
	ui_layer.show_message("Looking for match...")
	
	var data = {
		min_count = min_players,
		string_properties = {
			game = "snatched",
			engine = "godot",
		},
		query = "+properties.game:snatched +properties.engine:godot",
	}
	
	OnlineMatch.start_matchmaking(Online.nakama_socket, data)

func _on_OnlineMatch_matchmaker_matched(_players: Dictionary):
	ui_layer.show_message("Found Match")
	visible = false
	ui_layer.show_screen("ReadyScreen", { players = _players })

func _create_match() -> void:
	OnlineMatch.create_match(Online.nakama_socket)

func _on_OnlineMatch_created(match_id: String):
	ui_layer.show_screen("ReadyScreen", { match_id = match_id, clear = true })

func _join_match() -> void:
	var match_id = join_match_id_control.text.strip_edges()
	if match_id == '':
		ui_layer.show_message("Need to paste Match ID to join")
		return
	if not match_id.ends_with('.'):
		match_id += '.'
	
	OnlineMatch.join_match(Online.nakama_socket, match_id)

func _on_OnlineMatch_joined(match_id: String):
	ui_layer.show_screen("ReadyScreen", { match_id = match_id, clear = true })

func _on_PasteButton_pressed() -> void:
	join_match_id_control.text = OS.clipboard

func _on_LeaderboardButton_pressed() -> void:
	ui_layer.show_screen("LeaderboardScreen")


