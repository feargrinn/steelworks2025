class_name GhostSpawner
extends Node2D

@onready var viewport_rect := get_viewport_rect()
const GHOST = preload("uid://bixy5qo73jff4")
const SPAWN_FAR := 100

func _ready() -> void:
	set_viewport_rect()
	get_viewport().size_changed.connect(set_viewport_rect)
	
	var tween := create_tween()
	for i in 15:
		tween.tween_callback(spawn_ghost)
		tween.tween_interval(0.5)


func set_viewport_rect() -> void:
	viewport_rect = get_viewport_rect()


func spawn_ghost() -> void:
	var x: float
	var y: float
	if randi_range(0, 1):
		x = (viewport_rect.position.x - SPAWN_FAR if randi_range(0, 1) else
				viewport_rect.end.x + SPAWN_FAR)
		y = randf_range(0, 1) * viewport_rect.size.y + viewport_rect.position.y
	else:
		x = randf_range(0, 1) * viewport_rect.size.x + viewport_rect.position.x
		y = (viewport_rect.position.y - SPAWN_FAR if randi_range(0, 1) else
				viewport_rect.end.y + SPAWN_FAR)
	var pos := Vector2(x, y)
	var ghost := GHOST.instantiate()
	add_child(ghost)
	ghost.position = pos
