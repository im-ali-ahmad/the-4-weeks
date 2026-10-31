extends Control

func _ready() -> void:
	pass

func _on_startbutton_pressed() -> void:
	# For now, simply set level 1.
	get_tree().change_scene_to_file("res://Levels/Week-1/1.tscn")
