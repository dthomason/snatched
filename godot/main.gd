
extends Node

func _ready():
	get_tree().change_scene("res://splash.tscn")
	pass


func _on_touchScreenButton_pressed():
	get_tree().change_scene("res://scenes/museum_full.tscn")
