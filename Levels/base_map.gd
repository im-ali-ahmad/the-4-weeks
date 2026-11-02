extends Node2D

var SAVE_ALLOWED: bool = true
var SAVE_TIMER: float = 0.0
const SAVE_TIME_TARGET: float = 300.0

const DEFAULT_GAME_STATE: Dictionary = {}
const GameFileAccess: Script = preload("res://file-access.gd")

func __save_file(data: Dictionary):
	var file := FileAccess.open_encrypted_with_pass(
		GameFileAccess.SAVE_FILE,
		FileAccess.WRITE,
		GameFileAccess.KEY
	)

	if file:
		file.store_var(data)
		file.close()

func __read_file() -> Dictionary:
	var file := FileAccess.open_encrypted_with_pass(
		GameFileAccess.SAVE_FILE,
		FileAccess.READ,
		GameFileAccess.KEY
	)
	
	var data: Dictionary
	if file:
		data = file.get_var()
		file.close()
	else:
		data = DEFAULT_GAME_STATE
	return data

func load_state():
	var _DATA: Dictionary = __read_file()

func save_state():
	if SAVE_ALLOWED:
		__save_file({}) # To save real state

func _ready() -> void:
	load_state()

func _process(delta: float) -> void:
	SAVE_TIMER += delta
	if SAVE_TIMER >= SAVE_TIME_TARGET:
		save_state()
		SAVE_TIMER = 0.0
