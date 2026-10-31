extends Parallax2D

@onready var LIGHTNINGS: Array[AnimatedSprite2D] = [
	$"lightning/1",
	$"lightning/2",
	$"lightning/3",
	$"lightning/4",
	$"lightning/5",
	$"lightning/6",
	$"lightning/7",
	$"lightning/8",
	$"lightning/9",
	$"lightning/10"
]

@onready var LIGHTNING_DROPS: Array[AnimatedSprite2D] = [
	$"lightning-drop/1",
	$"lightning-drop/2",
	$"lightning-drop/3",
	$"lightning-drop/4",
	$"lightning-drop/5",
]

const LIGHTNING_ANIMATIONS: Array[StringName] = [
	&"single-1",
	&"single-2",
	&"single-3",
	&"full",
	&"full",
	&"full",
]

var LIGHTNING_TIMER: float = 0.0
var LIGHTNING_DROP_TIMER: float = 0.0
var TARGET_LIGHTNING_TIME: float = 0.0
var TARGET_LIGHTNING_DROP_TIME: float = 0.0


func _ready() -> void:
	randomize()
	TARGET_LIGHTNING_TIME = randf_range(5.0, 15.0)
	TARGET_LIGHTNING_DROP_TIME = randf_range(10.0, 25.0)
	
	for lightning in LIGHTNINGS:
		if is_instance_valid(lightning):
			lightning.visible = false
	
	for drop in LIGHTNING_DROPS:
		if is_instance_valid(drop):
			drop.visible = false


func _process(delta: float) -> void:
	LIGHTNING_TIMER += delta
	if LIGHTNING_TIMER >= TARGET_LIGHTNING_TIME:
		LIGHTNING_TIMER = 0.0
		TARGET_LIGHTNING_TIME = randf_range(5.0, 15.0)
		_spawn_lightning()
	
	LIGHTNING_DROP_TIMER += delta
	if LIGHTNING_DROP_TIMER >= TARGET_LIGHTNING_DROP_TIME:
		LIGHTNING_DROP_TIMER = 0.0
		TARGET_LIGHTNING_DROP_TIME = randf_range(5.0, 15.0)
		_spawn_lightning_drop()


func _spawn_lightning_drop() -> void:
	var lightning: AnimatedSprite2D = LIGHTNING_DROPS.pick_random()
	var animation: StringName = &"default"

	if not is_instance_valid(lightning):
		return

	lightning.visible = true
	lightning.animation = animation
	lightning.frame = 0
	lightning.play()

	var duration: float = (
		float(lightning.sprite_frames.get_frame_count(animation))
		/ lightning.sprite_frames.get_animation_speed(animation)
	)

	await get_tree().create_timer(duration).timeout

	if is_instance_valid(lightning):
		lightning.visible = false


func _spawn_lightning() -> void:
	var lightning: AnimatedSprite2D = LIGHTNINGS.pick_random()
	var animation: StringName = LIGHTNING_ANIMATIONS.pick_random()

	if not is_instance_valid(lightning):
		return

	lightning.visible = true
	lightning.animation = animation
	lightning.frame = 0
	lightning.play()

	var duration: float = (
		float(lightning.sprite_frames.get_frame_count(animation))
		/ lightning.sprite_frames.get_animation_speed(animation)
	)

	await get_tree().create_timer(duration).timeout

	if is_instance_valid(lightning):
		lightning.visible = false
