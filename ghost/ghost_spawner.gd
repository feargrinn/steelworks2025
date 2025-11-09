class_name GhostSpawner
extends Node2D

@onready var timer: Timer = $Timer
@onready var viewport_rect := get_viewport_rect()
const GHOST = preload("uid://bixy5qo73jff4")
const SPAWN_FAR := 100

@export var waves: Array[Wave]
@onready var no_waves = waves.size()
var current_wave_idx: int = 0

func _ready() -> void:
	set_viewport_rect()
	get_viewport().size_changed.connect(set_viewport_rect)
	timer.wait_time = waves[current_wave_idx].time_before if waves.size() > 0 else 1.0
	timer.start()


func set_viewport_rect() -> void:
	viewport_rect = get_viewport_rect()


func spawn_ghost(pos: Vector2) -> void:
	var ghost := GHOST.instantiate()
	ghost.position = pos
	add_child(ghost)


var get_random_down_pos := func() -> Vector2: return Vector2(
	viewport_rect.position.x + viewport_rect.size.x * randf_range(0, 1),
	viewport_rect.end.y + SPAWN_FAR
)
var get_random_top_pos := func() -> Vector2: return Vector2(
	viewport_rect.position.x + viewport_rect.size.x * randf_range(0, 1),
	viewport_rect.position.y - SPAWN_FAR
)
var get_random_right_pos := func() -> Vector2: return Vector2(
	viewport_rect.end.x + SPAWN_FAR,
	viewport_rect.position.y + viewport_rect.size.y * randf_range(0, 1)
)
var get_random_left_pos := func() -> Vector2: return Vector2(
	viewport_rect.position.x - SPAWN_FAR,
	viewport_rect.position.y + viewport_rect.size.y * randf_range(0, 1)
)

enum SpawnMode {TOP, DOWN, LEFT, RIGHT, HORIZONTAL, VERTICAL, ALL}

func get_random_position(mode: SpawnMode) -> Vector2:
	match(mode):
		SpawnMode.TOP: return get_random_top_pos.call()
		SpawnMode.DOWN: return get_random_down_pos.call()
		SpawnMode.LEFT: return get_random_left_pos.call()
		SpawnMode.RIGHT: return get_random_right_pos.call()
		SpawnMode.HORIZONTAL: return [get_random_left_pos, get_random_right_pos].pick_random().call()
		SpawnMode.VERTICAL: return [get_random_top_pos, get_random_down_pos].pick_random().call()
	return [get_random_top_pos, get_random_down_pos, get_random_left_pos, get_random_right_pos].pick_random().call()

func create_wave(enemy_count: int, time_between: float, mode: SpawnMode):
	AudioManager.play_sfx("ghost_wave")
	var tween = create_tween()
	for i in range(enemy_count):
		tween.tween_callback(spawn_ghost.bind(get_random_position(mode)))
		tween.tween_interval(time_between)


func _on_timer_timeout() -> void:
	create_wave(
		waves[current_wave_idx].enemy_count, 
		waves[current_wave_idx].time_interval, 
		waves[current_wave_idx].mode
	)
	
	current_wave_idx += 1
	if current_wave_idx >= no_waves:
		current_wave_idx = no_waves - 1
	
	timer.wait_time = waves[current_wave_idx].time_before
	timer.start()
