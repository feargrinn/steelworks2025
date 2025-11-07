class_name Ghost
extends Area2D

const SPEED: int = 300

@onready var goal := get_viewport_rect().get_center()


func _physics_process(delta: float) -> void:
	var direction := (goal - global_position).normalized()
	if (goal - global_position).length_squared() < pow(SPEED * delta, 2):
		global_position = goal
		return
	global_position += direction * SPEED * delta


func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			queue_free()
