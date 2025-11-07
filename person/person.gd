extends CharacterBody2D

class_name Person

@export var id: int = 0 # Maybe unnecessary
@export var speed: float = 100

@onready var navigation_agent_2d: NavigationAgent2D = $NavigationAgent2D

var highlighted: bool = false

func _physics_process(_delta: float) -> void:
	if Input.is_action_just_pressed("left_click") and highlighted:
		print("Clicked person with id: ", id)
		game_manager.currently_selected_person = self
	
	if not navigation_agent_2d.is_navigation_finished():
		var dir := to_local(navigation_agent_2d.get_next_path_position()).normalized()
		velocity = dir * speed
		move_and_slide()


func set_target_position(target_position: Vector2) -> void:
	navigation_agent_2d.target_position = target_position


func _on_mouse_click_detection_mouse_entered() -> void:
	highlighted = true
	# TODO: make a highlight

func _on_mouse_click_detection_mouse_exited() -> void:
	highlighted = false
