extends CharacterBody2D

class_name Person

@export var speed: float = 100

@onready var navigation_agent_2d: NavigationAgent2D = $NavigationAgent2D

func _physics_process(_delta: float) -> void:
	if not navigation_agent_2d.is_navigation_finished():
		var dir := to_local(navigation_agent_2d.get_next_path_position()).normalized()
		velocity = dir * speed
		move_and_slide()


func set_target_position(target_position: Vector2) -> void:
	navigation_agent_2d.target_position = target_position
