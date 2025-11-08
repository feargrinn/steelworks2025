class_name Ghost
extends Area2D

@export var SPEED: int = 100

@onready var node_to_follow: Node2D = get_tree().get_nodes_in_group("person").pick_random()


func _physics_process(delta: float) -> void:
	var goal = node_to_follow.global_position if node_to_follow else get_viewport_rect().get_center()
	var direction := (goal - global_position).normalized()
	if (goal - global_position).length_squared() < pow(SPEED * delta, 2):
		global_position = goal
		return
	global_position += direction * SPEED * delta


func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			AudioManager.play_sfx("ghost_death")
			queue_free()
