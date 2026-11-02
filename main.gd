
extends Control

var SCENE: String = "res://Levels/Week-1/1.tscn"
const GameFileAccess: Script = preload("res://file-access.gd")

@onready var BANNER: Sprite2D = $background
@onready var START_BUTTON: TextureButton = $"start-button"
@onready var MUSIC: AudioStreamPlayer2D = $music
@onready var FADE: ColorRect = $fade

var transitioning: bool = false


func _ready() -> void:
	var file := FileAccess.open_encrypted_with_pass(
		GameFileAccess.SAVE_FILE,
		FileAccess.READ,
		GameFileAccess.KEY
	)

	if file:
		var data: Dictionary = file.get_var()
		SCENE = data.get("scene", "res://Levels/Week-1/1.tscn")
		file.close()

	_play_intro()


func _play_intro() -> void:
	START_BUTTON.disabled = true

	BANNER.modulate.a = 0.0
	START_BUTTON.modulate.a = 0.0

	var banner_position := BANNER.position
	var button_position := START_BUTTON.position

	BANNER.position.y += 12.0
	START_BUTTON.position.y += 16.0

	FADE.color = Color.BLACK

	MUSIC.volume_db = -35.0
	MUSIC.play()

	var tween := create_tween()

	tween.set_parallel(true)
	tween.tween_property(BANNER, "modulate:a", 1.0, 1.5)
	tween.tween_property(
		BANNER,
		"position",
		banner_position,
		1.5
	).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)

	tween.tween_property(
		FADE,
		"color:a",
		0.0,
		1.5
	)

	tween.tween_property(
		MUSIC,
		"volume_db",
		-8.0,
		3.0
	)

	tween.set_parallel(false)
	tween.tween_interval(0.35)

	tween.set_parallel(true)
	tween.tween_property(
		START_BUTTON,
		"modulate:a",
		1.0,
		0.9
	)

	tween.tween_property(
		START_BUTTON,
		"position",
		button_position,
		0.9
	).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)

	tween.set_parallel(false)
	tween.tween_callback(func():
		START_BUTTON.disabled = false
	)


func _on_startbutton_pressed() -> void:
	if transitioning:
		return

	transitioning = true
	START_BUTTON.disabled = true

	var tween := create_tween()

	tween.tween_property(
		FADE,
		"color:a",
		1.0,
		1.2
	).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)

	tween.parallel().tween_property(
		MUSIC,
		"volume_db",
		-35.0,
		1.2
	)

	tween.tween_callback(func():
		get_tree().change_scene_to_file(SCENE)
	)
